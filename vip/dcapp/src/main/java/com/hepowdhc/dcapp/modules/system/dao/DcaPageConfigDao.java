/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.system.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.system.entity.DcaPageConfig;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.sys.entity.Office;

/**
 * 页面设置DAO接口
 * 
 * @author zhengwei.cui
 * @version 2016-12-26
 */
@MyBatisDao
public interface DcaPageConfigDao extends CrudDao<DcaPageConfig> {

	/**
	 * 批量插入
	 * 
	 * @param DcaPageConfigList
	 * @return
	 */
	public int insertBatch(List<DcaPageConfig> list);

	/**
	 * 获取首页配置数据
	 */
	public List<DcaPageConfig> getAllData();

	/**
	 * 部门风险占比数据查询（降序）
	 */
	public List<DcaPageConfig> getInvolveDeptData();

	/**
	 * 查询部门列表
	 * 
	 * @return
	 */
	public List<Office> getOfficeList();

	/**
	 * 删除表中全部数据
	 */
	public void delectAll();

}