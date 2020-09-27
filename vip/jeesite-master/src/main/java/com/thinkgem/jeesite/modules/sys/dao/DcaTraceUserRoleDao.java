/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.sys.dao;

import java.util.List;

import com.thinkgem.jeesite.common.persistence.TreeDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.sys.entity.DcaTraceUserRole;

/**
 * 岗位管理DAO接口
 * 
 * @author zhengwei.cui
 * @version 2016-12-15
 */
@MyBatisDao
public interface DcaTraceUserRoleDao extends TreeDao<DcaTraceUserRole> {

	/**
	 * 根据岗位id查询
	 * 
	 * @param roleId
	 * @return
	 */
	public DcaTraceUserRole findById(String roleId);

	/**
	 * 查询全部
	 */
	public List<DcaTraceUserRole> findAllList();

	/**
	 * 查出所以子节点
	 */
	public List<DcaTraceUserRole> findByParentIdsLike(DcaTraceUserRole dcaTraceUserRole);

	/**
	 * 根据用户id查出岗位信息
	 * 
	 * @param userId
	 * @return
	 */
	public List<DcaTraceUserRole> findByUserId(String userId);

	/**
	 * 根据parentId查询
	 * 
	 * @param roleParentId
	 * @return
	 */
	public List<DcaTraceUserRole> findByParentId(String roleParentId);

}