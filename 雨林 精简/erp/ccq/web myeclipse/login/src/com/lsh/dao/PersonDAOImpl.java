package com.lsh.dao;

import java.io.IOException;
import java.io.Reader;
import java.util.List;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import com.lsh.qq.Person;

public class PersonDAOImpl implements PersonDAO{

	public void add(Person person) {
		try {
			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
			//2获取sqlsession工厂,生成会话
			SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(reader,"development");//环境名
			//3获取sqlsession对象
			SqlSession session=factory.openSession();
			session.insert("com.lsh.qq.Person.add", person);
			session.commit();
			session.close();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	public List<Person> getAll() {
		List<Person>list=null;
		try {
			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
			//2获取sqlsession工厂,生成会话
			SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(reader,"development");//环境名
			//3获取sqlsession对象
			SqlSession session=factory.openSession();
			list=session.selectList("com.lsh.qq.Person.all");
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}

}
