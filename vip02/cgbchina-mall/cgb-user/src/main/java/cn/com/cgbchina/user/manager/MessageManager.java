/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.PersonalMessageDao;
import cn.com.cgbchina.user.dao.VendorMessageDao;
import cn.com.cgbchina.user.model.PersonalMessageModel;
import cn.com.cgbchina.user.model.VendorMessageModel;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * @author wusy
 * @version 1.0
 * @Since 2016/8/6.
 */
@Component
@Transactional
@Slf4j
public class MessageManager {
	@Resource
	VendorMessageDao vendorMessageDao;

	@Resource
	PersonalMessageDao personalMessageDao;

	/**
	 * 新增个人消息表，供应商消息
	 * 
	 * @param vendorMessageModel 供应商消息信息
	 * @param personalMessageModel 个人消息信息
	 * @return
	 */
	@Transactional(rollbackFor = { Exception.class })
	public void create(VendorMessageModel vendorMessageModel, PersonalMessageModel personalMessageModel) throws Exception{

        // 事物插入
        vendorMessageDao.insert(vendorMessageModel);

        personalMessageDao.insert(personalMessageModel);

	}

	public Integer insert(VendorMessageModel vendorMessageModel){
		return vendorMessageDao.insert(vendorMessageModel);
	}

	public Integer insert(PersonalMessageModel personalMessageModel){
		return personalMessageDao.insert(personalMessageModel);
	}

}
