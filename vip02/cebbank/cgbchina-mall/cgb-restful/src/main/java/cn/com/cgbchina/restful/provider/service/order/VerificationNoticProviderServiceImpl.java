package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.VerificationNotic;
import cn.com.cgbchina.rest.provider.model.order.VerificationNoticReturn;
import cn.com.cgbchina.rest.provider.service.XMLProvideService;
import cn.com.cgbchina.rest.provider.service.order.VerificationNoticService;
import cn.com.cgbchina.rest.provider.vo.order.VerificationNoticReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.VerificationNoticVO;

/**
 * 验证通知接口 从xml对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 * @param <Req>
 * @param <Resp>
 */
@TradeCode(value = "22")
@Slf4j
public class VerificationNoticProviderServiceImpl implements
		XMLProvideService<VerificationNoticVO, VerificationNoticReturnVO> {
	@Resource
	VerificationNoticService verificationNoticService;

	@Override
	public VerificationNoticReturnVO process(VerificationNoticVO model) {
		VerificationNotic verificationNotic = BeanUtils.copy(model,
				VerificationNotic.class);
		VerificationNoticReturn verificationNoticReturn = verificationNoticService
				.notic(verificationNotic);
		return BeanUtils.copy(verificationNoticReturn,
				VerificationNoticReturnVO.class);

	}

}
