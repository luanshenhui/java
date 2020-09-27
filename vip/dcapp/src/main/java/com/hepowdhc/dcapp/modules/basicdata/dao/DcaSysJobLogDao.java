/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.basicdata.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.basicdata.entity.DcaSysJobLog;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * 数据加载页面DAO接口
 * 
 * @author huidan.pang
 * @version 2016-11-07
 */
@MyBatisDao
public interface DcaSysJobLogDao extends CrudDao<DcaSysJobLog> {
	/**
	 * 查询节点数据
	 * 
	 * @param dcaSysJobLog
	 * @return
	 *
	 */
	public List<DcaSysJobLog> showdetial(DcaSysJobLog dcaSysJobLog);

}