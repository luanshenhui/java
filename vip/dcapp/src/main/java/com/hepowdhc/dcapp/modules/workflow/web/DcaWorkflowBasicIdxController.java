/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.web;

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

import com.alibaba.druid.wall.WallConfig;
import com.hepowdhc.dcapp.api.util.VerifySql;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflowBasicIdx;
import com.hepowdhc.dcapp.modules.workflow.service.DcaWorkflowBasicIdxService;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.IdGen;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 告警指标管理Controller
 * 
 * @author hanxin'an
 * @version 2016-11-08
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaWorkflowBasicIdx")
public class DcaWorkflowBasicIdxController extends BaseController {

	@Autowired
	private DcaWorkflowBasicIdxService dcaWorkflowBasicIdxService;

	// 英文(大小写)，数字，下划线，等号，逗号
	public static final String REGEX_SQL = "[^0-9A-Za-z()\\-,=]";

	public static final String SELECT_SQL = "select";

	@ModelAttribute
	public DcaWorkflowBasicIdx get(@RequestParam(required = false) String id) {
		DcaWorkflowBasicIdx entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = dcaWorkflowBasicIdxService.get(id);
		}
		if (entity == null) {
			entity = new DcaWorkflowBasicIdx();
		}
		return entity;
	}

	/**
	 * 列表画面
	 * 
	 * @param dcaWorkflowBasicIdx
	 * @param request
	 * @param response
	 * @param model
	 * @return 列表画面
	 */
	@RequiresPermissions("dca:dcaWorkflowBasicIdx:view")
	@RequestMapping(value = { "list", "" })
	public String list(DcaWorkflowBasicIdx dcaWorkflowBasicIdx, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<DcaWorkflowBasicIdx> page = dcaWorkflowBasicIdxService
				.findPage(new Page<DcaWorkflowBasicIdx>(request, response), dcaWorkflowBasicIdx);
		model.addAttribute("page", page);
		return "modules/dca/dcaWorkflowBasicIdxList";
	}

	/**
	 * 新建、编辑画面
	 * 
	 * @param dcaWorkflowBasicIdx
	 * @param model
	 * @return 新建、编辑画面
	 */
	@RequiresPermissions("dca:dcaWorkflowBasicIdx:view")
	@RequestMapping(value = "form")
	public String form(DcaWorkflowBasicIdx dcaWorkflowBasicIdx, Model model) {
		model.addAttribute("dcaWorkflowBasicIdx", dcaWorkflowBasicIdx);
		return "modules/dca/dcaWorkflowBasicIdxForm";
	}

	/**
	 * 新建、修改的保存处理
	 * 
	 * @param dcaWorkflowBasicIdx
	 * @param model
	 * @param redirectAttributes
	 * @return 列表页面
	 */
	@RequiresPermissions("dca:dcaWorkflowBasicIdx:edit")
	@RequestMapping(value = "save")
	public String save(DcaWorkflowBasicIdx dcaWorkflowBasicIdx, HttpServletRequest request,
			HttpServletResponse response, Model model, RedirectAttributes redirectAttributes) {

		// 重复的告警指标名称（true：存在，false：不存在）
		boolean existFlag = false;

		// 参数基本校验
		if (!beanValidator(model, dcaWorkflowBasicIdx)) {
			return form(dcaWorkflowBasicIdx, model);
		}

		// 判断id是否为空（空：新建，非空：修改），空的场合添加id（共同自动生成）
		if (StringUtils.isBlank(dcaWorkflowBasicIdx.getIdxId())) {

			// 判断告警指标是否存在(报警指标名称)
			existFlag = dcaWorkflowBasicIdxService.getCheckName(StringUtils.trim(dcaWorkflowBasicIdx.getIdxName()));

			if (existFlag) {
				addMessage(redirectAttributes, "该指标名称已存在，指标名称不能重复！");
				model.addAttribute("dcaWorkflowBasicIdx", dcaWorkflowBasicIdx);
				return "redirect:" + Global.getAdminPath() + "/dca/dcaWorkflowBasicIdx/form?repage";
			}
			dcaWorkflowBasicIdx.setIdxId(IdGen.uuid());
		}

		// 备注信息长度超过60时，截取到第60位
		String remarks = dcaWorkflowBasicIdx.getRemarks();
		if (remarks.length() > 60) {
			dcaWorkflowBasicIdx.setRemarks(remarks.substring(0, 60));
		}

		// 创建者，更新者设置
		if (UserUtils.getUser() != null) {
			dcaWorkflowBasicIdx.setCreatePerson(UserUtils.getUser().getId());
			dcaWorkflowBasicIdx.setUpdatePerson(UserUtils.getUser().getId());
		}

		dcaWorkflowBasicIdxService.save(dcaWorkflowBasicIdx);
		addMessage(redirectAttributes, "保存成功！");

		return "redirect:" + Global.getAdminPath() + "/dca/dcaWorkflowBasicIdx/?repage";
	}

	/**
	 * 删除操作
	 * 
	 * @param dcaWorkflowBasicIdx
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("dca:dcaWorkflowBasicIdx:edit")
	@RequestMapping(value = "delete")
	public String delete(DcaWorkflowBasicIdx dcaWorkflowBasicIdx, RedirectAttributes redirectAttributes) {

		// 工作流节点配置内容是否使用该项告警指标
		boolean checkFlag = dcaWorkflowBasicIdxService
				.checkTaskContent(StringUtils.trim(dcaWorkflowBasicIdx.getIdxName()));

		// 有工作流使用该告警指标的场合
		if (checkFlag) {

			addMessage(redirectAttributes, "该指标正在工作流使用中不能删除！");

		} else {
			dcaWorkflowBasicIdxService.delete(dcaWorkflowBasicIdx);
			addMessage(redirectAttributes, "删除成功！");
		}

		return "redirect:" + Global.getAdminPath() + "/dca/dcaWorkflowBasicIdx/?repage";
	}

	/**
	 * SQL合法验证
	 * 
	 * @param sqlStr
	 * @return result
	 */
	@ResponseBody
	@RequiresPermissions("dca:dcaWorkflowBasicIdx:edit")
	@RequestMapping(value = "sqlValidate")
	public String sqlValidate(String oldIdxSql, String idxSql) {

		// 输入的SQL必须为select语句，否则为为非法录入
		if ((idxSql != null) && (!idxSql.startsWith(SELECT_SQL))) {

			return "false";
		}

		if (idxSql != null && idxSql.equals(oldIdxSql)) {
			return "true";
		}

		// 输入的SQL的只能包括：数字、下滑线、英文（大小写）、逗号、等号、括号，否则为非法录入
		if (idxSql != null && idxSql.matches(REGEX_SQL)) {

			return "false";
		}

		VerifySql ver = new VerifySql() {

			@Override
			public void setConfig(WallConfig config) {
				// 禁止删除操作
				config.setDeleteAllow(false);
				config.setSelectIntoAllow(false);
				config.setDeleteAllow(false);
				config.setUpdateAllow(false);
				config.setInsertAllow(false);
				config.setReplaceAllow(false);
				config.setMergeAllow(false);
				config.setCallAllow(false);
				config.setSetAllow(false);
				config.setTruncateAllow(false);
				config.setCreateTableAllow(false);
				config.setAlterTableAllow(false);
				config.setDropTableAllow(false);
				config.setCommentAllow(false);
				config.setNoneBaseStatementAllow(false);
				config.setMultiStatementAllow(false);
				config.setUseAllow(false);
				config.setDescribeAllow(false);
				config.setShowAllow(false);
				config.setCommitAllow(false);
				config.setRollbackAllow(false);

			}
		};

		Boolean verify = ver.verify(idxSql);

		if (verify) {

		} else {
			return "false";
		}

		return "true";
	}

	/**
	 * 指标项名称校验
	 * 
	 * @param oldIdxName
	 * @param idxName
	 * @return
	 */
	@ResponseBody
	@RequiresPermissions("dca:dcaWorkflowBasicIdx:edit")
	@RequestMapping(value = "checkName")
	public String checkLoginName(String oldIdxName, String idxName) {

		// 指标项名称相同的场合-修改
		if (idxName != null && idxName.equals(oldIdxName)) {
			return "true";
		}

		// 指标项名称不相同的场合-查询是否存在相同名称
		boolean sameCount = dcaWorkflowBasicIdxService.getCheckName(StringUtils.trim(idxName));

		// 存在相同名称
		if (sameCount) {

			return "false";
		}

		return "true";
	}

}