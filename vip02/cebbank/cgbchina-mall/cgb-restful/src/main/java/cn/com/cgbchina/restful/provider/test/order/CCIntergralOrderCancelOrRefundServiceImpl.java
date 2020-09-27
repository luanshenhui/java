package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.CCIntergralOrderCancelOrRefundService;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderCancelOrRefundReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderCancelOrRefund;


@Service
public class CCIntergralOrderCancelOrRefundServiceImpl implements CCIntergralOrderCancelOrRefundService {
	@Override
	public CCIntergralOrderCancelOrRefundReturn cancelOrRefund(CCIntergralOrderCancelOrRefund cCIntergralOrderCancelOrRefund) {
		return BeanUtils.randomClass(CCIntergralOrderCancelOrRefundReturn.class);
	}

}
