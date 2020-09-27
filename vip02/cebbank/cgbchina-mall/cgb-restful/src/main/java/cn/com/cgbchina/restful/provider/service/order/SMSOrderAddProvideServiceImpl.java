package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.SMSOrderAdd;
import cn.com.cgbchina.rest.provider.model.order.SMSOrderAddReturn;
import cn.com.cgbchina.rest.provider.service.order.SMSOrderAddService;
import cn.com.cgbchina.rest.provider.vo.order.SMSOrderAddReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.SMSOrderAddVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL401 短信下单接口 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL401")
@Slf4j
public class SMSOrderAddProvideServiceImpl implements  SoapProvideService <SMSOrderAddVO,SMSOrderAddReturnVO>{
	@Resource
	SMSOrderAddService sMSOrderAddService;

	@Override
	public SMSOrderAddReturnVO process(SoapModel<SMSOrderAddVO> model, SMSOrderAddVO content) {
		SMSOrderAdd sMSOrderAdd = BeanUtils.copy(content, SMSOrderAdd.class);
		SMSOrderAddReturn sMSOrderAddReturn = sMSOrderAddService.add(sMSOrderAdd);
		SMSOrderAddReturnVO sMSOrderAddReturnVO = BeanUtils.copy(sMSOrderAddReturn,
				SMSOrderAddReturnVO.class);
		return sMSOrderAddReturnVO;
	}

}
