/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.system.dao;

import java.util.List;

import com.hepowdhc.dcapp.modules.system.entity.SysDictCustom;
import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

/**
 * 定制字典表DAO接口
 * 
 * @author dhc
 * @version 2017-01-09
 */
@MyBatisDao
public interface SysDictCustomDao extends CrudDao<SysDictCustom> {

	/**
	 * 通过type获取列表
	 */
	public List<SysDictCustom> findListByType(SysDictCustom sysDictCustom);

	/**
	 * 根据label和type查询
	 * 
	 * @param sysDictCustom
	 * @return
	 */
	public List<SysDictCustom> findByLableAndType(SysDictCustom sysDictCustom);

}