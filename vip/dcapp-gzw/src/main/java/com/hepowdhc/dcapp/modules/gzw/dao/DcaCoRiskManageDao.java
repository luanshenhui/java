/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.gzw.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoRiskManage;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaCountByPowerEntity;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * 企业风险管理DAO接口
 * 
 * @author zhengwei.cui
 * @version 2017-01-03
 */
@MyBatisDao
public interface DcaCoRiskManageDao extends CrudDao<DcaCoRiskManage> {

	/**
	 * 查询各企业风险等级数(首页用)
	 * 
	 * @return
	 */
	public List<DcaCoRiskManage> getCoRiskLevelNum();

	/**
	 * 查询各企业风险界定数(首页用)
	 * 
	 * @return
	 */
	public List<DcaCoRiskManage> getCoDefineStatusNum();

	/**
	 * 根据企业id查询当前年风险走势统计(首页用)
	 * 
	 * @param dcaCoRiskManage
	 * @return
	 */
	public List<DcaCoRiskManage> getCoRiskTrendReport(DcaCoRiskManage dcaCoRiskManage);

	/**
	 * 根据企业id查询当前年风险界定统计(首页用)
	 * 
	 * @param dcaCoRiskManage
	 * @return
	 */
	public List<DcaCoRiskManage> getCoRiskDefinedReport(DcaCoRiskManage dcaCoRiskManage);

	/**
	 * 根据权利和各专委会查询各12个月的数据
	 * 
	 * @param dcaCoRiskManage
	 * @return
	 */
	public List<DcaCoRiskManage> getSpeCommitteeRiskByMonth(DcaCoRiskManage dcaCoRiskManage);

	/**
	 * 根据企业id查询风险统计数据
	 * 
	 * @param coId
	 * @return
	 * @author geshuo
	 * @date 2017年1月4日
	 */
	public List<DcaCountByPowerEntity> getRiskCountByCoId(String coId);

}