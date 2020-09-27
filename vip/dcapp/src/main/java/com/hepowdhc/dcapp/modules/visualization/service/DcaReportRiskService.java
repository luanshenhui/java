package com.hepowdhc.dcapp.modules.visualization.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hepowdhc.dcapp.modules.visualization.dao.DcaReportRiskDao;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaReportRiskEntity;
import com.thinkgem.jeesite.common.service.CrudService;

/**
 * 风险查询Service
 * 
 * @author gaojianshuo
 * @version 2016-12-07
 */
@Service
public class DcaReportRiskService extends CrudService<DcaReportRiskDao, DcaReportRiskEntity> {

	@Autowired
	private DcaReportRiskDao dcaReportRiskDao;

	/**
	 * 风险统计表
	 * 
	 * @return
	 * @author gaojianshuo
	 * @date 2016年12月7日
	 */
	public List<DcaReportRiskEntity> findReportRisk(DcaReportRiskEntity dcaReportRiskEntity) {
		return dcaReportRiskDao.findReportRisk(dcaReportRiskEntity);
	}

	/**
	 * 获取所有风险年份数据
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2016年12月16日
	 */
	public List<Integer> findRiskYear(DcaReportRiskEntity dcaReportRiskEntity) {
		List<Integer> yearList = dao.findRiskYear(dcaReportRiskEntity);
		if (yearList != null && yearList.size() > 0 && yearList.get(0) == null) {
			yearList.remove(0);
		}
		return yearList;
	}

	/**
	 * 部门列表
	 * 
	 * @return
	 * @author gaojianshuo
	 * @date 2016年12月10日
	 */
	/*
	 * public List<String> findOperatorOffice() { return dcaReportRiskDao.findOperatorOffice(); }
	 */

}
