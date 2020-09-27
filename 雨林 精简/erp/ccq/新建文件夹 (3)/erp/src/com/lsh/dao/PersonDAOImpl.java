package com.lsh.dao;

import java.io.IOException;
import java.io.Reader;
import java.util.List;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import com.lsh.domain.Person;

/**
 * PersonDAO接口的实现类
 * @author 栾慎辉
 *
 * 2015-2-2下午04:53:42
 */
public class PersonDAOImpl extends BaseDAO implements PersonDAO {
	private static final String NAMESPACE="com.lsh.domain.Person";
	public void add(Person person) {
		// TODO 添加用户
//		try {
//			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
//			//2获取sqlsession工厂,生成会话
//			SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(reader,"development");//环境名
//			//3获取sqlsession对象
//			SqlSession session=factory.openSession();
			session.insert(NAMESPACE+".add", person);
			session.commit();
			
//			
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		
	}

	public void delete(long id) {
		// TODO 删除用户
		session.delete(NAMESPACE+".delete",id);
		session.commit();

	}

	public List<Person> getAll() {
		// TODO 查询所有用户
		List<Person>list=null;
//		try {
//			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
//			//2获取sqlsession工厂,生成会话
//			SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(reader,"development");//环境名
//			//3获取sqlsession对象
		//	SqlSession session=factory.openSession();
			list=session.selectList(NAMESPACE+".all");
//			
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		return list;
	
	}

	public Person getByID(long id) {
		// TODO 查询一个用户
		
		Person person=session.selectOne(NAMESPACE+".getID",id);
		
		return person;
	}

	public void update(Person person) {
		// TODO 修改用户
		session.update(NAMESPACE+".update",person);
		session.commit();

	}

}
