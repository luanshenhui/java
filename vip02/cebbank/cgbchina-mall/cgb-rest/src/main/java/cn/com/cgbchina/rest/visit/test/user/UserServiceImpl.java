package cn.com.cgbchina.rest.visit.test.user;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.utils.TestClass;
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
import cn.com.cgbchina.rest.visit.service.user.UserService;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
@Service
public class UserServiceImpl implements UserService {
	@Override
	public LoginResult login(LoginInfo notify) {
		return TestClass.debugMethod(LoginResult.class);
	}

	@Override
	public RegisterResult register(RegisterInfo notify) {
		return TestClass.debugMethod(RegisterResult.class);
	}

	@Override
	public MobileValidCodeResult getMobileValidCode(MobileValidCode code) {
		return TestClass.debugMethod(MobileValidCodeResult.class);
	}

	@Override
	public CheckChannelPwdResult checkChannelPwd(ChannelPwdInfo info) {
		return TestClass.debugMethod(CheckChannelPwdResult.class);
	}

	@Override
	public EEA1InfoResult getEncipherTextByEEA1(EEA1Info info) {
		return TestClass.debugMethod(EEA1InfoResult.class);
	}

	@Override
	public EEA2InfoResult getEncipherTextByEEA2(EEA2Info info) {
		return TestClass.debugMethod(EEA2InfoResult.class);
	}

	@Override
	public EEA5InfoResult getEncipherTextByEEA5(EEA5Info info) {
		return TestClass.debugMethod(EEA5InfoResult.class);
	}

	@Override
	public EEA6InfoResult getEncipherTextByEEA6(EEA6Info info) {
		return TestClass.debugMethod(EEA6InfoResult.class);
	}

	@Override
	public UserInfo getCousrtomInfo(QueryUserInfo cardId) {
		return TestClass.debugMethod(UserInfo.class);
	}

	@Override
	public RandomCode getRandomCodeReq() {
		return TestClass.debugMethod(RandomCode.class);
	}
}
