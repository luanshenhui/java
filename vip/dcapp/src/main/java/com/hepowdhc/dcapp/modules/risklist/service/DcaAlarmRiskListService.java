/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.risklist.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.risklist.dao.DcaAlarmRiskListDao;
import com.hepowdhc.dcapp.modules.risklist.entity.DcaAlarmRiskList;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.IdGen;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 风险清单管理Service
 * 
 * @author shiqiang.zhang
 * @version 2016-11-08
 */
@Service
@Transactional(readOnly = true)
public class DcaAlarmRiskListService extends CrudService<DcaAlarmRiskListDao, DcaAlarmRiskList> {

	public DcaAlarmRiskList get(String id) {
		return super.get(id);
	}

	public List<DcaAlarmRiskList> findList(DcaAlarmRiskList dcaAlarmRiskList) {
		return super.findList(dcaAlarmRiskList);
	}

	public Page<DcaAlarmRiskList> findPage(Page<DcaAlarmRiskList> page, DcaAlarmRiskList dcaAlarmRiskList) {
		return super.findPage(page, dcaAlarmRiskList);
	}

	/**
	 * 保存数据
	 */
	@Transactional(readOnly = false)
	public void save(DcaAlarmRiskList dcaAlarmRiskList) {
		if (StringUtils.isBlank(dcaAlarmRiskList.getId())) {
			dcaAlarmRiskList.setRiskId(IdGen.uuid());
			dcaAlarmRiskList.setCreatePerson(UserUtils.getUser().getId());
			dcaAlarmRiskList.setUpdatePerson(UserUtils.getUser().getId());
			dao.insert(dcaAlarmRiskList);
		} else {
			dcaAlarmRiskList.setUpdatePerson(UserUtils.getUser().getId());
			dao.update(dcaAlarmRiskList);
		}
	}

	@Transactional(readOnly = false)
	public void delete(DcaAlarmRiskList dcaAlarmRiskList) {
		super.delete(dcaAlarmRiskList);
	}

	/**
	 * 根据风险名称和权力id查询风险清单信息
	 * 
	 * @param riskName
	 * @param powerId
	 * @return
	 */
	public DcaAlarmRiskList getByName(String riskName, String powerId) {
		DcaAlarmRiskList dca = new DcaAlarmRiskList();
		dca.setRiskName(riskName);
		dca.setPowerId(powerId);
		return dao.getByName(dca);
	}

	/**
	 * 根据权力Id查询风险清单信息
	 * 
	 * @param powerId
	 * @return
	 */
	public List<DcaAlarmRiskList> getRiskByPowerId(String powerId) {
		DcaAlarmRiskList dca = new DcaAlarmRiskList();
		dca.setPowerId(powerId);
		return dao.getRiskByPowerId(dca);
	}

}