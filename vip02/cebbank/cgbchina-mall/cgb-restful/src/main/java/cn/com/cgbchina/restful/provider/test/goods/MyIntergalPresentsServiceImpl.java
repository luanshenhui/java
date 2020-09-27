package cn.com.cgbchina.restful.provider.test.goods;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.goods.MyIntergalPresentsService;
import cn.com.cgbchina.rest.provider.model.goods.MyIntergalPresentsReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.goods.MyIntergalPresentsQuery;


@Service
public class MyIntergalPresentsServiceImpl implements MyIntergalPresentsService {
	@Override
	public MyIntergalPresentsReturn query(MyIntergalPresentsQuery myIntergalPresentsQuery) {
		return BeanUtils.randomClass(MyIntergalPresentsReturn.class);
	}

}
