/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.web;

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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflow;
import com.hepowdhc.dcapp.modules.workflow.entity.Dict;
import com.hepowdhc.dcapp.modules.workflow.service.DcaWorkflowService;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.IdGen;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;

/**
 * 工作流管理Controller
 * 
 * @author shiqiang.zhang
 * @version 2016-11-21
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaWorkflow")
public class DcaWorkflowController extends BaseController {

	@Autowired
	private DcaWorkflowService dcaWorkflowService;

	@ModelAttribute
	public DcaWorkflow get(@RequestParam(required = false) String id) {
		DcaWorkflow entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = dcaWorkflowService.get(id);
		}
		if (entity == null) {
			entity = new DcaWorkflow();
		}
		return entity;
	}

	@RequiresPermissions("workflow:dcaWorkflow:view")
	@RequestMapping(value = { "list", "" })
	public String list(DcaWorkflow dcaWorkflow, HttpServletRequest request, HttpServletResponse response, Model model) {
		// 初始化页面显示列表
		Page<DcaWorkflow> page = dcaWorkflowService.findPage(new Page<DcaWorkflow>(request, response), dcaWorkflow);
		String enable = dcaWorkflow.getEditEnable();
		if (StringUtils.isNotBlank(enable)) {
			model.addAttribute("editEnable", enable);
		}
		model.addAttribute("page", page);
		return "modules/dca/dcaWorkflowList";
	}

	@RequiresPermissions("workflow:dcaWorkflow:view")
	@RequestMapping(value = "form")
	public String form(DcaWorkflow dcaWorkflow, Model model, RedirectAttributes redirectAttributes,
			HttpServletRequest request, HttpServletResponse response) {
		// 编辑操作
		model.addAttribute("dcaWorkflow", dcaWorkflow);
		return "modules/dca/dcaWorkflowForm";

	}

	@RequiresPermissions("workflow:dcaWorkflow:edit")
	@RequestMapping(value = "save")
	public String save(DcaWorkflow dcaWorkflow, Model model, RedirectAttributes redirectAttributes,
			HttpServletRequest request, HttpServletResponse response) {

		if (!beanValidator(model, dcaWorkflow)) {
			return form(dcaWorkflow, model, redirectAttributes, request, response);
		}

		// 后台校验是否得到完整数据
		if (StringUtils.isEmpty(dcaWorkflow.getWfName()) || StringUtils.isEmpty(dcaWorkflow.getPowerId())
				|| StringUtils.isEmpty(dcaWorkflow.getWfLevel()) || StringUtils.isEmpty(dcaWorkflow.getIdxDataType())) {
			addMessage(redirectAttributes, "未获得完整数据信息！");
		} else {
			// 新建工作流时没有wfid和json
			if (StringUtils.isBlank(dcaWorkflow.getWfId())) {
				if (dcaWorkflowService.checkWfName(dcaWorkflow.getWfName()) != null) {
					addMessage(redirectAttributes, "工作流名称已存在");
					return "redirect:" + Global.getAdminPath() + "/dca/dcaWorkflow/?repage";
				}
				String json = "{\"flowId\":\"" + IdGen.uuid() + "\",\"title\":\"" + dcaWorkflow.getWfName()
						+ "\",\"nodes\":{}}";
				dcaWorkflow.setWfId(IdGen.uuid());
				dcaWorkflow.setXmlContent(json);
				dcaWorkflow.setIsShow("0");
			}
			dcaWorkflowService.save(dcaWorkflow);
			addMessage(redirectAttributes, "保存工作流管理成功");
		}
		return "redirect:" + Global.getAdminPath() + "/dca/dcaWorkflow/?repage";
	}

	@RequiresPermissions("workflow:dcaWorkflow:edit")
	@RequestMapping(value = "delete")
	public String delete(DcaWorkflow dcaWorkflow, RedirectAttributes redirectAttributes) {
		// 删除
		// 校验
		if (StringUtils.isEmpty(dcaWorkflow.getWfId())) {
			addMessage(redirectAttributes, "未获得数据信息！");
		} else {
			dcaWorkflowService.updateWF(dcaWorkflow);
			addMessage(redirectAttributes, "删除工作流管理成功");
		}
		return "redirect:" + Global.getAdminPath() + "/dca/dcaWorkflow/?repage";

	}

	/**
	 * 跳转到流程设置页面
	 * 
	 * @param dcaWorkflow
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("workflow:dcaWorkflow:edit")
	@RequestMapping(value = "flow")
	public String flow(DcaWorkflow dcaWorkflow, RedirectAttributes redirectAttributes, Model model) {
		// 流程设置
		// 校验
		if (StringUtils.isEmpty(dcaWorkflow.getWfId())) {
			addMessage(redirectAttributes, "未获得数据信息！");
			return "redirect:" + Global.getAdminPath() + "/dca/dcaWorkflow/?repage";
		} else {
			model.addAttribute("wfId", dcaWorkflow.getWfId());
			return "modules/dca/dcaWorkflowSetting";

		}
	}

	@RequiresPermissions("workflow:dcaWorkflow:edit")
	@RequestMapping(value = "stopWorkFlow")
	public String stopWorkFlow(DcaWorkflow dcaWorkflow, RedirectAttributes redirectAttributes) {
		// 校验
		if (StringUtils.isEmpty(dcaWorkflow.getWfId())) {
			addMessage(redirectAttributes, "未获得数据信息！");
		} else {
			int flag = dcaWorkflowService.check(dcaWorkflow);
			if (flag != 0) {
				addMessage(redirectAttributes, "该工作流正加载到数据引擎中，不可停用。");
			} else {
				// 停止工作流
				dcaWorkflowService.stopWorkFlow(dcaWorkflow);
				addMessage(redirectAttributes, "停用成功。");
			}
		}
		return "redirect:" + Global.getAdminPath() + "/dca/dcaWorkflow/?repage";
	}

	@RequiresPermissions("workflow:dcaWorkflow:edit")
	@RequestMapping(value = "startWorkFlow")
	public String startWorkFlow(DcaWorkflow dcaWorkflow, RedirectAttributes redirectAttributes) {
		if (StringUtils.isEmpty(dcaWorkflow.getWfId())) {
			addMessage(redirectAttributes, "未获得数据信息！");
		} else {
			// 启动校验
			int flag = dcaWorkflowService.checkStartJson(dcaWorkflow, "");
			switch (flag) {
			case 0:
				addMessage(redirectAttributes, "没有工作流数据！");
				break;
			case 1:
				addMessage(redirectAttributes, "工作流定义时，有且只能有一个开始节点，请修改后重新保存！");
				break;
			case 2:
				addMessage(redirectAttributes, "工作流定义时，有且只能有一个结束节点，请修改后重新保存！");
				break;
			case 3:
				addMessage(redirectAttributes, "工作流定义时，开始节点和结束节点中至少有一个任务节点，请修改后重新保存！");
				break;
			case 4:
				addMessage(redirectAttributes, "工作流定义时，从开始节点开始的任务数有且只有一个，请修改后重新保存！");
				break;
			case 5:
				addMessage(redirectAttributes, "工作流定义时，以结束节点结束的任务数有且只有一个，请修改后重新保存！");
				break;
			case 6:
				addMessage(redirectAttributes, "工作流定义时，除去开始和结束节点，其他的任务节点均应该有来源和去向，请修改后重新保存！");
				break;
			case 7:
				addMessage(redirectAttributes, "工作流没有设置节点，请先设置后启动。");
				break;
			case 8:
				addMessage(redirectAttributes, "工作流没有设置连线，请先设置后启动。");
				break;
			case 9:
				addMessage(redirectAttributes, "存在非法数据，建议删除该工作流重新设置。");
				break;
			default:
				int flagOne = dcaWorkflowService.checkStartOne(dcaWorkflow);
				int flagTwo = dcaWorkflowService.checkStartTwo(dcaWorkflow);
				if (flagOne == 0) {
					addMessage(redirectAttributes, "该工作流未被设置约束条件，请设置后再“启用”该工作流。");
				} else if (flagTwo == 0) {
					addMessage(redirectAttributes, "该工作流未设置工作流节点或所有节点均被停用，不可启用。");
				} else {
					// 启动工作流
					dcaWorkflowService.startWorkFlow(dcaWorkflow);
					addMessage(redirectAttributes, "启动成功。");
				}
				break;
			}
		}

		return "redirect:" + Global.getAdminPath() + "/dca/dcaWorkflow/?repage";
	}

	@ResponseBody
	@RequiresPermissions("workflow:dcaWorkflow:edit")
	@RequestMapping(value = "checkWfName")
	public String checkWfName(String oldwfName, String wfName) {
		// 校验工作流名称是否重复
		if (wfName != null && wfName.equals(oldwfName)) {
			return "true";
		} else if (wfName != null && dcaWorkflowService.checkWfName(wfName) == null) {
			return "true";
		}
		return "false";
	}

	// 检索字典表，检索数据类型
	@ResponseBody
	@RequiresPermissions("workflow:dcaWorkflow:edit")
	@RequestMapping(value = "getDict")
	public List<Dict> getDict() {
		List<Dict> dict = dcaWorkflowService.searchDict();
		return dict;
	}

	@ResponseBody
	@RequiresPermissions("workflow:dcaWorkflow:edit")
	@RequestMapping(value = "universalCheck")
	public boolean universalCheck(DcaWorkflow dcaWorkflow) {
		// 编辑、删除、流程设置通用校验
		int flag = dcaWorkflowService.check(dcaWorkflow);
		if (flag != 0) {
			return false;
		} else {
			return true;
		}
	}
}