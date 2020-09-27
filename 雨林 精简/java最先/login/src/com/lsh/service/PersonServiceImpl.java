package com.lsh.service;

import java.util.List;

import com.lsh.dao.PersonDAO;
import com.lsh.dao.PersonDAOImpl;
import com.lsh.qq.Person;

public class PersonServiceImpl implements PersonService {
	
	private PersonDAO dao=new PersonDAOImpl();
	public boolean islogin(String username, String password) {
		List<Person>list=dao.getAll();
		for(Person p:list){
			if(p.getUsername().equals(username)
					&& p.getPassword().equals(password)){
				return true;
			}
		}
		return false;
	}

	public boolean register(String username, String password) {
		List<Person>list=dao.getAll();
		for(Person person:list){
			if(person.getUsername().equals(username)){
				return false;
			}
		}
		Person person=new Person(username,password);
		dao.add(person);
		return true;
	}

}
