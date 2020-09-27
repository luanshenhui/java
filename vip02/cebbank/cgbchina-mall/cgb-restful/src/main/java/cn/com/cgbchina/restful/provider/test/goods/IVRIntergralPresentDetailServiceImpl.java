package cn.com.cgbchina.restful.provider.test.goods;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.goods.IVRIntergralPresentDetailService;
import cn.com.cgbchina.rest.provider.model.goods.IVRIntergralPresentReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.goods.IVRIntergralPresentDetailQuery;


@Service
public class IVRIntergralPresentDetailServiceImpl implements IVRIntergralPresentDetailService {
	@Override
	public IVRIntergralPresentReturn detail(IVRIntergralPresentDetailQuery iVRIntergralPresentDetailQuery) {
		return BeanUtils.randomClass(IVRIntergralPresentReturn.class);
	}

}
