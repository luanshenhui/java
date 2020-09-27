package com.cebbank.ccis.cebmall.user.manager;

import com.cebbank.ccis.cebmall.user.dao.UserInfoDao;
import com.cebbank.ccis.cebmall.user.model.UserInfoModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by 11141021040453 on 16-4-21.
 */
@Component
@Transactional
public class UserInfoManager {

	@Resource
	private UserInfoDao userInfoDao;

	public Boolean insert(UserInfoModel userInfo) {
		return userInfoDao.insert(userInfo) == 1;
	}

	public Boolean update(UserInfoModel userInfoModel) {
		return userInfoDao.update(userInfoModel);
	}

	public void updatePwdByCode(UserInfoModel userInfoModel){
		userInfoDao.updatePwdByCode(userInfoModel);
	}
}
