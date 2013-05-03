/*
 * 	@(#)CustomCodePanel.java 1.1 11/10/1003
 * 
 * 	Use this class as a starting point for creating your own custom code panels.
 * 
 */

package com.acme;		// you should change this to your own package location

import java.awt.*;
import com.zerog.ia.api.pub.*;

/**
 * 	A <code>CustomCodePanel</code> is simply a Panel that can be displayed 
 * 	at install-time in the context of an installation step.
 *
 */
public class CustomCodePanelTemplate extends CustomCodePanel
{
	/**
	 * This method gets called prior to the Panel being displayed.
	 * This is useful for initializing the contained Components; In fact,
	 * all of the Components may be instantiated in this method.
	 * 
	 * It is very important that this method returns quickly so that the
	 * CustomCodePanel may be displayed when needed.  If it is necessary to
	 * do some lengthy processing, it must be done in a separate Thread.
	 * <br>
	 * <br>
	 * NOTE: If <code>setupUI():boolean</code> returns <code>false</code>,
	 *       to indicate that the CustomCodePanel should <i>not</i> be displayed,
	 *       the installation manager will go on without calling any of the
	 *       other methods in <code>CustomCodePanel</code>.
	 * <br>
	 * 
	 * @param customCodePanelProxy Provides access to designer-specified
	 * resources, system and user-defined variables, and international resources.
	 *
	 * @return <code>true</code> if the Panel should be displyed,
	 * <code>false</code> otherwise.  By default, this method returns
	 * <code>false</code>.
	 * 
	 * @see com.zerog.ia.api.pub.CustomCodePanelProxy
	 */
	public boolean setupUI(CustomCodePanelProxy customCodePanelProxy)
	{
		/**
		 * Example code.  The examples appear commented out with //
		 */
			
		
		
		/**
		 * Returns an instance of java.net.URL that refers to a resource
		 * located in the user's ZIP or JAR.
		 *	
		 * @param archivePath a forward-slash delimited path relative to
		 * the root of the user's archive.  For example "com/acme/picture.gif".
		 */

		//	URL myURL = customCodePanelProxy.getResource( "folder/file" );
	
		
		
		/**
		 * Returns a temporary directory.  InstallAnywhere will delete
		 * it at the completion of the installer or uninstaller.
		 */
		
		//	File myFile = customCodePanelProxy.getTempDirectory();
		
		
		
		/**
		 * Stores the contents of the given URL to a temporary file
		 * and returns an instance of java.io.File that refers to it.
		 */
		
		//	File myFile = customCodePanelProxy.saveURLContentToFile( myURL );
	
		
		
		/**
		 * Resolves all of the InstallAnywhere variables in a string.
		 * If the string contains a variable, and resolving that variable then
		 * contains another variable, that too will be resolved until all variables
		 * have been resolved.  If a variable cannot be resolved, it evaluates to an
		 * empty string ("").
		 */

		//	String myString = customCodePanelProxy.substitute( "myVariable" );

		
		
		/**
		 * Returns the value of the named variable.  If no variable is defined
		 * for that name, returns null.
		 */
		
		//	String myString = (String) customCodePanelProxy.getVariable( "myVariable" );
	
		
		
		/**
		 * Sets the named variable to to refer to the value. If the variable
		 * was already set, its previous value is returned.  Otherwise,
		 * returns null.
		 */
		
		//	Object previousValue = customCodePanelProxy.setVariable( "myVariable", "theValue" );
		
		
		
		/**
		 * For Internationalization support.
		 * Gives access to locale-specific static GUI strings.
		 */
		
		// 	String myString = customCodePanelProxy.getValue( "myKey", Locale.ENGLISH );


		
		/**
		 * For Internationalization support.
		 * Gives access to locale-specific static GUI strings.
		 * Returns the resource for the user's chosen installation locale.
		 */
		
		//	String myString = customCodePanelProxy.getValue( "myKey" );


		
		/**
		 * This method never returns.  Similar to calling System.exit(),
		 * except installer temporary files will be cleaned up.
		 */
		
		//	customCodePanelProxy.abortInstallation( 0 );

		
		
		/**
		 * Returns an instance of the requested service.
		 * You must cast the object returned. It is guaranteed
		 * to be the class (or subclass of) the requestedServiceClass.
		 * The only service currently available is SimpleRegistryManager
		 */
		
		//	SimpleRegistryManager srm = (SimpleRegistryManager)customCodePanelProxy.getService(SimpleRegistryManager.class);
		//	boolean success = srm.createRegistryKey("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey");
		//	boolean success = srm.deleteRegistryKey("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey");
		//	boolean success = srm.setRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue", "myValueData");
		//	boolean success = srm.setRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue", new Integer(1));
		//	Object valueData = srm.getRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue");
		//	boolean success = srm.deleteRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue");

		return true;	// true if you want your panel displayed or false if not
	}
	
	
	/**
	 * This method gets called immediately after the Panel is displayed.
	 * This is useful for doing some processing while the Panel is displayed,
	 * without having to wait for <code>okToContinue</code> to be called.
	 * Of course, this method will never be called if <code>setupUI()</code> 
	 * returns <code>false</code> to indicate that this 
	 * <code>CustomCodePanel</code> should not be displayed.
	 * The default implementation has an empty body.  Classes that extend
	 * CustomCodePanel may override this method if they wish to be notified
	 * when the Panel is displayed.
	 * 
	 * The method is optional and does not need to be implemented.
	 * 
	 * @see #okToContinue
	 */
	
	//	public void panelIsDisplayed()
	//	{
	//	}

	
	
	/**
	 * This method gets called prior to continuing on with the installer.
	 * Classes that extend CustomCodePanel may wish to override this method 
	 * to do some runtime checks to see if it is ok to continue with the 
	 * installation process.
	 * 
	 * The method is optional and does not need to be implemented.
	 * 
	 * @return <code>true</code> if it ok to continue, <code>false</code>
	 * otherwise.  By default, this method returns <code>true</code>.
	 */
	
	//	public boolean okToContinue()
	//	{
	//		return true;	// or false
	//	}
	
	
	
	/**
	 * This method returns the String to be displayed on the installation
	 * step of which this Panel will be contained.  By default, this method
	 * returns an empty String.  Classes that extend CustomCodePanel may override 
	 * this method if they wish to have a title displayed at install-time.
	 * 
	 * The method is optional and does not need to be implemented.
	 * 
	 * @return The title to be displayed for this panel.
	 */
	
	//	public String getTitle()
	//	{
	//		return "Some Title";
	//	}

}
