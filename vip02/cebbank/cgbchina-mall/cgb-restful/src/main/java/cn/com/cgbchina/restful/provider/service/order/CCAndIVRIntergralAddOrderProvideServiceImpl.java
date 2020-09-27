package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.CCAndIVRIntergalOrder;
import cn.com.cgbchina.rest.provider.model.order.CCAndIVRIntergalOrderReturn;
import cn.com.cgbchina.rest.provider.service.order.CCAndIVRIntergralAddOrderService;
import cn.com.cgbchina.rest.provider.vo.order.CCAndIVRIntergalOrderReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCAndIVRIntergalOrderVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL104 CC/IVR积分商城下单 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL104")
@Slf4j
public class CCAndIVRIntergralAddOrderProvideServiceImpl implements  SoapProvideService <CCAndIVRIntergalOrderVO,CCAndIVRIntergalOrderReturnVO>{
	@Resource
	CCAndIVRIntergralAddOrderService cCAndIVRIntergralAddOrderService;

	@Override
	public CCAndIVRIntergalOrderReturnVO process(SoapModel<CCAndIVRIntergalOrderVO> model, CCAndIVRIntergalOrderVO content) {
		CCAndIVRIntergalOrder cCAndIVRIntergalOrder = BeanUtils.copy(content, CCAndIVRIntergalOrder.class);
		CCAndIVRIntergalOrderReturn cCAndIVRIntergalOrderReturn = cCAndIVRIntergralAddOrderService.add(cCAndIVRIntergalOrder);
		CCAndIVRIntergalOrderReturnVO cCAndIVRIntergalOrderReturnVO = BeanUtils.copy(cCAndIVRIntergalOrderReturn,
				CCAndIVRIntergalOrderReturnVO.class);
		return cCAndIVRIntergalOrderReturnVO;
	}

}
