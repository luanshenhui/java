package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.VerificationNotic;
import cn.com.cgbchina.rest.provider.model.order.VerificationNoticReturn;

/**
 * 验证通知接口
 * 
 * @author Lizy
 *
 */
public interface VerificationNoticService {
	VerificationNoticReturn notic(VerificationNotic verificationNotic);
}
