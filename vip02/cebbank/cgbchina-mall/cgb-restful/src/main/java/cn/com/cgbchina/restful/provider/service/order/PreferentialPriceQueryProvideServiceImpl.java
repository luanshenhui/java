package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.PreferentialPrice;
import cn.com.cgbchina.rest.provider.model.order.PreferentialPriceRetrun;
import cn.com.cgbchina.rest.provider.service.order.PreferentialPriceQueryService;
import cn.com.cgbchina.rest.provider.vo.order.PreferentialPriceRetrunVO;
import cn.com.cgbchina.rest.provider.vo.order.PreferentialPriceVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL322 获取最优价 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL322")
@Slf4j
public class PreferentialPriceQueryProvideServiceImpl implements  SoapProvideService <PreferentialPriceVO,PreferentialPriceRetrunVO>{
	@Resource
	PreferentialPriceQueryService preferentialPriceQueryService;

	@Override
	public PreferentialPriceRetrunVO process(SoapModel<PreferentialPriceVO> model, PreferentialPriceVO content) {
		PreferentialPrice preferentialPrice = BeanUtils.copy(content, PreferentialPrice.class);
		PreferentialPriceRetrun preferentialPriceRetrun = preferentialPriceQueryService.query(preferentialPrice);
		PreferentialPriceRetrunVO preferentialPriceRetrunVO = BeanUtils.copy(preferentialPriceRetrun,
				PreferentialPriceRetrunVO.class);
		return preferentialPriceRetrunVO;
	}

}
