package com.f.DAO;

import java.util.List;

import com.f.domain.Person;

/**
 * 
 * @author 冯学明
 *
 * 2015-2-2下午4:27:02
 *	用户的数据访问接口
 *
 */

public interface PersonDAO {
	/**
	 * //添加用户
	 * @param person
	 */
	void add(Person person);
	/**
	 * //修改用户信息
	 * @param person
	 */
	void update(Person person);
	/**
	 * //删除用户
	 * @param id
	 */
	void delete(long id);
	/**
	 * //查看用户信息
	 * @param id
	 * @return Person
	 */
	Person getByID(long id);
	/**
	 * //查看所有用户
	 * @return list
	 */
	List<Person> getAll();
}
