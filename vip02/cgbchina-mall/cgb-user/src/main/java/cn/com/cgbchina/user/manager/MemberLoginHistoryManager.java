/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.CardProDao;
import cn.com.cgbchina.user.dao.MemberLogonHistoryDao;
import cn.com.cgbchina.user.model.CardPro;
import cn.com.cgbchina.user.model.MemberLogonHistoryModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-14.
 */
@Component
@Transactional
public class MemberLoginHistoryManager {
	@Resource
	private MemberLogonHistoryDao memberLogonHistoryDao;

	public Integer insert(MemberLogonHistoryModel memberLogonHistoryModel){
		return memberLogonHistoryDao.insert(memberLogonHistoryModel);
	}

	public Integer updateLogoutTime(Long id){
		return  memberLogonHistoryDao.updateLogoutTime(id);
	}

}
