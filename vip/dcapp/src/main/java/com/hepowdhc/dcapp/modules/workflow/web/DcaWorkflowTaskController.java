/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.web;

import java.util.List;
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

import com.google.common.collect.Lists;
import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.risklist.entity.DcaPowerList;
import com.hepowdhc.dcapp.modules.risklist.service.DcaAlarmRiskListService;
import com.hepowdhc.dcapp.modules.risklist.service.DcaPowerListService;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflow;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflowTask;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflowTaskContent;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflowTaskContentPop;
import com.hepowdhc.dcapp.modules.workflow.service.DcaWorkflowService;
import com.hepowdhc.dcapp.modules.workflow.service.DcaWorkflowTaskContentService;
import com.hepowdhc.dcapp.modules.workflow.service.DcaWorkflowTaskService;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.Collections3;
import com.thinkgem.jeesite.common.utils.IdGen;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.entity.DcaTraceUserRole;
import com.thinkgem.jeesite.modules.sys.service.DcaTraceUserRoleService;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 工作流节点Controller
 * 
 * @author ThinkGem
 * @version 2016-11-18
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaWorkflowTask")
public class DcaWorkflowTaskController extends BaseController {

	@Autowired
	private DcaWorkflowService dacWorkflowService;

	@Autowired
	private DcaWorkflowTaskService dcaWorkflowTaskService;

	@Autowired
	private DcaWorkflowTaskContentService dcaWorkflowTaskContentService;

	@Autowired
	private DcaPowerListService dcaPowerListService;

	@Autowired
	private DcaAlarmRiskListService riskService;

	@Autowired
	private DcaTraceUserRoleService dcaTraceUserRoleService;

	@ModelAttribute
	public DcaWorkflowTask get(@RequestParam(required = false) String id) {
		DcaWorkflowTask entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = dcaWorkflowTaskService.get(id);
		}
		if (entity == null) {
			entity = new DcaWorkflowTask();
		}
		return entity;
	}

	@RequiresPermissions("workflow:dcaWorkflowTask:view")
	@RequestMapping(value = { "list", "" })
	public String list(DcaWorkflowTask dcaWorkflowTask, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<DcaWorkflowTask> page = dcaWorkflowTaskService.findPage(new Page<DcaWorkflowTask>(request, response),
				dcaWorkflowTask);
		model.addAttribute("page", page);
		return "modules/workflow/dcaWorkflowTaskList";
	}

	@RequiresPermissions("workflow:dcaWorkflowTask:view")
	@RequestMapping(value = "form")
	public String form(DcaWorkflowTask dcaWorkflowTask, Model model) {
		model.addAttribute("dcaWorkflowTask", dcaWorkflowTask);
		return "modules/workflow/dcaWorkflowTaskForm";
	}

	@RequiresPermissions("workflow:dcaWorkflowTask:edit")
	@RequestMapping(value = "save")
	public String save(DcaWorkflowTask dcaWorkflowTask, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, dcaWorkflowTask)) {
			return form(dcaWorkflowTask, model);
		}
		dcaWorkflowTaskService.save(dcaWorkflowTask);
		addMessage(redirectAttributes, "保存单表成功");
		return "redirect:" + Global.getAdminPath() + "/workflow/dcaWorkflowTask/?repage";
	}

	@RequiresPermissions("workflow:dcaWorkflowTask:edit")
	@RequestMapping(value = "delete")
	public String delete(DcaWorkflowTask dcaWorkflowTask, RedirectAttributes redirectAttributes) {
		dcaWorkflowTaskService.delete(dcaWorkflowTask);
		addMessage(redirectAttributes, "删除单表成功");
		return "redirect:" + Global.getAdminPath() + "/workflow/dcaWorkflowTask/?repage";
	}

	/**
	 * 保存节点，更新工作流
	 * 
	 * @param workFlow
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "saveTask")
	public String saveTask(HttpServletRequest request, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {

		// 取得前台返回json串信息 工作流ID
		String flowId = request.getParameter("flowId");
		// 工作流名
		String flowName = request.getParameter("name");
		// 工作流拖拽画面json串
		String flowContent = request.getParameter("content");
		// 保存flag，用于区别时时保存和按钮保存
		String saveFlag = request.getParameter("saveData");
		// 有效节点的节点ID
		String taskIds = request.getParameter("nodeId");
		// 根据工作流ID取得工作流表信息
		DcaWorkflow flow = dacWorkflowService.getWorkFlowById(flowId);

		if (StringUtils.equals(saveFlag, Constant.FINAL_SAVE)) {
			// 如果是按钮保存的话

			// 保存校验
			String results = checkFlow(flowId, flowContent, redirectAttributes);
			if (!StringUtils.equals(results, Constant.STRING_TRUE)) {
				// 校验失败返回失败信息
				return results;
			}

			// 初始化工作流entity，更新工作流拖拽画面json串
			DcaWorkflow workFlow = new DcaWorkflow();
			workFlow.setWfId(flowId);
			workFlow.setXmlName(flowName);
			workFlow.setXmlContent(flowContent);
			workFlow.setUpdatePerson(UserUtils.getUser().getId());

			// 更新方法，更新工作流，保存节点信息
			dacWorkflowService.saveTaskAndUpdateFlow(workFlow, flowContent, taskIds, flow.getPowerId());
		}
		// 实时保存暂时不用
		// else {
		// DcaWorkflow workFlow = new DcaWorkflow();
		// workFlow.setWfId(flowId);
		// workFlow.setXmlName(flowName);
		// workFlow.setXmlContent(flowContent);
		// workFlow.setUpdatePerson(UserUtils.getUser().getId());
		// dacWorkflowService.UpdateFlow(workFlow);
		// }
		return Constant.STRING_TRUE;
	}

	/**
	 * 初始化拖拽页面
	 * 
	 * @param wfId
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "getContent")
	public String getContent(HttpServletRequest request, HttpServletResponse response) {

		String flowId = request.getParameter("flowId");
		DcaWorkflow flow = dacWorkflowService.getWorkFlowById(flowId);

		// 返回json
		String xmlContent = flow.getXmlContent();
		return xmlContent;
	}

	/**
	 * 节点内容查询
	 * 
	 * @param contentPop
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "initForm")
	public String initForm(DcaWorkflowTaskContentPop contentPop, Model model, HttpServletRequest request,
			HttpServletResponse response) {

		String flowId = request.getParameter("flowId"); // 工作流id
		String taskId = request.getParameter("nodeId"); // 节点id

		contentPop.setWfId(flowId);
		contentPop.setTaskId(taskId);

		DcaWorkflow flow = dacWorkflowService.getWorkFlowById(flowId);
		DcaWorkflowTaskContent content = new DcaWorkflowTaskContent();
		content.setTaskId(taskId);
		List<DcaWorkflowTaskContent> taskContentList = dcaWorkflowTaskContentService.findList(content);
		DcaWorkflowTask taskEntity = get(taskId);
		// 节点名称
		contentPop.setTaskName(taskEntity.getTaskName());
		// 业务角色ID 多选,逗号隔开
		contentPop.setBizRoleId(taskEntity.getBizRoleId());
		// 业务角色ID List
		contentPop.setBizRoleIdList(getBizRoleByPowerId(flow.getPowerId()));
		// 业务节点ID
		contentPop.setBizTaskId(taskEntity.getBizTaskId());
		// 节点是否启用
		contentPop.setIsShow(taskEntity.getIsShow());
		// 风险清单List
		contentPop.setRiskList(riskService.getRiskByPowerId(flow.getPowerId()));

		for (DcaWorkflowTaskContent taskContent : taskContentList) {
			// 循环节点内容
			if (StringUtils.equals(taskContent.getAlarmType(), Constant.ALARM_TYPE_1)) {
				// 如果是1的话为时间约束

				// 预警/风险维度，时间约束
				contentPop.setAlarmTypeTime(taskContent.getAlarmType());
				// 时间约束是否启用.0:停止；1：启用
				contentPop.setIsEffectiveTime(taskContent.getIsEffective());
				// 本节点需要时间;触发条件
				contentPop.setTimeNeed(taskContent.getTimeNeed());
				// 时间单位
				contentPop.setTimeNeedUnit(taskContent.getTimeNeedUnit());
				if (StringUtils.isNotBlank(taskContent.getAlarmLevelNeed())) {
					// 如果有时间约束的话

					String[] levelAndTimes = taskContent.getAlarmLevelNeed().split(Constant.SSX_C);
					if (levelAndTimes.length == 3) {
						// 本节点需要时间黄色
						contentPop.setTimeStart1(getTime(levelAndTimes, 0, 1, 0));
						// 本节点需要时间橙色
						contentPop.setTimeStart2(getTime(levelAndTimes, 1, 1, 0));
						// 本节点需要时间红色
						contentPop.setTimeStart3(getTime(levelAndTimes, 2, 1, 0));
						// 本节点需要时间黄色
						contentPop.setTimeEnd1(getTime(levelAndTimes, 0, 1, 1));
						// 本节点需要时间橙色
						contentPop.setTimeEnd2(getTime(levelAndTimes, 1, 1, 1));
						// 本节点需要时间红色
						contentPop.setTimeEnd3(getTime(levelAndTimes, 2, 1, 1));
					}
					if (levelAndTimes.length == 2) {
						if (StringUtils.equals(levelAndTimes[0].split(Constant.COLON)[0], Constant.ALARM_LEVEL_2)) {
							// 本节点需要时间黄色
							contentPop.setTimeStart1(getTime(levelAndTimes, 0, 1, 0));
							// 本节点需要时间黄色
							contentPop.setTimeEnd1(getTime(levelAndTimes, 0, 1, 1));
						}
						if (StringUtils.equals(levelAndTimes[0].split(Constant.COLON)[0], Constant.ALARM_LEVEL_3)) {
							// 本节点需要时间橙色
							contentPop.setTimeStart2(getTime(levelAndTimes, 0, 1, 0));
							// 本节点需要时间橙色
							contentPop.setTimeEnd2(getTime(levelAndTimes, 0, 1, 1));
						}
						if (StringUtils.equals(levelAndTimes[0].split(Constant.COLON)[0], Constant.ALARM_LEVEL_4)) {
							// 本节点需要时间红色
							contentPop.setTimeStart3(getTime(levelAndTimes, 0, 1, 0));
							// 本节点需要时间红色
							contentPop.setTimeEnd3(getTime(levelAndTimes, 0, 1, 1));
						}
						if (StringUtils.equals(levelAndTimes[1].split(Constant.COLON)[0], Constant.ALARM_LEVEL_2)) {
							// 本节点需要时间黄色
							contentPop.setTimeStart1(getTime(levelAndTimes, 1, 1, 0));
							// 本节点需要时间黄色
							contentPop.setTimeEnd1(getTime(levelAndTimes, 1, 1, 1));
						}
						if (StringUtils.equals(levelAndTimes[1].split(Constant.COLON)[0], Constant.ALARM_LEVEL_3)) {
							// 本节点需要时间橙色
							contentPop.setTimeStart2(getTime(levelAndTimes, 1, 1, 0));
							// 本节点需要时间橙色
							contentPop.setTimeEnd2(getTime(levelAndTimes, 1, 1, 1));
						}
						if (StringUtils.equals(levelAndTimes[1].split(Constant.COLON)[0], Constant.ALARM_LEVEL_4)) {
							// 本节点需要时间红色
							contentPop.setTimeStart3(getTime(levelAndTimes, 1, 1, 0));
							// 本节点需要时间红色
							contentPop.setTimeEnd3(getTime(levelAndTimes, 1, 1, 1));
						}
					}
					if (levelAndTimes.length == 1) {
						if (StringUtils.equals(levelAndTimes[0].split(Constant.COLON)[0], Constant.ALARM_LEVEL_2)) {
							// 本节点需要时间黄色
							contentPop.setTimeStart1(getTime(levelAndTimes, 0, 1, 0));
							// 本节点需要时间黄色
							contentPop.setTimeEnd1(getTime(levelAndTimes, 0, 1, 1));
						}
						if (StringUtils.equals(levelAndTimes[0].split(Constant.COLON)[0], Constant.ALARM_LEVEL_3)) {
							// 本节点需要时间橙色
							contentPop.setTimeStart2(getTime(levelAndTimes, 0, 1, 0));
							// 本节点需要时间橙色
							contentPop.setTimeEnd2(getTime(levelAndTimes, 0, 1, 1));
						}
						if (StringUtils.equals(levelAndTimes[0].split(Constant.COLON)[0], Constant.ALARM_LEVEL_4)) {
							// 本节点需要时间红色
							contentPop.setTimeStart3(getTime(levelAndTimes, 0, 1, 0));
							// 本节点需要时间红色
							contentPop.setTimeEnd3(getTime(levelAndTimes, 0, 1, 1));
						}
					}
				}
				// 至本节点完成所需时间;触发条件
				contentPop.setTimeSum(taskContent.getTimeSum());
				// 至本节点完成所需时间的时间单位
				contentPop.setTimeSumUnit(taskContent.getTimeSumUnit());

				if (StringUtils.isNotBlank(taskContent.getAlarmLevelSum())) {
					// 如果有至本节点时间约束的话

					String[] levelAndTimes = taskContent.getAlarmLevelSum().split(Constant.SSX_C);
					if (levelAndTimes.length == 3) {
						// 至本节点需要时间黄色
						contentPop.setTimeSumStart1(getTime(levelAndTimes, 0, 1, 0));
						// 至本节点需要时间橙色
						contentPop.setTimeSumStart2(getTime(levelAndTimes, 1, 1, 0));
						// 至本节点需要时间红色
						contentPop.setTimeSumStart3(getTime(levelAndTimes, 2, 1, 0));
						// 至本节点需要时间黄色
						contentPop.setTimeSumEnd1(getTime(levelAndTimes, 0, 1, 1));
						// 至本节点需要时间橙色
						contentPop.setTimeSumEnd2(getTime(levelAndTimes, 1, 1, 1));
						// 至本节点需要时间红色
						contentPop.setTimeSumEnd3(getTime(levelAndTimes, 2, 1, 1));
					}
					if (levelAndTimes.length == 2) {
						if (StringUtils.equals(levelAndTimes[0].split(Constant.COLON)[0], Constant.ALARM_LEVEL_2)) {
							// 至本节点需要时间黄色
							contentPop.setTimeSumStart1(getTime(levelAndTimes, 0, 1, 0));
							// 至本节点需要时间黄色
							contentPop.setTimeSumEnd1(getTime(levelAndTimes, 0, 1, 1));
						}
						if (StringUtils.equals(levelAndTimes[0].split(Constant.COLON)[0], Constant.ALARM_LEVEL_3)) {
							// 至本节点需要时间橙色
							contentPop.setTimeSumStart2(getTime(levelAndTimes, 0, 1, 0));
							// 至本节点需要时间橙色
							contentPop.setTimeSumEnd2(getTime(levelAndTimes, 0, 1, 1));
						}
						if (StringUtils.equals(levelAndTimes[0].split(Constant.COLON)[0], Constant.ALARM_LEVEL_4)) {
							// 至本节点需要时间红色
							contentPop.setTimeSumStart3(getTime(levelAndTimes, 0, 1, 0));
							// 至本节点需要时间红色
							contentPop.setTimeSumEnd3(getTime(levelAndTimes, 0, 1, 1));
						}
						if (StringUtils.equals(levelAndTimes[1].split(Constant.COLON)[0], Constant.ALARM_LEVEL_2)) {
							// 至本节点需要时间黄色
							contentPop.setTimeSumStart1(getTime(levelAndTimes, 1, 1, 0));
							// 至本节点需要时间黄色
							contentPop.setTimeSumEnd1(getTime(levelAndTimes, 1, 1, 1));
						}
						if (StringUtils.equals(levelAndTimes[1].split(Constant.COLON)[0], Constant.ALARM_LEVEL_3)) {
							// 至本节点需要时间橙色
							contentPop.setTimeSumStart2(getTime(levelAndTimes, 1, 1, 0));
							// 至本节点需要时间橙色
							contentPop.setTimeSumEnd2(getTime(levelAndTimes, 1, 1, 1));
						}
						if (StringUtils.equals(levelAndTimes[1].split(Constant.COLON)[0], Constant.ALARM_LEVEL_4)) {
							// 至本节点需要时间红色
							contentPop.setTimeSumStart3(getTime(levelAndTimes, 1, 1, 0));
							// 至本节点需要时间红色
							contentPop.setTimeSumEnd3(getTime(levelAndTimes, 1, 1, 1));
						}
					}
					if (levelAndTimes.length == 1) {
						if (StringUtils.equals(levelAndTimes[0].split(Constant.COLON)[0], Constant.ALARM_LEVEL_2)) {
							// 至本节点需要时间黄色
							contentPop.setTimeSumStart1(getTime(levelAndTimes, 0, 1, 0));
							// 至本节点需要时间黄色
							contentPop.setTimeSumEnd1(getTime(levelAndTimes, 0, 1, 1));
						}
						if (StringUtils.equals(levelAndTimes[0].split(Constant.COLON)[0], Constant.ALARM_LEVEL_3)) {
							// 至本节点需要时间橙色
							contentPop.setTimeSumStart2(getTime(levelAndTimes, 0, 1, 0));
							// 至本节点需要时间橙色
							contentPop.setTimeSumEnd2(getTime(levelAndTimes, 0, 1, 1));
						}
						if (StringUtils.equals(levelAndTimes[0].split(Constant.COLON)[0], Constant.ALARM_LEVEL_4)) {
							// 至本节点需要时间红色
							contentPop.setTimeSumStart3(getTime(levelAndTimes, 0, 1, 0));
							// 至本节点需要时间红色
							contentPop.setTimeSumEnd3(getTime(levelAndTimes, 0, 1, 1));
						}
					}
				}
				// 是否为风险 时间约束
				contentPop.setIsRiskTime(taskContent.getIsRisk());
				// 风险清单ID 时间约束
				contentPop.setRiskIdTime(taskContent.getRiskId());
				// 是否可以人工界定风险 0:否；1：是
				contentPop.setIsManualJudgeTime(StringUtils.trim(taskContent.getIsManualJudge()));

			} else if (StringUtils.equals(taskContent.getAlarmType(), Constant.ALARM_TYPE_2)) {
				// 如果有职能约束

				// 预警/风险维度，职能约束
				contentPop.setAlarmTypeCompetency(taskContent.getAlarmType());
				// 职能约束是否启用.0:停止；1：启用
				contentPop.setIsEffectiveCompetency(taskContent.getIsEffective());
				// 是否为风险 职能约束
				contentPop.setIsRiskCompetency(taskContent.getIsRisk());
				// 风险清单ID 职能约束
				contentPop.setRiskIdCompetency(taskContent.getRiskId());
				// 是否可以人工界定风险 0:否；1：是 职能约束
				contentPop.setIsManualJudgeCompetency(taskContent.getIsManualJudge());
				// 岗位
				contentPop.setPostId(taskContent.getPostId());
				if (StringUtils.isNotBlank(taskContent.getPostId())) {
					// 用当前岗位ID取出岗位名称
					DcaTraceUserRole dcaTraceUserRole = dcaTraceUserRoleService.findById(taskContent.getPostId());
					contentPop.setPostName(dcaTraceUserRole.getRoleName());
				}
				// 预警级别，职能约束
				contentPop.setAlarmLevelCompetency(taskContent.getAlarmLevel());

			} else if (StringUtils.equals(taskContent.getAlarmType(), Constant.ALARM_TYPE_3)) {
				// 如果有行为约束

				// 预警/风险维度,行为约束
				contentPop.setAlarmTypeAction(taskContent.getAlarmType());
				// 行为约束是否启用.0:停止；1：启用
				contentPop.setIsEffectiveAction(taskContent.getIsEffective());
				// 是否为风险 行为约束
				contentPop.setIsRiskAction(taskContent.getIsRisk());
				// 风险清单ID 行为约束
				contentPop.setRiskIdAction(taskContent.getRiskId());
				// 是否可以人工界定风险 0:否；1：是 行为约束
				contentPop.setIsManualJudgeAction(taskContent.getIsManualJudge());
				// 预警级别,行为约束
				contentPop.setAlarmLevelAction(taskContent.getAlarmLevel());
				// 计算公式，计算SQL,行为约束
				contentPop.setComputeRuleAction(taskContent.getComputeRule());

			} else if (StringUtils.equals(taskContent.getAlarmType(), Constant.ALARM_TYPE_4)) {
				// 如果有互证约束

				// 预警/风险维度,互证约束
				contentPop.setAlarmTypeMutually(taskContent.getAlarmType());
				// 互证约束是否启用.0:停止；1：启用
				contentPop.setIsEffectiveMutually(taskContent.getIsEffective());
				// 是否为风险 互证约束
				contentPop.setIsRiskMutually(taskContent.getIsRisk());
				// 风险清单ID 互证约束
				contentPop.setRiskIdMutually(taskContent.getRiskId());
				// 是否可以人工界定风险 0:否；1：是 互证约束
				contentPop.setIsManualJudgeMutually(taskContent.getIsManualJudge());
				// 预警级别,互证约束
				contentPop.setAlarmLevelMutually(taskContent.getAlarmLevel());
				// 计算公式，计算SQL,互证约束
				contentPop.setComputeRuleMutually(taskContent.getComputeRule());
			}
		}
		model.addAttribute("DcaWorkflowTaskContentPop", contentPop);
		return "modules/dca/dcaWorkflowTaskEditPop";
	}

	/**
	 * 节点内容登录
	 * 
	 * @param contentPop
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "saveContent")
	public String saveContent(DcaWorkflowTaskContentPop contentPop, Model model,
			RedirectAttributes redirectAttributes) {

		// 校验节点内容
		String results = checkContent(contentPop, redirectAttributes);
		if (!StringUtils.equals(results, Constant.STRING_TRUE)) {
			return results;
		}

		int updateFlagContent = 0;
		int updateFlagTask = 0;

		// 取得节点内容
		DcaWorkflowTaskContent content = new DcaWorkflowTaskContent();
		content.setTaskId(contentPop.getTaskId());
		List<DcaWorkflowTaskContent> taskContentList = dcaWorkflowTaskContentService.findList(content);
		if (Collections3.isEmpty(taskContentList)) {
			// 为空的话插入
			updateFlagContent = 0;
		} else {
			// 不为空的话更新
			updateFlagContent = 1;
		}

		// 取得节点信息
		DcaWorkflowTask task = get(contentPop.getTaskId());
		DcaWorkflowTask taskEntity = new DcaWorkflowTask();
		if (StringUtils.isNotBlank(task.getUuid())) {
			// 不为空的话更新
			taskEntity.setUuid(contentPop.getTaskId());
			taskEntity.setTaskName(contentPop.getTaskName());
			taskEntity.setWfId(contentPop.getWfId());
			taskEntity.setBizTaskId(contentPop.getBizTaskId());
			taskEntity.setBizRoleId(contentPop.getBizRoleId());
			taskEntity.setIsShow(contentPop.getIsShow());
			taskEntity.setUpdatePerson(UserUtils.getUser().getId());
			updateFlagTask = 1;
		} else {
			// 为空的话插入
			DcaWorkflow flow = dacWorkflowService.getWorkFlowById(contentPop.getWfId());
			taskEntity.setUuid(contentPop.getTaskId());
			taskEntity.setTaskName(contentPop.getTaskName());
			taskEntity.setWfId(contentPop.getWfId());
			taskEntity.setPowerId(flow.getPowerId());
			taskEntity.setBizTaskId(contentPop.getBizTaskId());
			taskEntity.setBizRoleId(contentPop.getBizRoleId());
			taskEntity.setSort((long) 0);
			taskEntity.setIsShow(contentPop.getIsShow());
			taskEntity.setUpdatePerson(UserUtils.getUser().getId());
			taskEntity.setCreatePerson(UserUtils.getUser().getId());
			updateFlagTask = 0;
		}

		List<DcaWorkflowTaskContent> contentList = Lists.newArrayList();
		for (int i = 1; i < 5; i++) {
			// 保存节点内容，循环四次，分别是四个约束
			DcaWorkflowTaskContent entity = new DcaWorkflowTaskContent();
			entity.setUuid(IdGen.uuid());
			entity.setTaskId(contentPop.getTaskId());
			entity.setUpdatePerson(UserUtils.getUser().getId());
			entity.setCreatePerson(UserUtils.getUser().getId());
			if (i == 1) {
				entity.setAlarmType(Constant.ALARM_TYPE_1); // 预警/风险维度
				String need = "";
				String sumNeed = "";
				if (StringUtils.isNotBlank(contentPop.getTimeStart1())
						&& StringUtils.isNotBlank(contentPop.getTimeEnd1())) {
					need = Constant.ALARM_LEVEL_2 + Constant.COLON + contentPop.getTimeStart1() + Constant.MINUS
							+ contentPop.getTimeEnd1() + Constant.SSX;
				}
				if (StringUtils.isNotBlank(contentPop.getTimeStart2())
						&& StringUtils.isNotBlank(contentPop.getTimeEnd2())) {
					need = need + Constant.ALARM_LEVEL_3 + Constant.COLON + contentPop.getTimeStart2() + Constant.MINUS
							+ contentPop.getTimeEnd2() + Constant.SSX;
				}
				if (StringUtils.isNotBlank(contentPop.getTimeStart3())
						&& StringUtils.isNotBlank(contentPop.getTimeEnd3())) {
					need = need + Constant.ALARM_LEVEL_4 + Constant.COLON + contentPop.getTimeStart3() + Constant.MINUS
							+ contentPop.getTimeEnd3();
				}
				if (StringUtils.isNotBlank(contentPop.getTimeSumStart1())
						&& StringUtils.isNotBlank(contentPop.getTimeSumEnd1())) {
					sumNeed = Constant.ALARM_LEVEL_2 + Constant.COLON + contentPop.getTimeSumStart1() + Constant.MINUS
							+ contentPop.getTimeSumEnd1() + Constant.SSX;
				}
				if (StringUtils.isNotBlank(contentPop.getTimeSumStart2())
						&& StringUtils.isNotBlank(contentPop.getTimeSumEnd2())) {
					sumNeed = sumNeed + Constant.ALARM_LEVEL_3 + Constant.COLON + contentPop.getTimeSumStart2()
							+ Constant.MINUS + contentPop.getTimeSumEnd2() + Constant.SSX;
				}
				if (StringUtils.isNotBlank(contentPop.getTimeSumStart3())
						&& StringUtils.isNotBlank(contentPop.getTimeSumEnd3())) {
					sumNeed = sumNeed + Constant.ALARM_LEVEL_4 + Constant.COLON + contentPop.getTimeSumStart3()
							+ Constant.MINUS + contentPop.getTimeSumEnd3();
				}
				// 本节点需要时间预警级别设置
				entity.setAlarmLevelNeed(need);
				// 至本节点完成所需时间预警级别设置
				entity.setAlarmLevelSum(sumNeed);
				// 本节点需要时间;触发条件
				entity.setTimeNeed(contentPop.getTimeNeed());
				// 时间单位
				entity.setTimeNeedUnit(contentPop.getTimeNeedUnit());
				// 至本节点完成所需时间;触发条件
				entity.setTimeSum(contentPop.getTimeSum());
				// 至本节点完成所需时间的时间单位
				entity.setTimeSumUnit(contentPop.getTimeSumUnit());
				// 是否为风险
				entity.setIsRisk(Constant.DEFINE_STATUS_1);
				// 风险清单ID
				entity.setRiskId(contentPop.getRiskIdTime());
				// 是否可以人工界定风险 0:否；1：是
				entity.setIsManualJudge(contentPop.getIsManualJudgeTime());
				// 是否有效.0:停止；1：启用
				entity.setIsEffective(contentPop.getIsEffectiveTime());
			} else if (i == 2) {
				// 岗位
				entity.setPostId(contentPop.getPostId());
				// 预警/风险维度
				entity.setAlarmType(Constant.ALARM_TYPE_2);
				// 预警级别
				entity.setAlarmLevel(contentPop.getAlarmLevelCompetency());
				// 是否为风险
				entity.setIsRisk(contentPop.getIsRiskCompetency());
				// 风险清单ID
				entity.setRiskId(contentPop.getRiskIdCompetency());
				// 是否可以人工界定风险 0:否；1：是
				entity.setIsManualJudge(contentPop.getIsManualJudgeCompetency());
				// 是否有效.0:停止；1：启用
				entity.setIsEffective(contentPop.getIsEffectiveCompetency());
			} else if (i == 3) {
				// 计算公式，计算SQL
				entity.setComputeRule(contentPop.getComputeRuleAction());
				// 预警/风险维度
				entity.setAlarmType(Constant.ALARM_TYPE_3);
				// 预警级别
				entity.setAlarmLevel(contentPop.getAlarmLevelAction());
				// 是否为风险
				entity.setIsRisk(contentPop.getIsRiskAction());
				// 风险清单ID
				entity.setRiskId(contentPop.getRiskIdAction());
				// 是否可以人工界定风险 0:否；1：是
				entity.setIsManualJudge(contentPop.getIsManualJudgeAction());
				// 是否有效.0:停止；1：启用
				entity.setIsEffective(contentPop.getIsEffectiveAction());
			} else if (i == 4) {
				// 计算公式，计算SQL
				entity.setComputeRule(contentPop.getComputeRuleMutually());
				// 预警/风险维度
				entity.setAlarmType(Constant.ALARM_TYPE_4);
				// 预警级别
				entity.setAlarmLevel(contentPop.getAlarmLevelMutually());
				// 是否为风险
				entity.setIsRisk(contentPop.getIsRiskMutually());
				// 风险清单ID
				entity.setRiskId(contentPop.getRiskIdMutually());
				// 是否可以人工界定风险 0:否；1：是
				entity.setIsManualJudge(contentPop.getIsManualJudgeMutually());
				// 是否有效.0:停止；1：启用
				entity.setIsEffective(contentPop.getIsEffectiveMutually());
			}
			contentList.add(entity);
		}
		int count = dcaWorkflowTaskService.saveTaskAndContent(taskEntity, contentList, updateFlagContent,
				updateFlagTask);
		if (count == 0) {
			return "保存节点内容失败";
		}
		return Constant.STRING_TRUE;
	}

	/**
	 * 节点校验
	 * 
	 * @param flowId
	 * @param flowContent
	 * @param redirectAttributes
	 * @return
	 */
	private String checkFlow(String flowId, String flowContent, RedirectAttributes redirectAttributes) {

		// 启动校验
		DcaWorkflow dcaWorkflow = new DcaWorkflow();
		dcaWorkflow.setWfId(flowId);
		int flag = dacWorkflowService.checkStartJson(dcaWorkflow, flowContent);
		if (flag == 0) {
			return "没有工作流数据！";
		}
		if (flag == 1) {
			return "工作流定义时，有且只能有一个开始节点，请修改后重新保存！";
		} else if (flag == 2) {
			return "工作流定义时，有且只能有一个结束节点，请修改后重新保存！";
		} else if (flag == 3) {
			return "工作流定义时，开始节点和结束节点中至少有一个任务节点，请修改后重新保存！";
		} else if (flag == 4) {
			return "工作流定义时，从开始节点开始的任务数有且只有一个，请修改后重新保存！";
		} else if (flag == 5) {
			return "工作流定义时，以结束节点结束的任务数有且只有一个，请修改后重新保存！";
		} else if (flag == 6) {
			return "工作流定义时，除去开始和结束节点，其他的任务节点均应该有来源和去向，请修改后重新保存！";
		} else if (flag == 7) {
			return "工作流没有设置节点，请先设置后启动。";
		} else if (flag == 8) {
			return "工作流没有设置连线，请先设置后启动。";
		}

		return Constant.STRING_TRUE;
	}

	/**
	 * 节点内容校验
	 * 
	 * @param contentPop
	 * @param redirectAttributes
	 * @return
	 */
	private String checkContent(DcaWorkflowTaskContentPop contentPop, RedirectAttributes redirectAttributes) {

		if (StringUtils.isBlank(contentPop.getTaskName())) {
			return "任务节点名称不能为空!";
		}

		if (StringUtils.equals(Constant.STRING_TRUE,
				checkTaskName(contentPop.getTaskName(), contentPop.getWfId(), contentPop.getTaskId()))) {
			return "当前输入的任务节点名称已被使用，请输入其他的名称。";
		}

		if (StringUtils.isBlank(contentPop.getBizRoleId())) {
			return "请至少选择一个业务角色。";
		}

		if (StringUtils.isBlank(contentPop.getBizTaskId())) {
			return "业务节点ID不能为空。";
		}

		if (StringUtils.equals(Constant.CLOSE, contentPop.getIsEffectiveTime())
				&& StringUtils.equals(Constant.CLOSE, contentPop.getIsEffectiveMutually())
				&& StringUtils.equals(Constant.CLOSE, contentPop.getIsEffectiveAction())
				&& StringUtils.equals(Constant.CLOSE, contentPop.getIsEffectiveCompetency())) {
			return "请至少设置一个约束条件。";
		}

		if (StringUtils.equals(Constant.OPEN, contentPop.getIsEffectiveTime())) {

			long timeNeed = contentPop.getTimeNeed() == null ? 0 : contentPop.getTimeNeed();
			long timeSum = contentPop.getTimeSum() == null ? 0 : contentPop.getTimeSum();

			// 如果本节点需要时间=[空白 or 0] AND 至本节点完成所需时间 =[空白 or 0]
			if (isBlankOrZero(timeNeed) && isBlankOrZero(timeSum)) {
				return "时间约束中，本节点需要时间和至本节点完成所需时间至少输入一项。";
			}

			// 本节点需要时间不为空
			if (!isBlankOrZero(timeNeed)) {
				boolean checkTimeFlag = checkTime(timeNeed, contentPop.getTimeStart1(), contentPop.getTimeEnd1(),
						contentPop.getTimeStart2(), contentPop.getTimeEnd2(), contentPop.getTimeStart3(),
						contentPop.getTimeEnd3());
				if (!checkTimeFlag) {
					return "时间约束中，本节点需要时间预警级别设置有误，请确认后再次输入。";
				}
			} else {
				if (StringUtils.isNotBlank(contentPop.getTimeStart1())
						|| StringUtils.isNotBlank(contentPop.getTimeEnd1())
						|| StringUtils.isNotBlank(contentPop.getTimeStart2())
						|| StringUtils.isNotBlank(contentPop.getTimeEnd2())
						|| StringUtils.isNotBlank(contentPop.getTimeStart3())
						|| StringUtils.isNotBlank(contentPop.getTimeEnd3())) {
					// 本节点需要时间=未设定（空白 or 0） AND 本节点需要时间预警级别被设定
					return "时间约束中，本节点需要时间“未设定”时，告警级别不可设置。";
				}
			}

			// 至本节点完成所需时间不为空
			if (!isBlankOrZero(timeSum)) {
				boolean checkTimeFlag = checkTime(timeSum, contentPop.getTimeSumStart1(), contentPop.getTimeSumEnd1(),
						contentPop.getTimeSumStart2(), contentPop.getTimeSumEnd2(), contentPop.getTimeSumStart3(),
						contentPop.getTimeSumEnd3());
				if (!checkTimeFlag) {
					return "时间约束中，至本节点完成所需时间预警级别设置有误，请确认后再次输入。";
				}
			} else {
				if (StringUtils.isNotBlank(contentPop.getTimeSumStart1())
						|| StringUtils.isNotBlank(contentPop.getTimeSumEnd1())
						|| StringUtils.isNotBlank(contentPop.getTimeSumStart2())
						|| StringUtils.isNotBlank(contentPop.getTimeSumEnd2())
						|| StringUtils.isNotBlank(contentPop.getTimeSumStart3())
						|| StringUtils.isNotBlank(contentPop.getTimeSumEnd3())) {
					// 本节点需要时间=未设定（空白 or 0） AND 本节点需要时间预警级别被设定
					return "时间约束中，至本节点完成所需时间“未设定”时，告警级别不可设置。";
				}
			}

			// 本节点需要时间 >0 AND 至本节点完成所需时间 >0 AND 本节点需要时间 >至本节点完成所需时间
			if (timeNeed > 0 && timeSum > 0 && timeNeed > timeSum) {
				return "时间约束中，本节点需要时间和至本节点完成所需时间关系有误，请重新输入。";
			}
			// 时间单位与 【从流程开始到任务节点完成时间】 设定的时间单位相同
			if (timeNeed > 0 && timeSum > 0
					&& !StringUtils.equals(contentPop.getTimeNeedUnit(), contentPop.getTimeSumUnit())) {
				return "时间约束中，时间单位与 【从流程开始到任务节点完成时间】 设定的时间单位必须相同。";
			}
			// 判断风险清单id是否为空
			if (StringUtils.isBlank(contentPop.getRiskIdTime())) {
				return "时间约束中，关联风险清单不能为空。";
			}

		}

		if (StringUtils.equals(Constant.OPEN, contentPop.getIsEffectiveCompetency())) {
			// 完成任务的岗位
			if (StringUtils.isBlank(contentPop.getPostId())) {
				return "职能约束中，本节点的触发条件信息必须填写，请信息完善后再进行保存。";
			}
			// 告警级别
			if (StringUtils.isBlank(contentPop.getAlarmLevelCompetency())) {
				return "职能约束中，本节点的告警级别信息必须填写，请信息完善后再进行保存。";
			}
			// 当是否是风险项目选中时，风险清单是否关联
			if (StringUtils.equals(contentPop.getIsRiskCompetency(), Constant.OPEN)
					&& StringUtils.isBlank(contentPop.getRiskIdCompetency())) {
				return "职能约束已置为风险项，则必须关联风险清单！";
			}

		}

		if (StringUtils.equals(Constant.OPEN, contentPop.getIsEffectiveAction())) {
			// 匹配的规则公式
			if (StringUtils.isBlank(contentPop.getComputeRuleAction())) {
				return "行为约束中，本节点的触发条件信息必须填写，请信息完善后再进行保存。";
			}
			// 告警级别
			if (StringUtils.isBlank(contentPop.getAlarmLevelAction())) {
				return "行为约束中，本节点的告警级别信息必须填写，请信息完善后再进行保存。";
			}
			// 当是否是风险项目选中时，风险清单是否关联
			if (StringUtils.equals(contentPop.getIsRiskAction(), Constant.OPEN)
					&& StringUtils.isBlank(contentPop.getRiskIdAction())) {
				return "行为约束已置为风险项，则必须关联风险清单！";
			}

		}

		if (StringUtils.equals(Constant.OPEN, contentPop.getIsEffectiveMutually())) {
			// 匹配的规则公式
			if (StringUtils.isBlank(contentPop.getComputeRuleMutually())) {
				return "互证约束中，本节点的触发条件信息必须填写，请信息完善后再进行保存。";
			}
			// 告警级别
			if (StringUtils.isBlank(contentPop.getAlarmLevelMutually())) {
				return "互证约束中，本节点的告警级别信息必须填写，请信息完善后再进行保存。";
			}
			// 当是否是风险项目选中时，风险清单是否关联
			if (StringUtils.equals(contentPop.getIsRiskMutually(), Constant.OPEN)
					&& StringUtils.isBlank(contentPop.getRiskIdMutually())) {
				return "互证约束已置为风险项，则必须关联风险清单！";
			}

		}

		// 如果所有节点都是停用状态则工作流自动变为停用
		if (StringUtils.equals(contentPop.getIsShow(), Constant.CLOSE)) {
			DcaWorkflowTask taskEntity = new DcaWorkflowTask();
			boolean ifShow = false;
			taskEntity.setWfId(contentPop.getWfId());
			List<DcaWorkflowTask> taskList = dcaWorkflowTaskService.findListByWfId(taskEntity);
			for (DcaWorkflowTask task : taskList) {
				if (!StringUtils.equals(task.getUuid(), contentPop.getTaskId())
						&& StringUtils.equals(task.getIsShow(), Constant.OPEN)) {
					ifShow = true;
					break;
				}
			}
			if (!ifShow) {
				// 停止工作流
				DcaWorkflow dcaWorkflow = new DcaWorkflow();
				dcaWorkflow.setWfId(contentPop.getWfId());
				dacWorkflowService.stopWorkFlow(dcaWorkflow);
			}
		}
		return Constant.STRING_TRUE;
	}

	/**
	 * 验证节点名称是否已经存在
	 * 
	 * @param taskName
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "checkTaskName")
	public String checkTaskName(String taskName, String wfId, String taskId) {
		DcaWorkflowTask flowTask = new DcaWorkflowTask();
		flowTask.setUuid(taskId);
		flowTask.setWfId(wfId);
		flowTask.setTaskName(taskName);
		DcaWorkflowTask dcaWorkflowTask = dcaWorkflowTaskService.findWorkflowTaskByTaskName(flowTask);
		if (dcaWorkflowTask != null) {
			return Constant.STRING_TRUE;
		}
		return Constant.STRING_FALSE;
	}

	/**
	 * 通过权力Id获取相关角色列表
	 * 
	 * @param dcaPowerList
	 * @return
	 */
	private List<DcaPowerList> getBizRoleByPowerId(String powerId) {
		DcaPowerList dcaPowerList = new DcaPowerList();
		dcaPowerList.setPowerId(powerId);
		List<DcaPowerList> list = dcaPowerListService.getBizRoleByPowerId(dcaPowerList);
		return list;
	}

	/**
	 * 取得时间
	 * 
	 * @param levelAndTimes
	 * @param i
	 * @param x
	 * @param y
	 * @return
	 */
	private static String getTime(String[] levelAndTimes, int i, int x, int y) {
		return levelAndTimes[i].split(Constant.COLON)[x].split(Constant.MINUS)[y];
	}

	/**
	 * 时间校验
	 * 
	 * @param sum
	 * @param start1
	 * @param end1
	 * @param start2
	 * @param end2
	 * @param start3
	 * @param end3
	 * @return
	 */
	private static boolean checkTime(Long sum, String start1, String end1, String start2, String end2, String start3,
			String end3) {

		if (StringUtils.isBlank(start1) || !isNumeric(start1) || Integer.parseInt(start1) > sum) {
			return false;
		}
		if (StringUtils.isBlank(end1) || !isNumeric(end1) || Integer.parseInt(start1) > Integer.parseInt(end1)
				|| Integer.parseInt(end1) > sum) {
			return false;
		}
		if (Integer.parseInt(end1) == sum && StringUtils.isBlank(start2) && StringUtils.isBlank(end2)
				&& StringUtils.isBlank(start3) && StringUtils.isBlank(end3)) {
			return true;
		}
		if (StringUtils.isBlank(start2) || !isNumeric(start2) || Integer.parseInt(start2) > sum
				|| Integer.parseInt(start2) - Integer.parseInt(end1) != 1) {
			return false;
		}
		if (StringUtils.isBlank(end2) || !isNumeric(end2) || Integer.parseInt(start2) > Integer.parseInt(end2)
				|| Integer.parseInt(end2) > sum) {
			return false;
		}
		if (Integer.parseInt(end2) == sum && StringUtils.isBlank(start3) && StringUtils.isBlank(end3)) {
			return true;
		}
		if (StringUtils.isBlank(start3) || !isNumeric(start3) || Integer.parseInt(start3) > sum
				|| Integer.parseInt(start3) - Integer.parseInt(end2) != 1) {
			return false;
		}
		if (StringUtils.isBlank(end3) || !isNumeric(end3) || Integer.parseInt(start3) > Integer.parseInt(end3)
				|| Integer.parseInt(end3) != sum) {
			return false;
		}
		return true;
	}

	/**
	 * 是否为整数
	 * 
	 * @param str
	 * @return
	 */
	private static boolean isNumeric(String str) {
		Pattern pattern = Pattern.compile("[0-9]*");
		Matcher isNum = pattern.matcher(str);
		if (!isNum.matches()) {
			return false;
		}
		return true;
	}

	/**
	 * 判断是否为空
	 * 
	 */
	private static boolean isBlankOrZero(Long value) {
		if (value == null || value == 0) {
			return true;
		} else {
			return false;
		}
	}
}