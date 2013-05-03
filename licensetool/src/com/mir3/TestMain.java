/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.mir3;

import java.lang.reflect.Method;

/**
 *
 * @author mark
 */
public class TestMain {

	public static int testFunc() {
		return -1;
	}
	
	public static void main(String [] args) throws Exception {
		for(Method method : TestMain.class.getMethods()) {
			System.out.println("Found method: " + method + " with return type: " + method.getReturnType());
		}
	}
}
