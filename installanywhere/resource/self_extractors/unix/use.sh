#!/bin/sh
#################################################################################################
#
# USE.SH - InstallAnywhere (tm) UNIX Self Extractor Version 7.0.0
#
# (c) Copyright 1999-2005 Zero G Software, Inc., all rights reserved.
#
#################################################################################################

GREP="grep"
# /usr/bin/grep is stripped down on Solaris
[ `uname` = "SunOS" -a -x /usr/xpg4/bin/grep ] && GREP=/usr/xpg4/bin/grep

echo "Preparing to install..."

if [ $JRESTART ]; then
	VM_INCLUDED="true"
else
	VM_INCLUDED="false"
fi

if [ $RESSIZE ]; then
	RESOURCEZIP_INCLUDED="true"
else
	RESOURCEZIP_INCLUDED="false"
fi

# remember what the current locale is
OLD_LANG="$LANG"

# then force it to POSIX for foreign environments where the primary locale
# isn't one we can safely work in; see bug #3411
LANG=C ; export LANG


#################################################################################################
# Gather the OS/execution environment
#

# USERENV is just a flag to laxunix.sh
USERENV=1

ORIG_PWD=`pwd`
OS_NAME=`uname -s 2> /dev/null | tr "[:upper:]" "[:lower:]" 2> /dev/null`

# always run POSIX commands first
PATH=/usr/xpg4/bin:"$PATH"

# enforce POSIX behavior of GNU commands
POSIXLY_CORRECT=1 ; export POSIXLY_CORRECT

# POSIX df lists available space in 512 byte-blocks, in the fourth column
OS_BLOCKSIZE=512
DF_AVAIL_COL=4

# find out whether df groks the POSIX option; if not, just use regular df and
# hope it does what we expect
[ $LAX_DEBUG ] && echo "Checking for POSIX df."

DF_CMD='df -P'

if $DF_CMD / >/dev/null 2>&1
then
	# POSIX df found
	[ $LAX_DEBUG ] && echo "Found POSIX df."

	POSIX_XPG_DF_CMD() {
	df -P "$1" | awk '{ if (NF == 1) { line1 = $0; getline; $0 = line1 $0 } print $0 }'
	}
	DF_CMD=POSIX_XPG_DF_CMD
else
	[ $LAX_DEBUG ] && echo "POSIX df not found; free space calculation may be wrong."
	DF_CMD=df
fi

# This checks if the -n 1 argument works
[ $LAX_DEBUG ] && echo 'Checking tail options...'
TAIL_CMD='tail -n 1 /dev/null'
if $TAIL_CMD 2>/dev/null
then
	TAILN1ARG="-n 1";
else
	TAILN1ARG="-1";
fi
[ $LAX_DEBUG ] && echo "Using tail $TAILN1ARG."

# Irix patch (is this still necessary?)
#if [ `expr "$OS_NAME" : '.*irix.*'` -gt 0 ]; then
#	DF_AVAIL_COL=5
#fi


if [ -x /bin/ls ]; then
	lsCMD="/bin/ls"
elif [ -x /usr/bin/ls ]; then
	lsCMD="/usr/bin/ls"
else
	lsCMD="ls"
fi


#################################################################################################
# Set up trap for interrupted installations
# This trap will catch if the user hits ^C in the console window where
# this script is being run.  When caught the following function will
# be run to clean up the /tmp/install.dir.XXXX directory
#################################################################################################
tmp_dir_cleanup () {
        echo
        echo "WARNING! This installation has been interrupted. The"
        echo "installation process will now terminate and the temporary"
        echo "files it is using will be deleted from $ZIPLOC."
        echo
        cd "$ORIG_PWD"
        rm -rf "$ZIPLOC"
        rm -f "$INSTBASE/env.properties.$$"
        exit 11;
}
trap "tmp_dir_cleanup" 1 2 3 4 6 8 10 12 13 15


#################################################################################################
# resolveLink()
# param		$1					a file or directory name
# sets		$resolveLink		the name of the linked disk entity
#################################################################################################
resolveLink()
{
	rl_linked="true"
	rl_operand="$1"
	rl_origDir="`dirname "$1"`"
	
	# MMA - 2001.04.04 - if 'dirname' returns '.', then we need the current working directory path
	if [ "$rl_origDir" = "." ]; then
		rl_origDir=`pwd`
	fi
	
	rl_ls=`$lsCMD -l "$rl_operand"`
	
	# MMA - 2001.02.28 - always resolve path to absolute.
	
	while [ "$rl_linked" = "true" ]; do
		# if the operand is not of an abs path, get its abs path
		case "$rl_operand" in
			/*)
				rl_origDir=`dirname "$rl_operand"`
			;;
			\./*)
				rl_origDir=`pwd`
				rl_operand="$rl_origDir/$rl_operand"
			;;
			\../*)
				rl_origDir=`pwd`
				rl_operand="$rl_origDir/$rl_operand"
			;;
			*)
				rl_operand="$rl_origDir/$rl_operand"
			;;
		esac
		#
		# the prevPrev hack is here because .../java often points to .java_wrapper.
		# at the end of the resolution rl_operand actually points to garbage
		# signifying it is done resolving the link.  So prev is actually .java_wrapper.
		# but we want the one just before that, its the real vm starting poiint we want
		#
		rl_prevOperand="$rl_operand"
		rl_ls=`$lsCMD -l "$rl_operand"`
		# get the output ls into a list
		set x $rl_ls
		# get rid of x and file info from ls -l
		shift 9
		
		#is this a link?
		case "$rl_ls" in
			*"->"*)
				rl_linked="true"
				# is a link, shift past the "->"
				rl_linker=""
				while [ "$1" != "->" -a $# -gt 1 ]; do
					rl_linker="$rl_linker $1"
					shift
				done
	
				if [ "$1" = "->" ]; then
					shift
				fi
			;;
			*)
				# not a link, the rest must be the targets name
				rl_linked="false"
			;;
		esac
		# now grab what's left 
		rl_linkee="$@"

		# debugOut "Following link to LAX $rl_linker -> $rl_linkee"

		if [ "$rl_linked" = "true" -a "`basename "$rl_linkee"`" != "$vmScript" ]; then
			# set to true incase the thing linked to is also a link and we can
			# try again.  The current think linked to now becomes the operand
			rl_operand="$rl_linkee"
			# if the linkee is not abs, make it abs relative to the linker
			case "$rl_operand" in
				/*)
				;;
				*)
					rl_operand="$rl_origDir/$rl_operand"
				;;
			esac
		else
			# otherwise, this operand is not a link itself and we are done
			rl_resolvedLink="$rl_prevOperand"
			# however, do not resolve the last leg of a VMs linked scripts. this will
			# disrupt their scripts.  it is expecting a link to the .java* script
			# let us believe it is not linked and continue on...
			if [ "`basename "$rl_linkee"`" = "$vmScript" ]; then
				rl_linked="false"
			fi
		fi
		# make sure the path returned is absolute
		case "$rl_operand" in
			\.\/*)
				rl_operand="`pwd`/$rl_operand"
			;;
		esac
	done

	# remove "/./" in paths, make it "/"
	# i,e,  "/a/b/./c" becomes "/a/b/c"
	resolvedLink=`echo "$rl_resolvedLink" |  sed 's,/\./,/,'`
}




#################################################################################################
# Find the true location of the self extractor, move to the right place
#

# -- if it's a relative path, make it absolute
if pwd -P 2>&1 > /dev/null; then
	PWD="pwd -P"
else
	PWD="pwd"
fi

ARGZERO=$0
if [ -z "`echo $ARGZERO | grep '^/'`" ]; then
	ARGZERO="`$PWD`/$ARGZERO"
fi
# this line removes turns ./ & // into / 
ARGZERO=`echo $ARGZERO | sed s,\\\\./,/,g | sed s,//,/,g`
# -- done fixing up relative path

# -- this shouldn't be necessary, but I'm going to leave it in anyways
resolveLink "$ARGZERO"
SEA_LOC="$resolvedLink"

[ $LAX_DEBUG ] && echo "True location of the self extractor: $SEA_LOC"


#################################################################################################
#  Set up tmp install location
#
if [ $IATEMPDIR ]; then
	INSTBASE=$IATEMPDIR
	if [ $LAX_DEBUG ]; then
		echo "Forcing install base (including tmp dir) to: $IATEMPDIR"
	fi
	if [ ! -d "$INSTBASE" ]; then
		echo "You have used the IATEMPDIR to set the install base and tmp dir"
		echo "for this installation.  However, the directory"
		echo "     $INSTBASE"
		echo "does not exist or is not a directory.  Please choose a valid directory."
		exit 1;
	fi
else
	if [ -d /tmp ]; then
		INSTBASE=/tmp
	else
		INSTBASE="$HOME"
		if [ $LAX_DEBUG ]; then
			echo "WARNING: /tmp is not a directory! Using $HOME for install base and tmp dir."
		fi
	fi
fi
ZIPLOC="$INSTBASE/install.dir.$$"
INSTALLER_DATA_DIR="$ZIPLOC/InstallerData"
INSTALL_ZIP="$INSTALLER_DATA_DIR/installer.zip"
INSTALL_PADDED_ZIP="$INSTALLER_DATA_DIR/installer.padded"
DISK1_DIR="$INSTALLER_DATA_DIR/Disk1"
INSTDATA_DIR="$DISK1_DIR/InstData"
RESOURCE_ZIP="$INSTDATA_DIR/Resource1.zip"
ENV_PROPERTIES="$ZIPLOC/env.properties"
TMP_LAX="$ZIPLOC/temp.lax"

[ $LAX_DEBUG ] && echo "Creating installer data directory: $ZIPLOC"
mkdir "$ZIPLOC" > /dev/null 2>&1

if [ $? -ne 0 ]; then
	echo "The temporary install directory: "
	echo "     $INSTBASE"
	echo "does not exist or you do not have permission to write to it."
	echo "Please set the IATEMPDIR environment variable to a directory"
	echo "to which you have the permission."
	echo "To set the variable enter one of the following"
	echo "commands at the UNIX command line prompt before running this"
	echo "installer again:"
	echo ""
	echo "- for Bourne shell (sh), ksh, bash and zsh:"
	echo ""
	echo "     $ IATEMPDIR=/your/temp/space/directory"
	echo "     $ export IATEMPDIR"
	echo ""
	echo "- for C shell (csh) and tcsh:"
	echo ""
	echo "     $ setenv IATEMPDIR /your/temp/space/directory"
	echo ""
fi

[ $LAX_DEBUG ] && echo "Creating installer data directory: $INSTALLER_DATA_DIR"
mkdir "$INSTALLER_DATA_DIR" > /dev/null 2>&1


#################################################################################################
# Gather disk free-space info
#
[ $LAX_DEBUG ] && echo "Gathering free-space information..."

EXTRA_SPACE=512
if [ $VM_INCLUDED = "true" ]; then
	BASE_SIZE=`expr \( $ARCHREALSIZE + $JREREALSIZE  + $RESREALSIZE \)`
	BASE_SIZE=`expr $BASE_SIZE \* 2 + $BASE_SIZE`
	NEEDED_SPACE=`expr $BASE_SIZE / $OS_BLOCKSIZE + $EXTRA_SPACE`
else
	NEEDED_SPACE=`expr $ARCHSIZE / $OS_BLOCKSIZE + $EXTRA_SPACE`
fi

[ $LAX_DEBUG ] && echo "Space needed to complete the self-extraction: $NEEDED_SPACE blocks"

sePwd=`pwd`
cd "$INSTBASE"

AVAIL_SPACE=`$DF_CMD . 2>/dev/null | awk "{print \\\$$DF_AVAIL_COL}" | tail $TAILN1ARG`
[ $LAX_DEBUG ] && echo "Available space: $AVAIL_SPACE blocks"

cd "$sePwd"

# if space info gathering worked well...
if [ $LAX_DEBUG ]; then
echo "Available blocks: $AVAIL_SPACE    Needed blocks: $NEEDED_SPACE (block = $OS_BLOCKSIZE bytes)"
fi
if [ ! \( -z $AVAIL_SPACE -o -z $NEEDED_SPACE \) ]; then
	if [ ${AVAIL_SPACE:-0} -lt ${NEEDED_SPACE:-0} ]; then

		#
		# MMA - 2001.03.01 - try the home directory first if not enough space in /tmp or $IATEMPDIR
		#
		if [ "$INSTBASE" != "$HOME" ]; then

			if [ -d "$ZIPLOC" ]; then
				rmdir "$ZIPLOC" > /dev/null 2>&1
			fi

			echo "WARNING: $INSTBASE does not have enough disk space!"
			echo "         Attempting to use $HOME for install base and tmp dir."

			INSTBASE="$HOME"
			ZIPLOC="$INSTBASE/install.dir.$$"
			INSTALLER_DATA_DIR="$ZIPLOC/InstallerData"
			INSTALL_ZIP="$INSTALLER_DATA_DIR/installer.zip"
			INSTALL_PADDED_ZIP="$INSTALLER_DATA_DIR/installer.padded"
			DISK1_DIR="$INSTALLER_DATA_DIR/Disk1"
			INSTDATA_DIR="$DISK1_DIR/InstData"
			RESOURCE_ZIP="$INSTDATA_DIR/Resource1.zip"
			ENV_PROPERTIES="$ZIPLOC/env.properties"
			TMP_LAX="$ZIPLOC/temp.lax"
			
			[ $LAX_DEBUG ] && echo "Creating installer data directory: $ZIPLOC"

			if mkdir "$ZIPLOC" > /dev/null 2>&1
			then
				# successful
				:
			else
				echo "The temporary install directory: "
				echo "     $INSTBASE"
				echo "does not exist or you do not have permission to write to it."
				echo "Please set the IATEMPDIR environment variable to a directory"
				echo "to which you have the permission."
				echo "To set the variable enter one of the following"
				echo "commands at the UNIX command line prompt before running this"
				echo "installer again:"
				echo ""
				echo "- for Bourne shell (sh), ksh, bash and zsh:"
				echo ""
				echo "     $ IATEMPDIR=/your/temp/space/directory"
				echo "     $ export IATEMPDIR"
				echo ""
				echo "- for C shell (csh) and tcsh:"
				echo ""
				echo "     $ setenv IATEMPDIR /your/temp/space/directory"
				echo ""
			fi
			
			[ $LAX_DEBUG ] && echo "Creating installer data directory: $INSTALLER_DATA_DIR"
			mkdir "$INSTALLER_DATA_DIR" > /dev/null 2>&1

			cd "$INSTBASE"
			AVAIL_SPACE=`$DF_CMD . 2>/dev/null | awk "{print \\\$$DF_AVAIL_COL}" | tail $TAILN1ARG `
			cd "$sePwd"
			
			if [ $LAX_DEBUG ]; then
				echo "Available blocks: $AVAIL_SPACE    Needed blocks: $NEEDED_SPACE (block = $OS_BLOCKSIZE bytes)"
			fi

			if [ ! \( -z $AVAIL_SPACE -o -z $NEEDED_SPACE \) ]; then
				if [ ${AVAIL_SPACE:-0} -lt ${NEEDED_SPACE:-0} ]; then

					# figure out num of Kb needed to install
					free_up=`expr ${NEEDED_SPACE:-0} - ${AVAIL_SPACE:-0}`
					free_up=`expr ${free_up:-1} \* $OS_BLOCKSIZE`
					free_up=`expr ${free_up:-1024} / 1024`
						
					echo ""
					echo "WARNING! The amount of $INSTBASE disk space required to perform"
					echo "this installation is greater than what is available.  Please"
					echo "free up at least $free_up kilobytes in $INSTBASE and attempt this"
					echo "installation again.  You may also set the IATEMPDIR environment"
					echo "variable to a directory on a disk partition with enough free"
					echo "disk space.  To set the variable enter one of the following"
					echo "commands at the UNIX command line prompt before running this"
					echo "installer again:"
					echo ""
					echo "- for Bourne shell (sh), ksh, bash and zsh:"
					echo ""
					echo "     $ IATEMPDIR=/your/free/space/directory"
					echo "     $ export IATEMPDIR"
					echo ""
					echo "- for C shell (csh) and tcsh:"
					echo ""
					echo "     $ setenv IATEMPDIR /your/free/space/directory"
					echo ""
					exit 12;
				fi
			else
				echo "WARNING! The amount of $INSTBASE disk space required and/or available"
				echo "could not be determined.  The installation will attempted anyway."
			fi
		fi
		#
		# End MMA - 2001.03.01
		#
	fi
else
	echo "WARNING! The amount of $INSTBASE disk space required and/or available"
	echo "could not be determined.  The installation will be attempted anyway."
fi

#################################################################################################
# Extract the JRE if included
#
if [ "$VM_INCLUDED" = "true" ]
then

	# determine where to place the jre
	RESOURCE_PATH="$ZIPLOC/$RESOURCE_DIR/resource"
	JRE_PADDED="$RESOURCE_PATH/jre_padded"
	JRE_TARZ="$RESOURCE_PATH/vm.tar.Z"
	JRE_TAR="$RESOURCE_PATH/vm.tar"

	# compute number of blocks to extract
	JRE_BLOCKS=`expr $JREREALSIZE / $BLOCKSIZE`
	JRE_REMAINDER=`expr $JREREALSIZE % $BLOCKSIZE`
	if [ ${JRE_REMAINDER:-0} -gt 0 ]; then
		JRE_BLOCKS=`expr $JRE_BLOCKS + 1`
	fi

	[ $LAX_DEBUG ] && echo "Computed number of blocks to extract: $JRE_BLOCKS"

	# save the old directory and switch into the temp directory
	sePwd=`pwd`
	cd "$ZIPLOC"
	# make the platform directory and switch into it
	mkdir "$RESOURCE_DIR"
	cd "$RESOURCE_DIR"
	# make the resource directory
	mkdir resource
	# switch back to the previous directory
	cd "$sePwd"

	# COMMENT ME TO REMOVE OUTPUT FROM NORMAL INSTALLER EXECUTION
	echo "Extracting the JRE from the installer archive..."

	# extract the jre
	[ $LAX_DEBUG ] && echo "Extracting JRE from $0 to $JRE_PADDED ..."
	dd if="$0" of="$JRE_PADDED" bs=$BLOCKSIZE skip=$JRESTART count=$JRE_BLOCKS > /dev/null 2>&1
	R1=$?
	[ $LAX_DEBUG ] && echo "Extracting done, exit code = $R1"
	
	[ $LAX_DEBUG ] && echo "Extracting JRE from $JRE_PADDED to $JRE_TARZ ..."
	dd if="$JRE_PADDED" of="$JRE_TARZ" bs=$JREREALSIZE count=1 > /dev/null 2>&1
	R2=$?
	[ $LAX_DEBUG ] && echo " Extracting done, exit code = $R2"
	
	rm -f "$JRE_PADDED"

	# verify the integrity of the jre archive
	JRE_TARZ_SIZE=`cksum "$JRE_TARZ" | awk '{ print $2 }'`
	if [ "${JRE_TARZ_SIZE:=0}" -ne "${JREREALSIZE:=1}" -o "$R1" -ne 0 -o "$R2" -ne 0 ]; then
		echo "The included VM could not be extracted. Please try to download"
		echo "the installer again and make sure that you download using 'binary'"
		echo "mode.  Please do not attempt to install this currently downloaded copy."
		exit 13
	fi

	# unpack the jre archive
	pre_unpack_pwd=`pwd`
	cd "$RESOURCE_PATH"

	# COMMENT ME TO REMOVE OUTPUT FROM NORMAL INSTALLER EXECUTION
	echo "Unpacking the JRE..."

	[ $LAX_DEBUG ] && echo "Unpacking the JRE..."
	
	JRE_EXPANDED="false"
	
	if [ $LAX_DEBUG ]; then
		type gzip
	else
		type gzip > /dev/null
	fi
	
	if [ $? -eq 0 ]; then
		gzip -d "$JRE_TARZ"
		if [ $? -eq 0 ]; then
			# gzip successful
			JRE_EXPANDED="true"
			[ $LAX_DEBUG ] && echo " GZIP done."
		else 
			[ $LAX_DEBUG ] && echo " GZIP failed, attempting UNCOMPRESS."
		fi
	else
		[ $LAX_DEBUG ] && echo " GZIP not found, attempting UNCOMPRESS."
	fi
	
	if [ "$JRE_EXPANDED" = "false" ]; then
		uncompress "$JRE_TARZ"
		if [ $? -eq 0 ]; then
			# uncompress successful
			JRE_EXPANDED="true"
			[ $LAX_DEBUG ] && echo " UNCOMPRESS done."
		else 
			[ $LAX_DEBUG ] && echo " UNCOMPRESS failed."
		fi
	fi

	# in case TYPE failed.
	if [ "$JRE_EXPANDED" = "false" ]; then
		gzip -d "$JRE_TARZ"
		if [ $? -eq 0 ]; then
			# uncompress successful
			JRE_EXPANDED="true"
			[ $LAX_DEBUG ] && echo " GZIP done."
		else 
			[ $LAX_DEBUG ] && echo " GZIP failed."
		fi
	fi

	if [ "$JRE_EXPANDED" = "true" ]; then
		tar xf "$JRE_TAR"
		if [ $? -eq 0 ]; then 
			# tar successful
			[ $LAX_DEBUG ] && echo " TAR done."
		else
			echo "The included VM could not be unarchived (TAR). Please try to download"
			echo "the installer again and make sure that you download using 'binary'"
			echo "mode.  Please do not attempt to install this currently downloaded copy."
			exit 15
		fi
	else
		echo "The included VM could not be uncompressed (GZIP/UNCOMPRESS). Please try to"
		echo "download the installer again and make sure that you download using 'binary'"
		echo "mode.  Please do not attempt to install this currently downloaded copy."
		exit 15
	fi
	
	chmod -R 755 jre > /dev/null 2>&1
		
	# Switch back to the previous directory
	cd "$pre_unpack_pwd"

	# Figure out the path to the bundled VM
	bundledVMPath="$RESOURCE_PATH/$LAX_NL_CURRENT_VM"
	
else

	if [ $LAX_DEBUG ]; then
		echo "This installation does not contain a VM."
	fi
	
	# There is no path to a bundled VM
	bundledVMPath=""

fi

# COMMENT ME TO REMOVE OUTPUT FROM NORMAL INSTALLER EXECUTION
echo "Extracting the installation resources from the installer archive..."

#################################################################################################
#  Extract install.zip archive
#

	INSTALLER_BLOCKS=`expr $ARCHREALSIZE / $BLOCKSIZE`
	INSTALLER_REMAINDER=`expr $ARCHREALSIZE % $BLOCKSIZE`
	if [ ${INSTALLER_REMAINDER:-0} -gt 0 ]; then
		INSTALLER_BLOCKS=`expr $INSTALLER_BLOCKS + 1`
	fi

# extract the install.zip
if [ $VM_INCLUDED = "true" ]; then

	[ $LAX_DEBUG ] && echo "Extracting install.zip from $0 to $INSTALL_PADDED_ZIP ..."
	
	dd if="$0" of="$INSTALL_PADDED_ZIP" bs=$BLOCKSIZE \
		skip=`expr $JRESTART + $JRE_BLOCKS` count=$INSTALLER_BLOCKS > /dev/null 2>&1

	[ $LAX_DEBUG ] && echo "Extracting to padded done, exit code = $?"

else
	[ $LAX_DEBUG ] && echo "Extracting install.zip from $0 to $INSTALL_ZIP ..."
	
	dd if="$0" of="$INSTALL_PADDED_ZIP" bs=$BLOCKSIZE \
		skip=$ARCHSTART count=$INSTALLER_BLOCKS > /dev/null 2>&1

	
	[ $LAX_DEBUG ] && echo "Extracting to padded done, exit code = $?"
fi


dd if="$INSTALL_PADDED_ZIP" of="$INSTALL_ZIP" bs=$ARCHREALSIZE \
		count=1 > /dev/null 2>&1


[ $LAX_DEBUG ] && echo "Extracting from padded to zip done, exit code = $?"
	
rm -f $INSTALL_PADDED_ZIP

# verify the integrity of the install.zip
INSTALL_ZIP_SIZE=`cksum "$INSTALL_ZIP" | awk '{ print $2 }'`

if [ ${ARCHREALSIZE:=0} -ne ${INSTALL_ZIP_SIZE:=1} ]; then
	echo "The size of the extracted files to be installed are corrupted.  Please"
	echo "try to download the installer again and make sure that you download"
	echo "using 'binary' mode."
	echo "Please do not attempt to install this currently downloaded copy."
	exit 16
fi

# extract the resource1.zip if it exists (web installers only)
if [ $RESOURCEZIP_INCLUDED = "true" ]; then

       [ $LAX_DEBUG ] && echo "Creating disk1 data directory: $DISK1_DIR"
       mkdir "$DISK1_DIR" > /dev/null 2>&1
       [ $LAX_DEBUG ] && echo "Creating instdata data directory: $INSTDATA_DIR"
       mkdir "$INSTDATA_DIR" > /dev/null 2>&1


	[ $LAX_DEBUG ] && echo "Extracting resources from $0 to $RESOURCE_ZIP ..."
	
	if [ $RESSIZE -eq 0 ]; then
		touch $RESOURCE_ZIP
	elif [ $VM_INCLUDED = "true" ]; then
		dd if="$0" of="$RESOURCE_ZIP" bs=$BLOCKSIZE \
		skip=`expr $JRESTART + $JRE_BLOCKS + $INSTALLER_BLOCKS` count=$RESSIZE > /dev/null 2>&1
	else
		dd if="$0" of="$RESOURCE_ZIP" bs=$BLOCKSIZE \
		skip=`expr $ARCHSTART + $INSTALLER_BLOCKS` count=$RESSIZE > /dev/null 2>&1
	fi

	[ $LAX_DEBUG ] && echo "Extracting done, exit code = $?"
	
	# verify the integrity of the resource1zip
	RESOURCE_ZIP_SIZE=`cksum "$RESOURCE_ZIP" | awk '{ print $2 }'`
	if [ ${RESREALSIZE:=0} -ne ${RESOURCE_ZIP_SIZE:=1} ]; then
		echo "The size of the extracted files to be installed are corrupted.  Please"
		echo "try to download the installer again and make sure that you download"
		echo "using 'binary' mode."
		echo "Please do not attempt to install this currently downloaded copy."
		exit 16
	fi
fi

# COMMENT ME TO REMOVE OUTPUT FROM NORMAL INSTALLER EXECUTION
echo "Configuring the installer for this system's environment..."

#
# write a file in the installerData dir named "sea_loc" that
# contains the path to the self-extractor
#
echo "$SEA_LOC" > "$ZIPLOC"/sea_loc

#################################################################################################
#  Create a lax file for the launcher
#

TMP_LAX="$ZIPLOC/temp.lax"

echo "lax.user.dir=$ZIPLOC" > $TMP_LAX
echo "lax.resource.dir=$RESOURCE_DIR" >> $TMP_LAX
echo "lax.class.path="$INSTALLER_DATA_DIR":"$INSTALL_ZIP >> $TMP_LAX
echo "lax.main.class=com.zerog.ia.installer.Main" >> $TMP_LAX
echo "lax.main.method=main" >> $TMP_LAX
echo "lax.nl.message.vm.not.loaded=The installer either could not find a Java VM, or the Java VM on this system is too old. The installer requires Java 1.1.5 or later. It can be downloaded from http://java.sun.com/products/jdk/1.1/jre/" >> $TMP_LAX

echo "lax.nl.java.launcher.main.class=com.zerog.lax.LAX" >> $TMP_LAX
echo "lax.nl.java.launcher.main.method=main" >> $TMP_LAX
echo "lax.command.line.args=\$CMD_LINE_ARGUMENTS\$" >> $TMP_LAX
echo "lax.nl.current.vm=$bundledVMPath" >> $TMP_LAX
echo "lax.nl.java.compiler=off" >> $TMP_LAX
echo "lax.nl.java.option.verify.mode=none" >> $TMP_LAX
echo "lax.nl.java.option.check.source=off" >> $TMP_LAX
echo "lax.stderr.redirect=$INSTALLER_STDERR_REDIRECT" >> $TMP_LAX
echo "lax.nl.java.option.java.heap.size.initial=$INSTALLER_HEAP_SIZE_INITIAL" >> $TMP_LAX
echo "lax.nl.java.option.java.heap.size.max=$INSTALLER_HEAP_SIZE_MAX" >> $TMP_LAX
echo "lax.nl.java.option.additional=$INSTALLER_OPTIONAL_ARGS" >> $TMP_LAX
echo "lax.installer.unix.internal.property.0=$LAX_INSTALLER_UNIX_INTERNAL_PROPERTY_0" >> $TMP_LAX
echo "lax.installer.unix.ui.default=$DEFAULT_UI_MODE" >> $TMP_LAX

#################################################################################################
# Tell the standard launcher that it should backup this lax file
# since this is a self extractor and not a launcher
#
noLaxBackup=true
templaxpath="$TMP_LAX"
umask $DEFAULTPERMS

# Tell the launcher where to find the properties file
seLaxPath="$TMP_LAX"

#################################################################################################
### END OF USE.SH ###############################################################################
#################################################################################################

