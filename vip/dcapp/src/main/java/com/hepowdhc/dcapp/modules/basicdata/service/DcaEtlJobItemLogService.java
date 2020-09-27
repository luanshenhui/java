/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.basicdata.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.hepowdhc.dcapp.modules.basicdata.entity.DcaEtlJobItemLog;
import com.hepowdhc.dcapp.modules.basicdata.dao.DcaEtlJobItemLogDao;

/**
 * 数据版本Service
 * @author dhc
 * @version 2017-01-18
 */
@Service
@Transactional(readOnly = true)
public class DcaEtlJobItemLogService extends CrudService<DcaEtlJobItemLogDao, DcaEtlJobItemLog> {
	
	@Autowired
	public DcaEtlJobItemLogDao dcaEtlJobItemLogDao;

	/**
	 * 获取数据列表
	 * @param dcaEtlJobItemLog
	 * @param page
	 * @return
	 */
	public Page<DcaEtlJobItemLog> findPage(Page<DcaEtlJobItemLog> page, DcaEtlJobItemLog dcaEtlJobItemLog) {
		return super.findPage(page, dcaEtlJobItemLog);
	}

	/**
	 * 获取物理表更新履历
	 * @param dcaEtlJobItemLog
	 * @return
	 */
	public List<DcaEtlJobItemLog> findDetailByStepname(DcaEtlJobItemLog dcaEtlJobItemLog) {
		List<DcaEtlJobItemLog> result = dcaEtlJobItemLogDao.findDetailByStepname(dcaEtlJobItemLog);
		return result;
	}
	
}