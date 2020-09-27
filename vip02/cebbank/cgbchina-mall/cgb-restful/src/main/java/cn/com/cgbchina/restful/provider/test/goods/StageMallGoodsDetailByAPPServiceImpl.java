package cn.com.cgbchina.restful.provider.test.goods;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.goods.StageMallGoodsDetailByAPPService;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsDetailByAPPReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsDetailByAPPQuery;


@Service
public class StageMallGoodsDetailByAPPServiceImpl implements StageMallGoodsDetailByAPPService {
	@Override
	public StageMallGoodsDetailByAPPReturn detail(StageMallGoodsDetailByAPPQuery stageMallGoodsDetailByAPPQuery) {
		return BeanUtils.randomClass(StageMallGoodsDetailByAPPReturn.class);
	}

}
