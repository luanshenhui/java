package com.lsh.dao;

import java.util.List;

import com.lsh.qq.Person;

public interface PersonDAO {
	public abstract void add(Person person);
	
	
	public abstract List<Person>getAll();

}
