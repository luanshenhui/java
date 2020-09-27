/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.riskmanage.dao;

import java.util.List;
import java.util.Map;

import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaCountByPowerEntity;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaRiskManage;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmRiskDefineEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmRiskStatEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmTypeCountEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaReportRiskMes;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaSimpleCountEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.RiskDefinedStatistics;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.sys.entity.Office;
import org.apache.ibatis.annotations.Param;

/**
 * 风险管理DAO接口
 * 
 * @author zhengwei.cui
 * @version 2016-11-16
 */
@MyBatisDao
public interface DcaRiskManageDao extends CrudDao<DcaRiskManage> {

	public List<DcaRiskManage> findListByUser(DcaRiskManage dcaRiskManage);

	/**
	 * 告警风险统计(权力)-平台风险统计
	 * 
	 * @return
	 * @author geshuo
	 * @date 2016年12月5日
	 */
	public List<DcaAlarmRiskStatEntity> findRiskStatData();

	/**
	 * 风险界定统计
	 * 
	 * @return
	 * @author yuduo
	 * @date 2016年12月6日
	 */
	public List<RiskDefinedStatistics> getRiskDefinedStatistics(Map<String, String> params);

	/**
	 * 风险界定统计(根据用户查询)
	 * 
	 * @param paramsMap 参数(selectYear,userId)
	 * @return
	 */
	public List<RiskDefinedStatistics> getRiskDefinedReportByUser(Map<String, Object> paramsMap);

	/**
	 * 风险走势分析统计
	 * 
	 * @return
	 */
	public List<DcaRiskManage> getRiskTrendReport(@Param("selectYear")String selectYear, @Param("idxDataType")String idxDataType);

	/**
	 * 风险信息表
	 * 
	 * @return
	 * @author liuby
	 * @date 2016年12月7日
	 */
	public List<DcaReportRiskMes> getRiskMes(DcaReportRiskMes entity);

	/**
	 * 告警风险统计(部门)-风险界定统计
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2016年12月6日
	 */
	public List<DcaAlarmRiskDefineEntity> findRiskDefineData(DcaAlarmRiskDefineEntity entity);

	/**
	 * 告警风险统计(部门)-告警风险统计年度个数
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2016年12月7日
	 */
	public List<DcaAlarmRiskDefineEntity> findRiskcount(DcaAlarmRiskDefineEntity entity);

	/**
	 * 告警风险统计(部门)-告警风险统计年份个数
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2016年12月7日
	 */
	public List<DcaAlarmRiskDefineEntity> findRiskMonthcount(DcaAlarmRiskDefineEntity entity);

	/**
	 * 告警风险统计(部门)-查询是否有下属部门
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2016年12月7日
	 */
	public List<Office> findParent(String officeId);

	/**
	 * 获取风险信息相关分类数量（首页使用）
	 * 
	 * @return result
	 * @author liuc
	 * @date 2016年12月23日
	 */
	public Integer getRiskDetailCountForHomePage(DcaRiskManage dcaRiskManage);

	/**
	 * 获取部门全路径
	 * 
	 * @param parentIdList
	 * @return
	 * @author geshuo
	 * @date 2016年12月28日
	 */
	public List<String> getParentOfficeList(List<String> parentIdList);

	/**
	 * 根据节点名称统计风险数量
	 * 
	 * @param taskNameList
	 * @return
	 * @author geshuo
	 * @date 2017年1月5日
	 */
	public List<DcaSimpleCountEntity> getRiskCountByTaskName(List<String> taskNameList);


	/**
	 * 查询各专委会风险统计数据(气泡图)
	 *
	 * @return
	 * @author geshuo
	 * @date 2017年1月5日
	 */
	public List<DcaCountByPowerEntity> getSpecialCommitteeRisk(Map<String, Object> paramMap);

	/**
	 * 获取当年季度的风险个数
	 * 
	 */
	public List<DcaAlarmRiskDefineEntity> getRiskQuarterData();

	/**
	 * 获取节点风险详细数据
	 * @param paramMap
	 * @return
	 */
	public List<DcaAlarmTypeCountEntity> getNodeRiskDetail(Map<String,Object> paramMap);
}