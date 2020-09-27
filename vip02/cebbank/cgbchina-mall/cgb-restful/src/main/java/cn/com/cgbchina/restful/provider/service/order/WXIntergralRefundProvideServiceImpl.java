package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.WXIntergral;
import cn.com.cgbchina.rest.provider.model.order.WXIntergralRefundReturn;
import cn.com.cgbchina.rest.provider.service.order.WXIntergralRefundService;
import cn.com.cgbchina.rest.provider.vo.order.WXIntergralRefundReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.WXIntergralVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL502 微信退积分接口 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL502")
@Slf4j
public class WXIntergralRefundProvideServiceImpl implements  SoapProvideService <WXIntergralVO,WXIntergralRefundReturnVO>{
	@Resource
	WXIntergralRefundService wXIntergralRefundService;

	@Override
	public WXIntergralRefundReturnVO process(SoapModel<WXIntergralVO> model, WXIntergralVO content) {
		WXIntergral wXIntergral = BeanUtils.copy(content, WXIntergral.class);
		WXIntergralRefundReturn wXIntergralRefundReturn = wXIntergralRefundService.refund(wXIntergral);
		WXIntergralRefundReturnVO wXIntergralRefundReturnVO = BeanUtils.copy(wXIntergralRefundReturn,
				WXIntergralRefundReturnVO.class);
		return wXIntergralRefundReturnVO;
	}

}
