package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.CCVerificationCodeQuery;
import cn.com.cgbchina.rest.provider.model.order.CCVerificationCodeReturn;
import cn.com.cgbchina.rest.provider.service.order.CCVerificationCodeService;
import cn.com.cgbchina.rest.provider.vo.order.CCVerificationCodeReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCVerificationCodeQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL121 CC重发验证码 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL121")
@Slf4j
public class CCVerificationCodeProvideServiceImpl implements  SoapProvideService <CCVerificationCodeQueryVO,CCVerificationCodeReturnVO>{
	@Resource
	CCVerificationCodeService cCVerificationCodeService;

	@Override
	public CCVerificationCodeReturnVO process(SoapModel<CCVerificationCodeQueryVO> model, CCVerificationCodeQueryVO content) {
		CCVerificationCodeQuery cCVerificationCodeQuery = BeanUtils.copy(content, CCVerificationCodeQuery.class);
		CCVerificationCodeReturn cCVerificationCodeReturn = cCVerificationCodeService.getCCVerificationCode(cCVerificationCodeQuery);
		CCVerificationCodeReturnVO cCVerificationCodeReturnVO = BeanUtils.copy(cCVerificationCodeReturn,
				CCVerificationCodeReturnVO.class);
		return cCVerificationCodeReturnVO;
	}

}
