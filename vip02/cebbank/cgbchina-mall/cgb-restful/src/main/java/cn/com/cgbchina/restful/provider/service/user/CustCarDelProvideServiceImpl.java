package cn.com.cgbchina.restful.provider.service.user;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.CustCarDel;
import cn.com.cgbchina.rest.provider.model.user.CustCarDelReturn;
import cn.com.cgbchina.rest.provider.service.user.CustCarDelService;
import cn.com.cgbchina.rest.provider.vo.user.CustCarDelReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.CustCarDelVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL307 删除购物车(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL307")
@Slf4j
public class CustCarDelProvideServiceImpl implements  SoapProvideService <CustCarDelVO,CustCarDelReturnVO>{
	@Resource
	CustCarDelService custCarDelService;

	@Override
	public CustCarDelReturnVO process(SoapModel<CustCarDelVO> model, CustCarDelVO content) {
		CustCarDel custCarDel = BeanUtils.copy(content, CustCarDel.class);
		CustCarDelReturn custCarDelReturn = custCarDelService.del(custCarDel);
		CustCarDelReturnVO custCarDelReturnVO = BeanUtils.copy(custCarDelReturn,
				CustCarDelReturnVO.class);
		return custCarDelReturnVO;
	}

}
