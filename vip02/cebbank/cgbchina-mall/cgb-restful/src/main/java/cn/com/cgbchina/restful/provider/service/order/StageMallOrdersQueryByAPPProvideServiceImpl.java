package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrdersQueryByAPP;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrdersQueryByAPPReturn;
import cn.com.cgbchina.rest.provider.service.order.StageMallOrdersQueryByAPPService;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrdersQueryByAPPReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrdersQueryByAPPVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL308 订单查询(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL308")
@Slf4j
public class StageMallOrdersQueryByAPPProvideServiceImpl implements  SoapProvideService <StageMallOrdersQueryByAPPVO,StageMallOrdersQueryByAPPReturnVO>{
	@Resource
	StageMallOrdersQueryByAPPService stageMallOrdersQueryByAPPService;

	@Override
	public StageMallOrdersQueryByAPPReturnVO process(SoapModel<StageMallOrdersQueryByAPPVO> model, StageMallOrdersQueryByAPPVO content) {
		StageMallOrdersQueryByAPP stageMallOrdersQueryByAPP = BeanUtils.copy(content, StageMallOrdersQueryByAPP.class);
		StageMallOrdersQueryByAPPReturn stageMallOrdersQueryByAPPReturn = stageMallOrdersQueryByAPPService.query(stageMallOrdersQueryByAPP);
		StageMallOrdersQueryByAPPReturnVO stageMallOrdersQueryByAPPReturnVO = BeanUtils.copy(stageMallOrdersQueryByAPPReturn,
				StageMallOrdersQueryByAPPReturnVO.class);
		return stageMallOrdersQueryByAPPReturnVO;
	}

}
