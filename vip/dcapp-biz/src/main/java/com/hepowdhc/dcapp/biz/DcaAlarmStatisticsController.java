/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.biz;

import com.hepowdhc.dcapp.modules.alarm.entity.DcaAlarmDetail;
import com.hepowdhc.dcapp.modules.alarm.service.DcaAlarmDetailService;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmStatEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmStatTotalEntity;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.utils.DateUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.entity.DcaTraceUserRole;
import com.thinkgem.jeesite.modules.sys.entity.Office;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import org.apache.commons.lang3.StringUtils;
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
 * 告警统计报表Controller
 * 
 * @author geshuo
 * @date 2016年12月7日
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaAlarmStatistics")
public class DcaAlarmStatisticsController extends BaseController {

	@Autowired
	private DcaAlarmDetailService dcaAlarmDetailService;
	// 当前查询的业务类型
	private String idxDataType;

	/**
	 * 告警统计报表
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @author geshuo
	 * @date 2016年12月8日
	 */
	@RequiresPermissions("dca:dcaAlarmReport:view")
	@RequestMapping(value = { "alarmReport", "" })
	public String list(HttpServletRequest request, HttpServletResponse response, Model model) {
		idxDataType = (String) request.getSession().getAttribute("tabType");
		return "modules/dca/dcaReportAlarmStat";
	}

	/**
	 * 告警统计
	 * 
	 * @return
	 * @author geshuo
	 * @date 2016年12月8日
	 */
	@RequestMapping(value = "findAlarmStatData")
	@ResponseBody
	public String findAlarmStatData(DcaAlarmDetail dcaAlarmDetail) {
		DcaAlarmStatTotalEntity result = new DcaAlarmStatTotalEntity();

		// 登录人的岗位包含在“可视范围”内
		List<DcaTraceUserRole> postList = UserUtils.getUser().getPostList();
		dcaAlarmDetail.setPostList(postList);

		// 设置查询的业务类型
		dcaAlarmDetail.setIdxDataType(idxDataType);

		// 查询统计数据
		List<DcaAlarmStatEntity> alarmList = dcaAlarmDetailService.findAlarmStatData(dcaAlarmDetail);
		result.setAlarmList(alarmList);

		List<Integer> yearList = dcaAlarmDetailService.findAlarmYear(dcaAlarmDetail);
		int nowYear = Integer.parseInt(DateUtils.getYear());
		if (yearList == null || yearList.size() == 0 || (yearList.size() > 0 && yearList.get(0) != nowYear)) {
			// 年份为空||今年无数据
			if (checkSelectNull(dcaAlarmDetail.getBizOperPerson())
					&& checkSelectNull(dcaAlarmDetail.getBizOperPost())) {
				// 没有选择 操作人 部门
				yearList.add(0, nowYear);
			}
		}
		result.setYearList(yearList);// 年份列表

		List<User> operList = dcaAlarmDetailService.findOperPerson(dcaAlarmDetail);
		result.setOperList(operList);// 操作人列表

		List<Office> officeList = dcaAlarmDetailService.findOperOffice(dcaAlarmDetail);
		result.setOfficeList(officeList);// 操作人所属部门列表

		return JsonMapper.nonDefaultMapper().toJson(result);
	}

	/**
	 * 校验 是否选中 有效值
	 * 
	 * @param value
	 * @return
	 * @author geshuo
	 * @date 2016年12月9日
	 */
	private boolean checkSelectNull(String value) {
		return StringUtils.isEmpty(value) || ("-999").equals(value);
	}

}