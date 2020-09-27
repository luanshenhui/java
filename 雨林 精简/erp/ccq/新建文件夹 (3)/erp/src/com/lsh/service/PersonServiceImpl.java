/**
 * 
 */
package com.lsh.service;

import java.util.List;

import com.lsh.dao.PersonDAO;
import com.lsh.dao.PersonDAOImpl;
import com.lsh.domain.Person;

/**
 * @author 栾慎辉
 *
 * 2015-2-5下午02:25:50
 */
public class PersonServiceImpl implements PersonService {
	private PersonDAO dao=new PersonDAOImpl();
		
	/* (non-Javadoc)
	 * @see com.lsh.service.PersonService#delete(long)
	 */
	public boolean delete(long id) {
		// TODO Auto-generated method stub
		dao.delete(id);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.PersonService#getAll()
	 */
	public List<Person> getAll() {
		// TODO Auto-generated method stub
		return dao.getAll();
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.PersonService#getByID(long)
	 */
	public Person getByID(long id) {
		// TODO Auto-generated method stub
		return dao.getByID(id);
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.PersonService#islogin(java.lang.String, java.lang.String)
	 */
	public boolean islogin(String username, String password) {
		// TODO Auto-generated method stub
		List<Person>list=getAll();
		for(Person person:list){
			if(person.getUsername().equals(username) && person.getPassword().equals(password)){
				return true;
			}
		}
		return false;
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.PersonService#register(com.lsh.domain.Person)
	 */
	public boolean register(Person person) {
		// TODO Auto-generated method stub
		dao.add(person);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.PersonService#update(com.lsh.domain.Person)
	 */
	public boolean update(Person person) {
		// TODO Auto-generated method stub
		dao.update(person);
		return true;
	}
	/**
	 *根据用户名获取用户对象 
	 */
	public Person getPersonByName(String username) {
		// TODO Auto-generated method stub
		List<Person>list=getAll();
		for(Person person:list){
			if(person.getUsername().equals(username)){
				return person;
			}
		}
		return null;
	}

}
