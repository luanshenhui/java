/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.alarm.dao;

import java.util.List;
import java.util.Map;

import com.hepowdhc.dcapp.modules.alarm.entity.DcaAlarmDetail;
import com.hepowdhc.dcapp.modules.risklist.entity.DcaAlarmUpGrade;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaARStatForPowerEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmStatEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmTypeCountEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaReportAlarmMsg;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaSimpleCountEntity;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.sys.entity.Office;
import com.thinkgem.jeesite.modules.sys.entity.User;

/**
 * 告警查询DAO接口
 * 
 * @author huibin.dong
 * @version 2016-11-15
 */
@MyBatisDao
public interface DcaAlarmDetailDao extends CrudDao<DcaAlarmDetail> {

	/**
	 * 通过【权力】【业务角色】【告警等级】项目选定【告警信息表】中的一类数据
	 * 
	 * @param dcaAlarmUpGrade
	 * @return
	 */
	public List<DcaAlarmDetail> getAlarmDetailListByUpGrade(DcaAlarmUpGrade dcaAlarmUpGrade);

	/**
	 * 告警统计报表
	 * 
	 * @return
	 * @author geshuo
	 * @date 2016年12月7日
	 */
	public List<DcaAlarmStatEntity> findAlarmStatData(DcaAlarmDetail dcaAlarmDetail);

	/**
	 * 获取所有告警年份数据
	 * 
	 * @return
	 * @author geshuo
	 * @date 2016年12月8日
	 */
	public List<Integer> findAlarmYear(DcaAlarmDetail dcaAlarmDetail);

	/**
	 * 获取操作人数据
	 * 
	 * @return
	 * @author geshuo
	 * @date 2016年12月8日
	 */
	public List<User> findOperPerson(DcaAlarmDetail dcaAlarmDetail);

	/**
	 * 获取操作人所属部门数据
	 * 
	 * @return
	 * @author geshuo
	 * @date 2016年12月8日
	 */
	public List<Office> findOperOffice(DcaAlarmDetail dcaAlarmDetail);

	/**
	 * 告警风险统计(权力)-汇总统计
	 * 
	 * @return
	 * @author geshuo
	 * @date 2016年12月6日
	 * @param dcaAlarmDetail
	 */
	public List<DcaARStatForPowerEntity> findARStatDataForPower(DcaAlarmDetail dcaAlarmDetail);

	/**
	 * 告警信息表
	 * 
	 * @return
	 * @author hun
	 * @date 2016年12月6日
	 */
	public List<DcaReportAlarmMsg> findAlarmMsgTable(DcaReportAlarmMsg dcaReportAlarmMsg);

	/**
	 * 获取告警信息相关分类数量（首页使用）
	 * 
	 * @return result
	 * @author liuc
	 * @date 2016年12月23日
	 */
	public Integer getAlarmDetailCountForHomePage(DcaAlarmDetail dcaAlarmDetail);

	/**
	 * 获取告警和风险项（update_date降序取20条）
	 * 
	 * @return
	 * @author cuizhengwei
	 * @date 2016-12-28
	 */
	public List<DcaAlarmDetail> getAlarmAndRisk(DcaAlarmDetail dcaAlarmDetail);

	/**
	 * 根据节点名称统计告警数量
	 * 
	 * @param taskNameList
	 * @return
	 * @author geshuo
	 * @date 2017年1月5日
	 */
	public List<DcaSimpleCountEntity> getAlarmCountByTaskName(List<String> taskNameList);

	/**
	 * 获取当前季度告警数量
	 * 
	 */
	public List<DcaAlarmDetail> getAlarmQuarterData();

	/**
	 * 获取节点告警详细数据
	 * @param paramMap
	 * @return
	 */
	public List<DcaAlarmTypeCountEntity> getNodeAlarmDetail(Map<String,Object> paramMap);

}