/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.metadata.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.metadata.entity.DcaTopicLib;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * 主题库管理DAO接口
 * 
 * @author lby
 * @version 2016-11-07
 */
@MyBatisDao
public interface DcaTopicLibDao extends CrudDao<DcaTopicLib> {
	/**
	 * 查询数据列表，如果需要分页，请设置分页对象，如：entity.setPage(new Page<T>());
	 * 
	 * @param entity
	 * @return
	 */

	// 传入topicId与tableName查看表中是否存在这条数据
	public List<DcaTopicLib> selectTableName(DcaTopicLib dcaTopicLib);

	// 添加或修改主题库时：查找topicName 看是否有这个topicName 因为主题库名称不能重复 toDelete
	public List<DcaTopicLib> selectTopicName(DcaTopicLib dcaTopicLib);

	// 为了前台验证查找数据 添加主题库时：查找topicName 看是否有这个topicName 因为主题库名称不能重复getDcaTopicLIbBytopicName
	public DcaTopicLib getDcaTopicLibBytopicName(String topicName);

	// 传入topicId 得到tableNameList 是所有主题库相关表的表名集合
	public List<String> selectTableNameList(DcaTopicLib dcaTopicLib);

	// 关联物理表里查询物理表中文名getSearchResult
	public List<DcaTopicLib> getSearchResult(DcaTopicLib entity);

	// 删除主题库时 查看此条的topicId 如果在关联表中有对应的topicId 则说明有关联关系
	public List<DcaTopicLib> selectTopicId(DcaTopicLib dcaTopicLib);

	// 删除本来是勾选状态，现在已经不勾选的条数deletePhyRefRelation
	public void deletePhyRefRelation(List<DcaTopicLib> list);

	// 向关联表中添加数据
	public void setPhyRef(List<DcaTopicLib> list);

	// 查看当前主题库 的状态 getTopicLib
	public String getTopicLib(DcaTopicLib daDcaTopicLib);

	/**
	 * 根据主题库id查询主题库下管理的物理表
	 * @param daDcaTopicLib
	 * @return
     */
	public List<DcaTopicLib> findTopicPhysicsByTopicId(DcaTopicLib daDcaTopicLib);
}