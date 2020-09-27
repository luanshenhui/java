package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.WXYX020FreeOrderQuery;
import cn.com.cgbchina.rest.provider.model.order.WXYX020FreeOrderReturn;
import cn.com.cgbchina.rest.provider.service.order.WXYX020FreeOrderAddService;
import cn.com.cgbchina.rest.provider.vo.order.WXYX020FreeOrderReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.WXYX020FreeOrderQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL423 微信易信O2O合作商0元秒杀下单 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL423")
@Slf4j
public class WXYX020FreeOrderAddProvideServiceImpl implements  SoapProvideService <WXYX020FreeOrderQueryVO,WXYX020FreeOrderReturnVO>{
	@Resource
	WXYX020FreeOrderAddService wXYX020FreeOrderAddService;

	@Override
	public WXYX020FreeOrderReturnVO process(SoapModel<WXYX020FreeOrderQueryVO> model, WXYX020FreeOrderQueryVO content) {
		WXYX020FreeOrderQuery wXYX020FreeOrderQuery = BeanUtils.copy(content, WXYX020FreeOrderQuery.class);
		WXYX020FreeOrderReturn wXYX020FreeOrderReturn = wXYX020FreeOrderAddService.add(wXYX020FreeOrderQuery);
		WXYX020FreeOrderReturnVO wXYX020FreeOrderReturnVO = BeanUtils.copy(wXYX020FreeOrderReturn,
				WXYX020FreeOrderReturnVO.class);
		return wXYX020FreeOrderReturnVO;
	}

}
