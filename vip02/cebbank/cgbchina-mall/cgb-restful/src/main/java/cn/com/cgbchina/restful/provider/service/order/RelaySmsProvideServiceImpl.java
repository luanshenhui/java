package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.PreferentialPrice;
import cn.com.cgbchina.rest.provider.model.order.PreferentialPriceRetrun;
import cn.com.cgbchina.rest.provider.model.order.RelaySmsReturn;
import cn.com.cgbchina.rest.provider.model.order.SmsInfo;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.service.XMLProvideService;
import cn.com.cgbchina.rest.provider.service.order.RelaySmsService;
import cn.com.cgbchina.rest.provider.vo.order.PreferentialPriceRetrunVO;
import cn.com.cgbchina.rest.provider.vo.order.PreferentialPriceVO;
import cn.com.cgbchina.rest.provider.vo.order.RelaySmsReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.SmsInfoVO;
import lombok.extern.slf4j.Slf4j;

/**
 * DXZF01 上行短信内容实时转发 从xml对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "DXZF01")
@Slf4j
public class RelaySmsProvideServiceImpl implements SoapProvideService<SmsInfoVO, RelaySmsReturnVO> {
	@Resource
	RelaySmsService relaySmsService;

	@Override
	public RelaySmsReturnVO process(SoapModel<SmsInfoVO> model, SmsInfoVO content) {
		SmsInfo smsInfo = BeanUtils.copy(content, SmsInfo.class);
		RelaySmsReturn relaySmsReturn = relaySmsService.RelaySms(smsInfo);
		return BeanUtils.copy(relaySmsReturn, RelaySmsReturnVO.class);
	}

 

}
