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
 * @author ������
 *
 * 2015-2-2����04:56:16
 * 
 * ����DAOʵ����ĸ���
 */
public abstract class BaseDAO {

	private static SqlSessionFactory factory;
	protected SqlSession session=factory.openSession();
	static{
		
		try {
			//(1)��ȡmybatis���������ļ�
			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
			//(2)��ȡsqlsession����
			factory=new SqlSessionFactoryBuilder().build(reader,"development");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
