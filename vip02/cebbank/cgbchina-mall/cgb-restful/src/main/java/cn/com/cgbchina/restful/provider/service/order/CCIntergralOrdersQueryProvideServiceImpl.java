package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrdersQuery;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrdersReturn;
import cn.com.cgbchina.rest.provider.service.order.CCIntergralOrdersQueryService;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrdersReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrdersQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL105 CC积分商城订单列表查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL105")
@Slf4j
public class CCIntergralOrdersQueryProvideServiceImpl implements  SoapProvideService <CCIntergralOrdersQueryVO,CCIntergralOrdersReturnVO>{
	@Resource
	CCIntergralOrdersQueryService cCIntergralOrdersQueryService;

	@Override
	public CCIntergralOrdersReturnVO process(SoapModel<CCIntergralOrdersQueryVO> model, CCIntergralOrdersQueryVO content) {
		CCIntergralOrdersQuery cCIntergralOrdersQuery = BeanUtils.copy(content, CCIntergralOrdersQuery.class);
		CCIntergralOrdersReturn cCIntergralOrdersReturn = cCIntergralOrdersQueryService.query(cCIntergralOrdersQuery);
		CCIntergralOrdersReturnVO cCIntergralOrdersReturnVO = BeanUtils.copy(cCIntergralOrdersReturn,
				CCIntergralOrdersReturnVO.class);
		return cCIntergralOrdersReturnVO;
	}

}
