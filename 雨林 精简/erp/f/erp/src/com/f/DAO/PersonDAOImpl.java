/**
 * 
 */
package com.f.DAO;

import java.util.List;

import com.f.domain.Person;

/**
 * @author 冯学明
 *
 * 2015-2-2下午4:49:34
 * PersonDAO实现类
 *
 */
public class PersonDAOImpl extends BaseDAO implements PersonDAO {
	private static final String NANMSPACE="com.f.domain.Person.";
	/* (non-Javadoc)
	 * @see com.f.DAO.PersonDAO#add(com.f.domain.Person)
	 */
	public  void add(Person person) {
		session.insert(NANMSPACE+"add",person);	
		session.commit();
		
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.PersonDAO#update(com.f.domain.Person)
	 */
	public void update(Person person) {	
		session.update(NANMSPACE+"update", person);
		session.commit();
	}
	/* (non-Javadoc)
	 * @see com.f.DAO.PersonDAO#delete(long)
	 */
	public void delete(long id) {
		session.delete(NANMSPACE+"delete", id);
		
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.PersonDAO#getByID(long)
	 */
	public Person getByID(long id) {
		
		Person person =session.selectOne(NANMSPACE+"getByID",id);
		return person;
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.PersonDAO#getAll()
	 */
	public List<Person> getAll() {
		
		List<Person> list=session.selectList(NANMSPACE+"getAll");		
		return list;
	}

}
