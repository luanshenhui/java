package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.SMSOrderAdd;
import cn.com.cgbchina.rest.provider.model.order.SMSOrderAddReturn;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.service.order.SMSOrderAddService;
import cn.com.cgbchina.rest.provider.vo.order.SMSOrderAddReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.SMSOrderAddVO;

/**
 * MAL401 短信下单接口 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 *
 */
@Service
@TradeCode(value = "MAL401")
@Slf4j
public class SMSOrderAddProvideServiceImpl implements SoapProvideService<SMSOrderAddVO, SMSOrderAddReturnVO> {
	@Resource
	private SMSOrderAddService smsOrderAddService;

	@Override
	public SMSOrderAddReturnVO process(SoapModel<SMSOrderAddVO> model, SMSOrderAddVO content) {
		SMSOrderAdd smsOrderAdd = BeanUtils.copy(content, SMSOrderAdd.class);
		SMSOrderAddReturn cCIntergralAnticipationReturn = smsOrderAddService.add(smsOrderAdd);
		SMSOrderAddReturnVO cCIntergralAnticipationReturnVO = BeanUtils.copy(cCIntergralAnticipationReturn,
				SMSOrderAddReturnVO.class);
		return cCIntergralAnticipationReturnVO;
	}

}
