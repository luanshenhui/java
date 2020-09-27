/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.kpi.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.kpi.entity.DcaKpi;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * 企业绩效管理DAO接口
 * 
 * @author dhc
 * @version 2017-01-09
 */
@MyBatisDao
public interface DcaKpiDao extends CrudDao<DcaKpi> {

	/**
	 * 获取绩效考核结果数据
	 * 
	 * @return geshuo 20170109
	 */
	public List<DcaKpi> getKPICheckResult(DcaKpi dcaKpi);

	public int deleteByIdxId(DcaKpi dcaKpi);

	/**
	 * 更新指标名称和类型
	 * 
	 * @param dcaKpi
	 * @return
	 */
	public int updateNameAndType(DcaKpi dcaKpi);

	/**
	 * 保存（如果不存在插入，存在更新）
	 * 
	 * @param dcaKpi
	 * @return
	 */
	public int savaResult(DcaKpi dcaKpi);

}