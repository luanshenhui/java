/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.riskmanage.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.riskmanage.dao.DcaRiskTransDao;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaRiskTrans;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;

/**
 * 风险转发Service
 * 
 * @author ThinkGem
 * @version 2016-11-22
 */
@Service
@Transactional(readOnly = true)
public class DcaRiskTransService extends CrudService<DcaRiskTransDao, DcaRiskTrans> {

	@Autowired
	private DcaRiskTransDao dcaRiskTransDao;

	public DcaRiskTrans get(String id) {
		return super.get(id);
	}

	public List<DcaRiskTrans> findList(DcaRiskTrans dcaRiskTrans) {
		return super.findList(dcaRiskTrans);
	}

	public Page<DcaRiskTrans> findPage(Page<DcaRiskTrans> page, DcaRiskTrans dcaRiskTrans) {
		return super.findPage(page, dcaRiskTrans);
	}

	@Transactional(readOnly = false)
	public void save(DcaRiskTrans dcaRiskTrans) {
		super.save(dcaRiskTrans);
	}

	@Transactional(readOnly = false)
	public void delete(DcaRiskTrans dcaRiskTrans) {
		super.delete(dcaRiskTrans);
	}

	/**
	 * 批量插入
	 * 
	 * @param dcaRiskTransList
	 * @return
	 */
	@Transactional(readOnly = false)
	public int insertBatch(List<DcaRiskTrans> dcaRiskTransList) {
		return dcaRiskTransDao.insertBatch(dcaRiskTransList);
	}

}