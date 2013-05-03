package com.mir3;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DBConnectionTest {

	private static final int CONNECTIONS = 250;

	public static void main(String [] args) throws Exception {
		//String url = "jdbc:oracle:thin:@(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 172.16.100.201)(PORT = 1521))    (ADDRESS = (PROTOCOL = TCP)(HOST = 172.16.100.202)(PORT = 1521))    (LOAD_BALANCE = yes)    (CONNECT_DATA =      (SERVER = DEDICATED)      (SERVICE_NAME = RAC)    )  )";
		String url = "jdbc:oracle:thin:@172.16.100.202:1521:RAC1";
		//String url = "jdbc:oracle:thin:@(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 172.16.100.201)(PORT = 1521))(ADDRESS = (PROTOCOL = TCP)(HOST = 172.16.100.202)(PORT = 1521))(LOAD_BALANCE = yes)(CONNECT_DATA=(SERVER = DEDICATED)(SERVICE_NAME = RAC)))";
		Class.forName("oracle.jdbc.OracleDriver");

		Connection [] connections = new Connection[CONNECTIONS];

		for(int i=0; i<connections.length; i++) {
			connections[i] = DriverManager.getConnection(url, "pro216", "pro216");
			PreparedStatement ps = connections[i].prepareStatement("SELECT 1 FROM DUAL");
			ResultSet rs = ps.executeQuery();
			rs.next();
			rs.getInt(1);
			rs.close();
			ps.close();
			System.out.println("Got connection["+i+"]: " + connections[i]);
		}
		for(int i=0; i<connections.length; i++) {
			PreparedStatement ps = connections[i].prepareStatement("SELECT 1 FROM DUAL");
			ResultSet rs = ps.executeQuery();
			rs.next();
			rs.getInt(1);
			rs.close();
			ps.close();
			System.out.println("Tested connection["+i+"]: " + connections[i]);
		}
	}
}
