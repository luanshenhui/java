/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.alarm.service;

import java.util.List;
import java.util.Map;

import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmTypeCountEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.alarm.dao.DcaAlarmDetailDao;
import com.hepowdhc.dcapp.modules.alarm.entity.DcaAlarmDetail;
import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaARStatForPowerEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmStatEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaReportAlarmMsg;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaSimpleCountEntity;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.sys.entity.DcaTraceUserRole;
import com.thinkgem.jeesite.modules.sys.entity.Office;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 告警查询Service
 * 
 * @author huibin.dong
 * @version 2016-11-15
 */
@Service
@Transactional(readOnly = true)
public class DcaAlarmDetailService extends CrudService<DcaAlarmDetailDao, DcaAlarmDetail> {

	/**
	 * 排序静态变量
	 */
	private static final String ORDERBY = "a.BIZ_FLOW_ID, a.ALARM_STATUS";

	public DcaAlarmDetail get(String id) {
		return super.get(id);
	}

	/**
	 * 告警分页查询
	 * 
	 * @param page
	 * @param dcaAlarmDetail
	 * @return
	 */
	public Page<DcaAlarmDetail> findPage(Page<DcaAlarmDetail> page, DcaAlarmDetail dcaAlarmDetail) {

		// 页面初期告警状态置为“告警中”
		if (StringUtils.isBlank(dcaAlarmDetail.getAlarmStatus())) {
			dcaAlarmDetail.setAlarmStatus(Constant.ALARMSTATUS_1);
		}

		// 登录人的岗位包含在“可视范围”内
		List<DcaTraceUserRole> postList = UserUtils.getUser().getPostList();
		dcaAlarmDetail.setPostList(postList);

		// 排序
		page.setOrderBy(ORDERBY);

		return super.findPage(page, dcaAlarmDetail);
	}

	/**
	 * 告警统计报表
	 * 
	 * @return
	 * @author geshuo
	 * @date 2016年12月7日
	 */
	public List<DcaAlarmStatEntity> findAlarmStatData(DcaAlarmDetail dcaAlarmDetail) {
		return dao.findAlarmStatData(dcaAlarmDetail);
	}

	/**
	 * 获取所有告警年份数据
	 * 
	 * @return
	 * @author geshuo
	 * @date 2016年12月8日
	 */
	public List<Integer> findAlarmYear(DcaAlarmDetail dcaAlarmDetail) {
		List<Integer> yearList = dao.findAlarmYear(dcaAlarmDetail);
		if (yearList != null && yearList.size() > 0 && yearList.get(0) == null) {
			yearList.remove(0);
		}
		return yearList;
	}

	/**
	 * 获取操作人数据
	 * 
	 * @return
	 * @author geshuo
	 * @date 2016年12月8日
	 */
	public List<User> findOperPerson(DcaAlarmDetail dcaAlarmDetail) {
		return dao.findOperPerson(dcaAlarmDetail);
	}

	/**
	 * 获取操作人所属部门数据
	 * 
	 * @return
	 * @author geshuo
	 * @date 2016年12月8日
	 */
	public List<Office> findOperOffice(DcaAlarmDetail dcaAlarmDetail) {
		return dao.findOperOffice(dcaAlarmDetail);
	}

	/**
	 * 告警风险统计(权力)-汇总统计
	 * 
	 * @return
	 * @author geshuo
	 * @date 2016年12月6日
	 */
	public List<DcaARStatForPowerEntity> findARStatDataForPower(DcaAlarmDetail dcaAlarmDetail) {
		return dao.findARStatDataForPower(dcaAlarmDetail);
	}

	/**
	 * 告警信息表
	 * 
	 * @return
	 * @author hun
	 * @date 2016年12月6日
	 */
	public Page<DcaReportAlarmMsg> findAlarmMsgTable(Page<DcaReportAlarmMsg> page,
			DcaReportAlarmMsg dcaReportAlarmMsg) {

		dcaReportAlarmMsg.setPage(page);
		List<DcaReportAlarmMsg> tableList = dao.findAlarmMsgTable(dcaReportAlarmMsg);
		page.setList(tableList);

		return page;
	}

	/**
	 * 获取告警和风险项（update_date降序取20条）
	 * 
	 * @return
	 * @author cuizhengwei
	 * @date 2016-12-28
	 */
	public List<DcaAlarmDetail> getAlarmAndRisk(DcaAlarmDetail dcaAlarmDetail) {
		return dao.getAlarmAndRisk(dcaAlarmDetail);
	}

	/**
	 * 根据节点名称统计告警数量
	 * 
	 * @param taskNameList
	 * @return
	 * @author geshuo
	 * @date 2017年1月5日
	 */
	public List<DcaSimpleCountEntity> getAlarmCountByTaskName(List<String> taskNameList) {
		return dao.getAlarmCountByTaskName(taskNameList);
	}

	/**
	 * 获取节点告警详细数据
	 * @param paramMap
	 * @return
	 */
	public List<DcaAlarmTypeCountEntity> getNodeAlarmDetail(Map<String,Object> paramMap){
		return dao.getNodeAlarmDetail(paramMap);
	}
}