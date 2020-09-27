package cn.com.cgbchina.restful.provider.test.activity;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.activity.WXYXo2oGoodsQueryService;
import cn.com.cgbchina.rest.provider.model.activity.WXYXo2oGoodsQueryReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.activity.WXYXo2oGoodsQuery;


@Service
public class WXYXo2oGoodsQueryServiceImpl implements WXYXo2oGoodsQueryService {
	@Override
	public WXYXo2oGoodsQueryReturn query(WXYXo2oGoodsQuery wXYXo2oGoodsQuery) {
		WXYXo2oGoodsQueryReturn wXYXo2oGoodsQueryReturn = BeanUtils.randomClass(WXYXo2oGoodsQueryReturn.class);
		return wXYXo2oGoodsQueryReturn;
	}

}
