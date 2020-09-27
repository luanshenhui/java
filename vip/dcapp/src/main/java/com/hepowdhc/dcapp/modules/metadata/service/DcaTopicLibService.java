/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.metadata.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.metadata.dao.DcaTopicLibDao;
import com.hepowdhc.dcapp.modules.metadata.entity.DcaTopicLib;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;

/**
 * 主题库管理Service
 * 
 * @author lby
 * @version 2016-11-07
 */
@Service
@Transactional(readOnly = true)
public class DcaTopicLibService extends CrudService<DcaTopicLibDao, DcaTopicLib> {

	@Autowired
	protected DcaTopicLibDao dcaTopicLibDao;

	public DcaTopicLib get(String id) {
		return super.get(id);
	}

	public List<DcaTopicLib> findList(DcaTopicLib dcaTopicLib) {
		return super.findList(dcaTopicLib);
	}

	/**
	 * 关联物理表里查询物理表中文名getSearchResult
	 * 
	 * @param page
	 * @param dcaTopicLib
	 * @return
	 */
	public Page<DcaTopicLib> getSearchResult(Page<DcaTopicLib> page, DcaTopicLib dcaTopicLib) {

		dcaTopicLib.setPage(page);
		List<DcaTopicLib> curList = dcaTopicLibDao.getSearchResult(dcaTopicLib);
		String curTopicId = dcaTopicLib.getTopicId();

		if (CollectionUtils.isNotEmpty(curList)) {
			// 给查询结果中有关联的物理表 的checkbox设为选中状态
			for (DcaTopicLib list : curList) {
				if (StringUtils.equals(curTopicId, list.getTopicId())) {

					list.setPhyCheck(Constant.BOXCHECKED);
				}

				list.setId(curTopicId);
			}

		}

		page.setList(curList);

		return page;
	}

	/**
	 * 跳转关联物理表
	 * 
	 * @param page
	 * @param dcaTopicLib
	 * @return
	 */
	public Page<DcaTopicLib> getPhy(Page<DcaTopicLib> page, DcaTopicLib dcaTopicLib) {

		dcaTopicLib.setPage(page);

		// 取得传进来的ID
		String curId = dcaTopicLib.getId();
		List<DcaTopicLib> curList = dcaTopicLibDao.getSearchResult(dcaTopicLib);
		if (CollectionUtils.isNotEmpty(curList)) {
			for (DcaTopicLib list : curList) {
				if (StringUtils.equals(curId, list.getTopicId())) {

					list.setPhyCheck(Constant.BOXCHECKED);
				}

				list.setId(curId);
			}

		}

		page.setList(curList);

		return page;
	}

	/**
	 * 保存关联表
	 * 
	 * @param dcaTopicLib
	 */
	@Transactional(readOnly = false)
	public void setPhyRef(DcaTopicLib dcaTopicLib) {
		// 查找数据库中已经存在的 物理关联表
		List<String> oldRefList = dcaTopicLibDao.selectTableNameList(dcaTopicLib);
		// 页面上传来的 保存list
		List<DcaTopicLib> saveJsonList = new ArrayList<>();
		// 页面上传来的 删除list
		List<DcaTopicLib> delJsonList = new ArrayList<>();
		List<DcaTopicLib> toSaveRefList = new ArrayList<>();
		List<DcaTopicLib> toDeleteRefList = new ArrayList<>();
		try {
			delJsonList = JsonMapper.toJsonCollections(dcaTopicLib.getDelList(), ArrayList.class, DcaTopicLib.class);
			saveJsonList = JsonMapper.toJsonCollections(dcaTopicLib.getSaveList(), ArrayList.class, DcaTopicLib.class);
			// 如果保存list不为空
			if (CollectionUtils.isNotEmpty(saveJsonList)) {
				// saveJsonList ： 需要保存的list
				for (DcaTopicLib slist : saveJsonList) {
					if (!oldRefList.contains(slist.getTableName())) {
						slist.preInsert();
						if (StringUtils.isNotBlank(dcaTopicLib.getCreatePerson())) {
							slist.setCreatePerson(dcaTopicLib.getCreatePerson());
							slist.setUpdatePerson(dcaTopicLib.getCreatePerson());
						}
						toSaveRefList.add(slist);
					}

				}

			}
			// 如果删除list不为空
			if (CollectionUtils.isNotEmpty(delJsonList)) {
				// delJsonList ： 需要删除的list
				for (DcaTopicLib dlist : delJsonList) {
					if (oldRefList.contains(dlist.getTableName())) {
						toDeleteRefList.add(dlist);
					}

				}

			}
		} catch (IOException e) {
			e.printStackTrace();
		}

		if (CollectionUtils.isNotEmpty(toSaveRefList)) {
			dcaTopicLibDao.setPhyRef(toSaveRefList);
		}
		if (CollectionUtils.isNotEmpty(toDeleteRefList)) {
			dcaTopicLibDao.deletePhyRefRelation(toDeleteRefList);
		}

	}

	public Page<DcaTopicLib> findPage(Page<DcaTopicLib> page, DcaTopicLib dcaTopicLib) {
		return super.findPage(page, dcaTopicLib);
	}

	@Transactional(readOnly = false)
	public void save(DcaTopicLib dcaTopicLib) {

		// 新增的场合
		if (dcaTopicLib.getIsNewRecord()) {
			// topicList 新增的主题库名称数据库中是否存在
			List<DcaTopicLib> topicList = dcaTopicLibDao.selectTopicName(dcaTopicLib);
			// 存在该主题库名称
			if (CollectionUtils.isNotEmpty(topicList)) {
				// 返回 “当前输入的主题库名称已被使用，请输入其他的主题库名称。”
				dcaTopicLib.setPageFlag(Constant.TOPICLIB_SAVE_UNSUC);
			} else {
				// 不存在此主题库名称
				if (topicList.size() == 0) {

					super.save(dcaTopicLib);
					// 保存
					dcaTopicLib.setPageFlag(Constant.TOPICLIB_SAVE_SUC);
				}
			}

		} else {
			// 更新的场合
			dcaTopicLib.preUpdate();
			dao.update(dcaTopicLib);
			dcaTopicLib.setPageFlag(Constant.TOPICLIB_SAVE_SUC);
		}

	}

	@Transactional(readOnly = false)
	public void delete(DcaTopicLib dcaTopicLib) {
		// refRelationList为取得当前主题库下的所有关联物理表
		List<DcaTopicLib> refRelationList = dcaTopicLibDao.selectTopicId(dcaTopicLib);

		if (CollectionUtils.isNotEmpty(refRelationList)) {
			// pageFlag=4时，提示“当前主题已关联物理表，不可进行删除操作！”
			dcaTopicLib.setPageFlag(Constant.TOPICLIB_DEL_UNSUC);

		} else {
			// 判断主题库是否存在关联物理表
			if (refRelationList.size() == 0) {
				super.delete(dcaTopicLib);
				// pageFlag=3时会提示“删除成功”
				dcaTopicLib.setPageFlag(Constant.TOPICLIB_DEL_SUC);
			}
		}
	}

	/**
	 * 根据主题库名称获取主题库
	 * 
	 * @param loginName
	 * @return
	 */
	public DcaTopicLib getDcaTopicLibBytopicName(String topicName) {
		// topicList 为主题库表中名字为新增的名字的列是否存在
		DcaTopicLib oldTopic = dcaTopicLibDao.getDcaTopicLibBytopicName(topicName);
		return oldTopic;
	}

	/**
	 * 根据当前主题库id获取主题库相关信息 用处：为了看主题库的状态
	 * 
	 * @param loginName
	 * @return
	 */
	public String getTopicLib(DcaTopicLib dcaTopicLib) {
		// 主题库状态
		String status = dcaTopicLibDao.getTopicLib(dcaTopicLib);

		// 如果没查到主题库的状态 说明该主题库已删除
		if (StringUtils.isBlank(status)) {
			status = Constant.TOPICISSHOW_2;
		}

		return status;
	}

	/**
	 * 根据主题库id查询主题库下管理的物理表
	 *
	 * @param page
	 * @param dcaTopicLib
     * @return
     */
	public Page<DcaTopicLib> findTopicPhysicsByTopicId(Page<DcaTopicLib> page, DcaTopicLib dcaTopicLib) {
		dcaTopicLib.setPage(page);
		List<DcaTopicLib> list = dcaTopicLibDao.findTopicPhysicsByTopicId(dcaTopicLib);
		page.setList(list);
		return page;
	}
}