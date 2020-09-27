/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.SmspCustDao;
import cn.com.cgbchina.item.dao.SmspInfDao;
import cn.com.cgbchina.item.dao.SmspRecordDao;
import cn.com.cgbchina.item.model.SmspCustModel;
import cn.com.cgbchina.item.model.SmspInfModel;
import cn.com.cgbchina.item.model.SmspRecordModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-13.
 */
@Component
@Transactional
@Slf4j
public class MessageTemplateManager {
	@Resource
	private SmspInfDao smspInfDao;
	@Resource
	private SmspCustDao smspCustDao;
	@Resource
	private SmspRecordDao smspRecordDao;

	/**
	 * 内管短信模板新增 niufw
	 *
	 * @param smspInfModel
	 * @return
	 */
	public boolean create(SmspInfModel smspInfModel) {
		boolean result = smspInfDao.insert(smspInfModel) == 1;
		return result;
	}

	/**
	 * 内管短信模板编辑 niufw
	 *
	 * @param smspInfModel
	 * @return
	 */
	public boolean update(SmspInfModel smspInfModel) {
		return smspInfDao.update(smspInfModel) == 1;
	}

	/**
	 * 内管短信模板删除 niufw
	 *
	 * @param id
	 * @return
	 */
	public boolean delete(Long id) {
		boolean result = smspInfDao.updateForDelete(id) == 1;
		return result;
	}

	/**
	 * 内管短信模板提交 niufw
	 *
	 * @param id
	 * @return
	 */
	public boolean submit(Long id) {
		boolean result = smspInfDao.updateForSubmit(id) == 1;
		return result;
	}

	/**
	 * 短信模板管理批量提交 niufw
	 *
	 * @param paramMap
	 * @return
	 */
	public Integer submitAll(Map<String, Object> paramMap) {
		Integer result = smspInfDao.submitAll(paramMap);
		return result;
	}

	/**
	 * 短信模板管理批量删除 niufw
	 *
	 * @param paramMap
	 * @return
	 */
	public Integer deleteAll(Map<String, Object> paramMap) {
		Integer result = smspInfDao.deleteAll(paramMap);
		return result;
	}

	/**
	 * 新增名单
	 * 
	 * @param smspCustModel
	 * @return
	 */
	public boolean createCust(SmspCustModel smspCustModel) {
		return smspCustDao.replaceSmsp(smspCustModel) > 0;
	}

	/**
	 * 更新名单
	 * 
	 * @param smspCustModel
	 * @return
	 */
	public boolean updateCust(SmspCustModel smspCustModel) {
		return smspCustDao.update(smspCustModel) == 1;
	}

	/**
	 * 新建履历表
	 * 
	 * @param smspRecordModel
	 * @return
	 */
	public boolean createRecord(SmspRecordModel smspRecordModel) {
		return smspRecordDao.insert(smspRecordModel) == 1;
	}

	/**
	 * 短信模板管理批量删除 niufw
	 *
	 * @param smspCustModel
	 * @return
	 */
	public boolean deleteNameForAudit(SmspCustModel smspCustModel) {
		return smspCustDao.delete(smspCustModel) == 1;
	}

	/**
	 * 只更新 短信模板的状态和操作人、时间
	 * 
	 * @param smspInfModel 更新对象
	 * @return boolean
	 */
	public boolean updateStatus(SmspInfModel smspInfModel) {
		return smspInfDao.updateStatus(smspInfModel) == 1;
	}

	/**
	 * 数据--导入
	 * 
	 * @param smspCustModelList 导入数据
	 * @param repeat 重复 数据
	 * @return map
	 */
	public Boolean importData(List<SmspCustModel> smspCustModelList, List<SmspCustModel> repeat) {

		Boolean createFlag = Boolean.TRUE;
		Boolean updateFlag = Boolean.TRUE;
		// 重复数据处理
		if (null != repeat && !repeat.isEmpty()) {
			// 对于重复名单的进行更新：成功更新db的存入成功的list,失败的存入失败的list
			int num = smspCustDao.updateBatch(repeat);
			if (0 == num || repeat.size() != num) {
				updateFlag = Boolean.FALSE;
			}
		}
		// 新增名单：成功插入db的存入成功的list,失败的存入失败的list
		if (!smspCustModelList.isEmpty()) {
			int num = smspCustDao.insertBatch(smspCustModelList);
			if (0 == num || smspCustModelList.size() != num) {
				createFlag = Boolean.FALSE;
			}
		}
		return createFlag && updateFlag;
	}

}
