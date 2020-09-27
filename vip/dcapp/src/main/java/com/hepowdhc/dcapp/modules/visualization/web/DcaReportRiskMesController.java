/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */

package com.hepowdhc.dcapp.modules.visualization.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hepowdhc.dcapp.modules.riskmanage.service.DcaRiskManageService;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaReportRiskMes;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.DateUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.entity.DcaTraceUserRole;
import com.thinkgem.jeesite.modules.sys.entity.Dict;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.service.DcaTraceUserRoleService;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 风险信息表Controller
 * 
 * @author Liuby
 * @version 2016-11-08
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaReportRiskMes")
public class DcaReportRiskMesController extends BaseController {
	@Autowired
	private DcaRiskManageService dcaReportRiskMesService;
	@Autowired
	private DcaTraceUserRoleService dcaTraceUserRoleService;

	@RequiresPermissions("dca:dcaReportRiskMes:view")
	@RequestMapping(value = { "list", "" })
	public String list(DcaReportRiskMes dcaReportRiskMes, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		// 纪检监察室
		String DISR = "";
		// 当前用户的部门id
		String userOfficeId = "";
		// 当前用户的id
		String userId = "";
		// 当前用户岗位id
		String postId = "";

		List<Dict> dictList = DictUtils.getDictList("discipline_depart");
		if (CollectionUtils.isNotEmpty(dictList)) {
			DISR = dictList.get(0).getValue();
		}

		Page<DcaReportRiskMes> page = new Page<DcaReportRiskMes>();
		// 当前登录人
		User curUser = UserUtils.getUser();
		userOfficeId = curUser.getOffice().getId();
		userId = curUser.getId();
		// 获取当前用的岗位
		if (CollectionUtils.isNotEmpty(curUser.getPostList())) {
			postId = curUser.getPostList().get(0).getRoleId();
		}

		// Login User的部门!=[纪检监察室]
		if (!StringUtils.equals(DISR, userOfficeId)) {
			// 判断岗位是否有下属
			if (isHavaSub(postId)) { // 有下属
				dcaReportRiskMes.setBizOperPost(userOfficeId);
			} else { // 没有下属
				dcaReportRiskMes.setBizOperPost(userOfficeId);
				dcaReportRiskMes.setBizOperPerson(userId);
				dcaReportRiskMes.setPostId(postId);
				dcaReportRiskMes.setCurrentUser(curUser);
			}
		}
		page = dcaReportRiskMesService.getRiskMes(new Page<DcaReportRiskMes>(request, response), dcaReportRiskMes);
		model.addAttribute("page", page);
		String todayDate = DateUtils.getYear() + "年" + DateUtils.getMonth() + "月" + DateUtils.getDay() + "日";
		model.addAttribute("today", todayDate);
		return "modules/dca/dcaReportRiskMes";
	}

	/**
	 * 判断岗位下是否有下属人员
	 * 
	 * @param roleId
	 * @return
	 */
	private boolean isHavaSub(String postId) {
		if (StringUtils.isNotBlank(postId)) {
			List<DcaTraceUserRole> list = dcaTraceUserRoleService.findByParentId(postId);
			if (list != null && list.size() > 0) {
				return true;
			}
		}
		return false;
	}

}