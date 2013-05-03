/* -*-tab-width: 4; -*-
 *
 * PropertiesFileReadeder.java 5/01/2005
 *
 * Copyright 2003 Zero G Software, Inc., All rights reserved.
 * 514 Bryant St., California, 94107, U.S.A.
 *
 * CONFIDENTIAL AND PROPRIETARY INFORMATION - DO NOT DISCLOSE.
 *
 * The following program code (the "Software") consists of
 * unpublished, confidential and proprietary information of
 * Zero G Software, Inc.  The use of the Software is governed
 * by a license agreement and protected by trade secret and
 * copyright laws.  Disclosure of the Software to third
 * parties, in any form, in whole or in part, is expressly
 * prohibited except as authorized by the license agreement.
 *
 * The DevNet license agreement gives you specific rights
 * with regard to using this code in your own projects and
 * in derivative works.  See the DevNet license agreement
 * for more information.
 *
 */
 
package com.zerog.ia.customcode.action;

import java.io.*;
import java.util.*;

import com.zerog.ia.api.pub.*;

public class PropertiesFileReader extends CustomCodeAction
{
	public String getInstallStatusMessage()
	{
		return "Reading Properties File";
	}

	public String getUninstallStatusMessage()
	{
		return "";
	}

	public void install(InstallerProxy ip) throws InstallException
	{
		String propertiesFile = ip.substitute("$PROPERTIES_FILE_LOCATION$");
		String substituteVariables = ip.substitute("$SUBSTITUTE_VARIABLES$");
		String ignoreProperties = ip.substitute("$PROPERTIES_TO_IGNORE$");
		String overrideVariables = ip.substitute("$OVERRIDE_EXISTING_VARIABLES$");
		
		
		//System.err.println("propertiesFile: "+propertiesFile);
		//System.err.println("substituteVariables: "+substituteVariables);
		//System.err.println("ignoreProperties: "+ignoreProperties);
		//System.err.println("overrideVariables: "+overrideVariables);
		
		
		if(overrideVariables.equals(""))
		{
			overrideVariables = "true";
		}
		if(substituteVariables.equals(""))
		{
			substituteVariables = "true";
		}
		if(propertiesFile.equals(""))
		{
			throw new NonfatalInstallException ("PropertiesFile not specified");
		}
		
		
		Properties props = new Properties();
		try
		{
			props.load(new FileInputStream(propertiesFile));
		}
		catch (FileNotFoundException e)
		{
			e.printStackTrace();
			throw new NonfatalInstallException ("PropertiesFile not found");
		}
		catch (IOException e)
		{
			e.printStackTrace();
			throw new NonfatalInstallException ("IOException");
		}
		
		Enumeration keys = props.keys();
		
		while(keys.hasMoreElements())
		{
			String key = (String)keys.nextElement();
			String value = props.getProperty(key);
			
			//System.err.println(key+": "+value);
			
			//Proceed only if the key is not on the ignore list
			if(ignoreProperties.indexOf(key) == -1)
			{
				//Do this if the user wants to substitute IA variables
				if(substituteVariables.equalsIgnoreCase("true"))
				{
					//  If the user wants to override variables, just set the value
					if(overrideVariables.equalsIgnoreCase("true"))
					{
						ip.setVariable(key,ip.substitute(value));
					}
					//  If the user does not want to override values, but the variable does not exist, set it
					else if(overrideVariables.equalsIgnoreCase("false") && ip.substitute("$"+key+"$").equals(""))
					{
						ip.setVariable(key,ip.substitute(value));
					}	
				}
				//Do this if the user does not want to substitute IA variables
				else
				{
					// If the user wants to override variables, just set the value
					if(overrideVariables.equalsIgnoreCase("true"))
					{
						ip.setVariable(key,value);
					}
					// If the user wants to override variables, just set the value
					else if(overrideVariables.equalsIgnoreCase("false") && ip.substitute("$"+key+"$").equals(""))
					{
						ip.setVariable(key,value);
					}
				}
			}	
			
			System.err.println("Setting $"+key+"$ to "+value);
		}
	}

	public void uninstall(UninstallerProxy up) throws InstallException
	{

	}

}