package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.CCIntergralOrderUpdateService;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrdersReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderUpdate;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderUpdateReturn;


@Service
public class CCIntergralOrderUpdateServiceImpl implements CCIntergralOrderUpdateService {
	@Override
	public CCIntergralOrderUpdateReturn update(CCIntergralOrderUpdate cCIntergralOrderUpdate) {
		CCIntergralOrderUpdateReturn res =BeanUtils.randomClass(CCIntergralOrderUpdateReturn.class);
		res.setChannelSN("CC");
		res.setSuccessCode("01");
		res.setReturnCode("000000");
		res.setReturnDes("正常");
		return res; 
	}

}
