package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.CCVerificationCodeQuery;
import cn.com.cgbchina.rest.provider.model.order.CCVerificationCodeReturn;

/**
 * MAL121 CC重发验证码
 * 
 * @author lizy 2016/4/28.
 */
public interface CCVerificationCodeService {
	CCVerificationCodeReturn getCCVerificationCode(CCVerificationCodeQuery ccVerificationCodeQueryObj);
}
