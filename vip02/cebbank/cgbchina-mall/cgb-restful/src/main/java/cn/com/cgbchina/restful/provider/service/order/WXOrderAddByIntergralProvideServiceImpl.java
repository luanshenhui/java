package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.WXOrderAddByIntergralQuery;
import cn.com.cgbchina.rest.provider.model.order.WXOrderAddByIntergralReturn;
import cn.com.cgbchina.rest.provider.service.order.WXOrderAddByIntergralService;
import cn.com.cgbchina.rest.provider.vo.order.WXOrderAddByIntergralReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.WXOrderAddByIntergralQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL501 微信生成订单接口（积分） 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL501")
@Slf4j
public class WXOrderAddByIntergralProvideServiceImpl implements  SoapProvideService <WXOrderAddByIntergralQueryVO,WXOrderAddByIntergralReturnVO>{
	@Resource
	WXOrderAddByIntergralService wXOrderAddByIntergralService;

	@Override
	public WXOrderAddByIntergralReturnVO process(SoapModel<WXOrderAddByIntergralQueryVO> model, WXOrderAddByIntergralQueryVO content) {
		WXOrderAddByIntergralQuery wXOrderAddByIntergralQuery = BeanUtils.copy(content, WXOrderAddByIntergralQuery.class);
		WXOrderAddByIntergralReturn wXOrderAddByIntergralReturn = wXOrderAddByIntergralService.add(wXOrderAddByIntergralQuery);
		WXOrderAddByIntergralReturnVO wXOrderAddByIntergralReturnVO = BeanUtils.copy(wXOrderAddByIntergralReturn,
				WXOrderAddByIntergralReturnVO.class);
		return wXOrderAddByIntergralReturnVO;
	}

}
