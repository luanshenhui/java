/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmRiskStatEntity;
import com.hepowdhc.dcapp.modules.workflow.dao.DcaWorkflowDao;
import com.hepowdhc.dcapp.modules.workflow.dao.DcaWorkflowTaskDao;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflow;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflowTask;
import com.hepowdhc.dcapp.modules.workflow.entity.Dict;
import com.hepowdhc.dcapp.modules.workflow.entity.Lines;
import com.hepowdhc.dcapp.modules.workflow.entity.Nodes;
import com.hepowdhc.dcapp.modules.workflow.entity.StartCheckJson;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 工作流管理Service
 * 
 * @author shiqiang.zhang
 * @version 2016-11-21
 */
@Service
@Transactional(readOnly = true)
public class DcaWorkflowService extends CrudService<DcaWorkflowDao, DcaWorkflow> {

	/**
	 * 工作流控件type属性
	 */

	public static final String MUTISELECT = "mutiselect";

	@Autowired
	protected DcaWorkflowTaskDao taskDao;

	@Autowired
	private DcaWorkflowTaskService dcaWorkflowTaskService;

	public DcaWorkflow get(String id) {
		return super.get(id);
	}

	public List<DcaWorkflow> findList(DcaWorkflow dcaWorkflow) {
		return super.findList(dcaWorkflow);
	}

	public Page<DcaWorkflow> findPage(Page<DcaWorkflow> page, DcaWorkflow dcaWorkflow) {
		// 列表页
		// Page<DcaWorkflow> returnPage = super.findPage(page, dcaWorkflow);
		return super.findPage(page, dcaWorkflow);
	}

	@Transactional(readOnly = false)
	public void save(DcaWorkflow dcaWorkflow) {
		// 保存工作流
		super.save(dcaWorkflow);
	}

	@Transactional(readOnly = false)
	public void delete(DcaWorkflow dcaWorkflow) {
		super.delete(dcaWorkflow);
	}

	@Transactional(readOnly = false)
	public void updateWF(DcaWorkflow dcaWorkflow) {
		if (dcaWorkflow != null) {
			// 逻辑删除工作流
			dao.updateWF(dcaWorkflow);
			// 逻辑删除工作流节点
			dcaWorkflowTaskService.deleteTaskByWfId(dcaWorkflow.getWfId());
		}
	}

	@Transactional(readOnly = false)
	public void stopWorkFlow(DcaWorkflow dcaWorkflow) {
		// 停止工作流（更新isshow）
		dao.stopWorkFlow(dcaWorkflow);
	}

	@Transactional(readOnly = false)
	public void startWorkFlow(DcaWorkflow dcaWorkflow) {
		// 启动工作流（更新isshow）
		dao.startWorkFlow(dcaWorkflow);
	}

	public int check(DcaWorkflow dcaWorkflow) {
		// 编辑、流程设置、删除通用校验
		return dao.check(dcaWorkflow);
	}

	public int checkStartOne(DcaWorkflow dcaWorkflow) {
		// 启动前校验1
		return dao.checkStartOne(dcaWorkflow);
	}

	public int checkStartTwo(DcaWorkflow dcaWorkflow) {
		// 启动前校验2
		return dao.checkStartTwo(dcaWorkflow);
	}

	public DcaWorkflow checkWfName(String wfName) {
		// 校验工作流名称重复
		// DcaWorkflow oldWorkflow = dao.checkWfName(wfName);
		return dao.checkWfName(wfName);
	}

	public List<Dict> searchDict() {
		// 检索字典表，检索数据类型
		// List<Dict> dict = dao.searchDict();
		return dao.searchDict();
	}

	/**
	 * 时时更新工作流
	 * 
	 * @param workflow 工作流
	 */
	@Transactional(readOnly = false)
	public int UpdateFlow(DcaWorkflow workflow) {
		// int count = 0;
		// 保存工作流
		// count = dao.updateXml(workflow);
		return dao.updateXml(workflow);
	}

	/**
	 * 保存节点更新工作流
	 * 
	 * @param workflow 工作流
	 */
	@Transactional(readOnly = false)
	public int saveTaskAndUpdateFlow(DcaWorkflow workflow, String flowContent, String taskIds, String powerId) {

		List<DcaWorkflowTask> taskList = Lists.newArrayList();

		// 取得工作流已保存的节点信息
		DcaWorkflowTask entity = new DcaWorkflowTask();
		entity.setWfId(workflow.getWfId());
		List<DcaWorkflowTask> oldList = taskDao.findListByWfId(entity);

		// 删除工作流的所有节点
		taskDao.deleteByFlow(workflow.getWfId());

		// 取得有效节点ID
		String[] taskIdStr = taskIds.split(Constant.COMMA);

		// 解析json
		StartCheckJson json = (StartCheckJson) JsonMapper.fromJsonString(flowContent, StartCheckJson.class);
		// 取得连线信息
		Map<String, Lines> lines = json.getLines();
		// 取得节点信息
		Map<String, Nodes> nodes = json.getNodes();

		for (int i = 0; i < taskIdStr.length; i++) {
			// 循环有效节点

			// 初始化节点entity
			DcaWorkflowTask flowTaskForSave = new DcaWorkflowTask();
			String taskId = taskIdStr[i];
			String startNode = Constant.START_TASK_ID;
			String endNode = Constant.END_TASK_ID;
			Nodes node = nodes.get(taskId);
			String type = node.getType();
			// 节点ID
			flowTaskForSave.setUuid(taskId);
			// 工作流ID
			flowTaskForSave.setWfId(workflow.getWfId());
			// 权力ID
			flowTaskForSave.setPowerId(powerId);
			// 排序（好像没什么用）
			flowTaskForSave.setSort((long) (i + 1));
			if (StringUtils.equals(type, Constant.START_ROUND) || StringUtils.equals(type, Constant.END_ROUND)) {
				// 如果是开始或者结束节点的话，节点置为无效
				flowTaskForSave.setIsShow(Constant.CLOSE);
			} else {
				flowTaskForSave.setIsShow(Constant.OPEN);
			}
			// 登录者
			flowTaskForSave.setCreatePerson(UserUtils.getUser().getId());
			// 更新者
			flowTaskForSave.setUpdatePerson(UserUtils.getUser().getId());
			for (DcaWorkflowTask task : oldList) {
				// 循环旧节点信息，把有效的节点数据更新回来
				if (StringUtils.equals(taskId, task.getUuid())) {
					flowTaskForSave.setTaskName(task.getTaskName());
					if (StringUtils.equals(type, Constant.MUTISELECT)) {
						// 如果是节点的话才更新是否有效（开始和结束节点不更新）
						flowTaskForSave.setIsShow(task.getIsShow());
					}
					flowTaskForSave.setBizRoleId(task.getBizRoleId());
					flowTaskForSave.setBizTaskId(task.getBizTaskId());
					break;
				}
			}
			for (Map.Entry<String, Lines> entry : lines.entrySet()) {
				// 循环连线信息，更新节点的连接关系
				Lines line = entry.getValue();
				if (StringUtils.equals(line.getFrom(), taskId)) {
					endNode = line.getTo();
				}
				if (StringUtils.equals(line.getTo(), taskId)) {
					startNode = line.getFrom();
				}
			}
			flowTaskForSave.setPreNodeId(startNode);
			flowTaskForSave.setNextNodeId(endNode);

			taskList.add(flowTaskForSave);
		}

		int count = 0;
		// 保存工作流
		count = dao.updateXml(workflow);
		// 保存节点
		count = taskDao.insertByFlow(taskList);
		return count;
	}

	public DcaWorkflow getWorkFlowById(String wfId) {
		return super.get(wfId);
	}

	// 启动校验
	public int checkStartJson(DcaWorkflow dcaWorkflow, String jsonStr) {
		// 定义开始、结束、中间节点数
		int startCount = 0;
		int endCount = 0;
		int indexEnd = 0;
		String startNode = "";
		String endNode = "";
		List<String> taskNodes = new ArrayList<>();

		if (StringUtils.isBlank(jsonStr)) {
			jsonStr = dao.getStratCheckJson(dcaWorkflow);
		}

		// json为空时
		if (StringUtils.isEmpty(jsonStr)) {
			return 0;
		}
		// 解析json
		StartCheckJson json = (StartCheckJson) JsonMapper.fromJsonString(jsonStr, StartCheckJson.class);

		if (json == null) {
			return 9;
		}
		Map<String, Nodes> node = json.getNodes();
		// 判断是否有节点
		if (node == null || node.size() == 0) {
			return 7;
		}
		Set<String> nobeKeys = node.keySet();
		for (String nodeKey : nobeKeys) {

			Nodes jsonNode = node.get(nodeKey);
			String type = jsonNode.getType();
			// arry.add(type);
			if (Constant.START_ROUND.equals(type)) {
				startNode = nodeKey;
				startCount++;
			} else if (Constant.END_ROUND.equals(type)) {
				endNode = nodeKey;
				endCount++;
			} else if (Constant.MUTISELECT.equals(type)) {
				taskNodes.add(nodeKey);
				indexEnd++;
			}
		}
		// 开始节点是否为1
		if (startCount != 1) {
			return 1;
		}
		// 结束节点是否为1
		if (endCount != 1) {
			return 2;
		}
		// 是否有中间节点
		if (indexEnd <= 0) {
			return 3;
		}
		List<String> fromLines = new ArrayList<>();
		List<String> toLines = new ArrayList<>();
		Map<String, Lines> lines = json.getLines();
		// 判断是否有连线
		if (lines == null || lines.size() == 0) {
			return 8;
		}
		Set<String> lineKeys = lines.keySet();
		for (String lineKey : lineKeys) {
			fromLines.add(lines.get(lineKey).getFrom());
			toLines.add(lines.get(lineKey).getTo());
		}
		// 开始节点连线
		int hasStartCount = 0;
		for (String strv : fromLines) {
			if (startNode.equals(strv)) {
				hasStartCount++;
			}
		}
		if (hasStartCount != 1) {
			return 4;
		}
		// 结束节点连线
		int hasEndCount = 0;
		for (String strv : toLines) {
			if (endNode.equals(strv)) {
				hasEndCount++;
			}
		}
		if (hasEndCount != 1) {
			return 5;
		}
		// 判断中间节点是否连线
		for (String nodeItem : taskNodes) {
			int taskStart = fromLines.indexOf(nodeItem);
			int taskEnd = toLines.indexOf(nodeItem);
			if (taskStart == -1 || taskEnd == -1) {
				return 6;
			}
		}
		return 100;
	}

	/**
	 * 告警风险统计(权力)-业务事项统计
	 * 
	 * @return 统计列表 geshuo 2016年12月6日
	 */
	public List<DcaAlarmRiskStatEntity> findWorkStatData() {
		return dao.findWorkStatData();
	}

	/**
	 * 查询启用的工作流数量
	 * 
	 * @return 启用的工作流数量
	 */
	public Integer findEnabledWorkflowCount() {
		return dao.findEnabledWorkflowCount();
	}

	/**
	 * 三中一大流程图
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2017年1月4日
	 */
	public List<DcaWorkflow> getWorkFlowXML(String powerId) {
		DcaWorkflow dcaWorkflow = new DcaWorkflow();
		dcaWorkflow.setPowerId(powerId);
		return dao.getWorkFlowXML(dcaWorkflow);
	}

	/**
	 * 三中一大流程图:风险个数
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2017年1月4日
	 */
	public List<DcaWorkflow> getWorkFlowRisk(String powerId) {
		String content = "";
		String nodeName = "";
		DcaWorkflow dcaWorkflow = new DcaWorkflow();
		dcaWorkflow.setPowerId(powerId);
		List<DcaWorkflow> workflowXML = dao.getWorkFlowXML(dcaWorkflow);
		if (CollectionUtils.isNotEmpty(workflowXML)) {
			content = workflowXML.get(0).getXmlContent();
			// 解析json
			StartCheckJson json = (StartCheckJson) JsonMapper.fromJsonString(content, StartCheckJson.class);

			Map<String, Nodes> node = json.getNodes();

			Set<String> nobeKeys = node.keySet();
			for (String nodeKey : nobeKeys) {

				Nodes jsonNode = node.get(nodeKey);
				String type = jsonNode.getType();
				// 获取节点name
				if (MUTISELECT.equals(type)) {
					nodeName = jsonNode.getName();
				}
			}
			dcaWorkflow.setWfName(nodeName);
		}

		return null;
	}

}