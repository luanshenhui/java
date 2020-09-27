/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.basicdata.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hepowdhc.dcapp.modules.basicdata.entity.DcaSysJobLog;
import com.hepowdhc.dcapp.modules.basicdata.service.DcaSysJobLogService;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;

/**
 * 数据加载页面
 * 
 * @author huidan.pang
 * @version 2016-11-07
 */

@Controller
@RequestMapping(value = "${adminPath}/dca/dcaSysJobLog")
public class DcaSysJobLogController extends BaseController {

	@Autowired
	private DcaSysJobLogService dcaSysJobLogService;

	@ModelAttribute
	public DcaSysJobLog get(@RequestParam(required = false) String id) {
		DcaSysJobLog entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = dcaSysJobLogService.get(id);
		}
		if (entity == null) {
			entity = new DcaSysJobLog();
		}
		return entity;
	}

	@RequiresPermissions("dca:dcaSysJobLog:view")
	@RequestMapping(value = { "list", "" })
	public String list(DcaSysJobLog dcaSysJobLog, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<DcaSysJobLog> page = dcaSysJobLogService.findPage(new Page<DcaSysJobLog>(request, response), dcaSysJobLog);
		model.addAttribute("page", page);
		return "modules/dca/dcaSysJobLogList";
	}

	@RequiresPermissions("dca:dcaSysJobLog:view")
	@RequestMapping(value = "form")
	public String form(DcaSysJobLog dcaSysJobLog, Model model) {
		model.addAttribute("dcaSysJobLog", dcaSysJobLog);
		return "modules/dca/dcaSysJobLogForm";
	}

	/**
	 * 保存
	 * 
	 * @param dcaSysJobLog
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("dca:dcaSysJobLog:edit")
	@RequestMapping(value = "save")
	public String save(DcaSysJobLog dcaSysJobLog, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, dcaSysJobLog)) {
			return form(dcaSysJobLog, model);
		}
		dcaSysJobLogService.save(dcaSysJobLog);
		addMessage(redirectAttributes, "保存dca_sys_job_log成功");
		return "redirect:" + Global.getAdminPath() + "/dca/dcaSysJobLog/?repage";
	}

	/**
	 * 查看日志链接
	 * 
	 * @param dcaSysJobLog
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("dca:dcaSysJobLog:view")
	@RequestMapping(value = "show")
	public String show(DcaSysJobLog dcaSysJobLog, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		model.addAttribute("dcaSysJobLog", dcaSysJobLog);

		return "modules/dca/dcaSysJobLogForm";
	}

	/**
	 * 查看详细链接
	 * 
	 * @param dcaSysJobLog
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */

	@RequiresPermissions("dca:dcaSysJobLog:view")
	@RequestMapping(value = "showdetial")
	public String showdetial(DcaSysJobLog dcaSysJobLog, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		if (!beanValidator(model, dcaSysJobLog)) {
			return form(dcaSysJobLog, model);
		}
		List<DcaSysJobLog> page = dcaSysJobLogService.showdetial(dcaSysJobLog);
		model.addAttribute("page", page);

		return "modules/dca/dcaSysJobLogFormdetial";
	}

	@RequiresPermissions("dca:dcaSysJobLog:edit")
	@RequestMapping(value = "delete")
	public String delete(DcaSysJobLog dcaSysJobLog, RedirectAttributes redirectAttributes) {
		dcaSysJobLogService.delete(dcaSysJobLog);
		addMessage(redirectAttributes, "删除dca_sys_job_log成功");
		return "redirect:" + Global.getAdminPath() + "/dca/dcaSysJobLog/?repage";
	}

}