/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.manager;

import javax.annotation.Resource;

import cn.com.cgbchina.related.dao.AdvertisingManageDao;
import cn.com.cgbchina.related.model.AdvertisingManageModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-13.
 */
@Component
@Transactional
public class AdvertisingManager {
	@Resource
	private AdvertisingManageDao advertisingManageDao;

	/**
	 * 内管短信模板审核 niufw
	 *
	 * @param advertisingManageModel
	 * @return
	 */
	public boolean advertisingCheck(AdvertisingManageModel advertisingManageModel) {
		boolean result = advertisingManageDao.changeCheckStatus(advertisingManageModel) == 1;
		return result;
	}

	/**
	 * 内管短信模板拒绝 niufw
	 *
	 * @param advertisingManageModel
	 * @return
	 */
	public boolean advertisingRefuse(AdvertisingManageModel advertisingManageModel) {
		boolean result = advertisingManageDao.changeCheckStatus(advertisingManageModel) == 1;
		return result;
	}

	/**
	 * 内管短信模板删除 niufw
	 *
	 * @param id
	 * @return
	 */
	public boolean delete(Long id) {
		boolean result = advertisingManageDao.updateForDelete(id) == 1;
		return result;
	}

	/**
	 * 广告管理添加(供应商平台) niufw
	 *
	 * @param advertisingManageModel
	 * @return
	 */
	public boolean create(AdvertisingManageModel advertisingManageModel) {
		boolean result = advertisingManageDao.insert(advertisingManageModel) == 1;
		return result;
	}

	/**
	 * 广告管理编辑(供应商平台) niufw
	 *
	 * @param advertisingManageModel
	 * @return
	 */
	public boolean update(AdvertisingManageModel advertisingManageModel) {
		boolean result = advertisingManageDao.update(advertisingManageModel) == 1;
		return result;
	}
}
