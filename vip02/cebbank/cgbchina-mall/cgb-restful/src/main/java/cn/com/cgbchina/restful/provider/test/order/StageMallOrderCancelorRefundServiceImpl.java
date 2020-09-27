package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.StageMallOrderCancelorRefundService;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderCancelorRefundReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderCancelorRefund;


@Service
public class StageMallOrderCancelorRefundServiceImpl implements StageMallOrderCancelorRefundService {
	@Override
	public StageMallOrderCancelorRefundReturn cancelorRefundorder(StageMallOrderCancelorRefund stageMallOrderCancelorRefund) {
		StageMallOrderCancelorRefundReturn  res =
		  BeanUtils.randomClass(StageMallOrderCancelorRefundReturn.class);
		res.setReturnCode("000000");
		res.setReturnDes("正常");
		return res;
	}

}
