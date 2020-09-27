package cn.com.cgbchina.restful.provider.service.user;

import javax.annotation.Resource;

import cn.com.cgbchina.trade.service.CartService;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.CustCarAdd;
import cn.com.cgbchina.rest.provider.model.user.CustCarAddReturn;
import cn.com.cgbchina.rest.provider.vo.user.CustCarAddReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.CustCarAddVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL304 加入购物车(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL304")
@Slf4j
public class CustCarAddProvideServiceImpl implements  SoapProvideService <CustCarAddVO,CustCarAddReturnVO>{
	@Resource
	CartService cartService;

	@Override
	public CustCarAddReturnVO process(SoapModel<CustCarAddVO> model, CustCarAddVO content) {
		CustCarAdd custCarAdd = BeanUtils.copy(content, CustCarAdd.class);
		CustCarAddReturn custCarAddReturn = cartService.createCartInfoForOut(custCarAdd);
		CustCarAddReturnVO custCarAddReturnVO = BeanUtils.copy(custCarAddReturn,
				CustCarAddReturnVO.class);
		return custCarAddReturnVO;
	}

}
