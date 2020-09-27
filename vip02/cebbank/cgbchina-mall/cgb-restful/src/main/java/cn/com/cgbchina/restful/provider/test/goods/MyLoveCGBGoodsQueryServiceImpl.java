package cn.com.cgbchina.restful.provider.test.goods;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.goods.MyLoveCGBGoodsQueryService;
import cn.com.cgbchina.rest.provider.model.goods.MyLoveCGBGoodsQueryReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.goods.MyLoveCGBGoodsQuery;


@Service
public class MyLoveCGBGoodsQueryServiceImpl implements MyLoveCGBGoodsQueryService {
	@Override
	public MyLoveCGBGoodsQueryReturn query(MyLoveCGBGoodsQuery myLoveCGBGoodsQuery) {
		return BeanUtils.randomClass(MyLoveCGBGoodsQueryReturn.class);
	}

}
