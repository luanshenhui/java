package com.f.DAO;

import java.io.IOException;
import java.io.Reader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;


public abstract class BaseDAO {
	private static SqlSessionFactory factory;
	protected SqlSession session=factory.openSession(); 
	static{
		try {
			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
			factory=new SqlSessionFactoryBuilder().build(reader,"development");
			
		} catch (IOException e) {
			
			e.printStackTrace();
		}
	}
}
