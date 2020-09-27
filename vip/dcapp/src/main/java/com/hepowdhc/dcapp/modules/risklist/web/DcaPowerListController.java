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
import com.hepowdhc.dcapp.modules.risklist.entity.DcaPowerList;
import com.hepowdhc.dcapp.modules.risklist.service.DcaPowerListService;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflowTask;
import com.hepowdhc.dcapp.modules.workflow.service.DcaWorkflowTaskService;
import com.thinkgem.jeesite.common.beanvalidator.BeanValidators;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.IdGen;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.utils.excel.ImportExcel;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.entity.DcaTraceUserRole;
import com.thinkgem.jeesite.modules.sys.service.DcaTraceUserRoleService;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 单表查询Controller
 * 
 * @author liunan
 * @version 2016-11-07
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaPowerList")
public class DcaPowerListController extends BaseController {

	@Autowired
	private DcaPowerListService dcaPowerListService;

	@Autowired
	private DcaWorkflowTaskService dcaWorkflowTaskService;

	@Autowired
	private DcaTraceUserRoleService dcaTraceUserRoleService;

	@ModelAttribute
	public DcaPowerList get(@RequestParam(required = false) String id) {
		DcaPowerList entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = dcaPowerListService.get(id);
		}
		if (entity == null) {
			entity = new DcaPowerList();
		}
		return entity;
	}

	@RequiresPermissions("dca:dcaPowerList:view")
	@RequestMapping(value = { "list", "" })
	public String list(DcaPowerList dcaPowerList, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<DcaPowerList> page = dcaPowerListService.findPage(new Page<DcaPowerList>(request, response), dcaPowerList);
		for (DcaPowerList list : page.getList()) {
			// 获取上报岗位name
			String gradeOrgPostName = getGradeOrgPostName(list);
			list.setName(gradeOrgPostName);
		}
		model.addAttribute("page", page);
		return "modules/dca/dcaPowerListList";
	}

	@RequiresPermissions("dca:dcaPowerList:view")
	@RequestMapping(value = "form")
	public String form(DcaPowerList dcaPowerList, Model model) {
		// 修改时用powerId,bizRoleId查询在dca_workflow_task表是否可绑定(绑定：岗位信息只能添加不能减少，未绑定：能加能减)
		if (StringUtils.isNotEmpty(dcaPowerList.getPowerId()) && StringUtils.isNotEmpty(dcaPowerList.getUuid())) {
			DcaWorkflowTask dcaWorkflowTask = new DcaWorkflowTask();
			dcaWorkflowTask.setPowerId(dcaPowerList.getPowerId());
			dcaWorkflowTask.setBizRoleId(dcaPowerList.getUuid());
			// 工作流节点是启用状态
			dcaWorkflowTask.setIsShow(Constant.OPEN);
			List<DcaWorkflowTask> list = dcaWorkflowTaskService.findList(dcaWorkflowTask);
			if (list.size() > 0) {
				dcaPowerList.setFlag("0");
			}
		}

		// 获取上报岗位name
		String gradeOrgPostName = getGradeOrgPostName(dcaPowerList);
		dcaPowerList.setName(gradeOrgPostName);

		model.addAttribute("dcaPowerList", dcaPowerList);
		return "modules/dca/dcaPowerListForm";
	}

	@RequiresPermissions("dca:dcaPowerList:edit")
	@RequestMapping(value = "save")
	public String save(DcaPowerList dcaPowerList, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, dcaPowerList)) {
			return form(dcaPowerList, model);
		}

		// 新建权责清单时用 BizRoleName，PowerId，DelFlag判断当前建立的角色与权力是否存在
		if (StringUtils.isEmpty(dcaPowerList.getUuid())) {
			DcaPowerList content = new DcaPowerList();
			content.setBizRoleName(dcaPowerList.getBizRoleName());
			content.setPowerId(dcaPowerList.getPowerId());
			content.setDelFlag("0");
			List<DcaPowerList> list = dcaPowerListService.findList(content);
			if (list != null && !list.isEmpty()) {
				addMessage(redirectAttributes, "当前业务角色、权力已存在，不可进行添加操作！");
				return "redirect:" + Global.getAdminPath() + "/dca/dcaPowerList/form?repage";
			}
		}

		if (StringUtils.isEmpty(dcaPowerList.getUuid())) {
			dcaPowerList.setUuid(IdGen.uuid());
			dcaPowerList.setBizRoleId(IdGen.uuid());
			dcaPowerList.setCreatePerson(UserUtils.getUser().getId());
			// dcaPowerList.setCreateDate(new Date());
		}
		dcaPowerList.setUpdatePerson(UserUtils.getUser().getId());

		dcaPowerList.setPostId(dcaPowerList.getRemarks());
		dcaPowerListService.officeSave(dcaPowerList);
		addMessage(redirectAttributes, "保存权责清单成功");
		return "redirect:" + Global.getAdminPath() + "/dca/dcaPowerList/?repage";
	}

	@RequiresPermissions("dca:dcaPowerList:edit")
	@RequestMapping(value = "delete")
	public String delete(DcaPowerList dcaPowerList, RedirectAttributes redirectAttributes) {

		DcaWorkflowTask dcaWorkflowTask = new DcaWorkflowTask();
		dcaWorkflowTask.setPowerId(dcaPowerList.getPowerId());
		dcaWorkflowTask.setBizRoleId(dcaPowerList.getId());
		dcaWorkflowTask.setDelFlag("0");
		List<DcaWorkflowTask> list = dcaWorkflowTaskService.findList(dcaWorkflowTask);
		if (list != null && !list.isEmpty()) {
			addMessage(redirectAttributes, "当前业务角色已关联工作流，不可进行删除操作！");
		} else {
			dcaPowerList.setDelFlag("1");
			dcaPowerListService.delete(dcaPowerList);
			dcaPowerListService.officeDelete(dcaPowerList);
			addMessage(redirectAttributes, "删除权责清单成功");
		}
		return "redirect:" + Global.getAdminPath() + "/dca/dcaPowerList/?repage";
	}

	/**
	 * 下载导入用户数据模板
	 * 
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("dca:dcaPowerList:view")
	@RequestMapping(value = "import/template")
	public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			// 读到流中
			// String path=this.getClass().getClassLoader().getResource("").getPath().substring(1);
			String path = System.getProperty("user.dir");
			// InputStream inStream = getClass().getResourceAsStream("/template/权责清单.xlsx");

			// InputStream inStream = new FileInputStream(path + "/src/main/resources/template/List_of_powers.xlsx");//
			// 文件的存放路径
			// 文件的存放路径
			InputStream inStream = new FileInputStream(
					path + "/webapps/ROOT/WEB-INF/classes/template/List_of_powers.xlsx");

			// 设置输出的格式
			response.reset();
			response.setContentType("bin");
			response.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode("权责清单.xlsx", "UTF-8"));
			// 循环取出流中的数据
			byte[] b = new byte[100];
			int len;

			while ((len = inStream.read(b)) > 0)
				response.getOutputStream().write(b, 0, len);
			inStream.close();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/dca/dcaPowerList/list?repage";

	}

	/**
	 * 导入用户数据
	 * 
	 * @param file
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("dca:dcaPowerList:edit")
	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/dca/dcaPowerList/list?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<DcaPowerList> list = ei.getDataList(DcaPowerList.class);
			list.remove(0);
			for (DcaPowerList dcaPowerList : list) {
				if (StringUtils.isNotEmpty(dcaPowerList.getPowerId())) {
					dcaPowerList.setPowerId(dcaPowerList.getPowerId().replaceAll("[\u4e00-\u9fa5]+", ""));
				} else {
					continue;
				}
				try {
					if (StringUtils.isEmpty(dcaPowerList.getBizRoleName())
							|| StringUtils.isEmpty(dcaPowerList.getAccord())
							|| StringUtils.isEmpty(dcaPowerList.getDuty())
							|| StringUtils.isEmpty(dcaPowerList.getRemarks())) {
						failureMsg.append("<br/>导入的文档为空或某字段为空 ");
						failureNum++;
					} else {

						DcaPowerList content = new DcaPowerList();
						content.setBizRoleName(dcaPowerList.getBizRoleName());
						content.setPowerId(dcaPowerList.getPowerId());
						content.setDelFlag("0");
						List<DcaPowerList> powerlist = dcaPowerListService.findList(content);
						if (powerlist.size() > 0) {
							failureNum++;
						} else {
							BeanValidators.validateWithException(validator, dcaPowerList);
							dcaPowerList.setUuid(IdGen.uuid());
							dcaPowerList.setCreatePerson(UserUtils.getUser().getId());
							dcaPowerList.setUpdatePerson(UserUtils.getUser().getId());
							// 两个保存放到一个方法中，便于事物回滚
							// dcaPowerListService.saveDcaPowerList(dcaPowerList);
							dcaPowerListService.importSave(dcaPowerList);
							successNum++;
						}
					}
				} catch (ConstraintViolationException ex) {
					failureMsg.append("文档 导入失败：");
					List<String> messageList = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("文档导入失败：" + ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条用户(表格模式错误或当前业务角色、权力已存在)，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条用户" + failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入用户失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/dca/dcaPowerList/list?repage";
	}

	/**
	 * 校验[风险名称]是否存在
	 * 
	 * @param riskName
	 * @param oldName
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "check")
	public String check(String powerId, String bizRoleName, String uuid) {
		// 判断uuid为空，则为新建页面
		if (StringUtils.isEmpty(uuid)) {
			DcaPowerList dca = new DcaPowerList();
			dca.setPowerId(powerId);
			dca.setBizRoleName(bizRoleName.trim());
			List<DcaPowerList> findList = dcaPowerListService.findList(dca);
			if (findList != null && findList.size() > 0) {
				return "false";
			} else {
				return "true";
			}
		} else {
			return "true";
		}
	}

	/**
	 * 获取上报岗位name
	 * 
	 * @param form
	 * @return
	 */
	private String getGradeOrgPostName(DcaPowerList form) {

		StringBuffer sb = new StringBuffer();
		if (form != null) {
			// 获取岗位id（以逗号分隔的字符串）
			String idString = form.getRemarks();
			if (StringUtils.isNotBlank(idString)) {
				// 将岗位id串转成数组
				String[] ids = idString.split(",");
				for (int i = 0; i < ids.length; i++) {

					// 通过岗位id，获取岗位name
					DcaTraceUserRole dcaTraceUserRole = dcaTraceUserRoleService.findById(ids[i]);
					if (dcaTraceUserRole != null) {
						String name = dcaTraceUserRole.getRoleName();

						// 将岗位name拼成用逗号分隔的字符串
						if (i != ids.length - 1) {
							sb.append(String.valueOf(name)).append(",");
						} else {
							sb.append(String.valueOf(name));
						}
					}
				}
			}
		}
		return sb.toString();
	}
}