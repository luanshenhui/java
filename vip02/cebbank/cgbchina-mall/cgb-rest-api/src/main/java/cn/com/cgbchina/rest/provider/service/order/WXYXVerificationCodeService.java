package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.VerificationCodeQuery;
import cn.com.cgbchina.rest.provider.model.order.VerificationCodeReturn;

/**
 * MAL422 微信易信验证码查询
 * 
 * @author lizy 2016/4/28.
 */
public interface WXYXVerificationCodeService {
	VerificationCodeReturn getVerificationCode(VerificationCodeQuery verificationCodeQuery);
}
