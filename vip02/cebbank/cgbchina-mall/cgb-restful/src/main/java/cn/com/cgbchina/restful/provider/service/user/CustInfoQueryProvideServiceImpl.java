package cn.com.cgbchina.restful.provider.service.user;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.CustInfo;
import cn.com.cgbchina.rest.provider.model.user.CustInfoQueryReturn;
import cn.com.cgbchina.rest.provider.service.user.CustInfoQueryService;
import cn.com.cgbchina.rest.provider.vo.user.CustInfoQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.CustInfoVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL323 客户信息查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL323")
@Slf4j
public class CustInfoQueryProvideServiceImpl implements  SoapProvideService <CustInfoVO,CustInfoQueryReturnVO>{
	@Resource
	CustInfoQueryService custInfoQueryService;

	@Override
	public CustInfoQueryReturnVO process(SoapModel<CustInfoVO> model, CustInfoVO content) {
		CustInfo custInfo = BeanUtils.copy(content, CustInfo.class);
		CustInfoQueryReturn custInfoQueryReturn = custInfoQueryService.query(custInfo);
		CustInfoQueryReturnVO custInfoQueryReturnVO = BeanUtils.copy(custInfoQueryReturn,
				CustInfoQueryReturnVO.class);
		return custInfoQueryReturnVO;
	}

}
