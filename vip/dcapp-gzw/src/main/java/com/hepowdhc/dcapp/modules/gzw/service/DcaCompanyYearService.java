/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.gzw.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.gzw.dao.DcaCompanyYearDao;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCompany;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;

/**
 * 单表生成Service
 * @author ThinkGem
 * @version 2017-01-02
 */
@Service
@Transactional(readOnly = true)
public class DcaCompanyYearService extends CrudService<DcaCompanyYearDao, DcaCompany> {

	
	public DcaCompany get(String id) {
		DcaCompany dcaCompany = super.get(id);
		return dcaCompany;
	}
	
	public List<DcaCompany> findList(DcaCompany dcaCompany) {
		return super.findList(dcaCompany);
	}
	
	public Page<DcaCompany> findPage(Page<DcaCompany> page, DcaCompany dcaCompany) {
		return super.findPage(page, dcaCompany);
	}
	
	@Transactional(readOnly = false)
	public void save(DcaCompany dcaCompany) {
		super.save(dcaCompany);
	}
	
	@Transactional(readOnly = false)
	public void delete(DcaCompany dcaCompany) {
		super.delete(dcaCompany);
	}
	
	
	/**
	 * 企业检索
	 ** 
	 * @param dcaCompany
	 * @return
	 */
	public String findCount(DcaCompany dcaCompany) {

		String typeCount = dao.findCount(dcaCompany);
		return typeCount;
	}
	
	/**
	 * 企业检索月单位
	 ** 
	 * @param dcaCompany
	 * @return
	 */
	public String findCountYM(DcaCompany dcaCompany) {

		String typeCount = dao.findCountYM(dcaCompany);
		return typeCount;
	}
	
	/**
	 * 企业问题总数检索
	 ** 
	 * @param companyID
	 * @return
	 */
	public String findSum(String companyID) {

		String errSum = dao.findSum(companyID);
		return errSum;
	}
	
	public void update(DcaCompany dcaCompany) {
		dao.update(dcaCompany);
	}
	
	public void backup(DcaCompany dcaCompany) {
		dao.backup(dcaCompany);
	}
	
	public List<DcaCompany> findListY(DcaCompany dcaCompany) {
		return dao.findListY(dcaCompany);
	}
}