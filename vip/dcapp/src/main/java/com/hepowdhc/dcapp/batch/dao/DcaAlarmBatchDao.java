/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.batch.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.alarm.entity.DcaAlarmDetail;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * 告警管理批处理DAO接口
 * @author dhc
 * @version 2016-11-17
 */
@MyBatisDao
public interface DcaAlarmBatchDao extends CrudDao<DcaAlarmDetail> {
	
	public List<DcaAlarmDetail> getDetailInfo(DcaAlarmDetail dcaAlarmDetail);
}