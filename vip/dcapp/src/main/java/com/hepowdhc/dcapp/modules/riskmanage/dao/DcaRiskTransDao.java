/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.riskmanage.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaRiskTrans;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * 风险转发DAO接口
 * 
 * @author ThinkGem
 * @version 2016-11-22
 */
@MyBatisDao
public interface DcaRiskTransDao extends CrudDao<DcaRiskTrans> {

	/**
	 * 批量插入
	 * 
	 * @param dcaRiskTransList
	 * @return
	 */
	public int insertBatch(List<DcaRiskTrans> dcaRiskTransList);
}