package com.zhaoyang.util;

import java.io.IOException;
import java.io.Reader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

/**
 * 
 * ���ݿ⹤���࣬�����ṩmybatis��sqlsession
 * 
 * @author ����
 * 
 *         2014-10-21 ����11:15:25
 */
public final class DBUtil {

	private static Reader reader;

	private static SqlSessionFactory factory;

	static {
		try {
			reader = Resources.getResourceAsReader("Configuration.xml");
			factory = new SqlSessionFactoryBuilder().build(reader);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private DBUtil() {

	}

	public static SqlSession getSqlSession() {

		SqlSession session = factory.openSession();

		return session;
	}

}
