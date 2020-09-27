/**
 * 
 */
package com.dongxianglong.dao;

import java.io.Reader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

/**
 * @author 董祥龙
 *
 * 2015-2-2下午04:56:16
 * 
 * 所有DAO实现类的父类
 */
public abstract class BaseDAO {

	private static SqlSessionFactory factory;
	protected SqlSession session=factory.openSession();
	static{
		
		try {
			//(1)读取mybatis核心配置文件
			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
			//(2)获取sqlsession工厂
			factory=new SqlSessionFactoryBuilder().build(reader,"development");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
