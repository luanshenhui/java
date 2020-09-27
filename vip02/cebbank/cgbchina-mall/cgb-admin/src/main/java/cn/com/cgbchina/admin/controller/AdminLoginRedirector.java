package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.web.controller.LoginRedirector;
import com.google.common.base.Strings;
import com.spirit.user.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * Created by 11140721050130 on 2016/4/30.
 */
@Component
public class AdminLoginRedirector implements LoginRedirector {

	@Value("#{app.adminMainSite}")
	private String mainSite;

	@Override
	public String redirectTarget(String target, User user) {
		if (!Strings.isNullOrEmpty(target)) {
			return target;
		} else {
			return "http://" + mainSite;
		}
	}
}
