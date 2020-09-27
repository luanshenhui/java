package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.CCIntergralAnticipationService;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralAnticipationReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralAnticipation;


@Service
public class CCIntergralAnticipationServiceImpl implements CCIntergralAnticipationService {
	@Override
	public CCIntergralAnticipationReturn intergralAnticipation(CCIntergralAnticipation cCIntergralAnticipation) {
		return BeanUtils.randomClass(CCIntergralAnticipationReturn.class);
	}

}
