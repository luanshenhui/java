package com.hepowdhc.dcapp.modules.gzw.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoPowerInstanceCountEntity;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoPowerInstanceDataCountEntity;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaCountByPowerEntity;
import com.thinkgem.jeesite.common.persistence.CrudDao;

/**
 * 企业业务实例表DAO接口
 * 
 * @author geshuo
 * @version 2017-01-03
 */
public interface DcaCoPowerInstanceCountDao extends CrudDao<DcaCoPowerInstanceCountEntity> {

	/**
	 * 查询业务数据量统计数据 （首页用）
	 * 
	 * @return
	 * @author geshuo
	 * @date 2017年1月3日
	 */
	public List<DcaCoPowerInstanceDataCountEntity> getBizDataCount();

	/**
	 * 根据企业id查询业务事项统计数据
	 * 
	 * @param coId
	 * @return
	 * @author geshuo
	 * @date 2017年1月4日
	 */
	public List<DcaCountByPowerEntity> getInstanceCountByCoId(String coId);
}
