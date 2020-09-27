/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.manager;

import javax.annotation.Resource;

import cn.com.cgbchina.related.dao.SmspRecordDao;
import cn.com.cgbchina.related.model.SmspRecordModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cn.com.cgbchina.related.dao.SmspCustDao;
import cn.com.cgbchina.related.dao.SmspInfDao;
import cn.com.cgbchina.related.model.SmspCustModel;
import cn.com.cgbchina.related.model.SmspInfModel;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-13.
 */
@Component
@Transactional
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
		boolean result = smspInfDao.update(smspInfModel) == 1;
		return result;
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
	 * 内管短信模板审核 niufw
	 *
	 * @param id
	 * @return
	 */
	public boolean smsTemplateCheck(Long id) {
		boolean result = smspInfDao.smsTemplateCheck(id) == 1;
		return result;
	}

	/**
	 * 内管短信模板拒绝 niufw
	 *
	 * @param id
	 * @return
	 */
	public boolean smsTemplateRefuse(Long id) {
		boolean result = smspInfDao.smsTemplateRefuse(id) == 1;
		return result;
	}

	/**
	 * 短信模板管理批量提交 niufw
	 *
	 * @param smspInfModel
	 * @return
	 */
	public boolean submitAll(SmspInfModel smspInfModel) {
		boolean result = smspInfDao.submitAll(smspInfModel) == 1;
		return result;
	}

	/**
	 * 短信模板管理批量删除 niufw
	 *
	 * @param smspInfModel
	 * @return
	 */
	public boolean deleteAll(SmspInfModel smspInfModel) {
		boolean result = smspInfDao.deleteAll(smspInfModel) == 1;
		return result;
	}

	/**
	 * 新增名单
	 * 
	 * @param smspCustModel
	 * @return
	 */
	public boolean createCust(SmspCustModel smspCustModel) {
		try {
			return smspCustDao.insert(smspCustModel) == 1;
		}catch (Exception e){
			return false;
		}
	}

	/**
	 * 更新名单
	 * 
	 * @param smspCustModel
	 * @return
	 */
	public boolean updateCust(SmspCustModel smspCustModel) {
		boolean result = smspCustDao.update(smspCustModel) == 1;
		return result;
	}

	/**
	 * 新建履历表
	 * 
	 * @param smspRecordModel
	 * @return
	 */
	public boolean createRecord(SmspRecordModel smspRecordModel) {
		boolean result = smspRecordDao.insert(smspRecordModel) == 1;
		return result;
	}

}
