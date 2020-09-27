/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.workflow.dao.DcaWorkflowTaskContentDao;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflowTaskContent;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;

/**
 * 工作流节点内容Service
 * 
 * @author ThinkGem
 * @version 2016-11-17
 */
@Service
@Transactional(readOnly = true)
public class DcaWorkflowTaskContentService extends CrudService<DcaWorkflowTaskContentDao, DcaWorkflowTaskContent> {

	public DcaWorkflowTaskContent get(String id) {
		return super.get(id);
	}

	public List<DcaWorkflowTaskContent> findList(DcaWorkflowTaskContent dcaWorkflowTaskContent) {
		return super.findList(dcaWorkflowTaskContent);
	}

	public Page<DcaWorkflowTaskContent> findPage(Page<DcaWorkflowTaskContent> page,
			DcaWorkflowTaskContent dcaWorkflowTaskContent) {
		return super.findPage(page, dcaWorkflowTaskContent);
	}

	@Transactional(readOnly = false)
	public void save(DcaWorkflowTaskContent dcaWorkflowTaskContent) {
		super.save(dcaWorkflowTaskContent);
	}

	@Transactional(readOnly = false)
	public void delete(DcaWorkflowTaskContent dcaWorkflowTaskContent) {
		super.delete(dcaWorkflowTaskContent);
	}

}