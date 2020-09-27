/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */

package com.hepowdhc.dcapp.modules.nytz.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.hepowdhc.dcapp.modules.visualization.service.DcaHomePageService;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.entity.Office;
import com.thinkgem.jeesite.modules.sys.service.OfficeService;

/**
 * 首页Controller
 *
 * @author
 * @version 2017-1-16
 */
@Controller
@RequestMapping(value = "${adminPath}/nytz")
public class NytzHomePageController extends BaseController {

	@Autowired
	private DcaHomePageService dcaHomePageService;

	@Autowired
	private OfficeService officeService;

	@Autowired
	@Qualifier("sqlApi")
	// private HashMap queryMap;

	/**
	 * 首页框显示
	 */
	@RequestMapping(value = "/homepage")
	public String showHomePageNytz() {
		/*
		 * DcaHomePageEntity result = dcaHomePageService.getHomePage(); if (result != null) {
		 * model.addAttribute("closingTime", result.getClosingTime()); model.addAttribute("refreshTime",
		 * result.getRefreshTime()); model.addAttribute("frequency", result.getFrequency());
		 * model.addAttribute("powerName", result.getPowerName()); }
		 */
		return "modules/nytz/homePage";
	}

	/**
	 * 首页左一仪表盘图使用数据
	 *
	 * @author liuc
	 * @date 2017年1月3日
	 */

	/*
	 * @ResponseBody
	 * 
	 * @RequestMapping(value = "/getDataForGauge") public String getDataForGaugeNytz() { DcaHomePageEntity result =
	 * dcaHomePageService.getDataForGauge();
	 * 
	 * return JsonMapper.nonDefaultMapper().toJson(result); }
	 */

	/**
	 * 首页左二风险/告警等级使用数据
	 *
	 * @author liuc
	 * @date 2017年1月3日
	 */

	/*
	 * @ResponseBody
	 * 
	 * @RequestMapping(value = "/getDataForRiskAlarm") public String getDataForRiskAlarmNytz(String powerId, String
	 * sysDate) { DcaHomePageEntity result = dcaHomePageService.getDataForRiskAlarm(powerId, sysDate);
	 * 
	 * return JsonMapper.nonDefaultMapper().toJson(result); }
	 */

	/**
	 * 首页左三数据引擎监控情况使用数据
	 *
	 * @author liuc
	 * @date 2017年1月6日
	 */
	/*
	 * @ResponseBody
	 * 
	 * @RequestMapping(value = "/getBizDataLastList") public String getBizDataLastListNytz() { List<Integer> result =
	 * dcaHomePageService.getBizDataLastList();
	 * 
	 * return JsonMapper.nonDefaultMapper().toJson(result); }
	 */

	/**
	 * 首页中间雷达图使用数据
	 *
	 * @author liuc
	 * @date 2017年1月3日
	 */

	/*
	 * @ResponseBody
	 * 
	 * @RequestMapping(value = "/getDataForRadar") public String getDataForRadarNytz() { DcaHomePageEntity result =
	 * dcaHomePageService.getDataForRadar();
	 * 
	 * return JsonMapper.nonDefaultMapper().toJson(result); }
	 */

	/**
	 * 首页右一柱状图使用数据
	 *
	 * @author liuc
	 * @date 2017年1月3日
	 */

	/*
	 * @ResponseBody
	 * 
	 * @RequestMapping(value = "/getDataForWorkBar") public String getDataForWorkBar() { DcaHomePageEntity result =
	 * dcaHomePageService.getDataForWorkBar();
	 * 
	 * return JsonMapper.nonDefaultMapper().toJson(result); }
	 */

	/**
	 * 首页右二饼图使用数据
	 *
	 * @author liuc
	 * @date 2017年1月3日
	 */

	/*
	 * @ResponseBody
	 * 
	 * @RequestMapping(value = "/getDataForPie") public String getDataForPie() { DcaHomePageEntity result =
	 * dcaHomePageService.getDataForPie();
	 * 
	 * return JsonMapper.nonDefaultMapper().toJson(result); }
	 */

	/**
	 * 首页右三数据展示使用数据
	 *
	 * @author liuc
	 * @date 2017年1月3日
	 */

	/*
	 * @ResponseBody
	 * 
	 * @RequestMapping(value = "/getDataForShowData") public String getDataForShowData(String sysDate) {
	 * DcaHomePageEntity result = dcaHomePageService.getDataForShowData(sysDate);
	 * 
	 * return JsonMapper.nonDefaultMapper().toJson(result); }
	 */

	/**
	 * 获取大屏第二屏相关数据
	 *
	 * @author liuc
	 * @date 2016年12月26日
	 */

	/*
	 * @ResponseBody
	 * 
	 * @RequestMapping(value = "/getSecondData") public String getHomePageSecondData(String powerId, String sysDate,
	 * Model model) { DcaHomePageEntity result = dcaHomePageService.getHomePageSecondData(powerId, sysDate);
	 * 
	 * return JsonMapper.nonDefaultMapper().toJson(result); }
	 */

	/**
	 * 首页内容显示
	 */
	@RequestMapping(value = "/homepageInfo")
	public String showHomePageInfoNytz() {

		return "modules/nytz/homePageInfo";
	}

	/**
	 * 首页第二页显示
	 */
	@RequestMapping(value = "/homepageDetail")
	public String showHomePageDetailNytz(String powerId, Model model) {
		model.addAttribute("powerId", powerId);
		return "modules/nytz/homePageDetail";
	}

	/**
	 * 首页风险点
	 */
	@RequestMapping(value = "/riskpoint")
	public String showriskPoint() {

		return "modules/dca/riskpoint";
	}

	/**
	 * 首页流程说明
	 */
	@RequestMapping(value = "/workflowinstruction")
	public String showworkflowinstruction() {

		return "modules/dca/workflowinstruction";
	}

	/**
	 * 首页监管职责
	 */
	@RequestMapping(value = "/duty")
	public String showduty() {

		return "modules/dca/duty";
	}

	/**
	 * 获取机构JSON数据。
	 * 
	 * @param extId 排除的ID
	 * @param type 类型（1：公司；2：部门/小组/其它：3：用户）
	 * @param grade 显示级别
	 * @param response
	 * @return
	 */

	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required = false) String extId,
			@RequestParam(required = false) String type, @RequestParam(required = false) Long grade,
			@RequestParam(required = false) Boolean isAll) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<Office> list = officeService.findList(isAll);
		for (int i = 0; i < list.size(); i++) {
			Office e = list.get(i);
			if ((StringUtils.isBlank(extId)
					|| (extId != null && !extId.equals(e.getId()) && e.getParentIds().indexOf("," + extId + ",") == -1))
					&& (type == null || (type != null && (type.equals("1") ? type.equals(e.getType()) : true)))
					&& (grade == null || (grade != null && Integer.parseInt(e.getGrade()) <= grade.intValue()))
					&& Global.YES.equals(e.getUseable())) {
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", e.getId());
				map.put("pId", e.getParentId());
				map.put("pIds", e.getParentIds());
				map.put("name", e.getName());
				// OA对应，添加上级名称、部门正职、部门副职 hxa
				map.put("parentName", e.getParentName());
				map.put("primaryPerson.name", e.getPrimaryPersonName());
				map.put("deputyPerson.name", e.getDeputyPersonName());
				if (type != null && "3".equals(type)) {
					map.put("isParent", true);
				}
				mapList.add(map);
			}
		}
		return mapList;
	}
	/**
	 * 首页sql执行接口
	 *
	 * @return 查询结果
	 * @throws Exception geshuo 20170110
	 */
	/*
	 * @ResponseBody
	 * 
	 * @RequestMapping(value = "/api") public Object pageApi(HttpServletRequest request, HttpSession session) throws
	 * Exception {
	 * 
	 * Map<String, String[]> requestParameterMap = request.getParameterMap();
	 * 
	 * // 构造查询参数 Map<String, String> paramMap = new HashMap<>();
	 * 
	 * for (Entry<String, String[]> me : requestParameterMap.entrySet()) {
	 * 
	 * paramMap.put(me.getKey(), ArrayUtils.isEmpty(me.getValue()) ? null : me.getValue()[0]);
	 * 
	 * }
	 * 
	 * if (paramMap.isEmpty()) { return "{msg:'参数不能为空!'}"; } String queryId = paramMap.get("_id");// 获取查询id
	 * 
	 * if (StringUtils.isEmpty(queryId)) { return "{msg:'id不能为空!'}"; }
	 * 
	 * MapperBean queryMapper = (MapperBean) queryMap.get(queryId);// 获取查询对象
	 * 
	 * if (null == queryMapper) { return "{msg:'SQL对应的_id配置错误!'}"; }
	 * 
	 * String sql = queryMapper.getSql();// 查询语句
	 * 
	 * if (StringUtils.isEmpty(sql) && queryMapper.isFile()) {
	 * 
	 * sql = queryMapper .getSql(Paths.get(session.getServletContext().getRealPath("WEB-INF/sql"), queryId + "" +
	 * ".sql"));
	 * 
	 * }
	 * 
	 * if (StringUtils.isEmpty(sql)) {
	 * 
	 * return "{msg:'sql不能为空!'}";
	 * 
	 * } final DruidDataSource dataSourceBean = queryMapper.getDs();// 数据源
	 * 
	 * // 加载数据库配置 if (dataSourceBean == null) { return "{msg:'数据源设置错误!'}"; }
	 * 
	 * final VerifySql ver = new VerifySql() {
	 * 
	 * @Override public void setConfig(final WallConfig config) { config.setCallAllow(false);
	 * config.setCreateTableAllow(false); config.setDropTableAllow(false); config.setAlterTableAllow(false);
	 * config.setRenameTableAllow(false); config.setLockTableAllow(false); config.setStartTransactionAllow(false);
	 * config.setDeleteAllow(false); config.setUpdateAllow(false); config.setInsertAllow(false);
	 * config.setMergeAllow(false); config.setIntersectAllow(false); config.setReplaceAllow(false);
	 * config.setCommitAllow(false); config.setRollbackAllow(false); config.setUseAllow(false);
	 * config.setDescribeAllow(false); config.setShowAllow(false); config.setSchemaCheck(false);
	 * config.setTableCheck(false); config.setFunctionCheck(false); config.setObjectCheck(false);
	 * config.setVariantCheck(false);
	 * 
	 * } };
	 * 
	 * logger.debug("======sql=====>" + sql);
	 * 
	 * try { if (!ver.verify(sql)) { throw new SQLException(); } } catch (SQLException e) { e.printStackTrace(); return
	 * "{msg:'非法的查询sql!'}"; }
	 * 
	 * List<Map<String, Object>> list; if (paramMap.size() == 1) { // 只有 _id一个参数，说明查询没有参数 final JdbcTemplate template =
	 * new JdbcTemplate(dataSourceBean); list = template.queryForList(sql); } else { NamedParameterJdbcTemplate
	 * namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(dataSourceBean); list =
	 * namedParameterJdbcTemplate.queryForList(sql, paramMap); } return list;
	 * 
	 * }
	 */

	// /**
	// * 首页sql执行接口(废弃 20170113)
	// *
	// * @param ds 数据源name，和spring-context.xml中bean的name对应
	// * @param fn sql文件名称，包括后缀名
	// * @param arg 参数数组
	// * @return 查询结果
	// * @throws Exception geshuo
	// * 20170110
	// */
	// @ResponseBody
	// @RequestMapping(value = "/api")
	// public Object pageApi(@RequestParam("ds") String ds,
	// @RequestParam("fn") String fn,
	// @RequestParam("arg[]") String[] arg,
	// HttpSession session) throws Exception {
	//
	// String sqlpath = session.getServletContext().getRealPath("/WEB-INF/sql/");
	//
	// //校验参数
	// if (StringUtils.isEmpty(ds)) {
	// return "{msg:'数据源不能为空!'}";
	// }
	// //加载数据库配置
	// final DruidDataSource dataSourceBean = SpringContextHolder.getBean(ds);
	//
	// if (dataSourceBean == null) {
	// return "{msg:'数据源设置错误!'}";
	// }
	//
	// final JdbcTemplate template = new JdbcTemplate(dataSourceBean);
	//
	// if (StringUtils.isEmpty(fn)) {
	// return "{msg:'文件名不能为空!'}";
	// }
	//
	// final String sql = FileUtils.readFileToString(Paths.get(sqlpath, fn).toFile(), "UTF8");
	//
	// final VerifySql ver = new VerifySql() {
	//
	// @Override
	// public void setConfig(WallConfig config) {
	// config.setCallAllow(false);
	// config.setCreateTableAllow(false);
	// config.setDropTableAllow(false);
	// config.setAlterTableAllow(false);
	// config.setRenameTableAllow(false);
	// config.setLockTableAllow(false);
	// config.setStartTransactionAllow(false);
	// config.setDeleteAllow(false);
	// config.setUpdateAllow(false);
	// config.setInsertAllow(false);
	// config.setMergeAllow(false);
	// config.setIntersectAllow(false);
	// config.setReplaceAllow(false);
	// config.setCommitAllow(false);
	// config.setRollbackAllow(false);
	// config.setUseAllow(false);
	// config.setDescribeAllow(false);
	// config.setShowAllow(false);
	// config.setSchemaCheck(false);
	// config.setTableCheck(false);
	// config.setFunctionCheck(false);
	// config.setObjectCheck(false);
	// config.setVariantCheck(false);
	//
	// }
	// };
	//
	// logger.debug("======sql=====>" + sql);
	// try {
	// if (!ver.verify(sql)) {
	// throw new SQLException();
	// }
	// } catch (SQLException e) {
	// return "{msg:'非法的查询sql!'}";
	// }
	// //=============
	//
	// List<Map<String, Object>> list;
	// if (arg.length == 0) {
	// list = template.queryForList(sql);
	// } else {
	// //构造参数
	// Object[] params = new Object[arg.length];
	// for (int i = 0; i < arg.length; i++) {
	// params[i] = arg[i];
	// }
	// list = template.queryForList(sql, params);
	// }
	// return list;
	// }

}