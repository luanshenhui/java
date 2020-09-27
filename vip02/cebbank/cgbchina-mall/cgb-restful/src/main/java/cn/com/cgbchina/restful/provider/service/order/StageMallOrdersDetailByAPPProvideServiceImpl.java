package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrdersDetailByAPPQuery;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrdersDetailByAPPReturn;
import cn.com.cgbchina.rest.provider.service.order.StageMallOrdersDetailByAPPService;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrdersDetailByAPPReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrdersDetailByAPPQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL309 订单详细信息查询(分期商城)App 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL309")
@Slf4j
public class StageMallOrdersDetailByAPPProvideServiceImpl implements  SoapProvideService <StageMallOrdersDetailByAPPQueryVO,StageMallOrdersDetailByAPPReturnVO>{
	@Resource
	StageMallOrdersDetailByAPPService stageMallOrdersDetailByAPPService;

	@Override
	public StageMallOrdersDetailByAPPReturnVO process(SoapModel<StageMallOrdersDetailByAPPQueryVO> model, StageMallOrdersDetailByAPPQueryVO content) {
		StageMallOrdersDetailByAPPQuery stageMallOrdersDetailByAPPQuery = BeanUtils.copy(content, StageMallOrdersDetailByAPPQuery.class);
		StageMallOrdersDetailByAPPReturn stageMallOrdersDetailByAPPReturn = stageMallOrdersDetailByAPPService.detail(stageMallOrdersDetailByAPPQuery);
		StageMallOrdersDetailByAPPReturnVO stageMallOrdersDetailByAPPReturnVO = BeanUtils.copy(stageMallOrdersDetailByAPPReturn,
				StageMallOrdersDetailByAPPReturnVO.class);
		return stageMallOrdersDetailByAPPReturnVO;
	}

}
