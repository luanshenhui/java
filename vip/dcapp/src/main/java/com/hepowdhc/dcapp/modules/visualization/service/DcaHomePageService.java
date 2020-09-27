package com.hepowdhc.dcapp.modules.visualization.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hepowdhc.dcapp.modules.alarm.dao.DcaAlarmDetailDao;
import com.hepowdhc.dcapp.modules.alarm.entity.DcaAlarmDetail;
import com.hepowdhc.dcapp.modules.alarm.service.DcaAlarmDetailService;
import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.risklist.dao.DcaAlarmRiskListDao;
import com.hepowdhc.dcapp.modules.risklist.dao.DcaPowerListDao;
import com.hepowdhc.dcapp.modules.risklist.entity.DcaAlarmRiskList;
import com.hepowdhc.dcapp.modules.risklist.entity.DcaPowerList;
import com.hepowdhc.dcapp.modules.riskmanage.dao.DcaRiskManageDao;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaRiskManage;
import com.hepowdhc.dcapp.modules.system.dao.DcaPageConfigDao;
import com.hepowdhc.dcapp.modules.system.entity.DcaPageConfig;
import com.hepowdhc.dcapp.modules.system.entity.DcaPageConfigDetail;
import com.hepowdhc.dcapp.modules.system.entity.EfficacyAnalysis;
import com.hepowdhc.dcapp.modules.system.entity.OverallData;
import com.hepowdhc.dcapp.modules.system.service.DcaPageConfigService;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmRiskDefineEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaHomePageEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaHomePageFields;
import com.hepowdhc.dcapp.modules.workflow.dao.DcaWorkflowDao;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflow;
import com.hepowdhc.dcapp.modules.workflow.entity.Dict;
import com.hepowdhc.dcapp.modules.workflow.service.DcaPowerBizDataCountService;

/**
 * 首页Service
 * 
 * @author liuc
 * @version 2016-12-23
 */
@Service
public class DcaHomePageService {

	@Autowired
	private DcaAlarmDetailDao dcaAlarmDetailDao;

	@Autowired
	private DcaRiskManageDao dcaRiskManageDao;

	@Autowired
	private DcaWorkflowDao dcaWorkflowDao;

	@Autowired
	DcaPageConfigService dcaPageConfigService;

	@Autowired
	private DcaPowerListDao dcaPowerListDao;

	@Autowired
	private DcaAlarmRiskListDao dcaAlarmRiskListDao;

	@Autowired
	private DcaPageConfigDao dcaPageConfigDao;

	@Autowired
	private DcaAlarmDetailService dcaAlarmDetailService;
	
	@Autowired
	private DcaPowerBizDataCountService dcaPowerBizDataCountService;
	

	/**
	 * 首页框显示
	 */
	public DcaHomePageEntity getHomePage() {

		DcaHomePageEntity result = new DcaHomePageEntity();

		// new Date()为获取当前系统时间
		Date closingTime = new Date();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");// 设置日期格式
		String closingTimeString = df.format(closingTime);
		result.setClosingTime(closingTimeString);

		// 首页按钮名称
		DcaWorkflow dcaWorkflow = new DcaWorkflow();
		dcaWorkflow.setUpdateDate(closingTime);
		List<Dict> powerNames = findPowerId(dcaWorkflow);
		result.setPowerName(powerNames);

		// [总体数据]、[时间维度]、[设计部门]、[业务综合效能分析]的数据取得
		DcaPageConfigDetail dcaPageConfigDetail = dcaPageConfigService.getAllData();

		if (dcaPageConfigDetail != null) {
			// [总体数据]的数据设置
			if (CollectionUtils.isNotEmpty(dcaPageConfigDetail.getOverallDataList())) {
				getOverallData(result, dcaPageConfigDetail.getOverallDataList());
			} else {
				result.setRefreshTime("0");
				result.setTotalNumber("0");
				result.setEfficiency("0");
				result.setFrequency("0");
			}
		}

		return result;

	}

	/**
	 * 首页左一仪表盘图使用数据
	 * 
	 * @author liuc
	 * @date 2017年1月3日
	 */
	public DcaHomePageEntity getDataForGauge() {

		DcaHomePageEntity result = new DcaHomePageEntity();

		// [总体数据]、[时间维度]、[设计部门]、[业务综合效能分析]的数据取得
		DcaPageConfigDetail dcaPageConfigDetail = dcaPageConfigService.getAllData();

		if (dcaPageConfigDetail != null) {
			// [总体数据]的数据设置
			if (CollectionUtils.isNotEmpty(dcaPageConfigDetail.getOverallDataList())) {
				getOverallData(result, dcaPageConfigDetail.getOverallDataList());
			} else {
				result.setRefreshTime("0");
				//result.setTotalNumber("0");
				result.setEfficiency("0");
				result.setFrequency("0");
			}
		}

		String totalNum = dcaPowerBizDataCountService.getBizDataCount();
		if(StringUtils.isEmpty(totalNum)){
			totalNum = "0";
		}
		result.setTotalNumber(totalNum);
		
		return result;
	}

	/**
	 * 首页左二风险/告警等级使用数据
	 * 
	 * @author liuc
	 * @date 2017年1月3日
	 */
	public DcaHomePageEntity getDataForRiskAlarm(String powerId, String sysDate) {

		DcaHomePageEntity result = new DcaHomePageEntity();

		// 设置日期格式
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date closingTime = null;
		try {
			closingTime = sdf.parse(sysDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		// 获取风险和告警信息相关分类数量
		setAlarmAndRiskCountForHomePage(result, powerId, closingTime);

		return result;
	}
	
	/**
	 * 首页左三数据引擎监控情况使用数据
	 * 
	 * @author liuc
	 * @date 2017年1月6日
	 */
	public List<Integer> getBizDataLastList(){
		
		List<Integer> result = dcaPowerBizDataCountService.getBizDataLastList();
		
		return result;
	}

	/**
	 * 首页中间雷达图使用数据
	 * 
	 * @author liuc
	 * @date 2017年1月3日
	 */
	public DcaHomePageEntity getDataForRadar() {

		DcaHomePageEntity result = new DcaHomePageEntity();

		// [总体数据]、[时间维度]、[设计部门]、[业务综合效能分析]的数据取得
		DcaPageConfigDetail dcaPageConfigDetail = dcaPageConfigService.getAllData();

		if (dcaPageConfigDetail != null) {

			// [业务综合效能分析] 的数据设置
			if (CollectionUtils.isNotEmpty(dcaPageConfigDetail.getEfficacyAnalysisList())) {
				getEfficiencyAnalysis(result, dcaPageConfigDetail.getEfficacyAnalysisList());
			} else {
				result.setEfficiencyAnalysisList(new ArrayList<DcaHomePageFields>());
			}
		}

		return result;
	}

	/**
	 * 首页右一柱状图使用数据
	 * 
	 * @author liuc
	 * @date 2017年1月3日
	 */
	public DcaHomePageEntity getDataForWorkBar() {

		DcaHomePageEntity result = new DcaHomePageEntity();

		List<DcaHomePageFields> timeDimensionList = new ArrayList<DcaHomePageFields>();

		// 告警数据取得（只会取得四条数据）
		List<DcaAlarmDetail> alarmList = dcaAlarmDetailDao.getAlarmQuarterData();

		// 风险数据取得（只会取得四条数据）
		List<DcaAlarmRiskDefineEntity> riskList = dcaRiskManageDao.getRiskQuarterData();

		for (int i = 0; i < alarmList.size(); i++) {

			DcaHomePageFields dcaHomePageFields = new DcaHomePageFields();
			// 告警信息设置
			DcaAlarmDetail item = alarmList.get(i);
			// 风险信息设置
			DcaAlarmRiskDefineEntity temp = riskList.get(i);

			// 时间（第一、二、三、四季度）
			dcaHomePageFields.setTime(item.getQuarter());
			// 告警数量
			dcaHomePageFields.setAlarmNumber(item.getAlarmNumber());
			// 风险数量
			dcaHomePageFields.setRiskNumber(temp.getRiskCount().toString());
			timeDimensionList.add(dcaHomePageFields);
		}

		result.setTimeDimensionList(timeDimensionList);

		return result;

	}

	/**
	 * 首页右二饼图使用数据
	 * 
	 * @author liuc
	 * @date 2017年1月3日
	 */
	public DcaHomePageEntity getDataForPie() {

		DcaHomePageEntity result = new DcaHomePageEntity();

		// [涉及部门]的数据设置
		getInvolvedDepartment(result);

		return result;
	}

	/**
	 * 首页右三使用数据
	 * 
	 * @author liuc
	 * @date 2017年1月3日
	 */
	public DcaHomePageEntity getDataForShowData(String sysDate) {

		DcaHomePageEntity result = new DcaHomePageEntity();

		// 设置日期格式
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date closingTime = null;
		try {
			closingTime = sdf.parse(sysDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		// [总体数据]、[时间维度]、[设计部门]、[业务综合效能分析]的数据取得
		DcaPageConfigDetail dcaPageConfigDetail = dcaPageConfigService.getAllData();

		if (dcaPageConfigDetail != null) {
			// [总体数据]的数据设置
			if (CollectionUtils.isNotEmpty(dcaPageConfigDetail.getOverallDataList())) {
				getOverallData(result, dcaPageConfigDetail.getOverallDataList());
			} else {
				result.setRefreshTime("0");
				result.setTotalNumber("0");
				result.setEfficiency("0");
				result.setFrequency("0");
			}
			// [涉及部门]的数据设置
			getInvolvedDepartment(result);
		}

		// 职责清单数量
		DcaPowerList dcaPowerList = new DcaPowerList();
		dcaPowerList.setUpdateDate(closingTime);
		Integer dutyListCount = dcaPowerListDao.getPowerListCount(dcaPowerList);

		result.setDutyListCount(dutyListCount);

		// 风险点数量
		DcaAlarmRiskList dcaAlarmRiskList = new DcaAlarmRiskList();
		dcaAlarmRiskList.setUpdateDate(closingTime);
		Integer riskListCount = dcaAlarmRiskListDao.getRiskListCount(dcaAlarmRiskList);

		result.setRiskListCount(riskListCount);

		// 关键流程数量
		DcaWorkflow keyWorkFlow = new DcaWorkflow();
		keyWorkFlow.setUpdateDate(closingTime);
		Integer keyWorkFlowCount = dcaWorkflowDao.getKeyWorkFlowCount(keyWorkFlow);

		result.setKeyWorkFlowCount(keyWorkFlowCount);

		return result;
	}

	/**
	 * 获取大屏第二屏相关数据
	 * 
	 * @author liuc
	 * @date 2016年12月26日
	 */
	public DcaHomePageEntity getHomePageSecondData(String powerId, String sysDate) {

		DcaHomePageEntity result = new DcaHomePageEntity();

		// 设置日期格式
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date closingTime = null;
		try {
			closingTime = sdf.parse(sysDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		// 获取告警和风险列表
		DcaAlarmDetail dcaAlarmDetail = new DcaAlarmDetail();
		dcaAlarmDetail.setPowerId(powerId);
		dcaAlarmDetail.setUpdateDate(closingTime);

		List<DcaAlarmDetail> alarmAndRiskList = dcaAlarmDetailService.getAlarmAndRisk(dcaAlarmDetail);
		result.setAlarmAndRiskList(alarmAndRiskList);

		// 获取风险和告警信息相关分类数量
		setAlarmAndRiskCountForHomePage(result, powerId, closingTime);

		// [总体数据]、[时间维度]、[设计部门]、[业务综合效能分析]的数据取得
		DcaPageConfigDetail dcaPageConfigDetail = dcaPageConfigService.getAllData();

		if (dcaPageConfigDetail != null) {
			// [总体数据]的数据设置
			if (CollectionUtils.isNotEmpty(dcaPageConfigDetail.getOverallDataList())) {
				getOverallData(result, dcaPageConfigDetail.getOverallDataList());
			} else {
				result.setRefreshTime("0");
				result.setTotalNumber("0");
				result.setEfficiency("0");
				result.setFrequency("0");
			}
		}

		// 关键流程数量
		DcaWorkflow keyWorkFlow = new DcaWorkflow();
		keyWorkFlow.setUpdateDate(closingTime);
		Integer keyWorkFlowCount = dcaWorkflowDao.getKeyWorkFlowCount(keyWorkFlow);

		result.setKeyWorkFlowCount(keyWorkFlowCount);

		return result;

	}

	/**
	 * [总体数据]的数据设置
	 * 
	 * @param
	 * @return
	 */
	private void getOverallData(DcaHomePageEntity result, List<OverallData> list) {

		// 0:刷新时间、1:总业务流程数、2:企业效能、3:自动播放频次
		for (int i = 0; i < list.size(); i++) {

			OverallData item = list.get(i);

			if (item.getCode() == 1) {
				result.setRefreshTime(item.getTargetValue());
			} else if (item.getCode() == 2) {
				result.setTotalNumber(item.getTargetValue());
			} else if (item.getCode() == 3) {
				result.setEfficiency(item.getTargetValue());
			} else if (item.getCode() == 4) {
				result.setFrequency(item.getTargetValue());
			}
		}
	}

	/**
	 * [涉及部门]的数据设置
	 * 
	 * @param
	 * @return
	 */
	private void getInvolvedDepartment(DcaHomePageEntity result) {

		int otherCount = 0;

		List<DcaHomePageFields> involvedDepartmentList = new ArrayList<DcaHomePageFields>();
		List<DcaPageConfig> list = dcaPageConfigDao.getInvolveDeptData();

		for (DcaPageConfig item : list) {

			DcaHomePageFields dcaHomePageFields = new DcaHomePageFields();

			// 部门
			dcaHomePageFields.setDeptName(item.getCfgName());
			// 风险占比
			dcaHomePageFields.setProportion(item.getCfgValue1());

			// 获取有效数据（风险占比不为空）的前八个部门
			if (involvedDepartmentList.size() < 9) {
				involvedDepartmentList.add(dcaHomePageFields);
			} else {

				if (StringUtils.isNotEmpty(item.getCfgValue1())) {
					otherCount = otherCount + Integer.parseInt(item.getCfgValue1());
				}

			}

		}

		if (involvedDepartmentList.size() == 8) {

			DcaHomePageFields otherData = new DcaHomePageFields();
			// 部门
			otherData.setDeptName("其它");
			// 风险占比
			otherData.setProportion(String.valueOf(otherCount));
			involvedDepartmentList.add(otherData);

			result.setInvolvedDeptCount(list.size());
		}
		result.setInvolvedDepartmentList(involvedDepartmentList);
	}

	/**
	 * [业务综合效能分析]的数据设置
	 * 
	 * @param
	 * @return
	 */
	private void getEfficiencyAnalysis(DcaHomePageEntity result, List<EfficacyAnalysis> list) {

		List<DcaHomePageFields> efficiencyAnalysisList = new ArrayList<DcaHomePageFields>();

		for (EfficacyAnalysis item : list) {

			DcaHomePageFields dcaHomePageFields = new DcaHomePageFields();

			// 效能名
			dcaHomePageFields.setPerformanceName(item.getEfficacyName());
			// 效能值
			dcaHomePageFields.setEfficiencyValue(item.getEfficacyValue());

			efficiencyAnalysisList.add(dcaHomePageFields);
		}
		result.setEfficiencyAnalysisList(efficiencyAnalysisList);
	}

	private void setAlarmAndRiskCountForHomePage(DcaHomePageEntity result, String powerId, Date closingTime) {

		// 获取风险信息相关分类数量

		// 风险级别:2-黄色
		Integer riskAlarmLevelYCount = getRiskDetailCountForHomePage(Constant.ALARM_LEVEL_2, "", powerId, closingTime);
		result.setRiskAlarmLevelYCount(riskAlarmLevelYCount);
		// 风险级别:2-黄色、界定状态 3:未界定（未处理）
		Integer unProcessedYCount = getRiskDetailCountForHomePage(Constant.ALARM_LEVEL_2, Constant.DEFINE_STATUS_3,
				powerId, closingTime);
		// 风险级别:2-黄色（已处理）
		result.setRiskAlarmLevelProcessedYCount(riskAlarmLevelYCount - unProcessedYCount);

		// 风险级别:3-橙色
		Integer riskAlarmLevelOCount = getRiskDetailCountForHomePage(Constant.ALARM_LEVEL_3, "", powerId, closingTime);
		result.setRiskAlarmLevelOCount(riskAlarmLevelOCount);
		// 风险级别:3-黄橙色、界定状态 3:未界定（未处理）
		Integer unProcessedOCount = getRiskDetailCountForHomePage(Constant.ALARM_LEVEL_3, Constant.DEFINE_STATUS_3,
				powerId, closingTime);
		// 风险级别:3-橙色（已处理）
		result.setRiskAlarmLevelProcessedOCount(riskAlarmLevelOCount - unProcessedOCount);

		// 风险级别:4-红色
		Integer riskAlarmLevelRCount = getRiskDetailCountForHomePage(Constant.ALARM_LEVEL_4, "", powerId, closingTime);
		result.setRiskAlarmLevelRCount(riskAlarmLevelRCount);
		// 风险级别:4-红色、界定状态 3:未界定（未处理）
		Integer unProcessedRCount = getRiskDetailCountForHomePage(Constant.ALARM_LEVEL_4, Constant.DEFINE_STATUS_3,
				powerId, closingTime);
		// 风险级别:4-红色（已处理）
		result.setRiskAlarmLevelProcessedRCount(riskAlarmLevelRCount - unProcessedRCount);

		// 获取告警信息相关分类数量
		// 告警级别:2-黄色、告警状态：2-已消警（已处理）
		Integer alarmLevelProcessedYCount = getAlarmDetailCountForHomePage(Constant.ALARM_LEVEL_2,
				Constant.ALARMSTATUS_2, powerId, closingTime);
		result.setAlarmLevelProcessedYCount(alarmLevelProcessedYCount);

		// 告警级别:2-黄色
		Integer alarmLevelYCount = getAlarmDetailCountForHomePage(Constant.ALARM_LEVEL_2, "", powerId, closingTime);
		result.setAlarmLevelYCount(alarmLevelYCount);

		// 告警级别:3-橙色、告警状态：2-已消警（已处理）
		Integer alarmLevelProcessedOCount = getAlarmDetailCountForHomePage(Constant.ALARM_LEVEL_3,
				Constant.ALARMSTATUS_2, powerId, closingTime);
		result.setAlarmLevelProcessedOCount(alarmLevelProcessedOCount);

		// 告警级别:3-橙色
		Integer alarmLevelOCount = getAlarmDetailCountForHomePage(Constant.ALARM_LEVEL_3, "", powerId, closingTime);
		result.setAlarmLevelOCount(alarmLevelOCount);

		// 告警级别:4-红色、告警状态：2-已消警（已处理）
		Integer alarmLevelRrocessedOCount = getAlarmDetailCountForHomePage(Constant.ALARM_LEVEL_4,
				Constant.ALARMSTATUS_2, powerId, closingTime);
		result.setAlarmLevelProcessedRCount(alarmLevelRrocessedOCount);

		// 告警级别:4-红色
		Integer alarmLevelRCount = getAlarmDetailCountForHomePage(Constant.ALARM_LEVEL_4, "", powerId, closingTime);
		result.setAlarmLevelRCount(alarmLevelRCount);

	}

	// 获取告警信息相关分类数量
	private Integer getAlarmDetailCountForHomePage(String alarmLevel, String alarmStatus, String powerId, Date date) {

		DcaAlarmDetail dcaAlarmDetail = new DcaAlarmDetail();
		dcaAlarmDetail.setPowerId(powerId);
		dcaAlarmDetail.setAlarmLevel(alarmLevel);
		dcaAlarmDetail.setAlarmStatus(alarmStatus);
		dcaAlarmDetail.setUpdateDate(date);

		Integer count = dcaAlarmDetailDao.getAlarmDetailCountForHomePage(dcaAlarmDetail);
		return count;
	}

	// 获取风险信息相关分类数量
	private Integer getRiskDetailCountForHomePage(String alarmLevel, String defineStatus, String powerId, Date date) {

		DcaRiskManage dcaRiskManage = new DcaRiskManage();
		dcaRiskManage.setPowerId(powerId);
		dcaRiskManage.setAlarmLevel(alarmLevel);
		dcaRiskManage.setDefineStatus(defineStatus);
		dcaRiskManage.setUpdateDate(date);

		Integer count = dcaRiskManageDao.getRiskDetailCountForHomePage(dcaRiskManage);
		return count;
	}

	// 获取首页菜单按钮的名称
	public List<Dict> findPowerId(DcaWorkflow dcaWorkflow) {
		List<Dict> name = dcaWorkflowDao.findPowerId(dcaWorkflow);

		return name;
	}
}
