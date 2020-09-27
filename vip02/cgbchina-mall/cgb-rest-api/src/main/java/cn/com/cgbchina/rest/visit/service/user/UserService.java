package cn.com.cgbchina.rest.visit.service.user;

import cn.com.cgbchina.rest.visit.model.user.ChannelPwdInfo;
import cn.com.cgbchina.rest.visit.model.user.CheckChannelPwdResult;
import cn.com.cgbchina.rest.visit.model.user.EEA1Info;
import cn.com.cgbchina.rest.visit.model.user.EEA1InfoResult;
import cn.com.cgbchina.rest.visit.model.user.EEA2Info;
import cn.com.cgbchina.rest.visit.model.user.EEA2InfoResult;
import cn.com.cgbchina.rest.visit.model.user.EEA5Info;
import cn.com.cgbchina.rest.visit.model.user.EEA5InfoResult;
import cn.com.cgbchina.rest.visit.model.user.EEA6Info;
import cn.com.cgbchina.rest.visit.model.user.EEA6InfoResult;
import cn.com.cgbchina.rest.visit.model.user.LoginInfo;
import cn.com.cgbchina.rest.visit.model.user.LoginResult;
import cn.com.cgbchina.rest.visit.model.user.MobileValidCode;
import cn.com.cgbchina.rest.visit.model.user.MobileValidCodeResult;
import cn.com.cgbchina.rest.visit.model.user.QueryUserInfo;
import cn.com.cgbchina.rest.visit.model.user.RandomCode;
import cn.com.cgbchina.rest.visit.model.user.RegisterInfo;
import cn.com.cgbchina.rest.visit.model.user.RegisterResult;
import cn.com.cgbchina.rest.visit.model.user.UserInfo;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public interface UserService {
	LoginResult login(LoginInfo notify);

	RegisterResult register(RegisterInfo notify);

	MobileValidCodeResult getMobileValidCode(MobileValidCode code);

	UserInfo getCousrtomInfo(QueryUserInfo cardId);

	CheckChannelPwdResult checkChannelPwd(ChannelPwdInfo info);

	EEA1InfoResult getEncipherTextByEEA1(EEA1Info info);

	EEA2InfoResult getEncipherTextByEEA2(EEA2Info info);

	EEA5InfoResult getEncipherTextByEEA5(EEA5Info info);

	EEA6InfoResult getEncipherTextByEEA6(EEA6Info info);

	RandomCode getRandomCodeReq();
}
