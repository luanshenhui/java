/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.riskmanage.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.riskmanage.dao.DcaRiskManageLogDao;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaRiskManageLog;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 风险管理履历Service
 * 
 * @author zhengwei.cui
 * @version 2016-11-16
 */
@Service
@Transactional(readOnly = true)
public class DcaRiskManageLogService extends CrudService<DcaRiskManageLogDao, DcaRiskManageLog> {

	public DcaRiskManageLog get(String id) {
		return super.get(id);
	}

	/**
	 * 查询风险操作履历
	 */
	public List<DcaRiskManageLog> findList(DcaRiskManageLog dcaRiskManageLog) {
		List<DcaRiskManageLog> logList = super.findList(dcaRiskManageLog);
		List<DcaRiskManageLog> newList = Lists.newArrayList();
		for (DcaRiskManageLog log : logList) {
			User user = UserUtils.get(log.getCreatePerson());
			if (user != null) {
				log.setCreatePerson(user.getName());
			}
			// 1：界定;2：撤销界定;3：转发界定
			String action = "";
			switch (log.getAction()) {
			case Constant.DEFINE_ACTION_1:
				action = "界定";
				break;
			case Constant.DEFINE_ACTION_2:
				action = "撤销界定";
				break;
			case Constant.DEFINE_ACTION_3:
				action = "转发界定";
				break;
			}
			log.setAction(action);
			newList.add(log);
		}
		return newList;
	}

	public Page<DcaRiskManageLog> findPage(Page<DcaRiskManageLog> page, DcaRiskManageLog dcaRiskManageLog) {
		return super.findPage(page, dcaRiskManageLog);
	}

	/**
	 * 保存数据
	 */
	@Transactional(readOnly = false)
	public void save(DcaRiskManageLog dcaRiskManageLog) {
		super.save(dcaRiskManageLog);
	}

	@Transactional(readOnly = false)
	public void delete(DcaRiskManageLog dcaRiskManageLog) {
		super.delete(dcaRiskManageLog);
	}

}