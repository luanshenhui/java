/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.metadata.web;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.metadata.entity.DcaTopicLib;
import com.hepowdhc.dcapp.modules.metadata.service.DcaTopicLibService;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 主题库管理Controller
 * 
 * @author lby
 * @version 2016-11-07
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaTopicLib/")
public class DcaTopicLibController extends BaseController {

	@Autowired
	private DcaTopicLibService dcaTopicLibService;

	@ModelAttribute
	public DcaTopicLib get(@RequestParam(required = false) String id) {
		DcaTopicLib entity = null;

		if (StringUtils.isNotBlank(id)) {
			entity = dcaTopicLibService.get(id);
		}
		if (entity == null) {
			entity = new DcaTopicLib();
			entity.setIsShow(Constant.TOPICISSHOW_1);
		}
		return entity;
	}

	@RequiresPermissions("dca:dcaTopicLib:view")
	@RequestMapping(value = { "list", "" })
	public String list(DcaTopicLib dcaTopicLib, HttpServletRequest request, HttpServletResponse response, Model model) {

		Page<DcaTopicLib> page = dcaTopicLibService.findPage(new Page<DcaTopicLib>(request, response), dcaTopicLib);
		model.addAttribute("page", page);

		return "modules/dca/dcaTopicLibList";
	}

	/**
	 * 查询主题库下包含的物理表
	 *
	 * @param dcaTopicLib
	 * @param request
	 * @param response
	 * @param model
     * @return
     */
	@RequiresPermissions("dca:dcaTopicLib:view")
	@RequestMapping(value = { "topicLibDetail"})
	public String topicLibDetail(DcaTopicLib dcaTopicLib, HttpServletRequest request, HttpServletResponse response, Model model) {

		Page<DcaTopicLib> page = dcaTopicLibService.findTopicPhysicsByTopicId(new Page<DcaTopicLib>(request, response), dcaTopicLib);
		model.addAttribute("page", page);

		return "modules/dca/dcaTopicLibDetailList";
	}

	@RequiresPermissions("dca:dcaTopicLib:view")
	@RequestMapping(value = "form")
	public String form(DcaTopicLib dcaTopicLib, Model model) {
		model.addAttribute("dcaTopicLib", dcaTopicLib);
		return "modules/dca/dcaTopicLibForm";
	}

	@RequiresPermissions("dca:dcaTopicLib:edit")
	@RequestMapping(value = "save")
	public String save(DcaTopicLib dcaTopicLib, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, dcaTopicLib)) {
			return form(dcaTopicLib, model);
		}
		if (UserUtils.getUser() != null) {
			dcaTopicLib.setCreatePerson(UserUtils.getUser().getId());
			dcaTopicLib.setUpdatePerson(UserUtils.getUser().getId());
		}
		Pattern pt = Pattern.compile("[0-9a-zA-Z_\u4e00-\u9fa5]*");
		Matcher mt = pt.matcher(dcaTopicLib.getTopicName());
		if (!mt.matches()) {
			addMessage(model, "主题库名称只能包括中文字、英文字母、数字和下划线");
			return "modules/dca/dcaTopicLibForm";

		}
		dcaTopicLibService.save(dcaTopicLib);
		if (dcaTopicLib.getPageFlag() == Constant.TOPICLIB_SAVE_UNSUC) {
			addMessage(redirectAttributes, "当前输入的主题库名称已被使用，请输入其他的主题库名称。");
		} else if (dcaTopicLib.getPageFlag() == Constant.TOPICLIB_SAVE_SUC) {
			addMessage(redirectAttributes, "保存主题库管理成功!");
		}

		return "redirect:" + Global.getAdminPath() + "/dca/dcaTopicLib/?repage";
	}

	@RequiresPermissions("dca:dcaTopicLib:edit")
	@RequestMapping(value = "delete")
	public String delete(DcaTopicLib dcaTopicLib, RedirectAttributes redirectAttributes) {
		dcaTopicLibService.delete(dcaTopicLib);
		if (dcaTopicLib.getPageFlag() == Constant.TOPICLIB_DEL_SUC) {
			addMessage(redirectAttributes, "删除主题库管理成功!");
		} else if (dcaTopicLib.getPageFlag() == Constant.TOPICLIB_DEL_UNSUC) {
			addMessage(redirectAttributes, "当前主题已关联物理表，不可进行删除操作！");
		}

		return "redirect:" + Global.getAdminPath() + "/dca/dcaTopicLib/?repage";
	}

	/**
	 * 关联物理表里 查询物理表中文名getSearchResult 所有的方法注释
	 * 
	 * @param dcaTopicLib
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("dca:dcaTopicPhysics:view")
	@RequestMapping(value = "getSearchResult")
	public String getSearchResult(DcaTopicLib dcaTopicLib, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		// DcaTopicLib toSaveRef=dcaTopicLib;
		Page<DcaTopicLib> page = dcaTopicLibService.getPhy(new Page<DcaTopicLib>(request, response), dcaTopicLib);

		model.addAttribute("page", page);
		model.addAttribute("dlist", dcaTopicLib.getDelList());
		model.addAttribute("slist", dcaTopicLib.getSaveList());

		return "modules/dca/dcaTopicRefPhysicsListRef";
	}

	/**
	 * 跳转物理表关联
	 * 
	 * @param dcaTopicLib
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("dca:dcaTopicLib:edit")
	@RequestMapping(value = "showRef")
	public String showRef(DcaTopicLib dcaTopicLib, HttpServletRequest request, HttpServletResponse response,
			Model model, RedirectAttributes redirectAttributes) {

		// 此主题库状态为启用
		Page<DcaTopicLib> page = dcaTopicLibService.getPhy(new Page<DcaTopicLib>(request, response), dcaTopicLib);

		model.addAttribute("page", page);

		return "modules/dca/dcaTopicRefPhysicsListRef";

	}

	/**
	 * 保存物理表关联
	 * 
	 * @param dcaTopicLib
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("dca:dcaTopicLib:edit")
	@RequestMapping(value = "setPhyRef")
	public String setPhyRef(DcaTopicLib dcaTopicLib, Model model, RedirectAttributes redirectAttributes) {

		if (!beanValidator(model, dcaTopicLib)) {
			return form(dcaTopicLib, model);
		}
		if (UserUtils.getUser() != null) {
			dcaTopicLib.setCreatePerson(UserUtils.getUser().getId());
			dcaTopicLib.setUpdatePerson(UserUtils.getUser().getId());
		}
		if (StringUtils.equals(Constant.REF_CHANGE_0, dcaTopicLib.getChangeFlag())) {
			// 可进行保存
			dcaTopicLibService.setPhyRef(dcaTopicLib);
			addMessage(redirectAttributes, "保存关联物理表成功!");
			return "redirect:" + Global.getAdminPath() + "/dca/dcaTopicLib/?repage";
		} else {
			// 无可保存操作
			addMessage(redirectAttributes, "请选择物理表后，进行保存。");

			return "redirect:" + Global.getAdminPath() + "/dca/dcaTopicLib/showRef?id=" + dcaTopicLib.getId();
		}

	}

	/**
	 * 验证主题库名称是否已经存在
	 * 
	 * @param oldTopicName
	 * @param topicName
	 * @return
	 */
	@ResponseBody
	@RequiresPermissions("dca:dcaTopicLib:edit")
	@RequestMapping(value = "checkTopicName")
	public String checkLoginName(String oldTopicName, String topicName) {
		if (topicName != null && topicName.equals(oldTopicName)) {
			return "true";
		} else if (topicName != null && dcaTopicLibService.getDcaTopicLibBytopicName(topicName) == null) {
			return "true";
		}
		return "false";
	}

	/**
	 * 判断该主题库的状态
	 *
	 * @param dcaTopicLib
	 * @param request
	 * @param response
	 * @param model
     * @return
     */
	@RequiresPermissions("dca:dcaTopicLib:edit")
	@RequestMapping(value = "checkTopicLibStatus")
	@ResponseBody
	public String checkTopicLibStatus(DcaTopicLib dcaTopicLib, HttpServletRequest request, HttpServletResponse response,
			Model model) {

		String id = request.getParameter("id");
		dcaTopicLib.setId(id);
		// 返回的标志位
		String tag = "";

		// 获取当前主题库的状态
		String status = dcaTopicLibService.getTopicLib(dcaTopicLib);

		if (StringUtils.equals(status, Constant.TOPICISSHOW_1)) {
			tag = "启用";
		} else if (StringUtils.equals(status, Constant.TOPICISSHOW_0)) {
			tag = "停用";
		} else {
			tag = "删除";
		}
		return tag;
	}
}
