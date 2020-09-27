package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.AppIntergralAddOrder;
import cn.com.cgbchina.rest.provider.model.order.AppIntergralAddOrderReturn;
import cn.com.cgbchina.rest.provider.service.order.AppIntergralAddOrderService;
import cn.com.cgbchina.rest.provider.vo.order.AppIntergralAddOrderReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.AppIntergralAddOrderVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL314 下单接口(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL314")
@Slf4j
public class AppIntergralAddOrderProvideServiceImpl implements  SoapProvideService <AppIntergralAddOrderVO,AppIntergralAddOrderReturnVO>{
	@Resource
	AppIntergralAddOrderService appIntergralAddOrderService;

	@Override
	public AppIntergralAddOrderReturnVO process(SoapModel<AppIntergralAddOrderVO> model, AppIntergralAddOrderVO content) {
		AppIntergralAddOrder appIntergralAddOrder = BeanUtils.copy(content, AppIntergralAddOrder.class);
		AppIntergralAddOrderReturn appIntergralAddOrderReturn = appIntergralAddOrderService.add(appIntergralAddOrder);
		AppIntergralAddOrderReturnVO appIntergralAddOrderReturnVO = BeanUtils.copy(appIntergralAddOrderReturn,
				AppIntergralAddOrderReturnVO.class);
		return appIntergralAddOrderReturnVO;
	}

}
