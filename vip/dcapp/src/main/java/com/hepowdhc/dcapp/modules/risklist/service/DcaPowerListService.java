/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.risklist.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.risklist.dao.DcaPowerListDao;
import com.hepowdhc.dcapp.modules.risklist.entity.DcaPowerList;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.IdGen;

/**
 * 单表查询Service
 * 
 * @author liunan
 * @version 2016-11-08
 */
@Service
@Transactional(readOnly = true)
public class DcaPowerListService extends CrudService<DcaPowerListDao, DcaPowerList> {
	@Autowired
	public DcaPowerListDao dcaPowerListDao;

	public DcaPowerList get(String id) {
		return super.get(id);
	}

	public List<DcaPowerList> findList(DcaPowerList dcaPowerList) {
		return super.findList(dcaPowerList);
	}

	public Page<DcaPowerList> findPage(Page<DcaPowerList> page, DcaPowerList dcaPowerList) {
		return super.findPage(page, dcaPowerList);
	}

	@Transactional(readOnly = false)
	public void delete(DcaPowerList dcaPowerList) {
		super.delete(dcaPowerList);
	}

	@Transactional(readOnly = false)
	public void saveDcaPowerList(DcaPowerList dcaPowerList) {
		super.save(dcaPowerList);

	}

	/**
	 * 通过权力Id获取相关角色列表
	 * 
	 * @param dcaPowerList
	 * @return
	 */
	public List<DcaPowerList> getBizRoleByPowerId(DcaPowerList dcaPowerList) {
		return dcaPowerListDao.getBizRoleByPowerId(dcaPowerList);
	}

	/**
	 * 保存数据（插入或更新）
	 * 
	 * @param entity
	 */
	@Transactional(readOnly = false)
	public void officeSave(DcaPowerList dcaPowerList) {
		if (dcaPowerList.getIsNewRecord()) {
			dcaPowerList.preInsert();
			dcaPowerListDao.insert(dcaPowerList);
			dcaPowerList.setBizRoleId(dcaPowerList.getUuid());
			if (!dcaPowerList.getPostId().matches(",")) {
				String[] postId = dcaPowerList.getPostId().split(",");
				// String[] orgId = dcaPowerList.getOrgId().split(",");
				for (int i = 0; i < postId.length; i++) {
					dcaPowerList.setPostId(postId[i]);
					// dcaPowerList.setOrgId(orgId[i]);
					dcaPowerList.setUuid(IdGen.uuid());
					dcaPowerListDao.insertSave(dcaPowerList);
				}
			} else {
				dcaPowerListDao.insertSave(dcaPowerList);
			}
		} else {
			dcaPowerList.preUpdate();
			dcaPowerListDao.update(dcaPowerList);
			dcaPowerListDao.updateSave(dcaPowerList);
		}
	}

	@Transactional(readOnly = false)
	public void save(DcaPowerList dcaPowerList) {
		super.save(dcaPowerList);
	}

	@Transactional(readOnly = false)
	public void officeDelete(DcaPowerList dcaPowerList) {
		dcaPowerListDao.officeDelete(dcaPowerList);
	}

	/**
	 * 保存数据（插入或更新）
	 * 
	 * @param entity
	 */
	@Transactional(readOnly = false)
	public void importSave(DcaPowerList dcaPowerList) {
		// 插入权责清单表
		saveDcaPowerList(dcaPowerList);
		// 插入业务角色和组织岗位关联关系表
		dcaPowerList.setBizRoleId(dcaPowerList.getUuid());
		if (!dcaPowerList.getRemarks().matches(",")) {
			String[] postIds = dcaPowerList.getRemarks().split(",");
			for (String id : postIds) {
				dcaPowerList.setPostId(id);
				dcaPowerList.setUuid(IdGen.uuid());
				dcaPowerListDao.insertSave(dcaPowerList);
			}
		} else {
			dcaPowerListDao.insertSave(dcaPowerList);
		}
	}
}