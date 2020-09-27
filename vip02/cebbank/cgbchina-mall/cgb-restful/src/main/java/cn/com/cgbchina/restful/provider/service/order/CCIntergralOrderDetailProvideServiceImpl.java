package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderDetailQuery;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderDetailReturn;
import cn.com.cgbchina.rest.provider.service.order.CCIntergralOrderDetailService;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrderDetailReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrderDetailQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL108 CC积分商城订单详细信息查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL108")
@Slf4j
public class CCIntergralOrderDetailProvideServiceImpl implements  SoapProvideService <CCIntergralOrderDetailQueryVO,CCIntergralOrderDetailReturnVO>{
	@Resource
	CCIntergralOrderDetailService cCIntergralOrderDetailService;

	@Override
	public CCIntergralOrderDetailReturnVO process(SoapModel<CCIntergralOrderDetailQueryVO> model, CCIntergralOrderDetailQueryVO content) {
		CCIntergralOrderDetailQuery cCIntergralOrderDetailQuery = BeanUtils.copy(content, CCIntergralOrderDetailQuery.class);
		CCIntergralOrderDetailReturn cCIntergralOrderDetailReturn = cCIntergralOrderDetailService.detail(cCIntergralOrderDetailQuery);
		CCIntergralOrderDetailReturnVO cCIntergralOrderDetailReturnVO = BeanUtils.copy(cCIntergralOrderDetailReturn,
				CCIntergralOrderDetailReturnVO.class);
		return cCIntergralOrderDetailReturnVO;
	}

}
