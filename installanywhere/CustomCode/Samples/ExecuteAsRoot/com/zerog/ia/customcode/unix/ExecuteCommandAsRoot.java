/* -*-tab-width: 4; -*-
 * 
 * ExecuteCommandAsRoot.java 2003.04.01
 * 
 * Copyright 2002 Zero G Software, Inc., All rights reserved.
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
package com.zerog.ia.customcode.unix;

import com.zerog.ia.api.pub.*;
import java.io.*;

/**
 * ExecuteCommandAsRoot.java
 * 
 * 
 */
public class ExecuteCommandAsRoot extends CustomCodeAction
{

	private String expectBin = "/usr/bin/expect";
	private String sleepTime = "5";
	private String tmpPath = "/tmp";
	private String command;
	private String password;

	/**
	 *  This is the method that is called at install-time.  The InstallerProxy
	 *  instance provides methods to access information in the installer,
	 *  set status, and control flow.
	 */
	public void install( InstallerProxy ip ) throws InstallException
	{

		// populate the variables
		command = ip.substitute("$EXECUTE_AS_ROOT_COMMAND$");
		password = ip.substitute("$EXECUTE_AS_ROOT_PASSWORD$");
		String tmp = ip.substitute("$EXECUTE_AS_ROOT_EXPECT_PATH$");
		if (tmp != null && tmp.length() > 0)
			expectBin = tmp;
		tmp = ip.substitute("$EXECUTE_AS_ROOT_WAIT_TIME$");
		if (tmp != null && tmp.length() > 0)
			sleepTime = tmp;
		tmp = ip.substitute("$EXECUTE_AS_ROOT_TMP_PATH$");
		if (tmp != null && tmp.length() > 0)
			tmpPath = tmp;

		String scriptPath = null;
		
		try {

		// Does expect exist on this machine?
		File expectBinary = new File(expectBin);
		if (!expectBinary.exists())
		{
			System.out.println("Expect not found at " + expectBin + ", unable to run command as root");
			CustomError err = (CustomError)ip.getService(CustomError.class);
			err.appendError("File creation error",CustomError.ERROR);
			err.setLogDescription("expect not installed at " + tmpPath  + ", unable to run command as root");
			return;
		}

		// Locate a unique file name for the scipt file
		scriptPath = getTmpFile(tmpPath);
		if (scriptPath == null)
		{
			System.out.println("Can't create temporary script file in location: " + tmpPath);
			CustomError err = (CustomError)ip.getService(CustomError.class);
			err.appendError("File creation error",CustomError.ERROR);
			err.setLogDescription("Unable to create temporary script file in " + tmpPath);
			return;
		}


		// Write the actual script out
		// 
		// Note: Since we're passing the root password in the background
		// we have to choose between two evils, the root password being
		// in the script file temporarily or showing up in the process 
		// list temporarily, you can choose your lesserevil by modifying
		// the send [lindex... line and instead writing the root 
		// password into it, rather than passing it on the 
		// runtime.exec line..

		PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(scriptPath)));
		pw.println("#!" + expectBin);
		pw.println("spawn su -c \"" + command + "\"");
		pw.println("sleep 1");
		pw.println("expect \"assword*\"");
		pw.println("send \"[lindex $argv 0]\r\"");
		pw.println("expect \"\"");
		pw.println("expect \"\r\n\"");
		pw.println("expect {");
		pw.println("	\"incorrect*\" { exit 100 }");
		pw.println("	\"orry*\" { exit 100 }");
		pw.println("}");
		pw.println("sleep " + sleepTime);
		pw.close();

		//run the file
		Process p = Runtime.getRuntime().exec("chmod +x " + scriptPath);
		p.waitFor();
		p = Runtime.getRuntime().exec(scriptPath + " " + password);
		p.waitFor();
		int result = p.exitValue();
		//reset these messages in case we've been called multiple times
		ip.setVariable("$EXECUTE_AS_ROOT_EXIT_CODE$",""+result);
		ip.setVariable("$EXECUTE_AS_ROOT_ERROR_MESSAGE$","");
		if (result != 0)
		{
			System.out.println("Command run as root failed, exit code: " + result);
			if (result == 100) 
			{
				ip.setVariable("$EXECUTE_AS_ROOT_ERROR_MESSAGE$","Root password inccorect");
			}
			else
			{
				ip.setVariable("$EXECUTE_AS_ROOT_ERROR_MESSAGE$","Unknown error while processing command");
			}
		}	
		
		} catch (IOException e) {
			CustomError err = (CustomError)ip.getService(CustomError.class);
			err.appendError("File I/O error",CustomError.ERROR);
			err.setLogDescription("Unable to run command as root, file error: " + e);
			System.out.println("File I/O Error executing command as root:" + e);
			e.printStackTrace();			
			ip.setVariable("$EXECUTE_AS_ROOT_ERROR_MESSAGE$","File I/O Error");
		} catch (InterruptedException e) {
			CustomError err = (CustomError)ip.getService(CustomError.class);
			err.appendError("File I/O error",CustomError.ERROR);
			err.setLogDescription("Unable to run command as root, process error: " + e);
			System.out.println("Process Error executing command as root:" + e);
			e.printStackTrace();			
			ip.setVariable("$EXECUTE_AS_ROOT_ERROR_MESSAGE$","Process Interrupted Error");
		} finally {
				File f = new File(scriptPath);
				if (f.exists())
					f.delete();
		}
	}

	private String getTmpFile(String tmpPath) throws IOException
	{
		File f = new File(tmpPath + File.separator + "ia_script");

		int i=1;

		while (f.exists())
		{
			f = new File(tmpPath + File.separator + "ia_script" + i);
			i++;
			if (i > 1000) return null; //sanity escape, should never happen
		}
		return f.getAbsolutePath();
	}
	
	/**
	 *  This is the method that is called at uninstall-time.  The DataInput
	 *  instance provides access to any information written at install-time
	 *  with the instance of DataOutput provided by UninstallerProxy.getLogOutput().
	 */
	public void uninstall( UninstallerProxy up ) throws InstallException
	{
	}
	
	/**
	 *  This method will be called to display a status message during the
	 *  installation.
	 */
	public String getInstallStatusMessage()
	{
		return "Executing command..";	// screen will say "Installing... My Action"
	}
	
	/**
	 *  This method will be called to display a status message during the
	 *  uninstall.
	 */
	public String getUninstallStatusMessage()
	{
		return "Executing command..";	// screen will say "Uninstalling... My Action"
	}
}
