package cn.com.cgbchina.web.controller;

import com.google.common.base.Strings;
import com.spirit.user.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

/**
 * Created by 11140721050130 on 2016/5/3.
 */
@Component
public class MallLoginRedirector implements LoginRedirector {

	@Value(value = "#{app.mainSite}")
	private String mainSite;

	@Override
	public String redirectTarget(String target, User user) {
		if (!Strings.isNullOrEmpty(target)) {
			return target;
		} else {
			return "http://" + mainSite + "/index";
		}
	}
}
