/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.risklist.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.risklist.entity.DcaAlarmRiskList;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * 风险清单管理DAO接口
 * 
 * @author shiqiang.zhang
 * @version 2016-11-08
 */
@MyBatisDao
public interface DcaAlarmRiskListDao extends CrudDao<DcaAlarmRiskList> {

	/**
	 * 根据风险名称查询
	 * 
	 * @param dcaAlarmRiskList
	 * @return
	 */
	public DcaAlarmRiskList getByName(DcaAlarmRiskList dcaAlarmRiskList);

	/**
	 * 根据权力ID查询
	 * 
	 * @param dcaAlarmRiskList
	 * @return
	 */
	public List<DcaAlarmRiskList> getRiskByPowerId(DcaAlarmRiskList dcaAlarmRiskList);
	
	/**
	 * 获取风险清单数量（首页用）
	 * @param entity
	 * @return
	 */
	public Integer getRiskListCount(DcaAlarmRiskList dcaAlarmRiskList);

}