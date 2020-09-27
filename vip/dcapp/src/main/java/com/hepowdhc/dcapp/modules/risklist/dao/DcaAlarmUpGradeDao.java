/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.risklist.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.risklist.entity.DcaAlarmUpGrade;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * 告警上报管理DAO接口
 * @author dhc
 * @version 2016-11-15
 */
@MyBatisDao
public interface DcaAlarmUpGradeDao extends CrudDao<DcaAlarmUpGrade> {
	
	/**
	 * 更新数据
	 * @param dcaAlarmUpGrade
	 * @return
	 */
	public int modify(DcaAlarmUpGrade dcaAlarmUpGrade);
	
	/**
	 * 查询数据列表，如果需要分页，请设置分页对象，如：entity.setPage(new Page<T>());
	 * @param dcaAlarmUpGrade
	 * @return
	 */
	public List<DcaAlarmUpGrade> getList(DcaAlarmUpGrade dcaAlarmUpGrade);
	
	/**
	 * 通过id获取Form
	 * @param id
	 * @return
	 */
	public DcaAlarmUpGrade getDcaAlarmUpGradeForm(String id);
	
	/**
	 * 获取Form
	 * @param dcaAlarmUpGrade
	 * @return
	 */
	public List<DcaAlarmUpGrade> getForm(DcaAlarmUpGrade dcaAlarmUpGrade);
	
	/**
	 * 获取所有有效数据
	 * @return
	 */
	public List<DcaAlarmUpGrade> getAllFormList(DcaAlarmUpGrade dcaAlarmUpGrade);
	
}