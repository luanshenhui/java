/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.kpi.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.kpi.entity.DcaKpi;
import com.hepowdhc.dcapp.modules.kpi.entity.DcaKpiIdx;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * 企业绩效管理DAO接口
 * 
 * @author dhc
 * @version 2017-01-09
 */
@MyBatisDao
public interface DcaKpiIdxDao extends CrudDao<DcaKpiIdx> {

	/**
	 * 批量插入
	 * 
	 * @param list
	 * @return
	 */
	public int insertBatch(List<DcaKpiIdx> list);

	public List<DcaKpiIdx> getData(DcaKpiIdx dcaKpiIdx);

	/**
	 * 根据idxId查询
	 * 
	 * @param dcaKpiIdx
	 * @return
	 */
	public List<DcaKpiIdx> getByIdxId(DcaKpiIdx dcaKpiIdx);

	public int deleteByIdxId(DcaKpiIdx dcaKpiIdx);

	public int deleteDataByIdxId(DcaKpiIdx dcaKpiIdx);

	/**
	 * 获取绩效考核类型 pang huidan
	 */
	public List<DcaKpiIdx> findNameList(DcaKpi dcaKpi);

	/**
	 * 根据指标类型和指标名称查询数据
	 * 
	 * @param dcaKpi
	 * @return
	 */
	public List<DcaKpiIdx> findByIdxTypeAndIdxName(DcaKpiIdx dcaKpiIdx);
}