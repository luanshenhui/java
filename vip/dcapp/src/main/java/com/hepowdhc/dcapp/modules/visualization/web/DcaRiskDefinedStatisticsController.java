/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.visualization.web;

import com.hepowdhc.dcapp.modules.visualization.entity.RiskStatistics;
import com.hepowdhc.dcapp.modules.visualization.service.DcaRiskDefinedStatisticsService;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.utils.DateUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 风险界定统计
 * 
 * @author dhc
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaRiskDefinedStatistics")
public class DcaRiskDefinedStatisticsController extends BaseController {

	@Autowired
	private DcaRiskDefinedStatisticsService dcaRiskDefinedStatisticsService;
	// 当前查询的业务类型
	private String idxDataType;

	/**
	 * 跳转风险界定页面
	 * 
	 * @author yuduo
	 * @version 2016-12-07
	 */
	@RequiresPermissions("dca:dcaRiskDefinedStatistics:view")
	@RequestMapping(value = { "showRiskDefined", "" })
	public String list(HttpServletRequest request, HttpServletResponse response, Model model) {
		// 设置查询的业务类型
		idxDataType = (String) request.getSession().getAttribute("tabType");
		return "modules/dca/dcaRiskDefinedStatistics";
	}

	/**
	 * 风险界定统计获取数据
	 * 
	 * @author yuduo
	 * @version 2016-12-07
	 */
	@ResponseBody
	@RequestMapping(value = "getStatistics")
	public String getStatistics(String selectYear) {
		RiskStatistics rs = dcaRiskDefinedStatisticsService.getRiskStatistics(selectYear,idxDataType);
		rs.setDt(DateUtils.getDate());
		return JsonMapper.nonDefaultMapper().toJson(rs);
	}
}