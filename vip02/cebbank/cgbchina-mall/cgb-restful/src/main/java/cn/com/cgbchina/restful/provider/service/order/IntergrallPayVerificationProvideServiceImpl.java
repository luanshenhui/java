package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.IntergrallPayVerification;
import cn.com.cgbchina.rest.provider.model.order.IntergrallPayVerificationReturn;
import cn.com.cgbchina.rest.provider.service.order.IntergrallPayVerificationService;
import cn.com.cgbchina.rest.provider.vo.order.IntergrallPayVerificationReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.IntergrallPayVerificationVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL325 积分商城支付校验接口 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL325")
@Slf4j
public class IntergrallPayVerificationProvideServiceImpl implements  SoapProvideService <IntergrallPayVerificationVO,IntergrallPayVerificationReturnVO>{
	@Resource
	IntergrallPayVerificationService intergrallPayVerificationService;

	@Override
	public IntergrallPayVerificationReturnVO process(SoapModel<IntergrallPayVerificationVO> model, IntergrallPayVerificationVO content) {
		IntergrallPayVerification intergrallPayVerification = BeanUtils.copy(content, IntergrallPayVerification.class);
		IntergrallPayVerificationReturn intergrallPayVerificationReturn = intergrallPayVerificationService.Verification(intergrallPayVerification);
		IntergrallPayVerificationReturnVO intergrallPayVerificationReturnVO = BeanUtils.copy(intergrallPayVerificationReturn,
				IntergrallPayVerificationReturnVO.class);
		return intergrallPayVerificationReturnVO;
	}

}
