package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderCancelorRefund;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderCancelorRefundReturn;
import cn.com.cgbchina.rest.provider.service.order.StageMallOrderCancelorRefundService;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderCancelorRefundReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderCancelorRefundVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL110 订单撤销退货(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL110")
@Slf4j
public class StageMallOrderCancelorRefundProvideServiceImpl implements  SoapProvideService <StageMallOrderCancelorRefundVO,StageMallOrderCancelorRefundReturnVO>{
	@Resource
	StageMallOrderCancelorRefundService stageMallOrderCancelorRefundService;

	@Override
	public StageMallOrderCancelorRefundReturnVO process(SoapModel<StageMallOrderCancelorRefundVO> model, StageMallOrderCancelorRefundVO content) {
		StageMallOrderCancelorRefund stageMallOrderCancelorRefund = BeanUtils.copy(content, StageMallOrderCancelorRefund.class);
		StageMallOrderCancelorRefundReturn stageMallOrderCancelorRefundReturn = stageMallOrderCancelorRefundService.cancelorRefundorder(stageMallOrderCancelorRefund);
		StageMallOrderCancelorRefundReturnVO stageMallOrderCancelorRefundReturnVO = BeanUtils.copy(stageMallOrderCancelorRefundReturn,
				StageMallOrderCancelorRefundReturnVO.class);
		return stageMallOrderCancelorRefundReturnVO;
	}

}
