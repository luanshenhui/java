/**
 * 
 */
package com.f.service;

import java.util.List;

import com.f.DAO.PersonDAO;
import com.f.DAO.PersonDAOImpl;
import com.f.domain.Person;

/**
 * @author ·ëÑ§Ã÷
 *
 * 2015-2-4ÏÂÎç3:52:10
 */
public class PersonServiceImpl extends BaseService implements PersonService {
	PersonDAO dao=new PersonDAOImpl();
	
	/* (non-Javadoc)
	 * @see com.f.service.PersonService#login(java.lang.String, java.lang.String)
	 */
	public boolean islogin(String username, String password) {
		List<Person> list =getAll();
		for(Person person:list){
			if(person.getUsername().equals(username)
					&& person.getPassword().equals(password)){
				return true;
			}
		}
		return false;
	}

	/* (non-Javadoc)
	 * @see com.f.service.PersonService#register(java.lang.String, java.lang.String, java.lang.String, int, java.lang.String, long, double)
	 */
	public boolean register(Person person) {
		List<Person> list =getAll();
		for(Person p:list){
			if(p.getUsername().equals(person.getUsername())){
				return false;
			}
		}
		dao.add(person);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.f.service.PersonService#getByID(long)
	 */
	public Person getByID(long id) {
		
		Person person =dao.getByID(id);
		
		return person;
	}
	/* (non-Javadoc)
	 * @see com.f.service.PersonService#invalidate()
	 */
	public void invalidate() {
		// TODO Auto-generated method stub

	}

	public List<Person> getAll() {
		
		return dao.getAll();
	}

	public boolean Uinformtion(Person person) {
		
		dao.update(person);
		
		
		return true;
		
	}

	public boolean Upassword(Person person) {
		dao.update(person);
		return true;
	}

	public Person getPersonByName(String username) {
		List<Person> list =getAll();
		for(Person p:list){
			if(p.getUsername().equals(username)){
				return p;
			}
		}
		return null;
	}
	
}
