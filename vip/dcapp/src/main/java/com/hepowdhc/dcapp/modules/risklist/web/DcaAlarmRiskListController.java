/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.risklist.web;

import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.risklist.entity.DcaAlarmRiskList;
import com.hepowdhc.dcapp.modules.risklist.service.DcaAlarmRiskListService;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflowTaskContent;
import com.hepowdhc.dcapp.modules.workflow.service.DcaWorkflowTaskContentService;
import com.thinkgem.jeesite.common.beanvalidator.BeanValidators;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.IdGen;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.utils.excel.ImportExcel;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 风险清单管理Controller
 * 
 * @author shiqiang.zhang
 * @version 2016-11-08
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaAlarmRiskList")
public class DcaAlarmRiskListController extends BaseController {

	@Autowired
	private DcaAlarmRiskListService dcaAlarmRiskListService;
	@Autowired
	private DcaWorkflowTaskContentService dcaWorkflowTaskContentService;

	@ModelAttribute
	public DcaAlarmRiskList get(@RequestParam(required = false) String id) {
		DcaAlarmRiskList entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = dcaAlarmRiskListService.get(id);
		}
		if (entity == null) {
			entity = new DcaAlarmRiskList();
		}
		return entity;
	}

	@RequiresPermissions("dca:dcaAlarmRiskList:view")
	@RequestMapping(value = { "list", "" })
	public String list(DcaAlarmRiskList dcaAlarmRiskList, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<DcaAlarmRiskList> page = dcaAlarmRiskListService.findPage(new Page<DcaAlarmRiskList>(request, response),
				dcaAlarmRiskList);
		model.addAttribute("page", page);
		return "modules/dca/dcaAlarmRiskListList";
	}

	@RequiresPermissions("dca:dcaAlarmRiskList:view")
	@RequestMapping(value = "form")
	public String form(DcaAlarmRiskList dcaAlarmRiskList, Model model) {
		if (!StringUtils.isBlank(dcaAlarmRiskList.getId())) {
			// 判断是否关联了工作流
			DcaWorkflowTaskContent content = new DcaWorkflowTaskContent();
			content.setRiskId(dcaAlarmRiskList.getRiskId());
			List<DcaWorkflowTaskContent> list = dcaWorkflowTaskContentService.findList(content);
			if (list != null && !list.isEmpty()) {
				dcaAlarmRiskList.setWorkFlowFlag("true");
			}
		}
		model.addAttribute("dcaAlarmRiskList", dcaAlarmRiskList);
		return "modules/dca/dcaAlarmRiskListForm";
	}

	/**
	 * 保存
	 * 
	 * @param dcaAlarmRiskList
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("dca:dcaAlarmRiskList:edit")
	@RequestMapping(value = "save")
	public String save(DcaAlarmRiskList dcaAlarmRiskList, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, dcaAlarmRiskList)) {
			return form(dcaAlarmRiskList, model);
		}

		if (dcaAlarmRiskList.getRiskName() != null
				&& dcaAlarmRiskList.getRiskName().equals(dcaAlarmRiskList.getOldRiskName())) {
			dcaAlarmRiskListService.save(dcaAlarmRiskList);
			addMessage(redirectAttributes, "保存风险清单成功");
		} else if (dcaAlarmRiskList.getRiskName() != null) {
			// 判断风险名称是否唯一
			DcaAlarmRiskList dca = dcaAlarmRiskListService.getByName(dcaAlarmRiskList.getRiskName(),
					dcaAlarmRiskList.getPowerId());
			if (dca == null) {
				dcaAlarmRiskListService.save(dcaAlarmRiskList);
				addMessage(redirectAttributes, "保存风险清单成功");
			}
		} else {
			addMessage(redirectAttributes, "保存风险清单失败:风险名称不能重复!");
		}
		return "redirect:" + Global.getAdminPath() + "/dca/dcaAlarmRiskList/?repage";
	}

	/**
	 * 删除风险清单数据 (注意：已关联了工作流的风险，不可删除！)
	 * 
	 * @param dcaAlarmRiskList
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("dca:dcaAlarmRiskList:edit")
	@RequestMapping(value = "delete")
	public String delete(DcaAlarmRiskList dcaAlarmRiskList, RedirectAttributes redirectAttributes) {
		// 判断是否关联了工作流
		DcaWorkflowTaskContent content = new DcaWorkflowTaskContent();
		content.setRiskId(dcaAlarmRiskList.getRiskId());
		List<DcaWorkflowTaskContent> list = dcaWorkflowTaskContentService.findList(content);
		if (list != null && !list.isEmpty()) {
			addMessage(redirectAttributes, "当前业务角色已关联工作流，不可进行删除操作！");
		} else {
			dcaAlarmRiskListService.delete(dcaAlarmRiskList);
			addMessage(redirectAttributes, "删除风险清单成功");
		}
		return "redirect:" + Global.getAdminPath() + "/dca/dcaAlarmRiskList/?repage";
	}

	/**
	 * 校验[风险名称]是否存在
	 * 
	 * @param riskName
	 * @param oldName
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "checkName")
	public String checkName(String riskName, String oldName, String powerId) {

		if (StringUtils.isNotEmpty(powerId)) {
			if (riskName.trim() != null && riskName.trim().equals(oldName.trim())) {
				return "true";
			} else if (riskName.trim() != null) {
				DcaAlarmRiskList dca = dcaAlarmRiskListService.getByName(riskName.trim(), powerId);
				if (dca == null) {
					return "true";
				}
			}
		}

		return "false";
	}

	/**
	 * 下载风险清单模板
	 * 
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("dca:dcaAlarmRiskList:edit")
	@RequestMapping(value = "import/template")
	public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String path = System.getProperty("user.dir");
			// InputStream inStream = new FileInputStream(path + "/src/main/resources/template/List_of_risks.xlsx");//
			// 文件的存放路径
			InputStream inStream = new FileInputStream(
					path + "/webapps/ROOT/WEB-INF/classes/template/List_of_risks.xlsx");// 文件的存放路径

			// 设置输出的格式
			response.reset();
			response.setContentType("bin");
			response.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode("风险清单.xlsx", "UTF-8"));
			// 循环取出流中的数据
			byte[] b = new byte[100];
			int len;
			while ((len = inStream.read(b)) > 0)
				response.getOutputStream().write(b, 0, len);
			inStream.close();
			return null;

			// String fileName = "风险清单模板.xlsx";
			// new ExportExcel("风险清单", DcaAlarmRiskList.class, 2).write(response, fileName).dispose();
			// return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/dca/dcaAlarmRiskList?repage";
	}

	/**
	 * 导入风险清单数据
	 * 
	 * @param file
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("dca:dcaAlarmRiskList:edit")
	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/dca/dcaAlarmRiskList?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 2, 0);
			List<DcaAlarmRiskList> list = ei.getDataList(DcaAlarmRiskList.class);
			for (DcaAlarmRiskList dcaAlarmRiskList : list) {
				try {
					// 判断导入数据的每一项是否为空,如果都为空，则跳过；如果有为空项，则记为失败。
					if (dcaAlarmRiskList.getRiskName().isEmpty() && dcaAlarmRiskList.getPowerId().isEmpty()
							&& dcaAlarmRiskList.getRiskLevel().isEmpty() && dcaAlarmRiskList.getRiskContent().isEmpty()
							&& dcaAlarmRiskList.getRiskTask().isEmpty() && dcaAlarmRiskList.getMeasure().isEmpty()) {
						continue;
					} else if (dcaAlarmRiskList.getRiskName().isEmpty() || dcaAlarmRiskList.getPowerId().isEmpty()
							|| dcaAlarmRiskList.getRiskLevel().isEmpty() || dcaAlarmRiskList.getRiskContent().isEmpty()
							|| dcaAlarmRiskList.getRiskTask().isEmpty() || dcaAlarmRiskList.getMeasure().isEmpty()) {
						failureMsg.append("<br/>风险环节 " + dcaAlarmRiskList.getRiskTask() + " 导入失败：数据项不可为空！");
						failureNum++;
					} else {
						// 判断风险名称是否存在
						DcaAlarmRiskList dca = dcaAlarmRiskListService.getByName(dcaAlarmRiskList.getRiskName(),
								dcaAlarmRiskList.getPowerId());
						if (dca != null) {
							failureMsg.append("<br/>风险环节 " + dcaAlarmRiskList.getRiskTask() + " 导入失败：风险名称已存在！");
							failureNum++;
						} else {
							// 截取权力id
							if (dcaAlarmRiskList.getPowerId().length() >= 4) {
								String powerId = dcaAlarmRiskList.getPowerId().substring(0, 4);
								dcaAlarmRiskList.setPowerId(powerId);
							}
							String riskLevel = dcaAlarmRiskList.getRiskLevel();
							if ("高".equals(riskLevel)) {
								dcaAlarmRiskList.setRiskLevel(Constant.RISK_LEVEL_10);
							} else if ("中".equals(riskLevel)) {
								dcaAlarmRiskList.setRiskLevel(Constant.RISK_LEVEL_20);
							} else if ("低".equals(riskLevel)) {
								dcaAlarmRiskList.setRiskLevel(Constant.RISK_LEVEL_30);
							}
							BeanValidators.validateWithException(validator, dcaAlarmRiskList);
							dcaAlarmRiskList.setRiskId(IdGen.uuid());
							dcaAlarmRiskList.setCreatePerson(UserUtils.getUser().getId());
							dcaAlarmRiskList.setUpdatePerson(UserUtils.getUser().getId());
							dcaAlarmRiskListService.save(dcaAlarmRiskList);
							successNum++;
						}
					}
				} catch (ConstraintViolationException ex) {
					failureMsg.append("<br/>风险环节 " + dcaAlarmRiskList.getRiskTask() + " 导入失败：");
					List<String> messageList = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>风险环节 " + dcaAlarmRiskList.getRiskTask() + ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条数据，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条数据" + failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/dca/dcaAlarmRiskList?repage";
	}

}