package com.hepowdhc.dcapp.modules.gzw.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoAlarmDetailEntity;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoAlarmLevelCountEntity;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaCountByPowerEntity;
import com.thinkgem.jeesite.common.persistence.CrudDao;

/**
 * 企业告警信息表DAO接口
 * 
 * @author geshuo
 * @version 2017-01-03
 */
public interface DcaCoAlarmDetailDao extends CrudDao<DcaCoAlarmDetailEntity> {

	/**
	 * 查询告警等级统计数据 （首页用）
	 * 
	 * @return
	 * @author geshuo
	 * @date 2017年1月3日
	 */
	public List<DcaCoAlarmLevelCountEntity> getAlarmLevelDataCount();

	/**
	 * 根据企业id查询告警统计数据
	 * 
	 * @param coId
	 * @return
	 * @author geshuo
	 * @date 2017年1月4日
	 */
	public List<DcaCountByPowerEntity> getAlarmCountByCoId(String coId);

}
