/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.metadata.dao;

import java.util.List;
import java.util.Map;

import com.hepowdhc.dcapp.modules.metadata.entity.DcaTopicPhysics;
import com.hepowdhc.dcapp.modules.metadata.entity.DcaTopicPhysicsFields;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * DcaTopicPhysicsDAO接口
 * 
 * @author hn
 * @version 2016-11-08
 */
@MyBatisDao
public interface DcaTopicPhysicsDao extends CrudDao<DcaTopicPhysics> {

	public List<DcaTopicPhysics> getDetail(DcaTopicPhysics dcaTopicPhysics);

	public List<DcaTopicPhysicsFields> getCloumn(DcaTopicPhysics dcaTopicPhysics);

	// 获取字典表中对应的数据库类型
	public List<DcaTopicPhysics> getTypeForOracle(String dbType);

	/**
	 * 获取基础数据管理 列表
	 * @param dcaTopicPhysics
	 * @return
	 */
	public List<DcaTopicPhysics> findBasicDataByPage( DcaTopicPhysics dcaTopicPhysics);

	/**
	 * 查询物理表所有列
	 * @param tableName
	 * @return
	 */
	public List<String> findBasicDataColumns(String tableName);

	/**
	 * 查询数据总数
	 * @param paramMap
	 * @return
	 */
	public Long findBasicDataCount(Map<String,Object> paramMap);

	/**
	 * 分页查询物理表数据
	 * @return
	 */
	public List<Object> findBasicDataDetailByPage(Map<String,Object> paramMap);

	/**
	 * 查询物理表信息
	 * @param tableName
	 * @return
	 */
	public DcaTopicPhysics findDcaTopicPhysics(String tableName);
}