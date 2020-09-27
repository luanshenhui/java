package cn.com.cgbchina.restful.provider.service.user;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.CustCarQuery;
import cn.com.cgbchina.rest.provider.model.user.CustCarQueryReturn;
import cn.com.cgbchina.rest.provider.service.user.CustCarQueryService;
import cn.com.cgbchina.rest.provider.vo.user.CustCarQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.CustCarQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL305 查询购物车(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL305")
@Slf4j
public class CustCarQueryProvideServiceImpl implements  SoapProvideService <CustCarQueryVO,CustCarQueryReturnVO>{
	@Resource
	CustCarQueryService custCarQueryService;

	@Override
	public CustCarQueryReturnVO process(SoapModel<CustCarQueryVO> model, CustCarQueryVO content) {
		CustCarQuery custCarQuery = BeanUtils.copy(content, CustCarQuery.class);
		CustCarQueryReturn custCarQueryReturn = custCarQueryService.query(custCarQuery);
		CustCarQueryReturnVO custCarQueryReturnVO = BeanUtils.copy(custCarQueryReturn,
				CustCarQueryReturnVO.class);
		return custCarQueryReturnVO;
	}

}
