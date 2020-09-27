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

	@Value("#{app.mainSite}")
	private String mainSite;
	@Value("#{app.context}")
	private  String context;

	public String redirectTarget(String target, User user) {
//		if (!Strings.isNullOrEmpty(target)) {
//			if("/".equals(target) || "/index".equals(target)) {
//				return "http://" + mainSite + context;
//			}
//			return target;
//		} else {
//			return "http://" + mainSite + context;
//		}
		// TODO
		if (!Strings.isNullOrEmpty(target) && !"/".equals(target) && "/index".equals(target)) {
			if (("/" + context + "/").equals(target)) {
				return "http://" + mainSite + context + "/index";
			}
			else if (("/" + context).equals(target)) {
				return "http://" + mainSite + context + "/index";
			}
			return target;
		} else {
			return "http://" + mainSite + context + "/index";
		}
	}

}
