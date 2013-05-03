/* -*-tab-width: 4; -*-
 * 
 * main.c 18.04.2003
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
#include <stdio.h>
#include <windows.h>
#include "jni.h"
#include "RefreshEnvironmentJNI.h"


JNIEXPORT void JNICALL Java_RefreshEnvironmentJNI_refresh
  (JNIEnv *env, jclass obj)
{
	printf("Calling Refresh Environment...");
	//Tell system to refresh the environment
	SendMessage(HWND_BROADCAST, WM_SETTINGCHANGE, 0L, (LPARAM) "Environment");
}