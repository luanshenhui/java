package cn.com.cgbchina.restful.provider.test.goods;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.goods.StageMallGoodsQueryService;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsQueryReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsQuery;


@Service
public class StageMallGoodsQueryServiceImpl implements StageMallGoodsQueryService {
	@Override
	public StageMallGoodsQueryReturn query(StageMallGoodsQuery stageMallGoodsQuery) {
		return BeanUtils.randomClass(StageMallGoodsQueryReturn.class);
	}

}
