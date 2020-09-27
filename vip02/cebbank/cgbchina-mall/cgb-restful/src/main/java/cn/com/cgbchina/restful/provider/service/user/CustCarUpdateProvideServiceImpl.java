package cn.com.cgbchina.restful.provider.service.user;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.CustCarUpdate;
import cn.com.cgbchina.rest.provider.model.user.CustCarUpdateReturn;
import cn.com.cgbchina.rest.provider.service.user.CustCarUpdateService;
import cn.com.cgbchina.rest.provider.vo.user.CustCarUpdateReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.CustCarUpdateVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL306 修改购物车(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL306")
@Slf4j
public class CustCarUpdateProvideServiceImpl implements  SoapProvideService <CustCarUpdateVO,CustCarUpdateReturnVO>{
	@Resource
	CustCarUpdateService custCarUpdateService;

	@Override
	public CustCarUpdateReturnVO process(SoapModel<CustCarUpdateVO> model, CustCarUpdateVO content) {
		CustCarUpdate custCarUpdate = BeanUtils.copy(content, CustCarUpdate.class);
		CustCarUpdateReturn custCarUpdateReturn = custCarUpdateService.update(custCarUpdate);
		CustCarUpdateReturnVO custCarUpdateReturnVO = BeanUtils.copy(custCarUpdateReturn,
				CustCarUpdateReturnVO.class);
		return custCarUpdateReturnVO;
	}

}
