package com.zhaoyang.util;

import java.io.IOException;
import java.io.Reader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

/**
 * 
 * 数据库工具类，用来提供mybatis的sqlsession
 * 
 * @author 赵阳
 * 
 *         2014-10-21 上午11:15:25
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
