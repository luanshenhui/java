package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.CCAddOrderByCgbAdd;
import cn.com.cgbchina.rest.provider.model.order.CCAddOrderByCgbAddReturn;
import cn.com.cgbchina.rest.provider.service.order.CCAddOrderByCgbService;
import cn.com.cgbchina.rest.provider.vo.order.CCAddOrderByCgbAddReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCAddOrderByCgbAddVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL115 CC广发下单 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL115")
@Slf4j
public class CCAddOrderByCgbProvideServiceImpl implements  SoapProvideService <CCAddOrderByCgbAddVO,CCAddOrderByCgbAddReturnVO>{
	@Resource
	CCAddOrderByCgbService cCAddOrderByCgbService;

	@Override
	public CCAddOrderByCgbAddReturnVO process(SoapModel<CCAddOrderByCgbAddVO> model, CCAddOrderByCgbAddVO content) {
		CCAddOrderByCgbAdd cCAddOrderByCgbAdd = BeanUtils.copy(content, CCAddOrderByCgbAdd.class);
		CCAddOrderByCgbAddReturn cCAddOrderByCgbAddReturn = cCAddOrderByCgbService.add(cCAddOrderByCgbAdd);
		CCAddOrderByCgbAddReturnVO cCAddOrderByCgbAddReturnVO = BeanUtils.copy(cCAddOrderByCgbAddReturn,
				CCAddOrderByCgbAddReturnVO.class);
		return cCAddOrderByCgbAddReturnVO;
	}

}
