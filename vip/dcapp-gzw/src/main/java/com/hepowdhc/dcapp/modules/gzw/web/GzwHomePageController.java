/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */

package com.hepowdhc.dcapp.modules.gzw.web;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaCountByPowerEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmTypeCountEntity;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.Maps;
import com.hepowdhc.dcapp.modules.alarm.service.DcaAlarmDetailService;
import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoAlarmLevelCountEntity;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoAlarmLevelResult;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoPowerInstanceDataCountEntity;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoPowerInstanceResult;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoRiskDataEntity;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoRiskDefineDataEntity;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoRiskManage;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoRiskManageResult;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaNodeCountBean;
import com.hepowdhc.dcapp.modules.gzw.service.DcaCoAlarmDetailService;
import com.hepowdhc.dcapp.modules.gzw.service.DcaCoPowerInstanceCountService;
import com.hepowdhc.dcapp.modules.gzw.service.DcaCoRiskManageService;
import com.hepowdhc.dcapp.modules.riskmanage.service.DcaRiskManageService;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaHomePageEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaSimpleCountEntity;
import com.hepowdhc.dcapp.modules.visualization.service.DcaHomePageService;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflow;
import com.hepowdhc.dcapp.modules.workflow.service.DcaPowerBizDataCountService;
import com.hepowdhc.dcapp.modules.workflow.service.DcaWorkflowService;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.utils.DateUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.entity.Dict;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;

/**
 * 国资委首页Controller
 * 
 * @author liuc
 * @version 2017-1-3
 */
@Controller
@RequestMapping(value = "${adminPath}/gzw")
public class GzwHomePageController extends BaseController {

	private static String FIRST_PAGE = "01";
	private static String SECOND_PAGE = "02";
	private static String THIED_PAGE = "03";
	private static String FOURTH_PAGE = "04";

	/* 时间标志： 1-本月 ； 2-近半年 ； 3-近一年 */
	private static final String RECENT_MONTH = "1";
	private static final String RECENT_HALF_YEAR = "2";
	private static final String RECENT_ONE_YEAR = "3";

	@Autowired
	private DcaHomePageService dcaHomePageService;
	@Autowired
	private DcaCoRiskManageService dcaCoRiskManageService;

	/**
	 * 企业业务数据表Service
	 */
	@Autowired
	private DcaCoPowerInstanceCountService dcaCoPowerInstanceCountService;

	/**
	 * 告警信息表Service
	 */
	@Autowired
	private DcaCoAlarmDetailService dcaCoAlarmDetailService;

	@Autowired
	private DcaWorkflowService dcaWorkflowService;

	@Autowired
	private DcaAlarmDetailService dcaAlarmDetailService;

	@Autowired
	private DcaRiskManageService dcaRiskManageService;

	@Autowired
	private DcaPowerBizDataCountService dcaPowerBizDataCountService;

	/**
	 * 国资委首页访问
	 */
	@RequestMapping(value = "")
	public String indexGzw() {

		return "modules/gzw/index-gzw";
	}

	/**
	 * 首页框显示
	 */
	@RequestMapping(value = "/homepage")
	public String showHomePage(String pageIndex, Model model) {

		DcaHomePageEntity result = dcaHomePageService.getHomePage();

		if (result != null) {
			model.addAttribute("closingTime", result.getClosingTime());
			model.addAttribute("refreshTime", result.getRefreshTime());
			model.addAttribute("frequency", result.getFrequency());
		}

		model.addAttribute("pageIndex", pageIndex);

		return "modules/gzw/homePage-gzw";
	}

	/**
	 * 首页内容显示
	 */
	@RequestMapping(value = "/homepageInfo")
	public String showHomePageInfo(String pageIndex, Model model) {

		String path = "modules/gzw/homePageInfo";

		if (StringUtils.equals(pageIndex, FIRST_PAGE)) {
			path = "modules/gzw/homePageInfo";
		} else if (StringUtils.equals(pageIndex, SECOND_PAGE)) {

			model.addAttribute("powerId", "01");
			path = "modules/gzw/threeImportant1-gzw";

		} else if (StringUtils.equals(pageIndex, THIED_PAGE)) {
			path = "modules/gzw/businessDataVolume-gzw";
		} else if (StringUtils.equals(pageIndex, FOURTH_PAGE)) {
			path = "modules/gzw/workflowInstruction-gzw";
		}

		return path;
	}

	/**
	 * 首页风险点
	 */
	@RequestMapping(value = "/riskpoint")
	public String showRiskPoint() {

		return "modules/dca/riskpoint";
	}

	/**
	 * 首页流程说明
	 */
	@RequestMapping(value = "/workflowinstruction")
	public String showWorkflowInstruction() {

		return "modules/gzw/workflowInstruction-gzw";
	}

	/**
	 * 首页监管职责
	 */
	@RequestMapping(value = "/duty")
	public String showDuty() {

		return "modules/gzw/supervisoryDutiy-gzw";
	}

	/**
	 * 首页融合分析
	 */
	@RequestMapping(value = "/businessDataVolume")
	public String showBusinessDataVolume() {

		return "modules/gzw/businessDataVolume-gzw";
	}

	/**
	 * 首页某公司融合分析
	 */
	@RequestMapping(value = "/companyFusionAnalysis")
	public String showCompanyFusionAnalysis(String companyId, String companyName, Model model) {

		model.addAttribute("companyId", companyId);
		model.addAttribute("companyName", companyName);

		return "modules/gzw/alarmRiskAnalysis-gzw";
	}

	/**
	 * 首页三重一大
	 */
	@RequestMapping(value = "/threeImportant1")
	public String showThreeImportant1(Model model) {

		model.addAttribute("powerId", "01");

		return "modules/gzw/threeImportant1-gzw";
	}

	/**
	 * 获取所有公司数据
	 * 
	 * @return
	 * @author geshuo
	 * @date 2017年1月3日
	 */
	@RequestMapping(value = "findAllCompanies")
	@ResponseBody
	public String findAllCompanies() {
		// 查询数据
		List<Dict> coList = DictUtils.getDictList("company_name");
		return JsonMapper.nonDefaultMapper().toJson(coList);
	}

	/**
	 * 业务数据量
	 * 
	 * @return
	 * @author geshuo
	 * @date 2017年1月3日
	 */
	@RequestMapping(value = "findBizData")
	@ResponseBody
	public String findBizData() {
		// 查询数据
		List<DcaCoPowerInstanceDataCountEntity> countList = dcaCoPowerInstanceCountService.getBizDataCount();
		LinkedHashMap<String, DcaCoPowerInstanceResult> map = new LinkedHashMap<>();
		for (DcaCoPowerInstanceDataCountEntity entity : countList) {
			String coId = entity.getCoId();// 企业id
			String coName = entity.getCoName();// 企业名称
			if (null == map.get(entity.getCoId())) {
				// map中不存在
				DcaCoPowerInstanceResult resultItem = new DcaCoPowerInstanceResult();
				resultItem.setCoId(coId);
				resultItem.setCoName(coName);// 企业名称
				if (null != entity.getInstanceCount()) {
					resultItem.getDataList().add(entity);// 添加结果数据
				}
				map.put(entity.getCoId(), resultItem);// 放入map
			} else {
				// map中已经存在
				map.get(coId).getDataList().add(entity);// 添加结果数据
			}
		}
		// 结果集转换
		List<DcaCoPowerInstanceResult> resultList = new ArrayList<>();
		for (String key : map.keySet()) {
			resultList.add(map.get(key));
		}
		return JsonMapper.nonDefaultMapper().toJson(resultList);
	}

	/**
	 * 告警等级
	 * 
	 * @return
	 * @author geshuo
	 * @date 2017年1月3日
	 */
	@RequestMapping(value = "findAlarmLevelData")
	@ResponseBody
	public String findAlarmLevelData() {
		// 查询数据
		List<DcaCoAlarmLevelCountEntity> countList = dcaCoAlarmDetailService.getAlarmLevelDataCount();
		LinkedHashMap<String, DcaCoAlarmLevelResult> map = new LinkedHashMap<>();// 结果map
		for (DcaCoAlarmLevelCountEntity entity : countList) {
			String coId = entity.getCoId();// 企业id
			String coName = entity.getCoName();// 企业名称
			if (null == map.get(coId)) {
				// map中不存在
				DcaCoAlarmLevelResult resultItem = new DcaCoAlarmLevelResult();
				resultItem.setCoId(coId);
				resultItem.setCoName(coName);
				if (null != entity.getAlarmCount()) {
					resultItem.getDataList().add(entity);// 添加结果数据
				}
				map.put(coId, resultItem);// 放入map
			} else {
				// map中已经存在
				map.get(coId).getDataList().add(entity);// 添加结果数据
			}
		}

		// 处理结果，并补全告警等级数据
		List<DcaCoAlarmLevelResult> resultList = new ArrayList<>();
		for (String key : map.keySet()) {
			DcaCoAlarmLevelResult resultItem = map.get(key);
			List<DcaCoAlarmLevelCountEntity> dataList = resultItem.getDataList();
			if (!dataList.isEmpty() && dataList.size() != 3) {
				// 不是空 并且数据不全时，补全告警等级数据 2、3、4
				for (int i = 0; i < 3; i++) {
					String alarmLevel = "";
					if (dataList.size() > i) {
						// 没有越界
						alarmLevel = dataList.get(i).getAlarmLevel();
					}
					switch (i) {
					case 0:
						if (!Constant.ALARM_LEVEL_2.equals(alarmLevel)) {
							// 第1个不是2，把"2"补上
							dataList.add(0, getBlankCountEntity(resultItem, Constant.ALARM_LEVEL_2));
						}
						break;
					case 1:
						if (!Constant.ALARM_LEVEL_3.equals(alarmLevel)) {
							// 第2个不是"3"，把"3"补上
							dataList.add(1, getBlankCountEntity(resultItem, Constant.ALARM_LEVEL_3));
						}
						break;
					case 2:
						if (!Constant.ALARM_LEVEL_4.equals(alarmLevel)) {
							// 第3个不是"4"，把"4"补上
							dataList.add(2, getBlankCountEntity(resultItem, Constant.ALARM_LEVEL_4));
						}
						break;
					}
				}
			}

			resultList.add(resultItem);
		}
		return JsonMapper.nonDefaultMapper().toJson(resultList);
	}

	/**
	 * 构造统计数据为0的告警等级数据
	 * 
	 * @param resultItem
	 * @param alarmLevel
	 * @return
	 * @author geshuo
	 * @date 2017年1月4日
	 */
	private DcaCoAlarmLevelCountEntity getBlankCountEntity(DcaCoAlarmLevelResult resultItem, String alarmLevel) {
		// 补上对应的告警等级
		DcaCoAlarmLevelCountEntity entity = new DcaCoAlarmLevelCountEntity();
		entity.setCoId(resultItem.getCoId());
		entity.setCoName(resultItem.getCoName());
		entity.setAlarmLevel(alarmLevel);
		entity.setAlarmCount(0l);
		return entity;
	}

	/**
	 * 查询风险等级统计数据
	 * 
	 * @author cuizhengwei
	 * @date 2017-01-03
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/findRiskLevelData")
	public String findRiskLevelData() {
		// 查询各企业风险等级数
		List<DcaCoRiskManage> riskLevelList = dcaCoRiskManageService.getCoRiskLevelNum();
		LinkedHashMap<String, DcaCoRiskManageResult> map = new LinkedHashMap<>();
		for (DcaCoRiskManage dcaCoRiskManage : riskLevelList) {
			String coId = dcaCoRiskManage.getCoId(); // 企业id
			if (null == map.get(coId)) {
				// map中不存在
				DcaCoRiskManageResult result = new DcaCoRiskManageResult();
				result.setCoId(coId);
				result.setCoName(dcaCoRiskManage.getCoName());
				if (null != dcaCoRiskManage.getRiskNum()) {
					result.getDataList().add(dcaCoRiskManage);
				}
				map.put(coId, result);
			} else {
				// map中存在
				map.get(coId).getDataList().add(dcaCoRiskManage);
			}
		}

		// 处理结果，并补全风险等级数据
		List<DcaCoRiskManageResult> resultList = new ArrayList<>();
		for (String key : map.keySet()) {
			DcaCoRiskManageResult resultItem = map.get(key);
			List<DcaCoRiskManage> dataList = resultItem.getDataList();
			if (!dataList.isEmpty() && dataList.size() != 3) {
				// 不是空 并且数据不全时，补全风险等级数据
				for (int i = 0; i < 3; i++) {
					String riskLevel = "";
					if (dataList.size() > i) {
						// 没有越界
						riskLevel = dataList.get(i).getRiskLevel();
					}
					switch (i) {
					case 0:
						if (!Constant.RISK_LEVEL_10.equals(riskLevel)) {
							// 第1个不是10，把"10"补上
							dataList.add(0, getBlankRiskLevelEntity(resultItem, Constant.RISK_LEVEL_10));
						}
						break;
					case 1:
						if (!Constant.RISK_LEVEL_20.equals(riskLevel)) {
							// 第2个不是"20"，把"20"补上
							dataList.add(1, getBlankRiskLevelEntity(resultItem, Constant.RISK_LEVEL_20));
						}
						break;
					case 2:
						if (!Constant.RISK_LEVEL_30.equals(riskLevel)) {
							// 第3个不是"30"，把"30"补上
							dataList.add(2, getBlankRiskLevelEntity(resultItem, Constant.RISK_LEVEL_30));
						}
						break;
					}
				}
			}

			resultList.add(resultItem);
		}

		return JsonMapper.nonDefaultMapper().toJson(resultList);
	}

	/**
	 * 补全风险统计数据为空的entity
	 * 
	 * @param resultItem
	 * @param riskLevel
	 * @return
	 */
	private DcaCoRiskManage getBlankRiskLevelEntity(DcaCoRiskManageResult resultItem, String riskLevel) {
		// 补上对应的风险统计数据
		DcaCoRiskManage entity = new DcaCoRiskManage();
		entity.setCoId(resultItem.getCoId());
		entity.setCoName(resultItem.getCoName());
		entity.setRiskLevel(riskLevel);
		entity.setRiskNum("0");
		return entity;
	}

	/**
	 * 查询风险界定统计数据
	 * 
	 * @author cuizhengwei
	 * @date 2017-01-03
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/findDefineStatusData")
	public String findDefineStatusData() {
		// 查询各企业风险界定数
		List<DcaCoRiskManage> defineStatusList = dcaCoRiskManageService.getCoDefineStatusNum();
		LinkedHashMap<String, DcaCoRiskManageResult> map = new LinkedHashMap<>();
		for (DcaCoRiskManage dcaCoRiskManage : defineStatusList) {
			String coId = dcaCoRiskManage.getCoId(); // 企业id
			if (null == map.get(coId)) {
				// map中不存在
				DcaCoRiskManageResult result = new DcaCoRiskManageResult();
				result.setCoId(coId);
				result.setCoName(dcaCoRiskManage.getCoName());
				if (null != dcaCoRiskManage.getRiskNum()) {
					result.getDataList().add(dcaCoRiskManage);
				}
				map.put(coId, result);
			} else {
				// map中存在
				map.get(coId).getDataList().add(dcaCoRiskManage);
			}
		}

		// 处理结果，并补全风险界定数据
		List<DcaCoRiskManageResult> resultList = new ArrayList<>();
		for (String key : map.keySet()) {
			DcaCoRiskManageResult resultItem = map.get(key);
			List<DcaCoRiskManage> dataList = resultItem.getDataList();
			if (!dataList.isEmpty() && dataList.size() != 3) {
				// 不是空 并且数据不全时，补全风险界定数据
				for (int i = 0; i < 3; i++) {
					String defineStatus = "";
					if (dataList.size() > i) {
						// 没有越界
						defineStatus = dataList.get(i).getDefineStatus();
					}
					switch (i) {
					case 0:
						if (!Constant.DEFINE_STATUS_1.equals(defineStatus)) {
							// 第1个不是1，把"1"补上
							dataList.add(0, getBlankDefineStatusEntity(resultItem, Constant.DEFINE_STATUS_1));
						}
						break;
					case 1:
						if (!Constant.DEFINE_STATUS_2.equals(defineStatus)) {
							// 第2个不是"2"，把"2"补上
							dataList.add(1, getBlankDefineStatusEntity(resultItem, Constant.DEFINE_STATUS_2));
						}
						break;
					case 2:
						if (!Constant.DEFINE_STATUS_3.equals(defineStatus)) {
							// 第3个不是"3"，把"3"补上
							dataList.add(2, getBlankDefineStatusEntity(resultItem, Constant.DEFINE_STATUS_3));
						}
						break;
					}
				}
			}

			resultList.add(resultItem);
		}

		return JsonMapper.nonDefaultMapper().toJson(resultList);
	}

	/**
	 * 补全风险统计数据为空的entity
	 * 
	 * @param resultItem
	 * @param defineStatus
	 * @return
	 */
	private DcaCoRiskManage getBlankDefineStatusEntity(DcaCoRiskManageResult resultItem, String defineStatus) {
		// 补上对应的风险统计数据
		DcaCoRiskManage entity = new DcaCoRiskManage();
		entity.setCoId(resultItem.getCoId());
		entity.setCoName(resultItem.getCoName());
		entity.setDefineStatus(defineStatus);
		entity.setRiskNum("0");
		return entity;
	}

	/**
	 * 根据企业id查询当前年风险走势统计
	 * 
	 * @param coId
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/findRiskTrendReportData")
	public String findRiskTrendReportData(String coId) {
		List<DcaCoRiskDataEntity> data = dcaCoRiskManageService.getRiskTrendReport(coId);
		Map<String, Object> map = Maps.newHashMap();
		map.put("curYear", DateUtils.getYear());
		map.put("data", data);
		return JsonMapper.nonDefaultMapper().toJson(data);
	}

	/**
	 * 根据企业id查询当前年风险界定统计
	 * 
	 * @param coId
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/findCoRiskDefinedReportData")
	public String findCoRiskDefinedReportData(String coId) {
		List<DcaCoRiskDefineDataEntity> data = dcaCoRiskManageService.getCoRiskDefinedReport(coId);
		Map<String, Object> map = Maps.newHashMap();
		map.put("curYear", DateUtils.getYear());
		map.put("data", data);
		return JsonMapper.nonDefaultMapper().toJson(map);
	}

	/**
	 * 根据权利和各专委会查询各12个月的数据
	 * 
	 * @param powerId 权利
	 * @param speCommittee 专委会
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/findSpeCommitteeRiskData")
	public DcaCoRiskDataEntity findSpeCommitteeRiskData(String powerId, String speCommittee) {
		DcaCoRiskManage dcaCoRiskManage = new DcaCoRiskManage();
		dcaCoRiskManage.setPowerId(powerId);
		dcaCoRiskManage.setSpeCommittee(speCommittee);
		DcaCoRiskDataEntity data = dcaCoRiskManageService.getSpeCommitteeRiskByMonth(dcaCoRiskManage);

		return data;
	}

	/**
	 * 根据企业id查询风险、告警、业务事项统计信息(按照权力统计)
	 * 
	 * @param coId
	 * @return
	 * @author geshuo
	 * @date 2017年1月4日
	 */
	@RequestMapping(value = "findAlarmRiskByCoId")
	@ResponseBody
	public String findAlarmRiskByCoId(String coId) {
		Map<String, List<DcaCountByPowerEntity>> resultMap = new HashMap<>();
		// 查询风险统计数据
		List<DcaCountByPowerEntity> riskList = dcaCoRiskManageService.getRiskCountByCoId(coId);
		resultMap.put("riskList", riskList);

		// 查询告警统计数据
		List<DcaCountByPowerEntity> alarmList = dcaCoAlarmDetailService.getAlarmCountByCoId(coId);
		resultMap.put("alarmList", alarmList);

		// 查询业务事项数据
		List<DcaCountByPowerEntity> instanceList = dcaCoPowerInstanceCountService.getInstanceCountByCoId(coId);
		resultMap.put("instanceList", instanceList);

		return JsonMapper.nonDefaultMapper().toJson(resultMap);
	}

	/**
	 * 查询各专委会风险统计数据(气泡图)
	 * 
	 * @return
	 * @author geshuo
	 * @date 2017年1月5日
	 */
	@RequestMapping(value = "findSpecialCommitteeRisk")
	@ResponseBody
	public String findSpecialCommitteeRisk(String powerId, String timeType) {
		Map<String, Object> paramMap = new HashMap<>();
		if (StringUtils.isNotEmpty(timeType)) {
			Calendar startCal = Calendar.getInstance();
			if (timeType.equals(RECENT_MONTH)) {// 本月
				startCal.set(Calendar.DAY_OF_MONTH, 1);
			} else if (timeType.equals(RECENT_HALF_YEAR)) {// 近半年
				startCal.add(Calendar.MONTH, -6);
			} else if (timeType.equals(RECENT_ONE_YEAR)) {// 近一年
				startCal.add(Calendar.YEAR, -1);
			}

			paramMap.put("startDate", startCal.getTime());// 开始日期
			paramMap.put("endDate", new Date());// 结束日期
		}

		if (StringUtils.isNotEmpty(powerId)) {
			paramMap.put("powerId", powerId);// 权力id
		}

		List<DcaCountByPowerEntity> resultList = dcaRiskManageService.getSpecialCommitteeRisk(paramMap);
		return JsonMapper.nonDefaultMapper().toJson(resultList);
	}

	/**
	 * 三重一大流程图
	 * 
	 * @author panghuidan
	 * @date 2017-01-04
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "getWorkFlowXML")
	public String getWorkFlowXML(String powerId, Model model) throws Exception {
		Map<String, Object> resultMap = new HashMap<>();
		// 获取json字符串
		String XMLContent = "";
		List<DcaWorkflow> workFlowXML = dcaWorkflowService.getWorkFlowXML(powerId);
		if (CollectionUtils.isNotEmpty(workFlowXML)) {
			XMLContent = workFlowXML.get(0).getXmlContent();
		}

		// 解析json中的节点名称数据，根据企业id powerid task_name 查询风险、告警、业务数据
		ObjectMapper mapper = new ObjectMapper();
		Map<String, DcaNodeCountBean> nodeMap = new HashMap<>();
		List<String> nodeNameList = new ArrayList<>();
		HashMap<String, Object> result = new HashMap<>();
		if (!StringUtils.isEmpty(XMLContent)) {
			result = mapper.readValue(XMLContent, HashMap.class);
		}
		if (null != result.get("nodes")) {
			HashMap<String, Object> nodesMap = (HashMap<String, Object>) result.get("nodes");
			for (String key : nodesMap.keySet()) {
				HashMap<String, Object> nodeDetailMap = (HashMap<String, Object>) nodesMap.get(key);
				String name = String.valueOf(nodeDetailMap.get("name"));
				nodeNameList.add(name);
			}
		}

		if (nodeNameList != null && !nodeNameList.isEmpty()) {
			// 根据节点名称 查询告警数
			List<DcaSimpleCountEntity> alarmList = dcaAlarmDetailService.getAlarmCountByTaskName(nodeNameList);
			nodeMap = parseCountList(alarmList, nodeMap, 0);

			// 根据节点名称 查询风险数
			List<DcaSimpleCountEntity> riskList = dcaRiskManageService.getRiskCountByTaskName(nodeNameList);
			nodeMap = parseCountList(riskList, nodeMap, 1);

			// 根据节点名称 查询业务数据量
			List<DcaSimpleCountEntity> bizDataList = dcaPowerBizDataCountService.getDataCountByTaskName(nodeNameList);
			nodeMap = parseCountList(bizDataList, nodeMap, 2);
		}

		resultMap.put("XMLContent", XMLContent);
		resultMap.put("nodesData", nodeMap);// 节点数据
		model.addAttribute("powerId", powerId);
		return JsonMapper.nonDefaultMapper().toJson(resultMap);
	}

	/**
	 * 解析统计数据
	 * 
	 * @param dataList
	 * @param nodeMap
	 * @param flag
	 * @return
	 * @author geshuo
	 * @date 2017年1月5日
	 */
	private Map<String, DcaNodeCountBean> parseCountList(List<DcaSimpleCountEntity> dataList,
			Map<String, DcaNodeCountBean> nodeMap, int flag) {
		for (DcaSimpleCountEntity entity : dataList) {
			String name = entity.getName();
			DcaNodeCountBean bean;
			if (null != nodeMap.get(name)) {
				bean = nodeMap.get(name);
			} else {
				bean = new DcaNodeCountBean();
			}
			switch (flag) {
			case 0:// 告警
				bean.setAlarmCount(entity.getCount());
				break;
			case 1:// 风险
				bean.setRiskCount(entity.getCount());
				break;
			case 2:// 业务数据
				bean.setBizDataCount(entity.getCount());
				break;
			}
			nodeMap.put(name, bean);
		}
		return nodeMap;
	}

	/**
	 * 三重一大流程图-节点详细数据
	 * @param powerId
	 * @param taskName
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "getNodeDetailData")
	public String getNodeDetailData(String powerId, String taskName) throws Exception {
		Map<String, Object> resultMap = new HashMap<>();
		Map<String,Object> paramMap = new HashMap<>();

		paramMap.put("powerId",powerId);
		paramMap.put("taskName",taskName);

		List<DcaAlarmTypeCountEntity> alarmList = dcaAlarmDetailService.getNodeAlarmDetail(paramMap);

		List<DcaAlarmTypeCountEntity> riskList = dcaRiskManageService.getNodeRiskDetail(paramMap);

		resultMap.put("taskName",taskName);
		resultMap.put("powerId",powerId);
		resultMap.put("alarmList",alarmList);
		resultMap.put("riskList",riskList);
		return JsonMapper.nonDefaultMapper().toJson(resultMap);
	}
}