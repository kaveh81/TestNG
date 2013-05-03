<?xml version="1.0" encoding="UTF-8"?>

<!--

    ia_project_info.xsl
    Version 2.0 - tam - 10/13/2003
    
    Thanks to Craig Rubendall for his significant contribution
    to this transform.

    *******************************************************
    Copyright (c) 2005 Zero G Software, Inc.
    InstallAnywhere is a registered trademark of
    Zero G Software, Inc., all rights reserved.
    514 Bryant St., California, 94107, U.S.A.

    The DevNet license agreement gives you specific rights
    with regard to using this code in your own projects and
    in derivative works.  See the DevNet license agreement
    for more information.
    *******************************************************

    InstallAnywhere Project Info Transform:

    This XSLT transform, when applied to an InstallAnywhere project
    file produces an HTML project summary including

        * A breakdown of the installation dependencies for Install Sets,
          Features and Components,
        * Detailed information for each of these components,
        * a listing of the installer properties that are modifiable
          with the ia_chg_prop.xsl transform, and
        * much more.

-->

<!DOCTYPE htmlEntities [
  <!ENTITY copy "&#169;">
]>

<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="1.0">

<xsl:output method="html" encoding="UTF-8" standalone="yes" />

<xsl:key name="installActions" match="//installChildren/object[@objectID]" use="@objectID"/>

<xsl:template match="/">
<html>
    <head>
        <title>InstallAnywhere Project Info: <xsl:value-of select="//property[@name='productName']/string"/></title>
        <link rel="stylesheet" href="default.css" type="text/css" />
    </head>

    <body>
        <h1>Product Name: <xsl:value-of select="//property[@name='productName']/string"/></h1>

        <p><b>Executable name:</b><xsl:text> </xsl:text><xsl:value-of select="//property[@name='installerName']/string"/></p>

        <h2>Table of Contents</h2>

        <br/><br/>
        <ul>
            <li><b>Product Organization</b>
            <ul>
                <li><a href="#i">Installer</a></li>
                <li><a href="#is">Install Sets</a></li>
                <li><a href="#f">Features</a></li>
                <li><a href="#c">Components</a></li>
            </ul></li>
            <li><b>Installation Sequences</b>
            <ul>
                <li><a href="#preinstall">Pre-Installation Actions and Panels</a></li>
                <li><a href="#install">Installation Actions </a></li>
                <li><a href="#postinstall">Post-Installation Actions and Panels</a></li>
            </ul></li>
            <li><a href="#ip"><b>Installer Properties</b></a></li>
        </ul>
        <br/>
        <hr/>

        <a name="i"><h2>Installer</h2></a><br />
        <ul>
        <xsl:for-each select="//object[@class='com.zerog.ia.installer.Installer']">
            <xsl:sort select="property[@name='installerName']" order="ascending"/>

            <li>
                <xsl:apply-templates mode="detail" select="."/>
                <br />
            </li>

        </xsl:for-each>
        </ul>
        <hr />

        <a name="is"><h2>Install Sets</h2></a><br />
        <ul>
        <xsl:for-each select="//object[@class='com.zerog.ia.installer.InstallSet']">
            <xsl:sort select="property[@name='installSetName']" order="ascending"/>

            <li>
                <xsl:apply-templates mode="detail" select="."/>
                <br />
            </li>

        </xsl:for-each>
        </ul>
        <hr />

        <a name="f"><h2>Features</h2></a><br />
        <ul>
        <xsl:for-each select="//descendant::object[@class='com.zerog.ia.installer.InstallBundle']">
            <xsl:sort select="property[@name='bundleName']" order="ascending"/>

            <li>
                <xsl:apply-templates mode="detail" select="."/>
                <br />
            </li>

        </xsl:for-each>
        </ul>
        <hr />

        <a name="c"><h2>Components</h2></a><br />
        <ul>
        <xsl:for-each select="//object[@class='com.zerog.ia.installer.InstallComponent']">
            <xsl:sort select="property[@name='componentName']" order="ascending"/>

            <li>
                <xsl:apply-templates mode="detail" select="."/>
                <br />
            </li>

        </xsl:for-each>
        </ul>
        <hr />

        <h2><a name="preinstall">Pre-Installation Tasks</a></h2>
        <ol>
            <xsl:apply-templates select="//property[@name='preInstallActions']//method/object"/>
        </ol>
        <hr />
        
        <h2><a name="install">Installation Tasks</a></h2>
        <xsl:apply-templates select="/InstallAnywhere_Deployment_Project/installationObjects/object/visualChildren"/>
        <hr />

        <h2><a name="postinstall">Post-Installation Tasks</a></h2>
        <ol>
            <xsl:apply-templates select="//property[@name='postInstallActions']//method/object"/>
        </ol>
        <hr />

        <a name="ip"><h2>Installer Properties</h2></a><br />
        <!-- for each Installer property, list in a table -->
        <xsl:for-each select="//object[@class='com.zerog.ia.installer.Installer']/property">
            <!-- sort by object type first then by property name -->
            <xsl:sort select="name(child::*[position()=1])" order="descending"/>
            <xsl:sort select="@name"/>

            <!-- only show properties with simple types -->
            <xsl:if test="not(name(child::*[position()=1])='object')">
            <br />

            <table>

                <tr>
                    <!-- prop name -->
                    <td class="propname"><b><xsl:value-of select="@name"/></b></td>

                    <!-- type name
                    <td class="proptype">
                        <b><xsl:value-of select="name(child::*[position()=1])"/></b>

                        <xsl:if test="child::*[position()=1]/@class">
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="child::*[position()=1]/@class"/>
                            <xsl:text>) </xsl:text>
                        </xsl:if>
                    </td> -->
                </tr>
                <tr>
                    <!-- prop value -->
                    <td class="propval" colspan="2"><xsl:value-of select="."/></td>
                </tr>
            </table>
            </xsl:if>
        </xsl:for-each>

        <hr/>
        <div class="copyright">
            &copy; 2002-3 Zero G Software, Inc. All rights reserved.  Zero G Software, Inc., Zero G, ZeroG.com,
            the Zero G logo, InstallAnywhere, the InstallAnywhere logo, PowerUpdate, PowerUpdate.com,
            the PowerUpdate logo, LaunchAnywhere, and SpeedFolder are trademarks or registered trademarks
            of Zero G Software, Inc. in the United States, other countries, or both.
        </div>
    </body>
</html>
</xsl:template>

<!-- This template provides the recursion through the visual tree -->
<xsl:template match="visualChildren">
    <xsl:choose>
        <xsl:when test="../@class='com.zerog.ia.installer.GhostDirectory'">
            <ol type="a">
                <xsl:apply-templates select="object"/>
            </ol>
        </xsl:when>
        <xsl:otherwise>
            <ol>
                <xsl:apply-templates select="object"/>
            </ol>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Template to match an object element that is reference to an already defined object -->
<xsl:key name="oid" match="object" use="@objectID"/>

<xsl:template match="object[@refID]">
        <xsl:variable name="targetID" select="@refID"/>
        <xsl:apply-templates select="key('oid',$targetID)"/>
</xsl:template>

<!-- Template to match an installer object -->
<xsl:template match="object[@class='com.zerog.ia.installer.Installer']">
    <xsl:apply-templates select="visualChildren"/>
</xsl:template>

<!-- Template to match an installset object -->
<xsl:template match="object[@class='com.zerog.ia.installer.InstallSet']">
    <!-- xsl:apply-templates select="installChildren"/ -->
</xsl:template>

<!-- Template to match an installbundle object -->
<xsl:template match="object[@class='com.zerog.ia.installer.InstallBundle']">
    <xsl:apply-templates select="visualChildren"/>
</xsl:template>

<!-- Template to match an installcomponent object -->
<xsl:template match="object[@class='com.zerog.ia.installer.InstallComponent']">
    <xsl:apply-templates select="visualChildren"/>
</xsl:template>

<!-- Template to match an ghostdirectory object -->
<xsl:template match="object[@class='com.zerog.ia.installer.GhostDirectory']">
    <li>
        <b>Directory:</b>
        <xsl:apply-templates select="property[@name='destinationFolder']/object"/>
        <xsl:apply-templates select="visualChildren"/>
    </li>
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.Billboard']">
    <li>
        <b>Show Billboard:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='imageName']/string"/>
    </li>
</xsl:template>

<!-- Templates for pre-defined directories -->
<xsl:template match="object[@class='com.zerog.ia.installer.util.magicfolders.InstallDirMF']">
User Install Dir
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.util.magicfolders.UserHomeMF']">
User Home Dir
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.util.magicfolders.IATempMF']">
Installer Temp Dir
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.util.magicfolders.ShortcutsMF']">
Shortcuts Dir
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.util.magicfolders.UserMagicFolder1MF']">
User Magic Folder 1
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.util.magicfolders.UserMagicFolder2MF']">
User Magic Folder 2
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.util.magicfolders.UserMagicFolder3MF']">
User Magic Folder 3
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.util.magicfolders.UserMagicFolder4MF']">
User Magic Folder 4
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.util.magicfolders.UserMagicFolder5MF']">
User Magic Folder 5
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.util.magicfolders.UserMagicFolder6MF']">
User Magic Folder 6
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.util.magicfolders.UserMagicFolder7MF']">
User Magic Folder 7
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.util.magicfolders.UserMagicFolder8MF']">
User Magic Folder 8
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.util.magicfolders.UserMagicFolder9MF']">
User Magic Folder 9
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.util.magicfolders.UserMagicFolder10MF']">
User Magic Folder 10
</xsl:template>

<!-- Templates for Actions -->

<!-- Create Shortcut action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.CreateShortcut']">
    <li>
        <b>Create Shortcut:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='destinationName']/string"/>
        <p><b><i>Target</i></b></p>
        <p><xsl:value-of select="property[@name='existingFilePath']/string"/></p>
        <p><b><i>Arguments</i></b></p>
        <p><xsl:value-of select="property[@name='args']/string"/></p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Get Windows Registry entry action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.GetRegEntry']">
    <li>
        <b>Get Windows Registry Entry:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='key']/string"/>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Advancect User Input action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.GetUserInput']">
    <li>
        <b>Get User Input:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='title']/string"/>
        <p>
        <xsl:value-of select="property[@name='prompt']/string"/>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Advanced User Input Console action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.GetUserInputConsole']">
    <li>
        <b>Get User Input - Console:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='title']/string"/>
        <p>
        <xsl:value-of select="property[@name='prompt']/string"/>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Choose Install Set action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.ChooseInstallSetAction']">
    <li>
        <b>Choose Install Set:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='title']/string"/>
        <p>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Choose Install Set Console action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.ChooseInstallSetActionConsole']">
    <li>
        <b>Choose Install Set - Console:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='title']/string"/>
        <p>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Choose Install Directory action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.InstallDirAction']">
    <li>
        <b>Choose Install Directory:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='title']/string"/>
        <p>
        <b><i>Prompt:</i></b>
        </p>
        <p>
        <xsl:value-of select="property[@name='prompt']/string"/>
        </p>
        <p>
        <b><i>Instructions:</i></b>
        <xsl:value-of select="property[@name='additionalText']/string"/>
        </p>
        <p>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Choose Install Directory Console action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.InstallDirActionConsole']">
    <li>
        <b>Choose Install Directory - Console:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='title']/string"/>
        <p>
        <b><i>Prompt:</i></b>
        </p>
        <p>
        <xsl:value-of select="property[@name='prompt']/string"/>
        </p>
        <p>
        <b><i>Instructions:</i></b>
        <xsl:value-of select="property[@name='additionalText']/string"/>
        </p>
        <p>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>


<!-- Choose Install Summary action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.InstallSummary']">
    <li>
        <b>Pre-Install Summary:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='title']/string"/>
        <p>
        <b><i>Prompt:</i></b>
        </p>
        <p>
        <xsl:value-of select="property[@name='stepPrompt']/string"/>
        </p>
        <p>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Choose Install Summary Console action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.InstallSummaryConsole']">
    <li>
        <b>Pre-Install Summary Console:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='title']/string"/>
        <p>
        <b><i>Prompt:</i></b>
        </p>
        <p>
        <xsl:value-of select="property[@name='stepPrompt']/string"/>
        </p>
        <p>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Choose Install Complete action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.InstallCompleteAction']">
    <li>
        <b>Install Complete Summary:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='stepTitle']/string"/>
        <p>
        <b><i>Message:</i></b>
        </p>
        <p>
        <xsl:value-of select="property[@name='message']/string"/>
        </p>
        <p>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Choose Install Complete Console action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.InstallCompleteActionConsole']">
    <li>
        <b>Install Complete Summary - Console:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='stepTitle']/string"/>
        <p>
        <b><i>Message:</i></b>
        </p>
        <p>
        <xsl:value-of select="property[@name='message']/string"/>
        </p>
        <p>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Choose Install Failed action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.InstallFailedAction']">
    <li>
        <b>Install Failed Summary:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='stepTitle']/string"/>
        <p>
        <b><i>Message:</i></b>
        </p>
        <p>
        <xsl:value-of select="property[@name='message']/string"/>
        </p>
        <p>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Choose Install Failed Console action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.InstallFailedActionConsole']">
    <li>
        <b>Install Failed Summary - Console:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='stepTitle']/string"/>
        <p>
        <b><i>Message:</i></b>
        </p>
        <p>
        <xsl:value-of select="property[@name='message']/string"/>
        </p>
        <p>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>


<!-- Choose Shortcut selection Panel action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.ShortcutLocAction']">
    <li>
        <b>Choose Shortcut Location</b>
        <p>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Expand Archive action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.ExpandFile']">
    <li>
        <b>Expand Archive:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='sourceName']/string"/>
        <xsl:apply-templates select="rules"/>
        </li>
        </xsl:template>

        <xsl:template match="object[@class='com.zerog.ia.installer.actions.InstallDirCont']">
        <li>
        <b>Install SpeedFolder</b>
        <p>
        <b><i>Source Path</i>:</b><xsl:value-of select="property[@name='sourcePath']/string"/>
        </p>
        <p>
        <b><i>Destination Path</i>:</b><xsl:value-of select="property[@name='destinationName']/string"/>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Install File action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.InstallFile']">
    <li>
        <b>Install File</b>
        <p>
        <b><i>Source Name</i>:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='sourceName']/string"/>
        </p>
        <p>
        <b><i>Destination Name</i>:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='destinationName']/string"/>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Delete File action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.DeleteFileAction']">
  <li>
      <b>Delete File</b>
      <p>
      <b><i>File to be deleted</i>:</b>
      <ul>
      <xsl:value-of select="property[@name='existingFilePath']/string"/>
      </ul>
      </p>
      <xsl:apply-templates select="rules"/>
  </li>
</xsl:template>

<!-- Delete Folder action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.DeleteFolderAction']">
    <li>
        <b>Delete Folder</b>
        <p>
        <b><i>Folder to be deleted</i>:</b>
        <ul>
        <xsl:apply-templates select="property[@name='targetAction']/object"/>
        </ul>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!--  Modify Text File Action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.ASCIIFileManipulator']">
    <li>
        <b>Modify Text File</b>
        <p><b><i>Existing File</i>:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='systemFilePath']/string"/></p>

        <xsl:if test="property[@name='additionalText']">
            <p><b><i>Additional Text</i></b></p>
            <p><xsl:value-of select="property[@name='additionalText']/string"/></p>
        </xsl:if>

        <p>
            <b><i>Substitute IA Variables</i>:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='substituteIAVariables']/boolean"/>
        </p>

        <!-- if we have any manual substitution strings, show them now -->

        <xsl:if test="property[@name='searchAndReplaceVector']/object/method/object">
            <p>
                <table border="1" width="100%">
                <tr>
                    <td width="50%"><b>Name</b></td>
                    <td width="50%"><b>Value</b></td>
                </tr>

                <xsl:for-each select="property[@name='searchAndReplaceVector']/object/method/object[@class='com.zerog.ia.installer.util.SearchAndReplacePropertyData']">
                    <tr>
                        <td width="50%"><xsl:value-of select="property[@name='propertyName']/string"/></td>
                        <td width="50%"><xsl:value-of select="property[@name='propertyValue']/string"/></td>
                    </tr>
                </xsl:for-each>
                </table>
            </p>
        </xsl:if>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!--  Modify Text Files Action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.SpeedASCIIFileManipulator']">
    <li>
        <b>Modify Text Files</b>
        <p><b><i>Existing File</i>:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='systemFilePath']/string"/></p>
        <p><b><i>Substitute IA Variables</i>:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='substituteIAVariables']/boolean"/></p>

        <!-- if we have any manual substitution strings, show them now -->

        <xsl:if test="property[@name='searchAndReplaceVector']/object/method/object">
            <p>
                <table border="1" width="100%">
                    <tr>
                      <td width="50%"><b>Name</b></td>
                      <td width="50%"><b>Value</b></td>
                    </tr>

                    <xsl:for-each select="property[@name='searchAndReplaceVector']/object/method/object">
                        <tr>
                          <td width="50%"><xsl:value-of select="property[@name='propertyName']/string"/></td>
                          <td width="50%"><xsl:value-of select="property[@name='propertyValue']/string"/></td>
                        </tr>
                    </xsl:for-each>
                </table>
            </p>
        </xsl:if>

        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!--  Comment Action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.Comment']">
    <li>
        <b>Comment</b>
        <p>
        <xsl:value-of select="property[@name='commentStr']/string"/>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Move Folder Action -->
<!-- TODO:  need to fix the source folder here to just get the name and not the whole object -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.MoveFolderAction']">
    <li>
        <b>Move Folder</b>
        <p> Source Folder
            <ul>
                <xsl:apply-templates select="property[@name='targetAction']/object"/>
            </ul>
        </p>
        <p>
            <b><i>Destination</i>:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='destination']/string"/>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>


<!--  Copy File Action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.CopyFileAction']">
    <li>
        <b>Copy File</b>
        <p>
            <b><i>Existing File</i>:</b><xsl:value-of select="property[@name='existingFilePath']/string"/>
        </p>
        <p>
            <b><i>Destination</i>:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='destination']/string"/>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Template to match an introAction panel action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.IntroAction']">
    <li>
        <b>Introduction Panel</b>
        <p>
        <xsl:value-of select="property[@name='message']/string"/>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Template to match a introAction console action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.IntroActionConsole']">
    <li>
        <b>Introduction Console</b>
        <p>
        <xsl:value-of select="property[@name='message']/string"/>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Template to match a custom action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.CustomAction']">
    <li>
        <b>Custom Action:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='clientClassFullName']/string"/>
        <p>
        <xsl:value-of select="property[@name='commentStr']/string"/>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>


<!-- Template to match a Choose Folder panel -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.ChooseFolder']">
    <li>
        <b>Choose Folder:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='stepTitle']/string"/>
        <p><b><i>Instructions</i></b></p>
        <p>
        <xsl:value-of select="property[@name='additionalText']/string"/>
        </p>
        <p><b><i>Result</i></b></p>
        <p>
        <xsl:value-of select="property[@name='selection']/string"/>
        </p>
        <p>
        <xsl:apply-templates select="rules"/>
        </p>
    </li>
</xsl:template>

<!-- Template to match a show dialog action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.ShowDialogAction']">
    <li>
        <b>Show Dialog:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='title']/string"/>
        <p>
            <xsl:value-of select="property[@name='narrative']/string"/>
        </p>
        <p>
            <xsl:apply-templates select="rules"/>
        </p>
        <p>
            <b><i>Properties</i></b>

            <table border="1" width="100%">
                <tr>
                    <td width="50%"><b>Property</b></td>
                    <td width="50%"><b>Value</b></td>
                </tr>

                <xsl:apply-templates select="property"/>

            </table>
        </p>
    </li>
</xsl:template>


<!-- Template to match a display message action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.DisplayMessage']">
    <li>
        <b>Display Message:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='stepTitle']/string"/>
        <p>
        <xsl:value-of select="property[@name='message']/string"/>
        </p>
        <p>
        <xsl:apply-templates select="rules"/>
        </p>
    </li>
</xsl:template>


<!-- Template to match a execute Script action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.ExecuteScript']">
    <li>
        <b>Execute Script:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='comment']/string"/>
        <p>
        <b><i>Script</i></b>
        </p>
        <p>
        <xsl:value-of select="property[@name='script']/string"/>
        </p>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Template to match an Execute action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.Exec']">
    <li>
        <b>Execute Command:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='commandLineArgs']/string"/>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Template to match a perform an XSLT transformation action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.PerformXSLT']">
    <li>
        <b>Perform XSLT Transformation</b>
        <p>

        <b><i>Source File</i>:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='sourceSystemFilePath']/string"/>
        </p>
        <p>
        <b><i>Source XSL</i>:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='transformationSystemFilePath']/string"/>
        </p>

        <xsl:choose>
            <xsl:when test="property[@name='destinationFileType'] = 3">
                <p>
                <b><i>Resulting Variable</i>:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='destinationVariable']/string"/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <b><i>Resulting File</i>:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='destinationFile']/string"/>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>

<!-- Template to match a set single variable action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.EditVariableTable']">
    <li>
        <b>Edit Single Variable:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='name']/string"/>=<xsl:value-of select="property[@name='value']/string"/>

        <p>
        <xsl:apply-templates select="rules"/>
        </p>
    </li>
</xsl:template>

<!-- Template to match a set multiple variables action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.EditMultipleVariables']">
    <li>
        <b>Edit Multiple Variables</b>
        <p>
            <xsl:apply-templates select="rules"/>
        </p>
        <p>
            <b><i>Variables</i></b>
            <table border="1" width="100%">
                <tr>
                    <td width="50%"><b>Name</b></td>
                    <td width="50%"><b>Value</b></td>
                </tr>

                <xsl:for-each select="property[@name='propertyList']/*/*/object">
                    <tr>
                        <td width="50%"><xsl:value-of select="property[@name='propertyName']/string"/></td>
                        <td width="50%"><xsl:value-of select="property[@name='propertyValue']/string"/></td>
                    </tr>
                </xsl:for-each>

            </table>
        </p>
    </li>
</xsl:template>


<!-- Template to match a Launch Default Browser action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.LaunchDefaultBrowser']">
    <li>
        <b>Launch Default Browser:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='target']/object/property[@name='destinationName']/string"/>
        <xsl:apply-templates select="rules"/>
        <p></p>
    </li>
</xsl:template>

<!-- Template to match a jump label action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.JumpLabel']">
    <li>
        <b>Jump Label:</b><xsl:text> </xsl:text><xsl:value-of select="property[@name='label']/string"/>
        <xsl:apply-templates select="rules"/>
        <p></p>
    </li>
</xsl:template>

<!-- Template to match a jump to action -->
<xsl:template match="object[@class='com.zerog.ia.installer.actions.JumpAction']">
    <li>
        <b>Jump To Action</b>
        <p>
            <xsl:apply-templates select="rules"/>
        </p>
        <p>
            <dl>
                <dt><b><i>Back</i></b></dt>
                <dd><xsl:value-of select="property[@name='previousTarget']/object[@class='com.zerog.ia.installer.actions.JumpLabel']/property[@name='label']/string"/></dd>
                <dt><b><i>Next</i></b></dt>
                <dd>
                    <xsl:choose>
                        <xsl:when test="property[@name='nextTarget']/object[@refID]">
                            <xsl:text>Not sure how to get this value</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="property[@name='nextTarget']/object[@class='com.zerog.ia.installer.actions.JumpLabel']/property[@name='label']"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </dd>
            </dl>
        </p>
    </li>
</xsl:template>

<!--  Utility Object types -->

<xsl:template match="object[@class='com.zerog.ia.installer.util.GUIGroupData']">
    <!-- just ignore these for now -->
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.util.GUIComponentData']">
    <!-- just ignore these now -->
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.util.VariablePropertyData']">
    <!-- just ignore these now -->
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.util.EntryAtom']">
    <!-- just ignore these now -->
</xsl:template>

<xsl:template match="object[@class='com.zerog.ia.installer.actions.InstallDirectory']">
    <!-- just ignore these now -->
</xsl:template>


<!-- Templates for Rules -->

<!-- Template to match the Rules property of an object -->
<xsl:template match="rules">
    <p>
        <b><i>Rules </i>(Logical Operator = <xsl:value-of select="@logicalOperation"/>)</b>

        <table border="1" width="100%">
            <tr>
                <td width="50%"><b>Type of Rule</b></td>
                <td width="50%"><b>Details</b></td>
            </tr>

            <xsl:for-each select="object">
                <xsl:apply-templates select="."/>
            </xsl:for-each>
        </table>
    </p>
</xsl:template>

<!-- Template to match a CompareVariable Rule -->
<xsl:template match="object[@class='com.zerog.ia.installer.rules.CompareVariable']">
    <tr>
        <td width="50%">Compare Variable</td>
        <td width="50%"><xsl:value-of select="property[@name='operandOne']/string"/><xsl:text> </xsl:text><xsl:value-of select="property[@name='operation']/string"/><xsl:text> </xsl:text><xsl:value-of select="property[@name='operandTwo']/string"/></td>
    </tr>
</xsl:template>

<!-- Template to match a FileFolder Check Rule -->
<xsl:template match="object[@class='com.zerog.ia.installer.rules.FileFolderPathChk']">
    <tr>
        <td width="50%">File Folder Check</td>
        <td width="50%"><xsl:for-each select="property"><b><xsl:value-of select="@name"/>:</b><xsl:text> </xsl:text><xsl:value-of select="*"/><xsl:text> </xsl:text></xsl:for-each></td>
    </tr>
</xsl:template>

<!-- Template to match a PlatformChk Check Rule -->
<xsl:template match="object[@class='com.zerog.ia.installer.rules.PlatformChk']">
    <tr>
        <td width="50%">Platform Check</td>
        <td width="50%"><xsl:apply-templates select="property[@name='installOnPlatformList']"/><p><xsl:apply-templates select="property[@name='doNotInstallOnPlatformList']"/></p></td>
    </tr>
</xsl:template>


<!--  Template to match properties -->

<!--  Template to match an installon property -->
<xsl:template match="property[@name='installOnPlatformList']">
    <b>Install On:</b><xsl:for-each select="object/method/string"><xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>" </xsl:text></xsl:for-each>
</xsl:template>

<!--  Template to match an do not installon property -->
<xsl:template match="property[@name='doNotInstallOnPlatformList']">
    <b>Do Not Install On:</b><xsl:for-each select="object/method/string"><xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>" </xsl:text></xsl:for-each>
</xsl:template>

<!-- Template to add a method -->
<xsl:template match="method">
    <li>
        found method <xsl:value-of select="@name"/>.
    </li>
</xsl:template>

<!--  Template to match a generic property -->
<!--  This template assumes you are adding the property to a tabular display that lists property name and value -->
<xsl:template match="property">
    <tr>
        <td width="50%"><xsl:value-of select="@name"/></td>
        <td width="50%"><xsl:value-of select="string"/></td>
    </tr>
</xsl:template>

<!-- Template to match a generic Object -->
<xsl:template match="object">
    <li>
        <font color="#bb0000">The project transform does not yet display
        objects of this type (<xsl:value-of select="@class"/>).</font> <br/><br/>
        <xsl:apply-templates select="rules"/>
    </li>
</xsl:template>


<!-- version 1 templates below -->

<!-- installer detail -->
<xsl:template match="object[@class='com.zerog.ia.installer.Installer']" mode="detail">
    <a name="{generate-id()}">
    <h3><xsl:value-of select="property[@name='installerName']"/></h3></a>
    <br />

    <b>Installer Title</b>: <xsl:value-of select="property[@name='productName']"/>
    <br />

    <b>Locales to build</b>: <xsl:value-of select="property[@name='localesToBuild']"/>
    <br />

    <xsl:if test="property[@name='isMergeModule']/boolean='true'">
        <br /><div class="warn">Installer is a Merge Module</div>
        <br />
        <b>Advertised Variables</b>:
        <xsl:for-each select="property[@name='advertisedVariables']/descendant::string">
            <xsl:value-of select="."/>
            <xsl:if test="position()!=last()">, </xsl:if>
        </xsl:for-each>
        <br />
    </xsl:if>

    <br />

    <xsl:call-template name="installerInfoData">
        <xsl:with-param name="iid" select="property[@name='installerInfoData']/object[1]"/>
    </xsl:call-template>
</xsl:template>


<!-- installerInfoData -->
<xsl:template name="installerInfoData">
    <xsl:param name="iid"/>

    <h4>Product Info</h4>
    <div class="refid"><xsl:text> </xsl:text>[Localization ID:<xsl:value-of select="$iid/@objectID"/>]</div>
    <br />

    <b>Product Name</b>: <xsl:value-of
        select="$iid/property[@name='productName']"/>
    <br />

    <b>Version</b>:
    <xsl:call-template name="prodVersion">
        <xsl:with-param name="object" select="$iid"/>
    </xsl:call-template>
    <br />

    <b>Copyright</b>: <xsl:value-of
        select="$iid/property[@name='copyright']"/>
    <br />

    <b>UUID</b>:
    <xsl:call-template name="uuid">
        <xsl:with-param name="uuid" select="$iid/property[@name='productID']"/>
    </xsl:call-template>
    <br />

    <b>Vendor UUID</b>:
    <xsl:call-template name="uuid">
        <xsl:with-param name="uuid" select="$iid/property[@name='vendorID']"/>
    </xsl:call-template>
    <br />
</xsl:template>


<!-- install set detail -->
<xsl:template match="object[@class='com.zerog.ia.installer.InstallSet']" mode="detail">
    <a name="{generate-id()}">
    <h3><xsl:value-of select="property[@name='installSetName']"/></h3></a>
    <div class="refid">[Localization ID:<xsl:value-of select="@objectID"/>]</div>
    <br />

    <b>Description</b>:
        <xsl:value-of select="property[@name='description']"/>
    <br />
</xsl:template>


<!-- feature detail -->
<xsl:template match="object[@class='com.zerog.ia.installer.InstallBundle']" mode="detail">
    <a name="{generate-id()}">
    <h3><xsl:value-of select="property[@name='bundleName']"/></h3></a>
    <div class="refid">[Localization ID:<xsl:value-of select="@objectID"/>]</div>
    <br />

    <b>Description</b>:
        <xsl:value-of select="property[@name='description']"/>
    <br />
</xsl:template>

<!-- component detail -->
<xsl:template match="object[@class='com.zerog.ia.installer.InstallComponent']" mode="detail">
    <a name="{generate-id()}">
    <h3><xsl:value-of select="property[@name='componentName']"/></h3></a>
    <br />

    <b>Version</b>:
    <xsl:call-template name="version">
        <xsl:with-param name="object" select="."/>
    </xsl:call-template>
    <br />

    <b>UUID</b>:
    <xsl:call-template name="uuid">
        <xsl:with-param name="uuid" select="property[@name='uniqueId']"/>
    </xsl:call-template>
    <br />

    <xsl:if test="property[@name='keyFile']/object">
        <b>Keyfile</b>:
            <xsl:value-of select="property[@name='keyFile']/object/property[@name='destinationName']"/>
        <br />
    </xsl:if>

    <div class="comment">
        <xsl:value-of select="property[@name='comment']"/>
    </div>

</xsl:template>

<!-- pretty prints a version property -->
<xsl:template name="version">
    <xsl:param name="object"/>
    <xsl:value-of select="normalize-space($object/property[@name='versionMajor'])"/>.<xsl:value-of select="normalize-space($object/property[@name='versionMinor'])"/>.<xsl:value-of select="normalize-space($object/property[@name='versionRevision'])"/>.<xsl:value-of select="normalize-space($object/property[@name='versionSubRevision'])"/>
</xsl:template>

<!-- pretty prints a product version property -->
<xsl:template name="prodVersion">
    <xsl:param name="object"/>
    <xsl:value-of select="normalize-space($object/property[@name='productVersionMajor'])"/>.<xsl:value-of select="normalize-space($object/property[@name='productVersionMinor'])"/>.<xsl:value-of select="normalize-space($object/property[@name='productVersionRevision'])"/>.<xsl:value-of select="normalize-space($object/property[@name='productVersionSubRevision'])"/>
</xsl:template>

<!-- pretty prints a uuid -->
<xsl:template name="uuid">
    <xsl:param name="uuid"/>
    <div class="uuid"><xsl:value-of select="normalize-space($uuid//string)"/></div>
</xsl:template>

<!-- pretty prints a refid -->
<xsl:template name="refid">
    <xsl:param name="refid"/>
    <div class="refid"><xsl:value-of select="normalize-space($refid)"/></div>
</xsl:template>

</xsl:stylesheet>

<!-- END OF DOCUMENT -->
