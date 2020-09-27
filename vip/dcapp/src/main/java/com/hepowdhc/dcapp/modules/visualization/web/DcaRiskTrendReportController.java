package com.hepowdhc.dcapp.modules.visualization.web;

import com.google.common.collect.Lists;
import com.hepowdhc.dcapp.modules.riskmanage.entity.RiskDataEntity;
import com.hepowdhc.dcapp.modules.riskmanage.service.DcaRiskManageService;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.entity.Dict;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 风险走势分析
 * 
 * @author zhengwei.cui
 * @version 2016-11-16
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaRiskTrendReport")
public class DcaRiskTrendReportController extends BaseController {

	@Autowired
	private DcaRiskManageService dcaRiskManageService;
	// 当前查询的业务类型
	private String idxDataType;

	/**
	 * 跳转到风险走势分析图页面
	 *
	 * @param request
	 * @param response
     * @return
     */
	@RequiresPermissions("dca:dcaRiskTrendReport:view")
	@RequestMapping(value = "riskTrendReport")
	public String riskTrendReport(HttpServletRequest request, HttpServletResponse response) {
		// 设置查询的业务类型
		idxDataType = (String) request.getSession().getAttribute("tabType");
		return "modules/dca/dcaRiskTrendReport";
	}

	/**
	 * 获取风险走势统计数据
	 * 
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "getData")
	public String getData(String selectYear) {
		// 纪检监察室
		String DISR = "";
		List<Dict> dictList = DictUtils.getDictList("discipline_depart");
		if (dictList != null && dictList.get(0) != null) {
			DISR = dictList.get(0).getValue();
		}
		User curUser = UserUtils.getUser();
		// 当前用户的部门id
		String userOfficeId = curUser.getOffice().getId();
		List<RiskDataEntity> riskReportData = Lists.newArrayList();
		// Login User的部门=[纪检监察室]
		if (DISR.equals(userOfficeId)) {
			riskReportData = dcaRiskManageService.getRiskReportData(selectYear,idxDataType);
		}
		return JsonMapper.nonDefaultMapper().toJson(riskReportData);
	}

}