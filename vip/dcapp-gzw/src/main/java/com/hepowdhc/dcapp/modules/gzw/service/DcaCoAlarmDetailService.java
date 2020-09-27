package com.hepowdhc.dcapp.modules.gzw.service;

import java.util.List;

import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaCountByPowerEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.gzw.dao.DcaCoAlarmDetailDao;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoAlarmDetailEntity;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoAlarmLevelCountEntity;
import com.thinkgem.jeesite.common.service.CrudService;

/**
 * 告警信息表Service
 * 
 * @author geshuo
 * @date 2017年1月3日
 */
@Service
@Transactional(readOnly = true)
public class DcaCoAlarmDetailService extends CrudService<DcaCoAlarmDetailDao, DcaCoAlarmDetailEntity> {

	@Autowired
	protected DcaCoAlarmDetailDao dcaCoAlarmDetailDao;

	/**
	 * 查询告警等级统计数据 （首页用）
	 * 
	 * @return
	 * @author geshuo
	 * @date 2017年1月3日
	 */
	public List<DcaCoAlarmLevelCountEntity> getAlarmLevelDataCount() {
		return dcaCoAlarmDetailDao.getAlarmLevelDataCount();
	}

	/**
	 * 根据企业id查询告警统计数据
	 * 
	 * @param coId
	 * @return
	 * @author geshuo
	 * @date 2017年1月4日
	 */
	public List<DcaCountByPowerEntity> getAlarmCountByCoId(String coId) {
		return dcaCoAlarmDetailDao.getAlarmCountByCoId(coId);
	}

}