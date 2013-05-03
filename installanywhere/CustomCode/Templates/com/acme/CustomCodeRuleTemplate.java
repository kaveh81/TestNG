/*
 * 	@(#)CustomCodeRuleTemplate.java 1.1 11/10/1003
 * 
 *	Use this class as a starting point for creating your own custom code rules.
 * 
 */

package com.acme; // You shou change this to your own package

import com.zerog.ia.api.pub.*;

/**
 * 	A <code>CustomCodeRule</code> is simply a Rule that can be used 
 * 	at install-time in the context of a rule.
 *
 */

public class CustomCodeRuleTemplate extends CustomCodeRule
{

	/**
	 * 	<p>This method is called at install-time when evaluating the rules set on a given
	 * 	installer action.</p>
	 *	
	 * 	<p>It is very important that this method return quickly so that unnecessary
	 * 	lag is not experienced in the installer.</p>
	 *
	 * 	@return <code>true</code> if the rule has evaluated to true (i.e., positive case),
	 *    <code>false</code> otherwise.
	 *
	 */
	 
	public boolean evaluateRule()
	{
		/**
		 * 	Example code.  The examples appear commented out with //
		 */	
		
		
		/**
		 *	Resolves all of the InstallAnywhere variables in a string.
		 *  	If the string contains a variable, and resolving that variable then
		 *  	contains another variable, that too will be resolved until all variables
		 *  	have been resolved.  If a variable cannot be resolved, it evaluates to an
		 *  	empty string ("").
		 */

		//	String myString = ruleProxy.substitute( "myVariable" );

		
		
		/**
		 *	Returns the value of the named variable.  If no variable is defined
		 *	for that name, returns null.
		 */
		
		//	String myString = (String) ruleProxy.getVariable( "myVariable" );
	
		
		
		/**
		 *	Sets the named variable to to refer to the value. If the variable
		 *	was already set, its previous value is returned.  Otherwise,
		 *	returns null.
		 */
		
		//	Object previousValue = ruleProxy.setVariable( "myVariable", "theValue" );
		
		
		
		/**
		 *	For Internationalization support.
		 *  	Gives access to locale-specific static GUI strings.
		 */
		
		// String myString = ruleProxy.getValue( "myKey", Locale.ENGLISH );

	
		/**
		 *	For Internationalization support.
		 *  	Gives access to locale-specific static GUI strings.
		 *	Returns the resource for the user's chosen installation locale.
		 */
		
		//	String myString = ruleProxy.getValue( "myKey" );
		

		/**
		 *	Returns an instance of the requested service.
		 *	You must cast the object returned. It is guaranteed
		 *	to be the class (or subclass of) the requestedServiceClass.
		 *	The only service currently available is SimpleRegistryManager
		 */
		
		//	SimpleRegistryManager srm = (SimpleRegistryManager)ruleProxy.getService(SimpleRegistryManager.class);
		//	boolean success = srm.createRegistryKey("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey");
		//	boolean success = srm.deleteRegistryKey("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey");
		//	boolean success = srm.setRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue", "myValueData");
		//	boolean success = srm.setRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue", new Integer(1));
		//	Object valueData = srm.getRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue");
		//	boolean success = srm.deleteRegistryKeyValue("HKEY_LOCAL_MACHINE\\Software\\MySoftwareKey", "myValue");

	}
}