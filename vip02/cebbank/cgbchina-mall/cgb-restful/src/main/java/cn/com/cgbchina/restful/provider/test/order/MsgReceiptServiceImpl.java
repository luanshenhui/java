package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.IntergrallPayVerification;
import cn.com.cgbchina.rest.provider.model.order.MsgQuery;
import cn.com.cgbchina.rest.provider.model.order.MsgReceipReturn;
import cn.com.cgbchina.rest.provider.service.order.MsgReceiptService;

@Service
public class MsgReceiptServiceImpl implements MsgReceiptService {

	@Override
	public MsgReceipReturn getMsgReceipt(MsgQuery msgQuery) {
		return BeanUtils.randomClass(MsgReceipReturn.class);
	}

}
