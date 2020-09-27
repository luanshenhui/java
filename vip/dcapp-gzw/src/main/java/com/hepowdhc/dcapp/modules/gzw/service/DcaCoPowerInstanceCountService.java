package com.hepowdhc.dcapp.modules.gzw.service;

import java.util.List;

import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaCountByPowerEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.gzw.dao.DcaCoPowerInstanceCountDao;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoPowerInstanceCountEntity;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCoPowerInstanceDataCountEntity;
import com.thinkgem.jeesite.common.service.CrudService;

/**
 * 企业业务实例表Service
 * 
 * @author geshuo
 * @date 2017年1月3日
 */
@Service
@Transactional(readOnly = true)
public class DcaCoPowerInstanceCountService
		extends CrudService<DcaCoPowerInstanceCountDao, DcaCoPowerInstanceCountEntity> {

	@Autowired
	protected DcaCoPowerInstanceCountDao dcaCoPowerInstanceCountDao;

	/**
	 * 查询业务数据量统计数据 （首页用）
	 * 
	 * @return
	 * @author geshuo
	 * @date 2017年1月3日
	 */
	public List<DcaCoPowerInstanceDataCountEntity> getBizDataCount() {
		return dcaCoPowerInstanceCountDao.getBizDataCount();
	}

	/**
	 * 根据企业id查询业务事项统计数据
	 * 
	 * @param coId
	 * @return
	 * @author geshuo
	 * @date 2017年1月4日
	 */
	public List<DcaCountByPowerEntity> getInstanceCountByCoId(String coId) {
		return dcaCoPowerInstanceCountDao.getInstanceCountByCoId(coId);
	}
}