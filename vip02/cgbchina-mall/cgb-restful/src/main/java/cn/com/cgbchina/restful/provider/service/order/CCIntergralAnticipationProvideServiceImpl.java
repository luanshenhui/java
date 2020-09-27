package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralAnticipation;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralAnticipationReturn;
import cn.com.cgbchina.rest.provider.service.order.CCIntergralAnticipationService;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralAnticipationReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralAnticipationVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL201 CC积分商城预判接口 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL201")
@Slf4j
public class CCIntergralAnticipationProvideServiceImpl implements  SoapProvideService <CCIntergralAnticipationVO,CCIntergralAnticipationReturnVO>{
	@Resource
	CCIntergralAnticipationService cCIntergralAnticipationService;

	@Override
	public CCIntergralAnticipationReturnVO process(SoapModel<CCIntergralAnticipationVO> model, CCIntergralAnticipationVO content) {
		CCIntergralAnticipation cCIntergralAnticipation = BeanUtils.copy(content, CCIntergralAnticipation.class);
		CCIntergralAnticipationReturn cCIntergralAnticipationReturn = cCIntergralAnticipationService.intergralAnticipation(cCIntergralAnticipation);
		CCIntergralAnticipationReturnVO cCIntergralAnticipationReturnVO = BeanUtils.copy(cCIntergralAnticipationReturn,
				CCIntergralAnticipationReturnVO.class);
		return cCIntergralAnticipationReturnVO;
	}

}
