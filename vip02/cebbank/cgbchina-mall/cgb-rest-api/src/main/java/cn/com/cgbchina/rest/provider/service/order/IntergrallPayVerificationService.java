package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.IntergrallPayVerificationReturn;
import cn.com.cgbchina.rest.provider.model.order.IntergrallPayVerification;

/**
 * MAL325 积分商城支付校验接口
 * 
 * @author lizy 2016/4/28.
 */
public interface IntergrallPayVerificationService {
	// IntergrallPayVerificationReturn Verification (IntergrallPayVerification intergrallPayVerification);
	IntergrallPayVerificationReturn Verification(IntergrallPayVerification intergrallPayVerification);
}
