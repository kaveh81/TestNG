/* -*-tab-width: 4; -*-
 * 
 * ArchiveResourceFileReader.java 
 * Version 1.0 - 02.06.1999
 *
 * MMA - MoMac
 * 
 * Copyright 1999 Zero G Software, Inc., All rights reserved.
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
 
 
package com.zerog.ia.customcode.util.fileutils;
 
import com.zerog.ia.api.pub.*;
import java.util.*;
import java.net.*;
import java.io.*;
 
/**
 *
 * ArchiveResourceFileReader.java
 * 
 * This class is used to read the contents of a specified resource file.
 * 
 */
public class ArchiveResourceFileReader
{
	// a global to class InstallerProxy object.
	private static InstallerProxy ipGlobal;
	// specifies whether or not this class is being used at install or uninstall.
	private static boolean installTime;

	/**
	 *
	 *	This method opens a URL connection to the specified resource and 
	 *  reads in the contents.  This is used during *install* time readings.
	 *
	 *  Parameters: an instance of InstallerProxy and a String representing the resource
	 *    in the archive that is to be read.
	 *
	 *  Returns: a String[] that is the contents of the resource file.  A return value of
	 *    'null' represents a failure to properly read the contents of the file.  Contents
	 *    of the file are automatically resolved for any embedded IA variables.
	 *
	 *  Throws IOException.
	 *
	 */
	public static String[] readContents(InstallerProxy ip, String resourceFile) throws IOException
	{
		ipGlobal = ip;
		installTime = true;
		BufferedReader resourceReader = null;
		
		//
		// Here, we use the instance of InstallerProxy passed in as a parameter
		// to get a URL to a resource we included in the archive we selected in the
		// customizer for Execute Custom Action in the Advanced Designer.
		//
		URL sourceURL = ip.getResource(resourceFile);
		
		if (sourceURL != null)
		{
			resourceReader = new BufferedReader(new InputStreamReader(sourceURL.openStream()));
		}
		else
		{
			throw new IOException("Unable to open resource file: " + resourceFile);
		}
		
		return readEntries(resourceReader);
	}
	

	/**
	 *
	 *	This method opens a URL connection to the specified resource and 
	 *  reads in the contents.  This is used during *uninstall* time readings.
	 *
	 *  Parameters: an instance of InstallerProxy and a String representing the resource
	 *    in the archive that is to be read.
	 *
	 *  Returns: a String[] that is the contents of the resource file.  A return value of
	 *    'null' represents a failure to properly read the contents of the file.  Contents
	 *    of the file are automatically resolved for any embedded IA variables.
	 *
	 *  Throws IOException.
	 *
	 */
	public static String[] readContents(UninstallerProxy up, String resourceFile) throws IOException
	{
		installTime = false;
		BufferedReader resourceReader = null;
		
		//
		// Here, we use the instance of InstallerProxy passed in as a parameter
		// to get a URL to a resource we included in the archive we selected in the
		// customizer for Execute Custom Action in the Advanced Designer.
		//
		try
		{
			URL sourceURL = up.getResource(resourceFile);
			
			resourceReader = new BufferedReader(new InputStreamReader(sourceURL.openStream()));
			
		}
		catch (IOException ioe)
		{
			throw new IOException( ioe.getMessage() );
		}
		
		return readEntries(resourceReader);
	}


	/**
	 *
	 *	This method opens a URL connection to the specified resource and 
	 *  reads in the contents.  This is used during *uninstall* time readings.
	 *
	 *  Parameters: an instance of InstallerProxy and a String representing the resource
	 *    in the archive that is to be read.
	 *
	 *  Returns: a String[] that is the contents of the resource file.  A return value of
	 *    'null' represents a failure to properly read the contents of the file.  Contents
	 *    of the file are automatically resolved for any embedded IA variables.
	 *
	 *  Throws IOException.
	 *
	 */
	private static String [] readEntries(BufferedReader resourceReader) throws IOException 
	{
		Vector resourceContents = new Vector(100, 10);
		String resourceEntry;
		String[] returnArray = null;

		//
		// Read the entire contents of the resource
		//
		try
		{		
			while ((resourceEntry = resourceReader.readLine()) != null)
			{
				resourceEntry = resourceEntry.trim();

				//				
				// ignore comments and whitespace.
				//
				if(!resourceEntry.startsWith("#") && !resourceEntry.equals(""))
				{
					//
					// if: installTime is true ,resolve any IA Variables in the 
					//     registryEntry String.
					//
					if (installTime)
					{
						resourceEntry = resolveIAVariables(resourceEntry);
					}
				
					resourceContents.addElement(resourceEntry);
				}
			}
		}
		catch (IOException ioe)
		{
			throw new IOException( ioe.getMessage() );
		}
		
		//
		// copy the contents of the vector holding the contents of the
		// resource file into an array.
		//
		if (resourceContents.size() != 0)
		{
			//
			// the size of the array is the size of the vector.
			//
			returnArray = new String[resourceContents.size()];
			resourceContents.copyInto(returnArray);
		}
					
		return returnArray;
	}

	
	/**
	 *
	 *	This private method resolves IA Variables. 
	 *
	 */
	public static String resolveIAVariables(String stringToResolve)
	{
		return ipGlobal.substitute(stringToResolve);
	} 
}
