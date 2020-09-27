package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Person;

/**
 * DAO：
 * 
 * person用户：
 * 
 * 数据访问对象
 */
public interface PersonDAO {
	/**
	 * 增加一个用户
	 * @param person
	 */
	public abstract void add(Person person); 
	
	/**
	 * 修改一个用户
	 * @param person
	 */
	public abstract void update(Person person); 
	
	/**
	 * 根据id删除用户
	 * @param id
	 */
	public abstract void delete(long id); 
	
	/**
	 * 查询一个用户
	 * @param id
	 * @return
	 */
	public abstract Person getByID(long id); 
	
	/**
	 * 查询所有用户
	 * @return
	 */
	public abstract List<Person> getAll(); 
	
	
}
