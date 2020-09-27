/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */

package com.hepowdhc.dcapp.modules.visualization.web;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hepowdhc.dcapp.modules.visualization.entity.DcaReportAlarmMsg;
import com.hepowdhc.dcapp.modules.alarm.service.DcaAlarmDetailService;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.DateUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.entity.DcaTraceUserRole;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 告警信息表Controller
 * 
 * @author HuNan
 * @version 2016-11-08
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaReportAlarmMsg")
public class DcaReportAlarmMsgController extends BaseController {

	@Autowired
	private DcaAlarmDetailService dcaAlarmDetailService;

	@RequiresPermissions("dca:dcaReportAlarmMsg:view")	
	@RequestMapping(value = { "list", "" })
	public String list(DcaReportAlarmMsg dcaReportAlarmMsg, HttpServletRequest request, HttpServletResponse response,
			Model model) {
	
		// 登陆者所在岗位
		List<DcaTraceUserRole> postList = new ArrayList<DcaTraceUserRole>();
		
		User curUser = UserUtils.getUser();
		if (curUser != null) {
			postList = curUser.getPostList();
		}
		
		// 登录人的岗位包含在“可视范围”内
		dcaReportAlarmMsg.setPostList(postList);
		
		Page<DcaReportAlarmMsg> page = dcaAlarmDetailService.findAlarmMsgTable(new Page<DcaReportAlarmMsg>(request, response),
				dcaReportAlarmMsg);
		
		model.addAttribute("page", page);
		String dateSys = DateUtils.getYear() + "年" + DateUtils.getMonth() + "月" + DateUtils.getDay() + "日";
		model.addAttribute("dateSys", dateSys);
		
		return "modules/dca/dcaReportAlarmMsg";
	}

}