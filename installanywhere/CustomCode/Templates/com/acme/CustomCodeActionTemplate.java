/**
 * @(#)CustomCodeActionTemplate.java 1.1 11/10/1003
 * 
 * Use this class as a starting point for creating your own custom code action.
 * 
 */

package com.acme;		// you should change this to your own package location

import com.zerog.ia.api.pub.*;
import java.net.*;
import java.io.*;

/**
 * CustomCodeActionTemplate.java
 * 
 * Use this class as a starting point for creating your own custom code action.
 * 
 */
public class CustomCodeActionTemplate extends CustomCodeAction
{

	/**
	 *	This is the method that is called at install-time.  The InstallerProxy
	 *  	instance provides methods to access information in the installer,
	 *  	set status, and control flow.
	 */
	public void install( InstallerProxy ip ) throws InstallException
	{
		/**
		 * 	Example code.  The examples appear commented out with //
		 */
			
		
		
		/**
		 *	Returns an instance of java.net.URL that refers to a resource
		 *  	located in the user's ZIP or JAR.
		 *	
		 *  	@param archivePath a forward-slash delimited path relative to
		 *  	the root of the user's archive.  For example "com/acme/picture.gif".
		 */

		//	URL myURL = ip.getResource( "folder/file" );
	

		
		/**
		 *	Returns a temporary directory.  InstallAnywhere will delete
		 *	it at the completion of the installer or uninstaller.
		 */
		
		//	File myFile = ip.getTempDirectory();

		
		
		/**
		 *	Stores the contents of the given URL to a temporary file
		 *	and returns an instance of java.io.File that refers to it.
		 */
		
		//	File myFile = ip.saveURLContentToFile( myURL );
	
	
	
		/**
		 *	Resolves all of the InstallAnywhere variables in a string.
		 *  	If the string contains a variable, and resolving that variable then
		 *  	contains another variable, that too will be resolved until all variables
		 *  	have been resolved.  If a variable cannot be resolved, it evaluates to an
		 *  	empty string ("").
		 */

		//	String myString = ip.substitute( "myVariable" );


		
		/**
		 *	Returns the value of the named variable.  If no variable is defined
		 *	for that name, returns null.
		 */
		
		//	String myString = (String)ip.getVariable( "myVariable" );
	
	
	
		/**
		 *	Sets the named variable to to refer to the value. If the variable
		 *	was already set, its previous value is returned.  Otherwise,
		 *	returns null.
		 */
		
		//	Object previousValue = ip.setVariable( "myVariable", "theValue" );
		
	
	
		/**
		 *	For Internationalization support.
		 *  	Gives access to locale-specific static GUI strings.
		 */
		
		// 	String myString = ip.getValue( "myKey", "es" );



		/**
		 *	For Internationalization support.
		 *  	Gives access to locale-specific static GUI strings.
		 *	Returns the resource for the user's chosen installation locale.
		 */
		
		//	String myString = ip.getValue( "myKey" );



		/**
		 *	This method is returns an instance that implements
		 *	java.io.DataOutput.  Information written to that instance
		 *	will be available at uninstall-time from the DataInput returned
		 *	by getLogInput().
		 */
		
		//	DataOutput myDataOutput = ip.getLogOutput();
		//  	myDataOutput.writeUTF("\n\n\"Now is the time.\tOr, not ...\"" );
		//  	myDataOutput.write( (int)66 );
		//  	myDataOutput.write( (int)-45 );
		//  	myDataOutput.write( new byte[] { -128, 0, 127 } );
		//  	myDataOutput.writeBoolean( true );
		//  	myDataOutput.writeBoolean( false );
		//  	myDataOutput.writeByte( (int)1 );
		//  	myDataOutput.writeShort( (int)32767 );
		//  	myDataOutput.writeShort( (int)-32768 );
		//  	myDataOutput.writeChar( 5381 );
		//  	myDataOutput.writeChar( '\"' );
		//  	myDataOutput.writeChar( ',' );
		//  	myDataOutput.writeInt( (int)820129 );
		//  	myDataOutput.writeLong( (int)820129 );
		//  	myDataOutput.writeFloat( 3.1415926535892f );
		//  	myDataOutput.writeDouble( 3.1415926535892d );
		//  	myDataOutput.writeBytes( "Now is the time." );
		//  	myDataOutput.writeChars( "Now is the time." );
		//  	myDataOutput.writeUTF( "Now is the time." );
		//  	myDataOutput.writeUTF( "\"\n\nNow is the\ttime to quote\"" );

	
	
		/**
		 *	This method never returns.  Similar to calling System.exit(),
		 *	except installer temporary files will be cleaned up.
		 */
		
		//	ip.abortInstallation( 0 );

		
		
		/**
		 *	Returns an instance of the requested service.
		 *	You must cast the object returned. It is guaranteed
		 *	to be the class (or subclass of) the requestedServiceClass.
		 *	The only service currently available is SimpleRegistryManager
		 */
		
		//	SimpleRegistryManager srm = (SimpleRegistryManager)ip.getService(SimpleRegistryManager.class);
		//	boolean success = srm.createRegistryKey("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey");
		//	boolean success = srm.deleteRegistryKey("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey");
		//	boolean success = srm.setRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue", "myValueData");
		//	boolean success = srm.setRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue", new Integer(1));
		//	Object valueData = srm.getRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue");
		//	boolean success = srm.deleteRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue");
		
	}

	
	/**
	 *  	This is the method that is called at uninstall-time.  The UninstallerProxy
	 *  	instance provides methods to access information in the uninstaller,
	 *  	set status, and control flow.  The DataInput instance provides access 
	 *  	to any information written at install-time with the instance of DataOutput
	 *  	provided by UninstallerProxy.getLogOutput().
	 */
	public void uninstall( UninstallerProxy up ) throws InstallException
	{
		/**
		 * 	Example code.  The examples appear commented out with //
		 */

		
		/**
		 *	This method is returns an instance that implements
		 *	java.io.DataOutput.  Information written to that instance
		 *	will be available at uninstall-time from the DataInput returned
		 *	by getLogInput().  The example sends the results to a file and matches the
		 *  	example above.
		 */

		//	DataInput din = up.getLogInput();
		//	PrintStream ps;
		//	try
		//	{
		//		ps = new PrintStream( new FileOutputStream( "test.txt" ) );
		//		ps.println( din.readUTF() );
		//		ps.println( din.readByte() );
		//		ps.println( din.readByte() );
		//		byte [] ba = new byte[3];
		//		din.readFully( ba );
		//		for ( int i = 0; i < ba.length; i++ )
		//			ps.println( ba[i] );
		//		ps.println( din.readBoolean() );
		//		ps.println( din.readBoolean() );
		//		ps.println( din.readByte() );
		//		ps.println( din.readShort() );
		//		ps.println( din.readShort() );
		//		ps.println( din.readChar() );
		//		ps.println( din.readChar() );
		//		ps.println( din.readChar() );
		//		ps.println( din.readInt() );
		//		ps.println( din.readLong() );
		//		ps.println( din.readFloat() );
		//		ps.println( din.readDouble() );
		//		ba = new byte[16];
		//		din.readFully( ba );
		//		for ( int i = 0; i < ba.length; i++ )
		//			ps.println( ba[i] );			
		//		for ( int i = 0; i < ba.length; i++ )
		//			ps.println( din.readChar() );
		//		ps.println( din.readUTF() );
		//		ps.println( din.readUTF() );
		//		ps.flush();
		//		ps.close();
		//	}
		//	catch ( IOException ioe )
		//	{
		//		ioe.printStackTrace();
		//	}

	
		
		/**
		 *  	Returns an instance of java.net.URL that refers to a resource
		 *	located in the user's ZIP or JAR.
		 *	
		 *	@param archivePath a forward-slash delimited path relative to
		 *		the root of the user's archive.  For example "com/acme/picture.gif".
		 */

		//	URL myURL = up.getResource( "folder/file" );
	
		
		
		/**
		 *	Returns a temporary directory.  InstallAnywhere will delete
		 *	it at the completion of the installer or uninstaller.
		 */
		
		//	File myFile = up.getTempDirectory();
		
		
		
		/**
		 *	Stores the contents of the given URL to a temporary file
		 *	and returns an instance of java.io.File that refers to it.
		 */
		
		//	File myFile = up.saveURLContentToFile( myURL );



		/**
		 *	Resolves all of the InstallAnywhere variables in a string.
		 *  	If the string contains a variable, and resolving that variable then
		 *  	contains another variable, that too will be resolved until all variables
		 *  	have been resolved.  If a variable cannot be resolved, it evaluates to an
		 *  	empty string ("").
		 */

		//	String myString = up.substitute( "myVariable" );



		/**
		 *	Returns the value of the named variable.  If no variable is defined
		 *	for that name, returns null.
		 */
		
		//	String myString = (String)up.getVariable( "myVariable" );
	

		
		/**
		 *	Sets the named variable to to refer to the value. If the variable
		 *	was already set, its previous value is returned.  Otherwise,
		 *	returns null.
		 */
		
		//	Object previousValue = up.setVariable( "myVariable", "theValue" );
	
		
		
		/**
		 *	For Internationalization support.
		 *  	Gives access to locale-specific static GUI strings.
		 */
		
		// 	String myString = up.getValue( "myKey", "es" );

		

		/**
		 *	For Internationalization support.
		 *  	Gives access to locale-specific static GUI strings.
		 *	Returns the resource for the user's chosen installation locale.
		 */
		
		//	String myString = up.getValue( "myKey" );
	
	
		
		/**
		 *	Returns an instance of the requested service.
		 *	You must cast the object returned. It is guaranteed
		 *	to be the class (or subclass of) the requestedServiceClass.
		 *	The only service currently available is SimpleRegistryManager
		 */
		
		//	SimpleRegistryManager srm = (SimpleRegistryManager)up.getService(SimpleRegistryManager.class);
		//	boolean success = srm.createRegistryKey("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey");
		//	boolean success = srm.deleteRegistryKey("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey");
		//	boolean success = srm.setRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue", "myValueData");
		//	boolean success = srm.setRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue", new Integer(1));
		//	Object valueData = srm.getRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue");
		//	boolean success = srm.deleteRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue");		
		
	}
	
	/**
	 *  	This method will be called to display a status message during the
	 *  	installation.
	 */
	public String getInstallStatusMessage()
	{
		return "My Action";	// screen will say "Installing... My Action"
	}
	
	/**
	 *  	This method will be called to display a status message during the
	 *  	uninstall.
	 */
	public String getUninstallStatusMessage()
	{
		return "My Action";	// screen will say "Uninstalling... My Action"
	}
}