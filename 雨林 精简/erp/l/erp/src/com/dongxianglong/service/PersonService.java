/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.domain.Person;

/**
 * @author 董祥龙
 * 
 *     EIS层：存储。
 *     DAO层：数据的访问
 * Service层：业务的规则。(第一：对DAO层进行封装。第二：增加新的业务方法。)
 *    
 *
 * 2015-2-5下午02:01:57
 * 用户的业务标准
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
	 * 查看详细信息
	 * @param id
	 * @return
	 */
	public abstract Person getByID(long id);
	
	/**
	 * 查看所有
	 * @return
	 */
	public abstract List<Person> getAll();
	
	/**
	 * 登录
	 * 添加的新方法
	 * @param username
	 * @param password
	 * @return
	 */
	public abstract boolean isLogin(String username,String password);
	
	
	/**
	 * 根据用户名获取用户对象
	 * @param username
	 * @return
	 */
	public abstract Person getPersonByName(String username);
	
	
	
	

}
