package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.CCAndIVRIntergralAddOrderService;
import cn.com.cgbchina.rest.provider.model.order.CCAndIVRIntergalOrderReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.CCAndIVRIntergalOrder;


@Service
public class CCAndIVRIntergralAddOrderServiceImpl implements CCAndIVRIntergralAddOrderService {
	@Override
	public CCAndIVRIntergalOrderReturn add(CCAndIVRIntergalOrder cCAndIVRIntergalOrder) {
		CCAndIVRIntergalOrderReturn res = BeanUtils.randomClass(CCAndIVRIntergalOrderReturn.class);
		res.setChannelSN("CC");
		res.setSuccessCode("01");
		res.setErrCode("000000");
		res.setOrderMainId("666666");
		res.setReturnDes("操作成功");
		res.setReturnCode("000000");
		return res;
	}

}
