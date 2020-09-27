package com.yulin.tast;

import java.sql.*;
import java.util.*;
import java.io.*;

public class DBUtil {
	/*���������ļ�������*/
	public static Connection getConn(String fileName) throws IOException{
		File file = new File(fileName);
		FileInputStream fis = new FileInputStream(file);
		/*������ȡ�����ļ�����*/
		Properties pro = new Properties();
		/*����*/
		pro.load(fis);
		/*ͨ��key�����value*/
		String url = pro.getProperty("url");
		String user = pro.getProperty("user");
		String pwd = pro.getProperty("pwd");
		Connection conn = null;
		
		try {
			/*���÷�����Ƽ���һ����*/
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(url, user, pwd);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
	}
}
