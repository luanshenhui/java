package cn.rkylin.apollo.system.service;

import cn.rkylin.apollo.system.domain.PrivilegeMenu;


/**
 * Copyright (C), 2016-2020, cn.rkylin.apollo FileName: IPrivilegeMenuService.java
 * 
 * @Description: 系统用户权限相关功能接口类
 * @author zhangXinyuan
 * @Date 2016-7-12 下午 17:15
 * @version 1.00
 */
public interface IPrivilegeMenuService {

	/**
	 * 【根据用户ID查询用户拥有左侧权限菜单】
	 * 
	 * @param userId
	 * @param platformId
	 * @return
	 * @throws Exception
	 */
	public String searchUserLeftMenus(PrivilegeMenu menu) throws Exception;

	/**
	 * 【根据角色ID查询权限菜单（包含已经分配的角色）】
	 * 
	 * @param roleId
	 * @param platformId
	 * @return
	 * @throws Exception
	 */
	public String searchRoleMenus(PrivilegeMenu menu) throws Exception;

	/**
	 * 【为角色分配权限】
	 * 
	 * @param menu
	 * @return
	 * @throws Exception
	 */
	public boolean roleAuthorize(PrivilegeMenu menu) throws Exception;
	
	/**
	 * 【查询用户有哪些功能权限-一般是控制按钮级别】
	 * @param menu
	 * @return
	 * @throws Exception
	 */
	public String searchUserPrivilege(PrivilegeMenu menu) throws Exception;

}
