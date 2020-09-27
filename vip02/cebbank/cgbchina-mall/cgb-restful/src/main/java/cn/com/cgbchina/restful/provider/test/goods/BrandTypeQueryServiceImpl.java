package cn.com.cgbchina.restful.provider.test.goods;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.goods.BrandTypeQueryService;
import cn.com.cgbchina.rest.provider.model.goods.BrandTypeQueryReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.goods.BrandTypeQuery;


@Service
public class BrandTypeQueryServiceImpl implements BrandTypeQueryService {
	@Override
	public BrandTypeQueryReturn query(BrandTypeQuery brandTypeQuery) {
		return BeanUtils.randomClass(BrandTypeQueryReturn.class);
	}

}
