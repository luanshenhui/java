/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflowTask;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * 工作流节点DAO接口
 * 
 * @author ThinkGem
 * @version 2016-11-22
 */
@MyBatisDao
public interface DcaWorkflowTaskDao extends CrudDao<DcaWorkflowTask> {

	/**
	 * 查询节点数据
	 * 
	 * @param dcaWorkflowTask
	 * @return
	 *
	 */
	public List<DcaWorkflowTask> findListByWfId(DcaWorkflowTask dcaWorkflowTask);

	/**
	 * 根据节点名称查询
	 * 
	 * @param flowTask
	 * @return
	 */
	public DcaWorkflowTask findWorkflowTaskByTaskName(DcaWorkflowTask flowTask);

	/**
	 * 更新节点
	 * 
	 * @param dcaWorkflowTask
	 * @return
	 */
	public int updateByContent(DcaWorkflowTask dcaWorkflowTask);

	/**
	 * 删除节点
	 * 
	 * @param wfId
	 * @return
	 */
	public int deleteByFlow(String wfId);

	/**
	 * 保存节点
	 * 
	 * @param taskList
	 * @return
	 */
	public int insertByFlow(List<DcaWorkflowTask> taskList);
	
	/**
	 * 根据工作流Id删除节点
	 * 
	 * @param wfId
	 * @return
	 */
	public int deleteTaskByWfId(String wfId);
}