/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.gzw.service;

import java.util.List;
import java.util.Map;

import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaCountByPowerEntity;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.gzw.dao.DcaCoRiskManageDao;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoRiskDataEntity;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoRiskDefineDataEntity;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoRiskManage;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.DateUtils;
import com.thinkgem.jeesite.modules.sys.entity.Dict;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;

/**
 * 企业风险管理Service
 * 
 * @author zhengwei.cui
 * @version 2017-01-03
 */
@Service
@Transactional(readOnly = true)
public class DcaCoRiskManageService extends CrudService<DcaCoRiskManageDao, DcaCoRiskManage> {

	@Autowired
	private DcaCoRiskManageDao dcaCoRiskManageDao;

	/**
	 * 查询各企业风险等级数(首页用)
	 * 
	 * @return
	 */
	public List<DcaCoRiskManage> getCoRiskLevelNum() {
		return dcaCoRiskManageDao.getCoRiskLevelNum();
	}

	/**
	 * 查询各企业风险界定数(首页用)
	 * 
	 * @return
	 */
	public List<DcaCoRiskManage> getCoDefineStatusNum() {
		return dcaCoRiskManageDao.getCoDefineStatusNum();
	}

	/**
	 * 根据企业id查询当前年风险走势统计(首页用)
	 * 
	 * @param dcaCoRiskManage
	 * @return
	 */
	public List<DcaCoRiskManage> getCoRiskTrendReport(DcaCoRiskManage dcaCoRiskManage) {
		return dcaCoRiskManageDao.getCoRiskTrendReport(dcaCoRiskManage);
	}

	/**
	 * 根据企业id查询当前年风险走势统计
	 * 
	 * @param coId
	 * @return
	 */
	public List<DcaCoRiskDataEntity> getRiskTrendReport(String coId) {
		DcaCoRiskManage dcaCoRiskManage = new DcaCoRiskManage();
		// 企业id
		dcaCoRiskManage.setCoId(coId);
		// 当前年份
		dcaCoRiskManage.setCurYear(DateUtils.getYear());
		// 根据企业id查询当前年风险走势统计
		List<DcaCoRiskManage> list = dcaCoRiskManageDao.getCoRiskTrendReport(dcaCoRiskManage);
		List<DcaCoRiskDataEntity> dataList = Lists.newArrayList();
		// 从字典表中取出三重一大分类
		List<Dict> dictList = DictUtils.getDictList("szyd_class");
		for (Dict dict : dictList) {
			DcaCoRiskDataEntity dataEntity = new DcaCoRiskDataEntity();
			// 定义数组存放12个月的统计数据
			Integer[] array = new Integer[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
			for (DcaCoRiskManage dca : list) {
				if (dict.getValue().equals(dca.getPowerId())) {
					// 把对应月份的数据放到数组对应位置
					array[dca.getMonth() - 1] = dca.getPowerNum();
				}
			}
			dataEntity.setName(dict.getLabel());
			dataEntity.setData(array);
			dataList.add(dataEntity);
		}
		return dataList;
	}

	/**
	 * 根据企业id查询当前年风险界定统计
	 * 
	 * @param coId
	 * @return
	 */
	public List<DcaCoRiskDefineDataEntity> getCoRiskDefinedReport(String coId) {
		DcaCoRiskManage dcaCoRiskManage = new DcaCoRiskManage();
		// 企业id
		dcaCoRiskManage.setCoId(coId);
		// 当前年份
		dcaCoRiskManage.setCurYear(DateUtils.getYear());
		List<DcaCoRiskManage> list = dcaCoRiskManageDao.getCoRiskDefinedReport(dcaCoRiskManage);

		List<DcaCoRiskDefineDataEntity> resultList = Lists.newArrayList();

		for (int i = 1; i <= 12; i++) {
			DcaCoRiskDefineDataEntity entity = new DcaCoRiskDefineDataEntity();
			int riskNum = 0, nonRiskNum = 0, notDefined = 0;
			for (DcaCoRiskManage dca : list) {
				if (i == dca.getMonth() && Constant.DEFINE_STATUS_1.equals(dca.getDefineStatus())) {
					riskNum = dca.getPowerNum();
				}
				if (i == dca.getMonth() && Constant.DEFINE_STATUS_2.equals(dca.getDefineStatus())) {
					nonRiskNum = dca.getPowerNum();
				}
				if (i == dca.getMonth() && Constant.DEFINE_STATUS_3.equals(dca.getDefineStatus())) {
					notDefined = dca.getPowerNum();
				}
			}
			entity.setMonth(String.valueOf(i));
			entity.setRiskNum(String.valueOf(riskNum));
			entity.setNonRiskNum(String.valueOf(nonRiskNum));
			entity.setNotDefined(String.valueOf(notDefined));
			entity.setTotalNum(String.valueOf(riskNum + nonRiskNum + notDefined));
			resultList.add(entity);
		}

		return resultList;
	}

	/**
	 * 根据权利和各专委会查询各12个月的数据
	 * 
	 * @param dcaCoRiskManage
	 * @return
	 */
	public DcaCoRiskDataEntity getSpeCommitteeRiskByMonth(DcaCoRiskManage dcaCoRiskManage) {

		List<DcaCoRiskManage> list = dcaCoRiskManageDao.getSpeCommitteeRiskByMonth(dcaCoRiskManage);
		DcaCoRiskDataEntity entity = new DcaCoRiskDataEntity();
		Integer[] array = new Integer[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
		for (DcaCoRiskManage dca : list) {
			// 把对应月份的数据放到数组对应位置
			array[dca.getMonth() - 1] = dca.getPowerNum();
		}
		String powerName = ""; // 权利名称
		if (CollectionUtils.isNotEmpty(list)) {
			powerName = DictUtils.getDictLabel(list.get(0).getPowerId(), "szyd_class", "");
		}
		entity.setName(powerName);
		entity.setData(array);
		return entity;
	}

	/**
	 * 根据企业id查询风险统计信息
	 * 
	 * @param coId
	 * @return
	 * @author geshuo
	 * @date 2017年1月4日
	 */
	public List<DcaCountByPowerEntity> getRiskCountByCoId(String coId) {
		return dcaCoRiskManageDao.getRiskCountByCoId(coId);
	}


}