/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflowBasicIdx;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * 告警指标管理DAO接口
 * 
 * @author hanxin'an
 * @version 2016-11-08
 */
@MyBatisDao
public interface DcaWorkflowBasicIdxDao extends CrudDao<DcaWorkflowBasicIdx> {

	// 查询告警指标名称是否存在重复（0：重复，否则重复）
	public List<DcaWorkflowBasicIdx> checkName(String idxName);

	// 删除时，判断所有【compute_rule】-计算公式项目中是否有要删除的告警指标，若有则不可删除。
	public List<String> checkTaskContent(String idxName);

}