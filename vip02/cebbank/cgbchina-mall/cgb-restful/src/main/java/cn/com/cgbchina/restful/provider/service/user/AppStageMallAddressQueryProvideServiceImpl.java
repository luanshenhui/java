package cn.com.cgbchina.restful.provider.service.user;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.AppStageMallAddressQuery;
import cn.com.cgbchina.rest.provider.model.user.AppStageMallAddressReturn;
import cn.com.cgbchina.rest.provider.service.user.AppStageMallAddressQueryService;
import cn.com.cgbchina.rest.provider.vo.user.AppStageMallAddressReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.AppStageMallAddressQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL317 地址查询接口(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL317")
@Slf4j
public class AppStageMallAddressQueryProvideServiceImpl implements  SoapProvideService <AppStageMallAddressQueryVO,AppStageMallAddressReturnVO>{
	@Resource
	AppStageMallAddressQueryService appStageMallAddressQueryService;

	@Override
	public AppStageMallAddressReturnVO process(SoapModel<AppStageMallAddressQueryVO> model, AppStageMallAddressQueryVO content) {
		AppStageMallAddressQuery appStageMallAddressQuery = BeanUtils.copy(content, AppStageMallAddressQuery.class);
		AppStageMallAddressReturn appStageMallAddressReturn = appStageMallAddressQueryService.query(appStageMallAddressQuery);
		AppStageMallAddressReturnVO appStageMallAddressReturnVO = BeanUtils.copy(appStageMallAddressReturn,
				AppStageMallAddressReturnVO.class);
		return appStageMallAddressReturnVO;
	}

}
