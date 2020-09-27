package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderCancelOrRefund;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderCancelOrRefundReturn;
import cn.com.cgbchina.rest.provider.service.order.CCIntergralOrderCancelOrRefundService;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrderCancelOrRefundReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrderCancelOrRefundVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL107 CC积分商城订单撤单和退货 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL107")
@Slf4j
public class CCIntergralOrderCancelOrRefundProvideServiceImpl implements  SoapProvideService <CCIntergralOrderCancelOrRefundVO,CCIntergralOrderCancelOrRefundReturnVO>{
	@Resource
	CCIntergralOrderCancelOrRefundService cCIntergralOrderCancelOrRefundService;

	@Override
	public CCIntergralOrderCancelOrRefundReturnVO process(SoapModel<CCIntergralOrderCancelOrRefundVO> model, CCIntergralOrderCancelOrRefundVO content) {
		CCIntergralOrderCancelOrRefund cCIntergralOrderCancelOrRefund = BeanUtils.copy(content, CCIntergralOrderCancelOrRefund.class);
		CCIntergralOrderCancelOrRefundReturn cCIntergralOrderCancelOrRefundReturn = cCIntergralOrderCancelOrRefundService.cancelOrRefund(cCIntergralOrderCancelOrRefund);
		CCIntergralOrderCancelOrRefundReturnVO cCIntergralOrderCancelOrRefundReturnVO = BeanUtils.copy(cCIntergralOrderCancelOrRefundReturn,
				CCIntergralOrderCancelOrRefundReturnVO.class);
		return cCIntergralOrderCancelOrRefundReturnVO;
	}

}
