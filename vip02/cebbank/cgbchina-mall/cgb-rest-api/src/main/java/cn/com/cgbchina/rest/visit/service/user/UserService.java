package cn.com.cgbchina.rest.visit.service.user;

import cn.com.cgbchina.rest.visit.model.user.*;

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
