/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.visualization.entity.DcaSimpleCountEntity;
import com.hepowdhc.dcapp.modules.workflow.dao.DcaPowerBizDataCountDao;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaPowerBizDataCountEntity;
import com.thinkgem.jeesite.common.service.CrudService;

/**
 * 业务数据统计service
 * 
 * @author geshuo
 * @date 2017年1月5日
 */
@Service
@Transactional(readOnly = true)
public class DcaPowerBizDataCountService extends CrudService<DcaPowerBizDataCountDao, DcaPowerBizDataCountEntity> {
	/**
	 * 根据节点名称查询业务数据量
	 * 
	 * @param taskNameList
	 * @return
	 * @author geshuo
	 * @date 2017年1月5日
	 */
	public List<DcaSimpleCountEntity> getDataCountByTaskName(List<String> taskNameList) {
		return dao.getDataCountByTaskName(taskNameList);
	}
	
	/**
	 * 获取业务数据总数
	 * 
	 * @return
	 * @author liuc
	 * @date 2017年1月6日
	 */
	public String getBizDataCount() {
		return dao.getBizDataCount();
	}
	
	/**
	 * 获取业务数据最近10次列表
	 * 
	 * @return
	 * @author liuc
	 * @date 2017年1月6日
	 */
	public List<Integer> getBizDataLastList(){
		return dao.getBizDataLastList();
	}
}