package cn.com.cgbchina.restful.provider.test.goods;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.goods.CCIntergralPresentDetailService;
import cn.com.cgbchina.rest.provider.model.goods.CCIntergalPresentDetail;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.goods.CCIntergalPresentDetailQuery;


@Service
public class CCIntergralPresentDetailServiceImpl implements CCIntergralPresentDetailService {
	@Override
	public CCIntergalPresentDetail detail(CCIntergalPresentDetailQuery cCIntergalPresentDetailQuery) {
		CCIntergalPresentDetail res  = BeanUtils.randomClass(CCIntergalPresentDetail.class);
		res.setSuccessCode("01");
		res.setChannelSN("CC");
		res.setReturnCode("000000");
		
		return res ;
	}

}
