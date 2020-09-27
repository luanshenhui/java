package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.AppStageMallPayVerification;
import cn.com.cgbchina.rest.provider.model.order.AppStageMallPayVerificationReturn;

/**
 * MAL315 订单支付结果校验接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public interface AppStageMallPayVerificationService {
	AppStageMallPayVerificationReturn Verification(AppStageMallPayVerification appStageMallPayVerification);
}
