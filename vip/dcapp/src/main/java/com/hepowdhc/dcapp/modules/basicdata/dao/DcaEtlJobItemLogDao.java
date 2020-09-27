/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.basicdata.dao;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

import java.util.List;

import com.hepowdhc.dcapp.modules.basicdata.entity.DcaEtlJobItemLog;

/**
 * 数据版本DAO接口
 * @author dhc
 * @version 2017-01-18
 */
@MyBatisDao
public interface DcaEtlJobItemLogDao extends CrudDao<DcaEtlJobItemLog> {
	
	/**
	 * 获取物理表更新履历
	 * @param dcaEtlJobItemLog
	 * @return
	 */
	public List<DcaEtlJobItemLog> findDetailByStepname(DcaEtlJobItemLog dcaEtlJobItemLog);
	
}