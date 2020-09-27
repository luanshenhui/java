package cn.com.cgbchina.restful.provider.service.user;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.AppStageMallAddressAdd;
import cn.com.cgbchina.rest.provider.model.user.AppStageMallAddressAddReturn;
import cn.com.cgbchina.rest.provider.service.user.AppStageMallAddressAddService;
import cn.com.cgbchina.rest.provider.vo.user.AppStageMallAddressAddReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.AppStageMallAddressAddVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL318 添加地址接口(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL318")
@Slf4j
public class AppStageMallAddressAddProvideServiceImpl implements  SoapProvideService <AppStageMallAddressAddVO,AppStageMallAddressAddReturnVO>{
	@Resource
	AppStageMallAddressAddService appStageMallAddressAddService;

	@Override
	public AppStageMallAddressAddReturnVO process(SoapModel<AppStageMallAddressAddVO> model, AppStageMallAddressAddVO content) {
		AppStageMallAddressAdd appStageMallAddressAdd = BeanUtils.copy(content, AppStageMallAddressAdd.class);
		AppStageMallAddressAddReturn appStageMallAddressAddReturn = appStageMallAddressAddService.add(appStageMallAddressAdd);
		AppStageMallAddressAddReturnVO appStageMallAddressAddReturnVO = BeanUtils.copy(appStageMallAddressAddReturn,
				AppStageMallAddressAddReturnVO.class);
		return appStageMallAddressAddReturnVO;
	}

}
