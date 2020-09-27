/**
 * 
 */
package com.dongxianglong.dao;

import java.io.IOException;
import java.io.Reader;
import java.util.List;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import com.dongxianglong.domain.Person;

/**
 * @author 董祥龙
 * 
 *         2015-2-2下午04:48:48
 * 
 *         PersonDAO接口的实现类PersonDAOImpl
 */
public class PersonDAOImpl extends BaseDAO implements PersonDAO {

	private static final String NAMESPACE = "com.dongxianglong.domain.Person.";

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dongxianglong.dao.PersonDAO#add(com.dongxianglong.domain.Person)
	 */
	public void add(Person person) {
		session.insert(NAMESPACE+"add",person);
		session.commit();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dongxianglong.dao.PersonDAO#delete(long)
	 */
	public void delete(long id) {
		session.delete(NAMESPACE+"delete", id);
       session.commit();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dongxianglong.dao.PersonDAO#getAll()
	 */
	public List<Person> getAll() {

		List<Person> list = session.selectList(NAMESPACE + "all");
		return list;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dongxianglong.dao.PersonDAO#getByID(long)
	 */
	public Person getByID(long id) {
		
		Person person=session.selectOne(NAMESPACE+"getID", id);
		return person;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.dongxianglong.dao.PersonDAO#update(com.dongxianglong.domain.Person)
	 */
	public void update(Person person) {
		session.update(NAMESPACE+"update", person);
        session.commit();
	}

	public static void main(String[] args) {

		PersonDAO person = new PersonDAOImpl();
		List<Person> list = person.getAll();
		for (Person p : list) {
			System.out.println(p);
		}
		
//      System.out.println(person.getByID(2));
	}

}
