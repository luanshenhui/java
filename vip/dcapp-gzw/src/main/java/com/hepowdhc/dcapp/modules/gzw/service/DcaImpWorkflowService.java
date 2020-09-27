package com.hepowdhc.dcapp.modules.gzw.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.alarm.entity.DcaAlarmDetail;
import com.hepowdhc.dcapp.modules.gzw.dao.DcaAlarmDetailGZWDao;
import com.hepowdhc.dcapp.modules.gzw.dao.DcaCoAlarmDetailDao;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoAlarmDetailEntity;
import com.thinkgem.jeesite.common.service.CrudService;

/**
 * 告警信息表Service
 * 
 * @author geshuo
 * @date 2017年1月3日
 */
@Service
@Transactional(readOnly = true)
public class DcaImpWorkflowService extends CrudService<DcaCoAlarmDetailDao, DcaCoAlarmDetailEntity> {

	@Autowired
	private DcaAlarmDetailGZWDao dcaAlarmDetailGZWDao;

	/**
	 * 获取告警和风险项（update_date降序取20条）
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2017-01-05
	 */
	public List<DcaAlarmDetail> getAlarmAndRisk(DcaAlarmDetail dcaAlarmDetail) {
		return dcaAlarmDetailGZWDao.getAlarmAndRisk(dcaAlarmDetail);
	}
}