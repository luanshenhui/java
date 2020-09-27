/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.system.web;

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

import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.hepowdhc.dcapp.modules.system.entity.SysDictCustom;
import com.hepowdhc.dcapp.modules.system.service.SysDictCustomService;

/**
 * 定制字典表Controller
 * @author dhc
 * @version 2017-01-09
 */
@Controller
@RequestMapping(value = "${adminPath}/system/sysDictCustom")
public class SysDictCustomController extends BaseController {

	@Autowired
	private SysDictCustomService sysDictCustomService;
	
	@ModelAttribute
	public SysDictCustom get(@RequestParam(required=false) String id) {
		SysDictCustom entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = sysDictCustomService.get(id);
		}
		if (entity == null){
			entity = new SysDictCustom();
		}
		return entity;
	}
	
	@RequiresPermissions("system:sysDictCustom:view")
	@RequestMapping(value = {"list", ""})
	public String list(SysDictCustom sysDictCustom, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<SysDictCustom> page = sysDictCustomService.findPage(new Page<SysDictCustom>(request, response), sysDictCustom); 
		model.addAttribute("page", page);
		return "modules/system/sysDictCustomList";
	}

	@RequiresPermissions("system:sysDictCustom:view")
	@RequestMapping(value = "form")
	public String form(SysDictCustom sysDictCustom, Model model) {
		model.addAttribute("sysDictCustom", sysDictCustom);
		return "modules/system/sysDictCustomForm";
	}

	@RequiresPermissions("system:sysDictCustom:edit")
	@RequestMapping(value = "save")
	public String save(SysDictCustom sysDictCustom, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sysDictCustom)){
			return form(sysDictCustom, model);
		}
		sysDictCustomService.save(sysDictCustom);
		addMessage(redirectAttributes, "保存定制字典表成功");
		return "redirect:"+Global.getAdminPath()+"/system/sysDictCustom/?repage";
	}
	
	@RequiresPermissions("system:sysDictCustom:edit")
	@RequestMapping(value = "delete")
	public String delete(SysDictCustom sysDictCustom, RedirectAttributes redirectAttributes) {
		sysDictCustomService.delete(sysDictCustom);
		addMessage(redirectAttributes, "删除定制字典表成功");
		return "redirect:"+Global.getAdminPath()+"/system/sysDictCustom/?repage";
	}

}