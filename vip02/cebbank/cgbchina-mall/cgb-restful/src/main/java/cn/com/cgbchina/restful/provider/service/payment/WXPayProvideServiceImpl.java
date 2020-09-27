package cn.com.cgbchina.restful.provider.service.payment;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.payment.WXPay;
import cn.com.cgbchina.rest.provider.model.payment.WXPayReturn;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.service.payment.WXPayService;
import cn.com.cgbchina.rest.provider.vo.order.CCVerificationCodeReturnVO;
import cn.com.cgbchina.rest.provider.vo.payment.WXPayReturnVO;
import cn.com.cgbchina.rest.provider.vo.payment.WXPayVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL503	微信发起支付接口
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL503")
@Slf4j
public class WXPayProvideServiceImpl implements  SoapProvideService <WXPayVO,WXPayReturnVO>{
	@Resource
	WXPayService wxPayService;

	@Override
	public WXPayReturnVO process(SoapModel<WXPayVO> model, WXPayVO content) {
		WXPay wxPay = BeanUtils.copy(content, WXPay.class);
		WXPayReturn wxPayReturn = wxPayService.pay(wxPay);
		return BeanUtils.copy(wxPayReturn,WXPayReturnVO.class);
	}

}
