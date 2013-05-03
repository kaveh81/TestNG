/* -*-tab-width: 4; -*-
 * 
 * RefreshEnvironment.java 18.04.2003
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

import com.zerog.ia.api.pub.*;
import java.io.PrintStream;
import java.net.URL;
import com.zerog.ia.customcode.util.fileutils.ExtractToFile;

public class RefreshEnvironment extends CustomCodeAction
{
	private static final String SOURCE_VAR_NAME = "refresh.dll";
	private static final String DEST_VAR_NAME = "$prop.user.dir$$/$refresh.dll";
	
	/**
	 * This is the method that is called at install-time.  The InstallerProxy
	 * instance provides methods to access information in the installer,
	 * set status, and control flow.
	 */	
    public void install(InstallerProxy ip) throws InstallException
    {    	
		try
		{
			// Extract the Windows DLL to the current working directory
			String source = ip.substitute( SOURCE_VAR_NAME );
			URL sourceURL = ip.getResource( source );		
			String destination = ip.substitute( DEST_VAR_NAME );		
	    	ExtractToFile.extractResource(sourceURL,destination);
		} 
		catch ( Exception ioe ) 
		{
			throw new NonfatalInstallException( ioe.getMessage() );
		}		
    	
	//  Make JNI call
        RefreshEnvironmentJNI.refresh();
    }

	/**
	 * This is the method that is called at uninstall-time.  The DataInput
	 * instance provides access to any information written at install-time
	 * with the instance of DataOutput provided by UninstallerProxy.getLogOutput().
	 */
    public void uninstall(UninstallerProxy parm1) throws InstallException
    {
    	// Do nothing at uninstall
    }

	/**
	 * This method will be called to display a status message during the
	 * installation.
	 */
    public String getUninstallStatusMessage()
    {
        return "";
    }

	/**
	 * This method will be called to display a status message during the
	 * uninstall.
	 */
    public String getInstallStatusMessage()
    {
        return "Refreshing Environment...";
    }
}
