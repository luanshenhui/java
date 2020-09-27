package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.VerificationCodeQuery;
import cn.com.cgbchina.rest.provider.model.order.VerificationCodeReturn;
import cn.com.cgbchina.rest.provider.service.order.WXYXVerificationCodeService;
import cn.com.cgbchina.rest.provider.vo.order.VerificationCodeReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.VerificationCodeQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL422 微信易信验证码查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL422")
@Slf4j
public class WXYXVerificationCodeProvideServiceImpl implements  SoapProvideService <VerificationCodeQueryVO,VerificationCodeReturnVO>{
	@Resource
	WXYXVerificationCodeService wXYXVerificationCodeService;

	@Override
	public VerificationCodeReturnVO process(SoapModel<VerificationCodeQueryVO> model, VerificationCodeQueryVO content) {
		VerificationCodeQuery verificationCodeQuery = BeanUtils.copy(content, VerificationCodeQuery.class);
		VerificationCodeReturn verificationCodeReturn = wXYXVerificationCodeService.getVerificationCode(verificationCodeQuery);
		VerificationCodeReturnVO verificationCodeReturnVO = BeanUtils.copy(verificationCodeReturn,
				VerificationCodeReturnVO.class);
		return verificationCodeReturnVO;
	}

}
