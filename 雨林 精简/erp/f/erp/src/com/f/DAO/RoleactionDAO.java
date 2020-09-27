/**
 * 
 */
package com.f.DAO;

import java.util.List;

import com.f.domain.Roleaction;


/**
 * @author 冯学明
 *
 * 2015-2-2下午4:55:32
 *角色的数据访问对象
 */
public interface RoleactionDAO {
	
	/**
	 * //查看角色信息
	 * @param id
	 * @return Person
	 */
	Roleaction getByID(long id);
	/**
	 * //查看角色用户
	 * @return list
	 */
	List<Roleaction> getAll();
}
