package com.lsh.dao;

import java.io.IOException;
import java.io.Reader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

/**
 * 
 * @author 栾慎辉
 *
 * 2015-2-2下午05:00:11
 * 
 * 所有dao的实现类的父类
 */

public abstract class BaseDAO{
	
	private static SqlSessionFactory factory;
	protected SqlSession session=factory.openSession();
	static{
		try {
			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
			//2获取sqlsession工厂,生成会话
			factory=new SqlSessionFactoryBuilder().build(reader,"development");//环境名
			//3获取sqlsession对象
			//SqlSession session=factory.openSession();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
