package cn.rkylin.apollo.system.service;

import java.util.Map;

import cn.rkylin.apollo.system.domain.RoleInfo;


/**
 * Copyright (C), 2016-2020, cn.rkylin.apollo FileName: ISystemRoleService.java
 * 
 * @Description: 系统用户角色相关功能接口类
 * @author zhangXinyuan
 * @Date 2016-7-12 下午 16:22
 * @version 1.00
 */

public interface ISystemRoleService {

	/**
	 * 【查询角色（all查询全部 或 角色ID查询）】
	 * 
	 * @param role
	 * @return
	 * @throws Exception
	 */
	public String searchRole(RoleInfo role) throws Exception;

	/**
	 * 【增加或修改角色】
	 * 
	 * @param role
	 * @return
	 * @throws Exception
	 */
	public Map<String,Object> addRole(RoleInfo role) throws Exception;

	/**
	 * 【删除角色】
	 * 
	 * @param role
	 * @return
	 * @throws Exception
	 */
	public boolean delRole(RoleInfo role) throws Exception;

}
