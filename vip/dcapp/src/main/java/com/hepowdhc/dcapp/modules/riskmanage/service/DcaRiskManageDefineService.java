/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.riskmanage.service;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.riskmanage.dao.DcaRiskManageDao;
import com.hepowdhc.dcapp.modules.riskmanage.dao.DcaRiskManageLogDao;
import com.hepowdhc.dcapp.modules.riskmanage.dao.DcaRiskTransDao;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaRiskManage;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaRiskManageLog;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaRiskTrans;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmRiskDefineEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmRiskStatEntity;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.IdGen;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.sys.entity.Office;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 风险管理Service
 * 
 * @author zhengwei.cui
 * @version 2016-11-16
 */
@Service
@Transactional(readOnly = true)
public class DcaRiskManageDefineService extends CrudService<DcaRiskManageDao, DcaRiskManage> {

	@Autowired
	private DcaRiskManageLogDao dcaRiskManageLogDao;
	@Autowired
	private DcaRiskTransDao dcaRiskTransDao;
	@Autowired
	private DcaRiskManageDao dcaRiskManageDao;

	public DcaRiskManage get(String id) {
		return super.get(id);
	}

	public List<DcaRiskManage> findList(DcaRiskManage dcaRiskManage) {
		return super.findList(dcaRiskManage);
	}

	public Page<DcaRiskManage> findPage(Page<DcaRiskManage> page, DcaRiskManage dcaRiskManage) {
		return super.findPage(page, dcaRiskManage);
	}

	@Transactional(readOnly = false)
	public void save(DcaRiskManage dcaRiskManage) {
		super.save(dcaRiskManage);
	}

	@Transactional(readOnly = false)
	public void delete(DcaRiskManage dcaRiskManage) {
		super.delete(dcaRiskManage);
	}

	/**
	 * 根据用户查询列表
	 * 
	 * @param page
	 * @param dcaRiskManage
	 * @return
	 */
	public Page<DcaRiskManage> findListByUser(Page<DcaRiskManage> page, DcaRiskManage dcaRiskManage) {
		dcaRiskManage.setPage(page);
		page.setList(dcaRiskManageDao.findListByUser(dcaRiskManage));
		return page;
	}

	/**
	 * 撤销界定
	 * 
	 * @param dcaRiskManage
	 */
	@Transactional(readOnly = false)
	public void recall(DcaRiskManage dcaRiskManage) {
		// 1：当前数据拷贝到风险管理履历表（共通项目除外），同时，动作描述=“撤销界定”
		DcaRiskManageLog dcaRiskManageLog = new DcaRiskManageLog();
		BeanUtils.copyProperties(dcaRiskManage, dcaRiskManageLog);
		dcaRiskManageLog.setAction(Constant.DEFINE_ACTION_2); // 撤销界定
		dcaRiskManageLog.setDefinePerson(UserUtils.getUser().getId());
		dcaRiskManageLog.setUuid(IdGen.uuid());
		dcaRiskManageLog.setCreatePerson(UserUtils.getUser().getId());
		dcaRiskManageLog.setUpdatePerson(UserUtils.getUser().getId());
		dcaRiskManageLogDao.insert(dcaRiskManageLog);

		// 2：更新风险管理表的当前数据（界定人=空白、界定状态=[未界定]、界定时间=空白、界定材料=空白、补充说明=空白）
		dcaRiskManage.setDefinePerson("");
		dcaRiskManage.setDefineStatus(Constant.DEFINE_STATUS_3);
		dcaRiskManage.setDefineDate(null);
		dcaRiskManage.setEvidence("");
		dcaRiskManage.setExplains("");
		dcaRiskManage.setUpdatePerson(UserUtils.getUser().getId());
		dcaRiskManageDao.update(dcaRiskManage);
	}

	/**
	 * 风险转发
	 * 
	 * @param dcaRiskManage
	 */
	@Transactional(readOnly = false)
	public void riskTrans(DcaRiskManage dcaRiskManage) {
		// 1.插入风险转发表
		List<DcaRiskTrans> dcaRiskTransList = Lists.newArrayList();
		String persons = dcaRiskManage.getBizOperPerson();
		List<String> userIdList = Lists.newArrayList();
		if (persons != null) {
			String[] split = StringUtils.split(persons, ',');
			userIdList = Arrays.asList(split);
		}
		for (String userId : userIdList) {
			User user = UserUtils.get(userId);
			if (user != null) {
				DcaRiskTrans dcaRiskTrans = new DcaRiskTrans();
				// 部门
				dcaRiskTrans.setOffice(user.getOffice().getParent());
				// 岗位
				dcaRiskTrans.setPostId(user.getOffice().getId());
				dcaRiskTrans.setUser(user);
				dcaRiskTrans.setRiskManageId(dcaRiskManage.getRiskManageId());// 风险管理ID
				dcaRiskTrans.setIsDefinePower(dcaRiskManage.getIsDefinePower());
				dcaRiskTrans.setUuid(IdGen.uuid());
				dcaRiskTrans.setCreatePerson(UserUtils.getUser().getId());
				dcaRiskTrans.setUpdatePerson(UserUtils.getUser().getId());
				dcaRiskTransList.add(dcaRiskTrans);
			}
		}
		dcaRiskTransDao.insertBatch(dcaRiskTransList);

		// 2.插入风险管理履历表，动作描述=“风险转发（风险转发人：login user）”
		DcaRiskManage riskManage = get(dcaRiskManage.getRiskManageId());
		DcaRiskManageLog dcaRiskManageLog = new DcaRiskManageLog();
		BeanUtils.copyProperties(riskManage, dcaRiskManageLog);
		dcaRiskManageLog.setAction(Constant.DEFINE_ACTION_3); // 转发界定
		dcaRiskManageLog.setDefinePerson(UserUtils.getUser().getId());
		dcaRiskManageLog.setUuid(IdGen.uuid());
		dcaRiskManageLog.setCreatePerson(UserUtils.getUser().getId());
		dcaRiskManageLog.setUpdatePerson(UserUtils.getUser().getId());
		dcaRiskManageLogDao.insert(dcaRiskManageLog);

		// 3.更新风险管理表的当前数据（风险转发标识=1-转发）
		riskManage.setRiskTransFlag(Constant.RISK_TRANS_FLAG_1);
		riskManage.setUpdatePerson(UserUtils.getUser().getId());
		dcaRiskManageDao.update(riskManage);
	}

	/**
	 * 告警风险统计(权力):平台风险统计
	 * 
	 * @return
	 * @author geshuo
	 * @date 2016年12月5日
	 */
	public List<DcaAlarmRiskStatEntity> findRiskStatData() {
		return dcaRiskManageDao.findRiskStatData();
	}

	/**
	 * 告警风险统计(部门):风险界定统计
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2016年12月5日
	 */
	public List<DcaAlarmRiskDefineEntity> findRiskDefineData(DcaAlarmRiskDefineEntity entity) {
		return dcaRiskManageDao.findRiskDefineData(entity);
	}

	/**
	 * 告警风险统计(部门):告警风险年度统计
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2016年12月7日
	 */
	public List<DcaAlarmRiskDefineEntity> findRiskCount(DcaAlarmRiskDefineEntity entity) {

		return dcaRiskManageDao.findRiskcount(entity);
	}

	/**
	 * 告警风险统计(部门):告警风险年分统计
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2016年12月7日
	 */
	public DcaAlarmRiskDefineEntity findRiskMonthCount(DcaAlarmRiskDefineEntity entity) {

		List<DcaAlarmRiskDefineEntity> monthCount = dcaRiskManageDao.findRiskMonthcount(entity);

		DcaAlarmRiskDefineEntity dataEntity = new DcaAlarmRiskDefineEntity();
		// 定义数组存放12个月的统计数据
		Integer[] riskArray = new Integer[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
		Integer[] alarmArray = new Integer[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
		for (DcaAlarmRiskDefineEntity dca : monthCount) {
			riskArray[dca.getMonth() - 1] = dca.getRiskMonthCount();
			alarmArray[dca.getMonth() - 1] = dca.getAlarmMonthCount();
		}
		dataEntity.setRiskArray(riskArray);
		dataEntity.setAlarmArray(alarmArray);

		return dataEntity;
	}

	/**
	 * 告警风险统计(部门):获取下属部门
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2016年12月22日
	 */
	public List<Office> findParent(String officeId) {
		List<Office> list = dcaRiskManageDao.findParent(officeId);

		return list;
	}
}