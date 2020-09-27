/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.basicdata.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.basicdata.dao.DcaSysJobLogDao;
import com.hepowdhc.dcapp.modules.basicdata.entity.DcaSysJobLog;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;

/**
 * 数据加载页面
 * 
 * @author huidan.pang
 * @version 2016-11-07
 */

@Service
@Transactional(readOnly = true)
public class DcaSysJobLogService extends CrudService<DcaSysJobLogDao, DcaSysJobLog> {

	public DcaSysJobLog get(String id) {
		return super.get(id);
	}

	public List<DcaSysJobLog> findList(DcaSysJobLog dcaSysJobLog) {
		return super.findList(dcaSysJobLog);
	}

	public Page<DcaSysJobLog> findPage(Page<DcaSysJobLog> page, DcaSysJobLog dcaSysJobLog) {

		return super.findPage(page, dcaSysJobLog);
	}

	@Transactional(readOnly = false)
	public void save(DcaSysJobLog dcaSysJobLog) {
		super.save(dcaSysJobLog);
	}

	@Transactional(readOnly = false)
	public void delete(DcaSysJobLog dcaSysJobLog) {
		super.delete(dcaSysJobLog);
	}

	/**
	 * 显示详细页面
	 ** 
	 * @param dcaSysJobLog
	 * @return
	 */
	public List<DcaSysJobLog> showdetial(DcaSysJobLog dcaSysJobLog) {

		List<DcaSysJobLog> dcaSysJobLogList = dao.showdetial(dcaSysJobLog);
		return dcaSysJobLogList;
	}

}