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
 * PersonDAO�ӿڵ�ʵ����
 * @author ������
 *
 * 2015-2-2����04:53:42
 */
public class PersonDAOImpl extends BaseDAO implements PersonDAO {
	private static final String NAMESPACE="com.lsh.domain.Person";
	public void add(Person person) {
		// TODO ����û�
//		try {
//			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
//			//2��ȡsqlsession����,���ɻỰ
//			SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(reader,"development");//������
//			//3��ȡsqlsession����
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
		// TODO ɾ���û�
		session.delete(NAMESPACE+".delete",id);
		session.commit();

	}

	public List<Person> getAll() {
		// TODO ��ѯ�����û�
		List<Person>list=null;
//		try {
//			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
//			//2��ȡsqlsession����,���ɻỰ
//			SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(reader,"development");//������
//			//3��ȡsqlsession����
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
		// TODO ��ѯһ���û�
		
		Person person=session.selectOne(NAMESPACE+".getID",id);
		
		return person;
	}

	public void update(Person person) {
		// TODO �޸��û�
		session.update(NAMESPACE+".update",person);
		session.commit();

	}

}
