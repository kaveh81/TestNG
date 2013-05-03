/* -*-tab-width: 4; -*-
 * 
 * DataInputLogReader.java
 * Version 0.6b - 02.06.1999
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
 * DataInputLogReader.java
 * 
 * This class is used to read the contents of a specified resource file.
 * 
 */
public class DataInputLogReader
{
	/**
	 *
	 *	This method reads the data saved by a custom code action saved during installation.
	 *  This is used only during *uninstall* time.
	 *
	 *  Parameters: an instance of UninstallerProxy and a String representing the 
	 *     terminator used to signal the end of the data to be read.
	 *
	 *  Returns: a String[] that is the contents of the saved data.  A return value of
	 *    'null' represents a failure to properly read the contents of the file.
	 *
	 *  Throws IOException.
	 *
	 */
	public static String[] readContents(UninstallerProxy up, String dataTerminator) throws IOException
	{
		DataInput din;
		
		//
		// Here, we use the instance of UninstallerProxy passed in as a parameter
		// to get a DataInput connection to the log information that we saved at install
		// time.
		//
		din = up.getLogInput();
		
		if (din == null)
		{
			throw new IOException("Error opening log file");
		}
		
		return readEntries(din, dataTerminator);
	}


	private static String [] readEntries(DataInput din, String dataTerminator) throws IOException 
	{
		Vector logContents = new Vector(100, 10);
		String logEntry;
		String[] returnArray = null;

		//
		// Read the entire contents of the log file
		//
		try
		{
			while (!(logEntry = din.readUTF()).equals(dataTerminator) && logEntry != null)
			{
				logContents.addElement(logEntry);
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
		if (logContents.size() != 0)
		{
			//
			// the size of the array is the size of the vector.
			//
			returnArray = new String[logContents.size()];
			logContents.copyInto(returnArray);
		}
					
		return returnArray;
	}
}
