/* -*-tab-width: 4; -*-
 * 
 * ExtractToFile.java 10/06/1999
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

import java.io.*;
import java.net.*;

import com.zerog.ia.api.pub.*;


public class ExtractToFile extends CustomCodeAction
{
	private static final String INSTALL_MESSAGE = "Extracting files";
	private static final String UNINSTALL_MESSAGE = "";
	private static final String ERR_MSG = "ExtractToFile: no source or destination specified.";
	private static final String SOURCE_VAR_NAME = "$ExtractToFile_Source$";
	private static final String DEST_VAR_NAME = "$ExtractToFile_Destination$";
	private boolean isLoaded = false;
	
	// Output Debug Info to stdout.
	private static void debugMsg(String msg)
	{
//		if (debug)	// if output should be shown.
		{
			System.out.println("ExtractToFile: " + msg);	// show message.
		}
	}
	
	/**
	 * This is the method that is called at install-time. The InstallerProxy
	 * instance provides methods to access information in the installer,
	 * set status, and control flow.<p>
	 *
	 * For the purposes of the this action (ExtractToFile), this method
	 * <ol>
	 * <li>gets its parameters from InstallAnywhere Variables,</li>
	 * <li>checks the parameters' validity,</li>
	 * <li>and copies the file.</li></ol>
	 *	
	 * @see com.zerog.ia.api.pub.CustomCodeAction#install
	 */
	public void install( InstallerProxy ip ) throws InstallException
	{
		if(isLoaded == true)
			return;
		isLoaded = true;

		/*	Get input from InstallAnywhere Variables.  The literal contents of
			the Variables are retieved into the Strings. */
		
		String source = ip.substitute( SOURCE_VAR_NAME );
		String destination = ip.substitute( DEST_VAR_NAME );

		/*	getVariable() will return an empty string for any InstallAnywhere 
			Variable that hasn't been assigned yet.  */
		
		/*	If there is both a source and a destination, extract the file. */

		if (   source.equals("")
			|| destination.equals("") )
		{
			error( source, destination );
		}
		else
		{
			try
			{
				/*	Here, we use the instance of InstallerProxy passed to 
					install() to get a URL to a resource we included in the 
					archive we selected in the customizer for Execute
					Custom Action in the Advanced Designer. */
				
				URL sourceURL = ip.getResource( source );
				
				/*	Then pull copy it from the URL to a location on disk. */
				extractResource( sourceURL, destination );
				
			} 
			catch ( IOException ioe ) 
			{
				throw new NonfatalInstallException( ioe.getMessage() );
			}
		}
	}
	
	/**
	 * This method will be called to display a status message during the
	 * uninstall.
	 *	
	 * @see com.zerog.ia.api.pub.CustomCodeAction#getUninstallStatusMessage
	 */
	public void uninstall( UninstallerProxy up ) throws InstallException
	{
	}
	
	/**
	 * This method will be called to display a status message during the
	 * installation.
	 *	
	 * @see com.zerog.ia.api.pub.CustomCodeAction#getInstallStatusMessage
	 */
	public String getInstallStatusMessage()
	{
		return INSTALL_MESSAGE;
	}
	
	/**
	 * This method will be called to display a status message during the
	 * uninstall.
	 *	
	 * @see com.zerog.ia.api.pub.CustomCodeAction#getUninstallStatusMessage
	 */
	public String getUninstallStatusMessage()
	{
		return UNINSTALL_MESSAGE;
	}
	
	/**
	 * Copy the contents of the URL represented by extractWhatURL to the file
	 * represented by destination.  Makes use of OtherUtils.bufStreamCopy
	 * to buffer the copy.
	 *	
	 * @returns A java.io.File representing the File's location on disk.
	 *	
	 * @see com.acme.fileutils.OtherUtils#bufStreamCopy
	 */
	public static File extractResource( URL extractWhatURL, String target ) throws IOException
	{

		File dest = new File( target );
		
		InputStream in = null;
		OutputStream out = null;
					
		try 
		{
			debugMsg("target = " + target);
			debugMsg("extractWhatURL = " + extractWhatURL.toString());		
			in = extractWhatURL.openStream();
			out = new FileOutputStream( dest );
						
			OtherUtils.bufStreamCopy( in, out );
			
			out.flush();
			out.close();
			in.close();
		}
		catch (IOException ioe)
		{
			debugMsg("Exception caught.");
			if (out == null) debugMsg("out = null.");
			if (in == null) debugMsg("in == null");
			throw new IOException (ioe.getMessage());
		}
		finally
		{

			/*	If there's an IOException, we let it propagate to a higher
				level, but we try to close the files in any case. */
			if ( out != null )
			{
				out.flush();
				out.close();
			}
			
			if ( in != null )
			{
				in.close();
			}
		}
		
		return dest;
	}			
	
	/**
	 * Print something to indicate that the parameters were not acceptable.
	 */
	private void error( String source, String destination )
	{
		System.err.println( ERR_MSG );
		System.err.println( "Source: " + source );
		System.err.println( "Destination: " + destination );
	}
}
