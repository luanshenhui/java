package com.hepowdhc.dcapp.modules.risklist.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.risklist.entity.RiskTypeDetail;
import com.hepowdhc.dcapp.modules.system.entity.SysDict;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

@MyBatisDao
public interface RiskTypeDetailDao extends CrudDao<RiskTypeDetail>{


	/**
	 * 从字典表获取type="risk_level"的数据
	 * @param sysDict
	 * @return
	 */
	List<SysDict> findriskListByType(SysDict sysDict);

	/**
	 * 加载风险矩阵没删除的数据(delFlg=0)
	 * @param riskTypeDetail
	 * @return
	 */
	List<RiskTypeDetail> getData(RiskTypeDetail riskTypeDetail);
	
	/**
	 * 假删除,SET delFl=1
	 * @param riskTypeDetail
	 */
	void updateriskTypeDetail(RiskTypeDetail riskTypeDetail);

	/**
	 * 插入矩阵表数据
	 * @param riskTypeDetail
	 */
	void insertriskTypeDetail(RiskTypeDetail riskTypeDetail);

}
