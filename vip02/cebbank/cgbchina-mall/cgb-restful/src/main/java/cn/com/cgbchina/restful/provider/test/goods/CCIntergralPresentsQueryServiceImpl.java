package cn.com.cgbchina.restful.provider.test.goods;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.goods.CCIntergralPresentsQueryService;
import cn.com.cgbchina.rest.provider.model.goods.CCIntergalPresentReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.goods.CCIntergalPresentQuery;


@Service
public class CCIntergralPresentsQueryServiceImpl implements CCIntergralPresentsQueryService {
	@Override
	public CCIntergalPresentReturn query(CCIntergalPresentQuery cCIntergalPresentQuery) {
		return BeanUtils.randomClass(CCIntergalPresentReturn.class);
	}

}
