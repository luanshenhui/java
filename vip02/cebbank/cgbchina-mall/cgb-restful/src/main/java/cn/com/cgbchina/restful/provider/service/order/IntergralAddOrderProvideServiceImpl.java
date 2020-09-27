package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.IntergralAddOrder;
import cn.com.cgbchina.rest.provider.model.order.IntergralAddOrderReturn;
import cn.com.cgbchina.rest.provider.service.order.IntergralAddOrderService;
import cn.com.cgbchina.rest.provider.vo.order.IntergralAddOrderReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.IntergralAddOrderVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL324 积分商城下单 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL324")
@Slf4j
public class IntergralAddOrderProvideServiceImpl implements  SoapProvideService <IntergralAddOrderVO,IntergralAddOrderReturnVO>{
	@Resource
	IntergralAddOrderService intergralAddOrderService;

	@Override
	public IntergralAddOrderReturnVO process(SoapModel<IntergralAddOrderVO> model, IntergralAddOrderVO content) {
		IntergralAddOrder intergralAddOrder = BeanUtils.copy(content, IntergralAddOrder.class);
		IntergralAddOrderReturn intergralAddOrderReturn = intergralAddOrderService.add(intergralAddOrder);
		IntergralAddOrderReturnVO intergralAddOrderReturnVO = BeanUtils.copy(intergralAddOrderReturn,
				IntergralAddOrderReturnVO.class);
		return intergralAddOrderReturnVO;
	}

}
