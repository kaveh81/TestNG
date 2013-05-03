/*
 * @(#)CustomCodeConsoleTemplate.java 1.1 11/10/1003
 * 
 * Use this class as a starting point for creating your own custom code console action.
 *
 */
package com.acme;		// you should change this to your own package location

import com.zerog.ia.api.pub.*;


/**
 * <p>The <code>CustomCodeConsoleAction</code> class is designed to allow developers to 
 * create console based steps integrated with InstallAnywhere installers.</p>
 *
 * <p>There are several services and classes that help classes that extend 
 * CustomCodeConsoleAction provide useful functionality and interaction with the
 * installer and the console.</p>
 *
 * <p>For instance, <b><code>IASys</code></b> provides static fields that can be used to write and
 * read from the installer's console.
 *
 *
 */
public class CustomCodeConsoleTemplate extends CustomCodeConsoleAction 
{
	/**
	 * <p>This class variable provides access to designer-specified resources, 
	 * system and user-defined variables, and international resources.</p>
	 * 
	 * <p>As a class variable, this instance is available to all methods of a 
	 * CustomCodeConsoleAction implementation, not just the <code>executeConsoleAction()</code> 
	 * method which receives an instance of CustomCodeConsoleProxy as a parameter.</p>
	 * 
	 * @see com.zerog.ia.api.pub.CustomCodeConsoleProxy
	 */
	
	//  protected static CustomCodeConsoleProxy consoleProxy;

	
	/**
	 * <p>This method gets called prior to the ConsoleAction being displayed.
	 * This is useful for performing any initialization needed by the action.</p>
	 * 
	 * <p>It is important that this method return quickly so that the
	 * CustomCodeConsoleAction may be displayed when needed.  If it is necessary to
	 * do lengthy processing, it should be done in a separate Thread.</p>
	 *
	 * <p>NOTE:  If <code>setup():boolean</code> returns <code>false</code>,
	 *        to indicate that the CustomCodeConsoleAction should <i>not</i> be displayed,
	 *        the installation manager will proceed without calling any of the
	 *        other methods in <code>CustomCodeConsoleAction</code>.</p>
	 * 
	 * @return <code>true</code> if the ConsoleAction should be displayed,
	 *         <code>false</code> otherwise.  By default, this
	 *         method returns <code>true</code>.
	 */
	public boolean setup()
	{

		/**
		 * Example code.  The examples appear commented out with //
		 */	
		
		
		/**
		 * Resolves all of the InstallAnywhere variables in a string.
		 * If the string contains a variable, and resolving that variable then
		 * contains another variable, that too will be resolved until all variables
		 * have been resolved.  If a variable cannot be resolved, it evaluates to an
		 * empty string ("").
		 */

		//	String myString = consoleProxy.substitute( "myVariable" );

		
		
		/**
		 * Returns the value of the named variable.  If no variable is defined
		 * for that name, returns null.
		 */
		
		//	String myString = (String) consoleProxy.getVariable( "myVariable" );
	
		
		
		/**
		 * Sets the named variable to to refer to the value. If the variable
		 * was already set, its previous value is returned.  Otherwise,
		 * returns null.
		 */
		
		//	Object previousValue = consoleProxy.setVariable( "myVariable", "theValue" );
		
		
		
		/**
		 * For Internationalization support.
		 * Gives access to locale-specific static GUI strings.
		 */
		
		//      String myString = consoleProxy.getValue( "myKey", Locale.ENGLISH );

	
		/**
		 * For Internationalization support.
		 * Gives access to locale-specific static GUI strings.
		 * Returns the resource for the user's chosen installation locale.
		 */
		
		//	String myString = consoleProxy.getValue( "myKey" );
		

		/**
		 * Returns an instance of the requested service.
		 * You must cast the object returned. It is guaranteed
		 * to be the class (or subclass of) the requestedServiceClass.
		 * The only service currently available is SimpleRegistryManager
		 */
		
		//	SimpleRegistryManager srm = (SimpleRegistryManager)consoleProxy.getService(SimpleRegistryManager.class);
		//	boolean success = srm.createRegistryKey("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey");
		//	boolean success = srm.deleteRegistryKey("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey");
		//	boolean success = srm.setRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue", "myValueData");
		//	boolean success = srm.setRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue", new Integer(1));
		//	Object valueData = srm.getRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue");
		//	boolean success = srm.deleteRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue");
		return true;
	}

	/**
	 * <p>This method gets called when the installer is ready to display the console 
	 * action.  Most, if not all, of the console input and output should orginate
	 * from the call into this action via this method.</p>
	 * 
	 */
	public void executeConsoleAction() throws PreviousRequestException
	{
		/**
		 * ConsoleUtils provides conveniece methods for custom code console actions.
		 * The ConsoleUtils object is obtained through the one of the custom code Proxy objects by a request for the ConsoleUtils class
		 */

		//	ConsoleUtils cu = (ConsoleUtils)consoleProxy.getService(ConsoleUtils.class);

		/**
		 * Constructs a console prompt that requests the user to choose from one of two supplied options.
		 */
		
// 	String response = cu.promptAndBilateralChoice("Do you want to see the current time", "yes", "no");
		
		
	}
	
	/**
	 * <p>This method returns the String to be displayed on the installation
	 * step of which this Console action will be contained.  By default, this method
	 * returns an empty String.  Classes that extend CustomCodeConsoleAction may override 
	 * this method if they wish to have a title displayed at install-time.</p>
	 * 
	 * @return The title to be displayed for this panel.
	 */
	public String getTitle()
	{
		return "";
	}	
}
