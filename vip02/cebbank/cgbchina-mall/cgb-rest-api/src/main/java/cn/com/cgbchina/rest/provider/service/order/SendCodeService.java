package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.SendCodeInfo;
import cn.com.cgbchina.rest.provider.model.order.SendCodeReturn;

/**
 * 发码（购票）成功通知接口
 * 
 * @author lizy
 *
 */
public interface SendCodeService {
	SendCodeReturn send(SendCodeInfo sendCodeInfo);

}
