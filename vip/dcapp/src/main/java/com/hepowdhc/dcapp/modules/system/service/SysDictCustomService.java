/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.system.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.system.dao.SysDictCustomDao;
import com.hepowdhc.dcapp.modules.system.entity.SysDictCustom;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;

/**
 * 定制字典表Service
 * 
 * @author dhc
 * @version 2017-01-09
 */
@Service
@Transactional(readOnly = true)
public class SysDictCustomService extends CrudService<SysDictCustomDao, SysDictCustom> {

	@Autowired
	private SysDictCustomDao sysDictCustomDao;

	public SysDictCustom get(String id) {
		return super.get(id);
	}

	public List<SysDictCustom> findList(SysDictCustom sysDictCustom) {
		return super.findList(sysDictCustom);
	}

	public Page<SysDictCustom> findPage(Page<SysDictCustom> page, SysDictCustom sysDictCustom) {
		return super.findPage(page, sysDictCustom);
	}

	@Transactional(readOnly = false)
	public void save(SysDictCustom sysDictCustom) {
		super.save(sysDictCustom);
	}

	@Transactional(readOnly = false)
	public void delete(SysDictCustom sysDictCustom) {
		super.delete(sysDictCustom);
	}

	/**
	 * 通过type获取列表
	 */
	public List<SysDictCustom> findListByType(SysDictCustom sysDictCustom) {
		List<SysDictCustom> result = sysDictCustomDao.findListByType(sysDictCustom);
		return result;
	}

	/**
	 * 根据label和type查询
	 * 
	 * @param sysDictCustom
	 * @return
	 */
	public List<SysDictCustom> findByLableAndType(SysDictCustom sysDictCustom) {
		return dao.findByLableAndType(sysDictCustom);
	}
}