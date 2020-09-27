package cn.com.cgbchina.restful.provider.test.activity;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.activity.SPGoodsQueryService;
import cn.com.cgbchina.rest.provider.model.activity.SPGoodsReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.activity.SPGoodsQuery;


@Service
public class SPGoodsQueryServiceImpl implements SPGoodsQueryService {
	@Override
	public SPGoodsReturn query(SPGoodsQuery sPGoodsQuery) {
		SPGoodsReturn sPGoodsReturn = BeanUtils.randomClass(SPGoodsReturn.class);
		return sPGoodsReturn;
	}

}
