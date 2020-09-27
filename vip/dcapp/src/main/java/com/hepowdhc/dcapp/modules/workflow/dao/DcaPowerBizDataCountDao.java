/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.workflow.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.visualization.entity.DcaSimpleCountEntity;
import com.hepowdhc.dcapp.modules.workflow.entity.DcaPowerBizDataCountEntity;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

@MyBatisDao
public interface DcaPowerBizDataCountDao extends CrudDao<DcaPowerBizDataCountEntity> {

	/**
	 * 根据节点名称查询业务数据量
	 * 
	 * @param taskNameList
	 * @return
	 * @author geshuo
	 * @date 2017年1月5日
	 */
	public List<DcaSimpleCountEntity> getDataCountByTaskName(List<String> taskNameList);
	

	/**
	 * 获取业务数据总数
	 * 
	 * @return
	 * @author liuc
	 * @date 2017年1月6日
	 */
	public String getBizDataCount();
	
	/**
	 * 获取业务数据最近10次列表
	 * 
	 * @return
	 * @author liuc
	 * @date 2017年1月6日
	 */
	public List<Integer> getBizDataLastList();

}