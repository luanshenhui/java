/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.risklist.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hepowdhc.dcapp.modules.risklist.entity.DcaAlarmUpGrade;
import com.hepowdhc.dcapp.modules.risklist.entity.DcaPowerList;
import com.hepowdhc.dcapp.modules.risklist.service.DcaAlarmUpGradeService;
import com.hepowdhc.dcapp.modules.risklist.service.DcaPowerListService;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.web.BaseController;

/**
 * 告警上报管理Controller
 * @author dhc
 * @version 2016-11-15
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaAlarmUpGrade")
public class DcaAlarmUpGradeController extends BaseController {

	@Autowired
	private DcaAlarmUpGradeService dcaAlarmUpGradeService;
	@Autowired
	private DcaPowerListService dcaPowerListService;
	
	@ModelAttribute
	public DcaAlarmUpGrade get(@RequestParam(required=false) String id) {
		DcaAlarmUpGrade entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = dcaAlarmUpGradeService.get(id);
		}
		if (entity == null){
			entity = new DcaAlarmUpGrade();
		}
		return entity;
	}
	
	/**
	 * 获取数据列表
	 * @param dcaAlarmUpGrade
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("dca:dcaAlarmUpGrade:view")
	@RequestMapping(value = {"list", ""})
	public String list(DcaAlarmUpGrade dcaAlarmUpGrade, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<DcaAlarmUpGrade> page = dcaAlarmUpGradeService.getPage(new Page<DcaAlarmUpGrade>(request, response), dcaAlarmUpGrade);
		model.addAttribute("bizRoleIdSelected", dcaAlarmUpGrade.getBizRoleId());
		model.addAttribute("page", page);
		return "modules/dca/dcaAlarmUpGradeList";
	}

	/**
	 * 获取单条数据
	 * @param dcaAlarmUpGrade
	 * @param model
	 * @return
	 */
	@RequiresPermissions("dca:dcaAlarmUpGrade:view")
	@RequestMapping(value = "form")
	public String form(DcaAlarmUpGrade dcaAlarmUpGrade, Model model) {
		model.addAttribute("dcaAlarmUpGrade", dcaAlarmUpGrade);
		return "modules/dca/dcaAlarmUpGradeForm";
	}

	/**
	 * 保存数据（新建/修改）
	 * @param dcaAlarmUpGrade
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("dca:dcaAlarmUpGrade:edit")
	@RequestMapping(value = "save")
	public String save(DcaAlarmUpGrade dcaAlarmUpGrade, Model model, RedirectAttributes redirectAttributes) {
		String powerId= dcaAlarmUpGrade.getPowerId();
		if(StringUtils.isBlank(powerId)){
			addMessage(redirectAttributes, "权力不能为空");
			return "redirect:" + Global.getAdminPath() + "/dca/dcaAlarmUpGrade/form?repage";
			
		}
		String bizRoleId = dcaAlarmUpGrade.getBizRoleId();
		if(StringUtils.isBlank(bizRoleId)){
			addMessage(redirectAttributes, "业务角色不能为空");
			return "redirect:" + Global.getAdminPath() + "/dca/dcaAlarmUpGrade/form?repage";
		}
		String alarmLevel = dcaAlarmUpGrade.getAlarmLevel();
		if(StringUtils.isBlank(alarmLevel)){
			addMessage(redirectAttributes, "告警级别不能为空");
			return "redirect:" + Global.getAdminPath() + "/dca/dcaAlarmUpGrade/form?repage";
		}
		String sunOutTime = dcaAlarmUpGrade.getSumOutTime();
		if(StringUtils.isBlank(sunOutTime)){
			addMessage(redirectAttributes, "累计超期时间不能为空");
			return "redirect:" + Global.getAdminPath() + "/dca/dcaAlarmUpGrade/form?repage";
		}
		String gradeOrgPost = dcaAlarmUpGrade.getGradeOrgPost();
		if(StringUtils.isBlank(gradeOrgPost)){
			addMessage(redirectAttributes, "上报部门岗位不能为空");
			return "redirect:" + Global.getAdminPath() + "/dca/dcaAlarmUpGrade/form?repage";
		}
		
		if (!beanValidator(model, dcaAlarmUpGrade)){
			return form(dcaAlarmUpGrade, model);
		}
		dcaAlarmUpGradeService.save(dcaAlarmUpGrade);
		addMessage(redirectAttributes, "保存告警上报管理成功");
		return "redirect:"+Global.getAdminPath()+"/dca/dcaAlarmUpGrade/?repage";
	}
	
	/**
	 * 删除数据
	 * @param dcaAlarmUpGrade
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("dca:dcaAlarmUpGrade:edit")
	@RequestMapping(value = "delete")
	public String delete(DcaAlarmUpGrade dcaAlarmUpGrade, RedirectAttributes redirectAttributes) {
		dcaAlarmUpGradeService.delete(dcaAlarmUpGrade);
		addMessage(redirectAttributes, "删除告警上报管理成功");
		return "redirect:"+Global.getAdminPath()+"/dca/dcaAlarmUpGrade/?repage";
	}
	
	/**
	 * 通过权力Id获取相关角色列表
	 * @param dcaPowerList
	 * @return
	 */
	@RequiresPermissions("dca:dcaAlarmUpGrade:view")
	@RequestMapping(value = "getBizRoleByPowerId")
	@ResponseBody
	public String getBizRoleByPowerId(DcaPowerList dcaPowerList) {
		List<DcaPowerList> list = dcaPowerListService.getBizRoleByPowerId(dcaPowerList); 
		return JsonMapper.nonDefaultMapper().toJson(list);
	}
	
	/**
	 * 点击修改跳转页面
	 * @param dcaAlarmUpGrade
	 * @param model
	 * @return
	 */
	@RequiresPermissions("dca:dcaAlarmUpGrade:view")
	@RequestMapping(value = "modify")
	public String modify(DcaAlarmUpGrade dcaAlarmUpGrade, Model model) {
		
		DcaAlarmUpGrade result = new DcaAlarmUpGrade();
		if(dcaAlarmUpGrade != null){
			result = dcaAlarmUpGradeService.getDcaAlarmUpGradeForm(dcaAlarmUpGrade.getUuid());
		}
		
		model.addAttribute("dcaAlarmUpGrade", result);
		return "modules/dca/dcaAlarmUpGradeForm";
	}

}