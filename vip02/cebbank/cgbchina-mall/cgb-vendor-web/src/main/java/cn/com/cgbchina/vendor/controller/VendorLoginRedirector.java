package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.web.controller.LoginRedirector;
import com.google.common.base.Strings;
import com.spirit.user.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * Created by 11150721040343 on 16-5-3.
 */
@Component
public class VendorLoginRedirector implements LoginRedirector {
	@Value("#{app.vendorMainSite}")
	private String mainSite;

	public String redirectTarget(String target, User user) {
		if (!Strings.isNullOrEmpty(target)) {
			return target;
		} else {
			return "http://" + mainSite;
		}
	}

}
