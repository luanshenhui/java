package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.WXIntergralRefundService;
import cn.com.cgbchina.rest.provider.model.order.WXIntergralRefundReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.WXIntergral;


@Service
public class WXIntergralRefundServiceImpl implements WXIntergralRefundService {
	@Override
	public WXIntergralRefundReturn refund(WXIntergral wXIntergral) {
		return BeanUtils.randomClass(WXIntergralRefundReturn.class);
	}

}
