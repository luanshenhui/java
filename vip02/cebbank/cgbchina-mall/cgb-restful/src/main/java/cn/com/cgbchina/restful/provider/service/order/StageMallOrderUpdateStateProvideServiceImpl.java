package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderUpdateState;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderUpdateStateRetrun;
import cn.com.cgbchina.rest.provider.service.order.StageMallOrderUpdateStateService;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderUpdateStateRetrunVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderUpdateStateVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL112 订单状态修改(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL112")
@Slf4j
public class StageMallOrderUpdateStateProvideServiceImpl implements  SoapProvideService <StageMallOrderUpdateStateVO,StageMallOrderUpdateStateRetrunVO>{
	@Resource
	StageMallOrderUpdateStateService stageMallOrderUpdateStateService;

	@Override
	public StageMallOrderUpdateStateRetrunVO process(SoapModel<StageMallOrderUpdateStateVO> model, StageMallOrderUpdateStateVO content) {
		StageMallOrderUpdateState stageMallOrderUpdateState = BeanUtils.copy(content, StageMallOrderUpdateState.class);
		StageMallOrderUpdateStateRetrun stageMallOrderUpdateStateRetrun = stageMallOrderUpdateStateService.update(stageMallOrderUpdateState);
		StageMallOrderUpdateStateRetrunVO stageMallOrderUpdateStateRetrunVO = BeanUtils.copy(stageMallOrderUpdateStateRetrun,
				StageMallOrderUpdateStateRetrunVO.class);
		return stageMallOrderUpdateStateRetrunVO;
	}

}
