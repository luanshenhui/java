/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.hepowdhc.dcapp.modules.workflow.dao.DcaWorkflowDao;
import com.hepowdhc.dcapp.modules.workflow.dao.DcaWorkflowTaskContentDao;
import com.hepowdhc.dcapp.modules.workflow.dao.DcaWorkflowTaskDao;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflow;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflowTask;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflowTaskContent;
import com.hepowdhc.dcapp.modules.workflow.entity.Nodes;
import com.hepowdhc.dcapp.modules.workflow.entity.StartCheckJson;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 单表生成Service
 * 
 * @author ThinkGem
 * @version 2016-11-18
 */
@Service
@Transactional(readOnly = true)
public class DcaWorkflowTaskService extends CrudService<DcaWorkflowTaskDao, DcaWorkflowTask> {

	@Autowired
	private DcaWorkflowTaskContentDao contentDao;
	@Autowired
	private DcaWorkflowDao flowDao;

	public DcaWorkflowTask get(String id) {
		return super.get(id);
	}

	public List<DcaWorkflowTask> findList(DcaWorkflowTask dcaWorkflowTask) {
		return super.findList(dcaWorkflowTask);
	}

	public Page<DcaWorkflowTask> findPage(Page<DcaWorkflowTask> page, DcaWorkflowTask dcaWorkflowTask) {
		return super.findPage(page, dcaWorkflowTask);
	}

	@Transactional(readOnly = false)
	public void save(DcaWorkflowTask dcaWorkflowTask) {
		super.save(dcaWorkflowTask);
	}

	@Transactional(readOnly = false)
	public void delete(DcaWorkflowTask dcaWorkflowTask) {
		super.delete(dcaWorkflowTask);
	}

	/**
	 * 更新节点信息保存节点内容
	 * 
	 * @param dcaWorkflowTask
	 * @param insetList
	 * @param updateFlagContent
	 * @param dcaWorkflowTask
	 * @return
	 */
	@Transactional(readOnly = false)
	public int saveTaskAndContent(DcaWorkflowTask dcaWorkflowTask, List<DcaWorkflowTaskContent> contentList,
			int updateFlagContent, int updateFlagTask) {
		int count = 0;
		if (updateFlagTask == 1) {
			count = dao.updateByContent(dcaWorkflowTask);
		} else {
			count = dao.insert(dcaWorkflowTask);
		}
		if (updateFlagContent == 1) {
			count = contentDao.updateContent(contentList);
		} else {
			count = contentDao.insertContent(contentList);
		}

		// 更新json串信息
		DcaWorkflow dcaWorkflow = new DcaWorkflow();
		dcaWorkflow.setWfId(dcaWorkflowTask.getWfId());
		String jsonStr = flowDao.getStratCheckJson(dcaWorkflow);
		StartCheckJson json = (StartCheckJson) JsonMapper.fromJsonString(jsonStr, StartCheckJson.class);
		Map<String, Nodes> node = json.getNodes();
		Nodes nodes = node.get(dcaWorkflowTask.getUuid());
		if (nodes != null) {
			nodes.setName(dcaWorkflowTask.getTaskName());
			String newJson = JsonMapper.toJsonString(json);
			dcaWorkflow.setXmlContent(newJson);
			dcaWorkflow.setUpdatePerson(UserUtils.getUser().getId());
			count = flowDao.updateXml(dcaWorkflow);
		}
		return count;
	}

	/**
	 * 查询节点数据
	 ** 
	 * @param dcaWorkflowTask
	 * @return
	 */
	public List<DcaWorkflowTask> findListByWfId(DcaWorkflowTask dcaWorkflowTask) {
		List<DcaWorkflowTask> dcaWorkflowTaskList = dao.findListByWfId(dcaWorkflowTask);
		return dcaWorkflowTaskList;
	}

	/**
	 * 查询节点ID
	 ** 
	 * @param dcaWorkflowTask
	 * @return
	 */
	public List<String> findUuId(String wfId) {
		DcaWorkflowTask search = new DcaWorkflowTask();
		search.setWfId(wfId);
		List<DcaWorkflowTask> list = dao.findListByWfId(search);
		List<String> uuidList = Lists.newArrayList();
		for (DcaWorkflowTask dcaWorkflowTask : list) {
			uuidList.add(dcaWorkflowTask.getUuid());
		}
		return uuidList;
	}

	/**
	 * 根据节点名称查询
	 * 
	 * @param taskName
	 * @return
	 */
	public DcaWorkflowTask findWorkflowTaskByTaskName(DcaWorkflowTask flowTask) {
		DcaWorkflowTask workflowTask = dao.findWorkflowTaskByTaskName(flowTask);
		return workflowTask;
	}
	
	/**
	 * 根据节点名称查询
	 * 
	 * @param taskName
	 * @return
	 */
	@Transactional(readOnly = false)
	public void deleteTaskByWfId(String wfId) {
		dao.deleteTaskByWfId(wfId);
	}
}