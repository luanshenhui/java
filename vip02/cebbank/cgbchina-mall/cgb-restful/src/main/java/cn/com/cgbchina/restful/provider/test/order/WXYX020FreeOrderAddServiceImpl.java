package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.WXYX020FreeOrderAddService;
import cn.com.cgbchina.rest.provider.model.order.WXYX020FreeOrderQuery;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.WXYX020FreeOrderReturn;


@Service
public class WXYX020FreeOrderAddServiceImpl implements WXYX020FreeOrderAddService {
 

	@Override
	public WXYX020FreeOrderReturn add(WXYX020FreeOrderQuery freeOrder) {
		return BeanUtils.randomClass(WXYX020FreeOrderReturn.class);
	}

}
