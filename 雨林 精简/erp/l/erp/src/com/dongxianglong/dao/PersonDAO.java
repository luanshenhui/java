package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Person;

/**
 * DAO:数据访问对象
 * 
 * 用户的数据访问接口
 * 
 * */


public interface PersonDAO {
	
	/**
	 * 
	 * @param person
	 * 增
	 * 
	 */
	
	public abstract void add(Person person);
	
	
	/**
	 * @author Administrator
	 * 删
	 * 
	 */
	public abstract void delete(long id);
	

	
	/**
	 * 
	 * @param person
	 * 改
	 */
	public abstract void update(Person person);
	
	
	
	/**
	 * 
	 * @param id
	 * 查单个
	 */
	public abstract Person getByID(long id);
	
/**
 * 
 * @return
 * 
 * 查所有
 */
	public abstract List<Person> getAll();
	

}
