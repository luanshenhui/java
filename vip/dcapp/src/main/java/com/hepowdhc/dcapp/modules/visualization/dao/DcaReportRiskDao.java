package com.hepowdhc.dcapp.modules.visualization.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.visualization.entity.DcaReportRiskEntity;
import com.thinkgem.jeesite.common.persistence.CrudDao;

/**
 * DcaReportRiskDAO接口
 * 
 * @author gaojianshuo
 * @version 2016-12-07
 */
public interface DcaReportRiskDao extends CrudDao<DcaReportRiskEntity> {

	/**
	 * 风险统计表
	 * 
	 * @return
	 * @author gaojianshuo
	 * @date 2016-12-07
	 */
	public List<DcaReportRiskEntity> findReportRisk(DcaReportRiskEntity dcaReportRiskEntity);

	/**
	 * 获取所有风险年份数据
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2016年12月16日
	 */
	public List<Integer> findRiskYear(DcaReportRiskEntity dcaReportRiskEntity);

	/**
	 * 获取部门列表
	 * 
	 * @return
	 * @author gaojianshuo
	 * @date 2016-12-10
	 */
	/* public List<String> findOperatorOffice(); */
}
