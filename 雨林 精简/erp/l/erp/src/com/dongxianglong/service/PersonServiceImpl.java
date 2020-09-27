/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.dao.BaseDAO;
import com.dongxianglong.dao.PersonDAO;
import com.dongxianglong.dao.PersonDAOImpl;
import com.dongxianglong.domain.Person;

/**
 * @author 董祥龙
 *
 * 2015-2-5下午02:22:19
 * 用户的业务实现
 */
public class PersonServiceImpl  implements PersonService {
	private PersonDAO dao=new PersonDAOImpl();
	

	/* (non-Javadoc)
	 * @see com.dongxianglong.service.PersonService#delete(long)
	 */
	public boolean delete(long id) {
		dao.delete(id);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.service.PersonService#getAll()
	 */
	public List<Person> getAll() {
		
		return dao.getAll();
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.service.PersonService#getByID(long)
	 */
	public Person getByID(long id) {
		return dao.getByID(id);
		
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.service.PersonService#isLogin(java.lang.String, java.lang.String)
	 */
	public boolean isLogin(String username, String password) {
		List<Person> list=getAll();
		for(Person p:list)
		{
			if(p.getUsername().equals(username)&& p.getPassword().equals(password))
			{
				return true;
			}
			
		}
		return false;
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.service.PersonService#register(com.dongxianglong.domain.Person)
	 */
	public boolean register(Person person) {
		dao.add(person);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.service.PersonService#update(com.dongxianglong.domain.Person)
	 */
	public boolean update(Person person) {
		dao.update(person);
		return true;
	}

	public Person getPersonByName(String username) {
		List<Person> list=getAll();
		for(Person p:list)
		{
			if(p.getUsername().equals(username))
			{
				return p;
			}
		}
		return null;
	}
public static void main(String[] args)
{
	PersonServiceImpl pl=new PersonServiceImpl();
	List<Person>list=pl.getAll();
	for(Person p:list)
	{
		System.out.println(p);
	}
	
	}
	
	
}
