/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.gzw.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.gzw.entity.DcaCompany;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * 单表生成DAO接口
 * @author ThinkGem
 * @version 2017-01-02
 */
@MyBatisDao
public interface DcaCompanyYearDao extends CrudDao<DcaCompany> {
	/**
	 * 企业检索
	 * 
	 * @param dcaCompany
	 * @return
	 *
	 */
	public String findCount(DcaCompany dcaCompany);
	
	/**
	 * 
	 * 企业检索月单位
	 * 
	 * @param dcaCompany
	 * @return
	 *
	 */
	public String findCountYM(DcaCompany dcaCompany);
	
	/**
	 * 企业问题总数检索
	 * 
	 * @param companyID
	 * @return
	 *
	 */
	public String findSum(String companyID);
	
	/**
	 * 更新数据
	 * @param dcaCompany
	 * @return
	 */
	public int update(DcaCompany dcaCompany);
	
	/**
	 * 履历表插入
	 * @param dcaCompany
	 * @return
	 */
	public void backup(DcaCompany dcaCompany);
	
	/**
	 * 企业年度查询
	 * @param dcaCompany
	 * @return
	 */
	public List<DcaCompany> findListY(DcaCompany dcaCompany);
	
}