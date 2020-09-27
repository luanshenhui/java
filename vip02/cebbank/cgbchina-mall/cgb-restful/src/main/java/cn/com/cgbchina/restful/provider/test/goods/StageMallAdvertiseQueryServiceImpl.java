package cn.com.cgbchina.restful.provider.test.goods;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.goods.StageMallAdvertiseQueryService;
import cn.com.cgbchina.rest.provider.model.goods.StageMallAdvertiseQueryReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.goods.StageMallAdvertise;


@Service
public class StageMallAdvertiseQueryServiceImpl implements StageMallAdvertiseQueryService {
	@Override
	public StageMallAdvertiseQueryReturn query(StageMallAdvertise stageMallAdvertise) {
		return BeanUtils.randomClass(StageMallAdvertiseQueryReturn.class);
	}

}
