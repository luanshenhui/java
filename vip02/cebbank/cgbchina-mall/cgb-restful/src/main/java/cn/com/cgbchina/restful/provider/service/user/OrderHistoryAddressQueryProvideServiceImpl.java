package cn.com.cgbchina.restful.provider.service.user;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.OrderHistoryAddressQuery;
import cn.com.cgbchina.rest.provider.model.user.OrderHistoryAddressQueryReturn;
import cn.com.cgbchina.rest.provider.service.user.OrderHistoryAddressQueryService;
import cn.com.cgbchina.rest.provider.vo.user.OrderHistoryAddressQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.OrderHistoryAddressQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL114 订单历史地址信息查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL114")
@Slf4j
public class OrderHistoryAddressQueryProvideServiceImpl implements  SoapProvideService <OrderHistoryAddressQueryVO,OrderHistoryAddressQueryReturnVO>{
	@Resource
	OrderHistoryAddressQueryService orderHistoryAddressQueryService;

	@Override
	public OrderHistoryAddressQueryReturnVO process(SoapModel<OrderHistoryAddressQueryVO> model, OrderHistoryAddressQueryVO content) {
		OrderHistoryAddressQuery orderHistoryAddressQuery = BeanUtils.copy(content, OrderHistoryAddressQuery.class);
		OrderHistoryAddressQueryReturn orderHistoryAddressQueryReturn = orderHistoryAddressQueryService.query(orderHistoryAddressQuery);
		OrderHistoryAddressQueryReturnVO orderHistoryAddressQueryReturnVO = BeanUtils.copy(orderHistoryAddressQueryReturn,
				OrderHistoryAddressQueryReturnVO.class);
		return orderHistoryAddressQueryReturnVO;
	}

}
