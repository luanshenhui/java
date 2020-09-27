package cn.com.cgbchina.restful.provider.service.order;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.process.InputXmlProcessImpl;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.SendCodeInfo;
import cn.com.cgbchina.rest.provider.model.order.SendCodeOrderInfo;
import cn.com.cgbchina.rest.provider.model.order.SendCodeReturn;
import cn.com.cgbchina.rest.provider.service.XMLProvideService;
import cn.com.cgbchina.rest.provider.service.order.SendCodeService;
import cn.com.cgbchina.rest.provider.vo.order.SendCodeInfoVO;
import cn.com.cgbchina.rest.provider.vo.order.SendCodeOrderInfoVO;
import cn.com.cgbchina.rest.provider.vo.order.SendCodeReturnVO;
import lombok.extern.slf4j.Slf4j;

/**
 *  发码（购票）成功通知接口
 * 
 * @author Lizy
 *
 * @param <Req>
 * @param <Resp>
 */
@Service
@TradeCode(value = "21")
@Slf4j
public class SendCodeProviderServiceImpl implements XMLProvideService<SendCodeInfoVO, SendCodeReturnVO> {
	@Resource
	SendCodeService sendCodeService;

	@Override
	public SendCodeReturnVO process(SendCodeInfoVO model) {
		SendCodeInfo sendCodeInfo=BeanUtils.copy(model, SendCodeInfo.class);
		SendCodeReturn sendCodeReturn = sendCodeService.send(sendCodeInfo);
		return BeanUtils.copy(sendCodeReturn, SendCodeReturnVO.class);
		// return null;
	}

}
