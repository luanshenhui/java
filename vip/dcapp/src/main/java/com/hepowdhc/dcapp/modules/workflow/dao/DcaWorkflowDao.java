/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmRiskStatEntity;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflow;
import com.hepowdhc.dcapp.modules.workflow.entity.Dict;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * 工作流管理DAO接口
 * 
 * @author shiqiang.zhang
 * @version 2016-11-21
 */
@MyBatisDao
public interface DcaWorkflowDao extends CrudDao<DcaWorkflow> {

	public int check(DcaWorkflow dcaWorkflow);

	public int checkStartOne(DcaWorkflow dcaWorkflow);

	public int checkStartTwo(DcaWorkflow dcaWorkflow);

	public void updateWF(DcaWorkflow dcaWorkflow);

	public void stopWorkFlow(DcaWorkflow dcaWorkflow);

	public void startWorkFlow(DcaWorkflow dcaWorkflow);

	public DcaWorkflow checkWfName(String wfName);

	public List<Dict> searchDict();

	public String getStratCheckJson(DcaWorkflow dcaWorkflow);

	/**
	 * 更新XML
	 * 
	 * @param dcaWorkflow
	 * @return
	 */
	public int updateXml(DcaWorkflow dcaWorkflow);

	/**
	 * 告警风险统计(权力)-业务事项统计
	 * 
	 * @return
	 * @author geshuo
	 * @date 2016年12月6日
	 */
	public List<DcaAlarmRiskStatEntity> findWorkStatData();

	/**
	 * 首页菜单按钮
	 * 
	 * @author PangHuiDan
	 * @date 2016年12月27日
	 */
	public List<Dict> findPowerId(DcaWorkflow dcaWorkflow);

	/**
	 * 获取关键流程数量（首页用）
	 * 
	 * @param entity
	 * @return
	 */
	public Integer getKeyWorkFlowCount(DcaWorkflow dcaWorkflow);

	/**
	 * 查询启用的工作流数量
	 * 
	 * @return
	 */
	public Integer findEnabledWorkflowCount();

	/**
	 * 查询流程图字符串
	 * 
	 * @return
	 */
	public List<DcaWorkflow> getWorkFlowXML(DcaWorkflow dcaWorkflow);

}