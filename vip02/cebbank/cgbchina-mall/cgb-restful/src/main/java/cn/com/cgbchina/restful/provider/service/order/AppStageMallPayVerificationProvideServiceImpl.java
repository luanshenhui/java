package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.AppStageMallPayVerification;
import cn.com.cgbchina.rest.provider.model.order.AppStageMallPayVerificationReturn;
import cn.com.cgbchina.rest.provider.service.order.AppStageMallPayVerificationService;
import cn.com.cgbchina.rest.provider.vo.order.AppStageMallPayVerificationReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.AppStageMallPayVerificationVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL315 订单支付结果校验接口(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL315")
@Slf4j
public class AppStageMallPayVerificationProvideServiceImpl implements  SoapProvideService <AppStageMallPayVerificationVO,AppStageMallPayVerificationReturnVO>{
	@Resource
	AppStageMallPayVerificationService appStageMallPayVerificationService;

	@Override
	public AppStageMallPayVerificationReturnVO process(SoapModel<AppStageMallPayVerificationVO> model, AppStageMallPayVerificationVO content) {
		AppStageMallPayVerification appStageMallPayVerification = BeanUtils.copy(content, AppStageMallPayVerification.class);
		AppStageMallPayVerificationReturn appStageMallPayVerificationReturn = appStageMallPayVerificationService.Verification(appStageMallPayVerification);
		AppStageMallPayVerificationReturnVO appStageMallPayVerificationReturnVO = BeanUtils.copy(appStageMallPayVerificationReturn,
				AppStageMallPayVerificationReturnVO.class);
		return appStageMallPayVerificationReturnVO;
	}

}
