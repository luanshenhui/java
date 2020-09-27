/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.risklist.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.risklist.entity.DcaPowerList;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * 权责清单DAO接口
 * @author liuc111922
 * @version 2016-11-08
 */
@MyBatisDao
public interface DcaPowerListDao extends CrudDao<DcaPowerList> {
	
	/**
	 * 通过权力Id获取相关角色列表
	 * @param dcaPowerList
	 * @return
	 */
	public List<DcaPowerList> getBizRoleByPowerId(DcaPowerList dcaPowerList);
	
	/**
	 * 插入数据
	 * @param entity
	 * @return
	 */
	public int insertSave(DcaPowerList dcaPowerList);
	/**
	 * 更新数据
	 * @param entity
	 * @return
	 */
	public int updateSave(DcaPowerList dcaPowerList);
	/**
	 * 删除数据
	 * @param entity
	 * @return
	 */
	public int officeDelete(DcaPowerList dcaPowerList);
	
	/**
	 * 获取权责清单数量（首页用）
	 * @param entity
	 * @return
	 */
	public Integer getPowerListCount(DcaPowerList dcaPowerList);
	
}