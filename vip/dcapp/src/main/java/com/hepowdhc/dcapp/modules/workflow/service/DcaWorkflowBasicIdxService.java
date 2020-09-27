/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.workflow.dao.DcaWorkflowBasicIdxDao;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaWorkflowBasicIdx;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;

/**
 * 告警指标管理Service
 * 
 * @author hanxin'an
 * @version 2016-11-08
 */
@Service
@Transactional(readOnly = true)
public class DcaWorkflowBasicIdxService extends CrudService<DcaWorkflowBasicIdxDao, DcaWorkflowBasicIdx> {

	@Autowired
	protected DcaWorkflowBasicIdxDao dcaWorkflowBasicIdxDao;

	/**
	 * 取得单条告警指标信息
	 * 
	 */
	public DcaWorkflowBasicIdx get(String id) {
		return super.get(id);
	}

	/**
	 * 告警指标列表信息
	 * 
	 */
	public List<DcaWorkflowBasicIdx> findList(DcaWorkflowBasicIdx dcaWorkflowBasicIdx) {
		return super.findList(dcaWorkflowBasicIdx);
	}

	/**
	 * 告警指标名称校验
	 * 
	 */
	public boolean getCheckName(String name) {

		List<DcaWorkflowBasicIdx> list = dcaWorkflowBasicIdxDao.checkName(name);

		// 查询结果是0件以上的场合，存在相同名称
		if (list != null && list.size() > 0) {

			return true;
		}
		return false;
	}

	/**
	 * 告警指标名删除校验
	 * 
	 */
	public boolean checkTaskContent(String name) {

		List<String> list = dcaWorkflowBasicIdxDao.checkTaskContent(name);

		// 查询结果是0件以上的场合，存在相同名称
		if (list != null && list.size() > 0) {

			return true;
		}

		return false;
	}

	/**
	 * 告警指标信息
	 * 
	 */
	public Page<DcaWorkflowBasicIdx> findPage(Page<DcaWorkflowBasicIdx> page, DcaWorkflowBasicIdx dcaWorkflowBasicIdx) {
		return super.findPage(page, dcaWorkflowBasicIdx);
	}

	/**
	 * 告警指标信息保存处理
	 * 
	 */
	@Transactional(readOnly = false)
	public void save(DcaWorkflowBasicIdx dcaWorkflowBasicIdx) {
		super.save(dcaWorkflowBasicIdx);
	}

	/**
	 * 告警指标信息删除处理
	 * 
	 */
	@Transactional(readOnly = false)
	public void delete(DcaWorkflowBasicIdx dcaWorkflowBasicIdx) {
		super.delete(dcaWorkflowBasicIdx);
	}

}