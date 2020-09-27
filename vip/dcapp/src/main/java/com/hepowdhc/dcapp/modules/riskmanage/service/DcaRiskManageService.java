/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.riskmanage.service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.riskmanage.dao.DcaRiskManageDao;
import com.hepowdhc.dcapp.modules.riskmanage.dao.DcaRiskManageLogDao;
import com.hepowdhc.dcapp.modules.riskmanage.dao.DcaRiskTransDao;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaCountByPowerEntity;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaRiskManage;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaRiskManageLog;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaRiskTrans;
import com.hepowdhc.dcapp.modules.riskmanage.entity.RiskDataEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmRiskStatEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaAlarmTypeCountEntity;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaReportRiskMes;
import com.hepowdhc.dcapp.modules.visualization.entity.DcaSimpleCountEntity;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.IdGen;
import com.thinkgem.jeesite.modules.sys.dao.DcaTraceUserRoleDao;
import com.thinkgem.jeesite.modules.sys.entity.DcaTraceUserRole;
import com.thinkgem.jeesite.modules.sys.entity.Dict;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 风险管理Service
 * 
 * @author zhengwei.cui
 * @version 2016-11-16
 */
@Service
@Transactional(readOnly = true)
public abstract class DcaRiskManageService extends CrudService<DcaRiskManageDao, DcaRiskManage> {

	@Autowired
	private DcaRiskManageLogDao dcaRiskManageLogDao;
	@Autowired
	private DcaRiskTransDao dcaRiskTransDao;
	@Autowired
	protected DcaRiskManageDao dcaRiskManageDao;
	@Autowired
	private DcaTraceUserRoleDao dcaTraceUserRoleDao;

	@Override
	public DcaRiskManage get(String id) {
		return super.get(id);
	}

	@Override
	public List<DcaRiskManage> findList(DcaRiskManage dcaRiskManage) {
		return getOfficeNameAll(super.findList(dcaRiskManage));
	}

	@Override
	public Page<DcaRiskManage> findPage(Page<DcaRiskManage> page, DcaRiskManage dcaRiskManage) {
		Page<DcaRiskManage> pageObj = super.findPage(page, dcaRiskManage);
		List<DcaRiskManage> list = getOfficeNameAll(pageObj.getList());
		pageObj.setList(list);
		return pageObj;
	}

	@Override
	@Transactional(readOnly = false)
	public void save(DcaRiskManage dcaRiskManage) {
		super.save(dcaRiskManage);
	}

	@Override
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
        long count = page.getCount();
		// 查询风险管理表的数据
		List<DcaRiskManage> findList = dcaRiskManageDao.findList(dcaRiskManage);
        count += page.getCount();
        // 根据登录用户查询风险转发表
		List<DcaRiskManage> findListByUser = dcaRiskManageDao.findListByUser(dcaRiskManage);
        count += page.getCount();
        // 将两个list合并
		findList.addAll(findListByUser);

		/* add start by geshuo 20161228:显示部门全路径 ------------------------- */
		findList = getOfficeNameAll(findList);
		/* add end by geshuo 20161228:显示部门全路径 ------------------------- */

		page.setCount(count);
		page.setList(findList);
		return page;
	}

	/**
	 * 查询部门全部所属关系
	 * 
	 * @param findList
	 * @return
	 * @author geshuo
	 * @date 2016年12月28日
	 */
	private List<DcaRiskManage> getOfficeNameAll(List<DcaRiskManage> findList) {
		/* add start by geshuo 20161228:显示部门全路径 ------------------------- */
		for (DcaRiskManage riskBean : findList) {
			// 取出部门全路径id
			String[] ids = StringUtils.split(riskBean.getParentIds(), ",");
			if (ids == null) {
				continue;
			}
			List<String> parentIdList = Arrays.asList(ids);

			List<String> officeList = dcaRiskManageDao.getParentOfficeList(parentIdList);
			if (officeList == null) {
				continue;
			}
			String officeNameAll = "";
			for (String officeName : officeList) {
				if (StringUtils.isNotEmpty(officeNameAll)) {
					officeNameAll += ">";
				}
				officeNameAll += officeName;
			}
			if (StringUtils.isNotEmpty(officeNameAll)) {
				officeNameAll += ">";
			}
			officeNameAll += riskBean.getBizOperPostName();
			riskBean.setBizOperPostName(officeNameAll);// 设置部门全路径
		}
		/* add end by geshuo 20161228:显示部门全路径 ------------------------- */
		return findList;
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
				dcaRiskTrans.setOffice(user.getOffice());
				// 获取岗位id
				List<DcaTraceUserRole> list = dcaTraceUserRoleDao.findByUserId(userId);
				if (null != list && !list.isEmpty()) {
					dcaRiskTrans.setPostId(list.get(0).getRoleId());
				}
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
	 * 风险走势分析统计
	 * 
	 * @author zhengwei.cui
	 */
	public List<RiskDataEntity> getRiskReportData(String selectYear, String idxDataType) {

		List<DcaRiskManage> list = dcaRiskManageDao.getRiskTrendReport(selectYear,idxDataType);
		List<RiskDataEntity> dataList = Lists.newArrayList();
		// 从字典表中取出权力
		List<Dict> dictList = DictUtils.getDictList(getDictList());
		for (Dict dict : dictList) {
			RiskDataEntity dataEntity = new RiskDataEntity();
			// 定义数组存放12个月的统计数据
			Integer[] array = new Integer[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
			for (DcaRiskManage dca : list) {
				if (dict.getValue().equals(dca.getPowerId())) {
					// 把对应月份的数据放到数组对应位置
					array[dca.getMonth() - 1] = dca.getPowerNum();
				}
			}
			dataEntity.setName(dict.getLabel());
			dataEntity.setType("line");
			dataEntity.setStack("总量");
			dataEntity.setData(array);
			dataList.add(dataEntity);
		}

//		if (CollectionUtils.isNotEmpty(list)){
//			RiskDataEntity dataEntity = new RiskDataEntity();
//			// 定义数组存放12个月的统计数据
//			Integer[] array = new Integer[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
//			for (DcaRiskManage dca : list) {
//				if (idxDataType.equals(dca.getPowerId().substring(0,2))) {
//					// 把对应月份的数据放到数组对应位置
//					array[dca.getMonth() - 1] = dca.getPowerNum();
//				}
//			}
//			// 权利名称
//			String label = "";
//			List<Dict> dictList = DictUtils.getDictList(getDictList());
//			for (Dict dict : dictList) {
//				if (idxDataType.equals(dict.getValue().substring(0,2))){
//					label = dict.getLabel();
//				}
//			}
//			dataEntity.setName(label);
//			dataEntity.setType("line");
//			dataEntity.setStack("总量");
//			dataEntity.setData(array);
//			dataList.add(dataEntity);
//		}

		return dataList;
	}

	protected abstract String getDictList();


	/**
	 * 风险信息表
	 * 
	 * @return
	 * @author liuby
	 * @date 2016年12月7日
	 */
	public Page<DcaReportRiskMes> getRiskMes(Page<DcaReportRiskMes> page, DcaReportRiskMes dcaReportRiskMes) {
		dcaReportRiskMes.setPage(page);

		page.setList(dcaRiskManageDao.getRiskMes(dcaReportRiskMes));

		return page;
	}

	/**
	 * 根据节点名称统计风险数量
	 * 
	 * @param taskNameList
	 * @return
	 * @author geshuo
	 * @date 2017年1月5日
	 */
	public List<DcaSimpleCountEntity> getRiskCountByTaskName(List<String> taskNameList) {
		return dcaRiskManageDao.getRiskCountByTaskName(taskNameList);
	}

	/**
	 * 查询各专委会风险统计数据(气泡图)
	 *
	 * @return
	 * @author geshuo
	 * @date 2017年1月5日
	 */
	public List<DcaCountByPowerEntity> getSpecialCommitteeRisk(Map<String, Object> paramMap) {
		return dcaRiskManageDao.getSpecialCommitteeRisk(paramMap);
	}

	/**
	 * 获取节点风险详细数据
	 * 
	 * @param paramMap
	 * @return
	 */
	public List<DcaAlarmTypeCountEntity> getNodeRiskDetail(Map<String, Object> paramMap) {
		return dcaRiskManageDao.getNodeRiskDetail(paramMap);
	}

}