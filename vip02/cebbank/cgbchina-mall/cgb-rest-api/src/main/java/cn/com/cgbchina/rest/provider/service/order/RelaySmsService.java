package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.RelaySmsReturn;
import cn.com.cgbchina.rest.provider.model.order.SmsInfo;

/**
 * DXZF01 上行短信内容实时转发
 * 
 * @author Lizy
 *
 */
public interface RelaySmsService {
	RelaySmsReturn RelaySms(SmsInfo smsInfo);

}
