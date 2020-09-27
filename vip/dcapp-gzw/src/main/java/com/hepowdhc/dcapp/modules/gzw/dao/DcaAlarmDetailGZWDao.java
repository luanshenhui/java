package com.hepowdhc.dcapp.modules.gzw.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.alarm.entity.DcaAlarmDetail;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoAlarmDetailEntity;
import com.thinkgem.jeesite.common.persistence.CrudDao;

/**
 * 企业告警信息表DAO接口
 * 
 * @author geshuo
 * @version 2017-01-03
 */
public interface DcaAlarmDetailGZWDao extends CrudDao<DcaCoAlarmDetailEntity> {

	/**
	 * 查询风险告警播报
	 * 
	 * @return
	 * @author panghuidan
	 * @date 2017年1月5日
	 */
	public List<DcaAlarmDetail> getAlarmAndRisk(DcaAlarmDetail dcaAlarmDetail);

}
