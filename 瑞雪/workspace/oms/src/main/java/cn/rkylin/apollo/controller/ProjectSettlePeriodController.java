package cn.rkylin.apollo.controller;

import java.util.List;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.rkylin.apollo.common.util.CookiesUtil;
import cn.rkylin.apollo.common.util.DateUtils;
import cn.rkylin.apollo.service.ProjectSettlePeriodService;
import cn.rkylin.apollo.system.domain.UserInfo;
import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.controller.AbstractController;

/**
 * Copyright (C), 2016-2020, cn.rkylin.apollo FileName:
 * ProjectSettlePeriodController.java
 * 
 * @Description: 账期管理
 * @author zhangXinyuan
 * @Date 2016-7-28 上午 10:08
 * @version 1.00
 */
@Controller
@RequestMapping("/project/settlePeriod")
public class ProjectSettlePeriodController extends AbstractController {
	private static final Log log = LogFactory.getLog(ProjectSettlePeriodController.class);

	@Autowired
	private ProjectSettlePeriodService ProjectSettlePeriodService;

	/**
	 * 增加账期
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/addProjectSettlePeriod")
	@ResponseBody
	public Map<String, Object> addProjectSettlePeriod(HttpServletRequest request, HttpServletResponse response) {
		UserInfo user = CookiesUtil.getUserCookies(request);
		ApolloMap<String, Object> params = getParams(request);
		if (null != params.get("settleBeginDt")) {
			String settleBeginDt = DateUtils.getFormatDateBeginSeconds(String.valueOf(params.get("settleBeginDt")));
			params.put("settleBeginDt", settleBeginDt);
		}
		if (null != params.get("settleEndDt")) {
			String settleEndDt = DateUtils.getFormatDateEndSeconds(String.valueOf(params.get("settleEndDt")));
			params.put("settleEndDt", settleEndDt);
		}
		if (null != params.get("settleYear") && null != params.get("settleYearPeriod")) {
			String settleYearPeriod = String.valueOf(params.get("settleYear")) + "年"
					+ String.valueOf(params.get("settleYearPeriod"));
			params.put("settleYearPeriod", settleYearPeriod);
		}
		if (null != user) {
			params.put("createUserId", user.getUserid());
			params.put("createUserName", user.getUserName());
		}
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Map<String, Object>> periodList = ProjectSettlePeriodService.findProjectSettlePeriod(params);
			if (null == periodList || periodList.size() <= 0) {
				ProjectSettlePeriodService.addProjectSettlePeriod(params);
				resultMap.put("resultId", 1);
				resultMap.put("resultDescription", "新增成功！");
			} else {
				resultMap.put("resultId", 0);
				resultMap.put("errorMsg", "新增失败,结算账期已经存在，请选择其他账期。");
			}

		} catch (Exception e) {
			log.error("新增账期异常！", e);
			resultMap.put("resultId", 0);
			resultMap.put("errorMsg", "新增失败！");
		}
		return resultMap;
	}

	/**
	 * 修改账期
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/modifyProjectSettlePeriod")
	@ResponseBody
	public Map<String, Object> modifyProjectSettlePeriod(HttpServletRequest request, HttpServletResponse response) {
		UserInfo user = CookiesUtil.getUserCookies(request);
		ApolloMap<String, Object> params = getParams(request);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String paramId = null;
		boolean updatePeriod = true;
		if (null != params.get("id")) {
			paramId = String.valueOf(params.get("id"));
		}
		if (null != params.get("settleBeginDt")) {
			String settleBeginDt = DateUtils.getFormatDateBeginSeconds(String.valueOf(params.get("settleBeginDt")));
			params.put("settleBeginDt", settleBeginDt);
		}
		if (null != params.get("settleEndDt")) {
			String settleEndDt = DateUtils.getFormatDateEndSeconds(String.valueOf(params.get("settleEndDt")));
			params.put("settleEndDt", settleEndDt);
		}
		if (null != params.get("settleYear") && null != params.get("settleYearPeriod")) {
			String settleYearPeriod = String.valueOf(params.get("settleYear")) + "年"
					+ String.valueOf(params.get("settleYearPeriod"));
			params.put("settleYearPeriod", settleYearPeriod);
		}
		if (null != user) {
			params.put("updateUserId", user.getUserid());
			params.put("updateUserName", user.getUserName());
		}
		try {
			List<Map<String, Object>> periodList = ProjectSettlePeriodService.findProjectSettlePeriod(params);
			params.put("id", paramId);
			if (null != periodList && periodList.size() > 0) {
				if (null != periodList.get(0).get("ID")) {
					String findResultId = String.valueOf(periodList.get(0).get("ID"));
					if (!findResultId.equals(paramId)) {
						updatePeriod = false;

					}
				}
			}
			if (updatePeriod) {
				ProjectSettlePeriodService.updateProjectSettlePeriod(params);
				resultMap.put("resultId", 1);
				resultMap.put("resultDescription", "修改成功！");
			} else {
				resultMap.put("resultId", 0);
				resultMap.put("errorMsg", "修改失败,结算账期已经存在，请选择其他账期。");
			}
		} catch (Exception e) {
			log.error("修改账期异常！", e);
			resultMap.put("resultId", 0);
			resultMap.put("resultDescription", "修改失败！");
		}
		return resultMap;
	}

}
