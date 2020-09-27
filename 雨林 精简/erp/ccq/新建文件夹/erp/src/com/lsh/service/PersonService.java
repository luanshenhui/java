/**
 * 
 */
package com.lsh.service;

import java.util.List;

import com.lsh.domain.Person;

/**
 * @author 栾慎辉
 *
 * 2015-2-5下午02:05:28
 * 
 * 用户的业务标准
 * 
 * EIS,存储
 * dao，数据的访问
 * service，业务的标准，业务的访问，业务的规则(一：对dao层封装，二：增加新的业务方法)
 */
public interface PersonService {
	
	/**
	 * 注册
	 * @param person
	 * @return
	 */
	public abstract boolean register(Person person); 
	
	/**
	 * 修改
	 * @param person
	 * @return
	 */
	public abstract boolean update(Person person); 
	
	/**
	 * 注销
	 * @param id
	 * @return
	 */
	public abstract boolean delete(long id); 
	
	/**
	 * 单查
	 * @param id
	 * @return
	 */
	public abstract Person getByID(long id); 
	
	/**
	 * 全查
	 * @return
	 */
	public abstract List<Person>getAll(); 
	
	
	/**
	 * 登陆
	 * @param username
	 * @param password
	 * @return
	 */
	public abstract boolean islogin(String username,String password); 
	
	public abstract Person getPersonByName(String username);
}
