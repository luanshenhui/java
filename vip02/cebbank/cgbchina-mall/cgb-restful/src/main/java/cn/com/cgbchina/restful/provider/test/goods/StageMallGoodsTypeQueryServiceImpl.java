package cn.com.cgbchina.restful.provider.test.goods;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.goods.StageMallGoodsTypeQueryService;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsTypeQuery;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsTypeQueryReturn;


@Service
public class StageMallGoodsTypeQueryServiceImpl implements StageMallGoodsTypeQueryService {

	@Override
	public StageMallGoodsTypeQueryReturn query(StageMallGoodsTypeQuery stageMallGoodsTypeQueryObj) {
		return BeanUtils.randomClass(StageMallGoodsTypeQueryReturn.class);
	}
 

}
