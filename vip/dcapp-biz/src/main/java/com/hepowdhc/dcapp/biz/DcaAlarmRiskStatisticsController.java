/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.biz;

import com.google.common.collect.Lists;
import com.hepowdhc.dcapp.modules.alarm.entity.DcaAlarmDetail;
import com.hepowdhc.dcapp.modules.alarm.service.DcaAlarmDetailService;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaARStatForPowerEntity;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.entity.Dict;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 告警风险统计(权力)
 * 
 * @author geshuo
 * @date 2016年12月5日
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaAlarmRiskStatistics")
public class DcaAlarmRiskStatisticsController extends BaseController {

	@Autowired
	private DcaAlarmDetailService dcaAlarmDetailService;
	// 当前查询的业务类型
	private String idxDataType;

	/**
	 * 告警风险统计(权力)
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @author geshuo
	 * @date 2016年12月5日
	 */
	@RequiresPermissions("dca:dcaARForPowerReport:view")
	@RequestMapping(value = { "forPower", "" })
	public String list(HttpServletRequest request, HttpServletResponse response, Model model) {
		idxDataType = (String) request.getSession().getAttribute("tabType");
		return "modules/dca/dcaReportARForPower";
	}

	/**
	 * 告警风险统计(权力)
	 * 
	 * @return
	 * @author geshuo
	 * @date 2016年12月5日
	 */
	@RequestMapping(value = "findAlarmRiskStatData")
	@ResponseBody
	public String findAlarmRiskStatData() {
		// 查询汇总统计数据
		List<DcaARStatForPowerEntity> totalList = Lists.newArrayList();

		// 纪检监察室
		String DISR = "";
		List<Dict> dictList = DictUtils.getDictList("discipline_depart");
		if (dictList != null && dictList.get(0) != null) {
			DISR = dictList.get(0).getValue();
		}
		User curUser = UserUtils.getUser();
		// 当前用户的部门id
		String userOfficeId = curUser.getOffice().getId();

		// 判断是否是纪律检查室人员 Login User的部门=[纪检监察室]
		if (DISR.equals(userOfficeId)) {
			DcaAlarmDetail dcaAlarmDetail = new DcaAlarmDetail();
			dcaAlarmDetail.setVisualScope(userOfficeId);
			// 设置查询的业务类型
			dcaAlarmDetail.setIdxDataType(idxDataType);

			// 获取统计数据
			totalList = dcaAlarmDetailService.findARStatDataForPower(dcaAlarmDetail);
		}

		// 查询平台告警统计数据
		return JsonMapper.nonDefaultMapper().toJson(totalList);
	}

}