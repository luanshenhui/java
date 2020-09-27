package com.lsh.dao;

import java.io.IOException;
import java.io.Reader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

/**
 * 
 * @author ������
 *
 * 2015-2-2����05:00:11
 * 
 * ����dao��ʵ����ĸ���
 */

public abstract class BaseDAO{
	
	private static SqlSessionFactory factory;
	protected SqlSession session=factory.openSession();
	static{
		try {
			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
			//2��ȡsqlsession����,���ɻỰ
			factory=new SqlSessionFactoryBuilder().build(reader,"development");//������
			//3��ȡsqlsession����
			//SqlSession session=factory.openSession();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
