/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.riskmanage.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaRiskManage;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaRiskManageLog;
import com.hepowdhc.dcapp.modules.riskmanage.service.DcaRiskManageLogService;
import com.hepowdhc.dcapp.modules.riskmanage.service.DcaRiskManageService;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.DateUtils;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.entity.DcaTraceUserRole;
import com.thinkgem.jeesite.modules.sys.entity.Dict;
import com.thinkgem.jeesite.modules.sys.entity.Office;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.service.DcaTraceUserRoleService;
import com.thinkgem.jeesite.modules.sys.service.OfficeService;
import com.thinkgem.jeesite.modules.sys.service.SystemService;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 风险管理Controller
 * 
 * @author zhengwei.cui
 * @version 2016-11-16
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaRiskManage")
public class DcaRiskManageController extends BaseController {

	@Autowired
	private DcaRiskManageService dcaRiskManageService;
	@Autowired
	private DcaRiskManageLogService dcaRiskManageLogService;
	@Autowired
	private SystemService systemService;
	@Autowired
	private OfficeService officeService;
	@Autowired
	private DcaTraceUserRoleService dcaTraceUserRoleService;

	@ModelAttribute
	public DcaRiskManage get(@RequestParam(required = false) String id) {
		DcaRiskManage entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = dcaRiskManageService.get(id);
		}
		if (entity == null) {
			entity = new DcaRiskManage();
		}
		return entity;
	}

	/**
	 * 查询页面列表
	 * 
	 * @param dcaRiskManage
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("dca:dcaRiskManage:view")
	@RequestMapping(value = { "list", "" })
	public String list(DcaRiskManage dcaRiskManage, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		// 纪检监察室
		String discipline = "";
		List<Dict> dictList = DictUtils.getDictList("discipline_depart");
		if (CollectionUtils.isNotEmpty(dictList)) {
			discipline = dictList.get(0).getValue();
		}
		Page<DcaRiskManage> page = new Page<DcaRiskManage>();
		User curUser = UserUtils.getUser();
		// 当前用户的部门id
		String userOfficeId = curUser.getOffice().getId();
		// 获取部门领导id
		String TOPLEADER = "";
		Office office = officeService.get(userOfficeId);
		if (office != null && office.getPrimaryPerson() != null) {
			TOPLEADER = office.getPrimaryPerson().getId();
		}
		// 获取当前用的岗位
		String postId = "";
		if (CollectionUtils.isNotEmpty(curUser.getPostList())) {
			postId = curUser.getPostList().get(0).getRoleId();
		}
		// Login User的部门=[纪检监察室]
		if (StringUtils.isNotBlank(discipline) && discipline.equals(userOfficeId)) {
			// 当登录用户的部门为[纪检监察室]时，默认选中【未界定】状态，并查询
			if (StringUtils.isBlank(dcaRiskManage.getDefineStatus())) {
				dcaRiskManage.setDefineStatus(Constant.DEFINE_STATUS_3);
			}
			page = dcaRiskManageService.findPage(new Page<DcaRiskManage>(request, response), dcaRiskManage);
		} else { // 不是[纪检监察室]
			// 判断登录用户的岗位是否有下属人员
			if (!isHavaSub(postId)) { // 如果没有下属，则只查当前用户的信息
				dcaRiskManage.setBizOperPost(userOfficeId);
				dcaRiskManage.setBizOperPerson(curUser.getId());
				dcaRiskManage.setCurrentUser(curUser);// 用于查询风险转发表
			} else { // 如果有下属，则查整个部门数据
				dcaRiskManage.setBizOperPost(userOfficeId);
				// 当选择的操作人为当前用户时，给CurrentUser赋值，用于查询风险转发表
				if (curUser.getId().equals(dcaRiskManage.getBizOperPerson())) {
					dcaRiskManage.setCurrentUser(curUser);
				}
			}
			dcaRiskManage.setPostId(postId); // 岗位id
			page = dcaRiskManageService.findListByUser(new Page<DcaRiskManage>(request, response), dcaRiskManage);
		}
		model.addAttribute("page", page);

		DcaRiskManage dca = new DcaRiskManage();
		// 如果不是纪检监察室
		if (!discipline.equals(userOfficeId)) {
			// 获取登录用户的部门名称
			dca.setBizOperPostName(curUser.getOffice().getName());
			dca.setBizOperPost(userOfficeId);
			// 判断登录用户的岗位是否有下属人员，如果没有，将当前用户返回
			if (!isHavaSub(postId)) {
				dca.setBizOperPerson(curUser.getId());
				dca.setBizOperPersonName(curUser.getName());
			}
		}
		model.addAttribute("dca", dca);
		model.addAttribute("isDISR", discipline.equals(userOfficeId)); // 纪检监察室
		model.addAttribute("isLEADER", TOPLEADER.equals(curUser.getId())); // 最高领导

		return "modules/dca/dcaRiskManageList";
	}

	/**
	 * 跳转到风险转发页面
	 * 
	 * @param dcaRiskManage
	 * @param model
	 * @return
	 */
	@RequiresPermissions("dca:dcaRiskManage:view")
	@RequestMapping(value = "form")
	public String form(DcaRiskManage dcaRiskManage, Model model) {
		DcaRiskManage newDcaRiskManage = new DcaRiskManage();
		newDcaRiskManage.setRiskManageId(dcaRiskManage.getRiskManageId());
		newDcaRiskManage.setDefineStatus(dcaRiskManage.getDefineStatus());
		model.addAttribute("dcaRiskManage", newDcaRiskManage);
		return "modules/dca/dcaRiskManageTrans";
	}

	/**
	 * 查看风险详情
	 * 
	 * @param dcaRiskManage
	 * @param model
	 * @return
	 */
	@RequiresPermissions("dca:dcaRiskManage:view")
	@RequestMapping(value = "detail")
	public String detail(DcaRiskManage dcaRiskManage, Model model) {
		// 根据风险管理id查询对应的操作履历
		DcaRiskManageLog log = new DcaRiskManageLog();
		log.setRiskManageId(dcaRiskManage.getRiskManageId());
		List<DcaRiskManageLog> logList = dcaRiskManageLogService.findList(log);
		model.addAttribute("logList", logList);
		model.addAttribute("dcaRiskManage", dcaRiskManage);
		return "modules/dca/dcaRiskManageDetail";
	}

	/**
	 * 保存界定
	 * 
	 * @param dcaRiskManage
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("dca:dcaRiskManage:edit")
	@RequestMapping(value = "save")
	public String save(DcaRiskManage dcaRiskManage, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, dcaRiskManage)) {
			return form(dcaRiskManage, model);
		}
		dcaRiskManage.setDefinePerson(UserUtils.getUser().getName());
		dcaRiskManage.setDefineDate(DateUtils.getSystemDate());
		dcaRiskManageService.save(dcaRiskManage);
		addMessage(redirectAttributes, "界定成功");
		return "redirect:" + Global.getAdminPath() + "/dca/dcaRiskManage/?repage";
	}

	@RequiresPermissions("dca:dcaRiskManage:edit")
	@RequestMapping(value = "delete")
	public String delete(DcaRiskManage dcaRiskManage, RedirectAttributes redirectAttributes) {
		dcaRiskManageService.delete(dcaRiskManage);
		addMessage(redirectAttributes, "删除单表成功");
		return "redirect:" + Global.getAdminPath() + "/dca/dcaRiskManage/?repage";
	}

	/**
	 * 撤销界定
	 * 
	 * @param dcaRiskManage
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("dca:dcaRiskManage:edit")
	@RequestMapping(value = "recall")
	public String recall(DcaRiskManage dcaRiskManage, RedirectAttributes redirectAttributes) {
		dcaRiskManageService.recall(dcaRiskManage);
		addMessage(redirectAttributes, "该风险已撤销界定！如需要请再次界定。");
		return "redirect:" + Global.getAdminPath() + "/dca/dcaRiskManage/?repage";
	}

	/**
	 * 风险界定
	 * 
	 * @param dcaRiskManage
	 * @param model
	 * @return
	 */
	@RequiresPermissions("dca:dcaRiskManage:edit")
	@RequestMapping(value = "define")
	public String define(DcaRiskManage dcaRiskManage, Model model) {
		// 设置界定人
		dcaRiskManage.setDefinePerson(UserUtils.getUser().getName());
		model.addAttribute("dcaRiskManage", dcaRiskManage);
		// 根据风险管理id查询对应的操作履历
		DcaRiskManageLog log = new DcaRiskManageLog();
		log.setRiskManageId(dcaRiskManage.getRiskManageId());
		List<DcaRiskManageLog> logList = dcaRiskManageLogService.findList(log);

		model.addAttribute("logList", logList);

		return "modules/dca/dcaRiskManageDefine";
	}

	/**
	 * 根据officeId查询用户(部门下所有人员)
	 * 
	 * @param officeId
	 * @param model
	 * @return
	 */
	@RequiresPermissions("dca:dcaRiskManage:view")
	@RequestMapping(value = "findUserByOfficeId")
	@ResponseBody
	public String findUserByOfficeId(String officeId, Model model) {
		List<User> allUserList = Lists.newArrayList();
		Office office = new Office();
		office.setParentIds("%," + officeId + ",");
		List<Office> findList = officeService.findList(office);
		for (Office office2 : findList) {
			List<User> userList = systemService.findUserByOfficeId(office2.getId());
			for (User user : userList) {
				allUserList.add(user);
			}
		}
		List<User> userList = systemService.findUserByOfficeId(officeId);
		for (User user : userList) {
			allUserList.add(user);
		}
		return JsonMapper.nonDefaultMapper().toJson(allUserList);
	}

	/**
	 * 风险转发
	 * 
	 * @param dcaRiskManage
	 * @param model
	 * @return
	 */
	@RequiresPermissions("dca:dcaRiskManage:edit")
	@RequestMapping(value = "trans")
	public String trans(DcaRiskManage dcaRiskManage, RedirectAttributes redirectAttributes) {
		dcaRiskManageService.riskTrans(dcaRiskManage);
		addMessage(redirectAttributes, "风险转发成功！");
		return "redirect:" + Global.getAdminPath() + "/dca/dcaRiskManage/?repage";
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