package com.f.service;

import java.util.List;

import com.f.domain.Person;
/**
 * 
 * @author 冯学明
 *		用户的业务类
 *		EIS:存储
 *		DAO：数据的访问
 *		Service：业务的规则
 *
 * 2015-2-5下午2:01:47
 */


public interface PersonService {
	/**
	 * 登录
	 * @param username
	 * @param password
	 * @return
	 */
	boolean islogin(String username,String password);
	/**
	 *  注册
	 * @param person
	 * @return
	 */
	
	boolean register(Person person);
	/**
	 * 根据用户名获取用户对象
	 * @param username
	 * @return
	 */
	public abstract Person getPersonByName(String username);
	
	/**
	 * 查看个人信息
	 * @param id
	 * @return
	 */
	Person getByID(long id);
	
	/**
	 * 修改个人信息
	 * @param person
	 * @return
	 */
	boolean Uinformtion(Person person);
	/**
	 * 修改密码
	 * @param id
	 * @param password
	 * @return
	 */
	boolean Upassword(Person person);
	
	/**
	 * 注销
	 */
	void invalidate();
	/**
	 * 查看所有
	 * @return
	 */
	List<Person> getAll();
	

	
}
