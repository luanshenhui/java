package cn.com.cgbchina.restful.provider.test.goods;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.goods.StageMallGoodsDetailService;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsDetailReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsDetailQuery;


@Service
public class StageMallGoodsDetailServiceImpl implements StageMallGoodsDetailService {
	@Override
	public StageMallGoodsDetailReturn detail(StageMallGoodsDetailQuery stageMallGoodsDetailQuery) {
		return BeanUtils.randomClass(StageMallGoodsDetailReturn.class);
	}

}
