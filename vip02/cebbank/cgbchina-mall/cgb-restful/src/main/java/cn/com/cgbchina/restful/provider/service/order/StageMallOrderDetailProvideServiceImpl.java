package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderDetail;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderDetailReturn;
import cn.com.cgbchina.rest.provider.service.order.StageMallOrderDetailService;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderDetailReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderDetailVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL111 订单详细信息查询(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL111")
@Slf4j
public class StageMallOrderDetailProvideServiceImpl implements  SoapProvideService <StageMallOrderDetailVO,StageMallOrderDetailReturnVO>{
	@Resource
	StageMallOrderDetailService stageMallOrderDetailService;

	@Override
	public StageMallOrderDetailReturnVO process(SoapModel<StageMallOrderDetailVO> model, StageMallOrderDetailVO content) {
		StageMallOrderDetail stageMallOrderDetail = BeanUtils.copy(content, StageMallOrderDetail.class);
		StageMallOrderDetailReturn stageMallOrderDetailReturn = stageMallOrderDetailService.detail(stageMallOrderDetail);
		StageMallOrderDetailReturnVO stageMallOrderDetailReturnVO = BeanUtils.copy(stageMallOrderDetailReturn,
				StageMallOrderDetailReturnVO.class);
		return stageMallOrderDetailReturnVO;
	}

}
