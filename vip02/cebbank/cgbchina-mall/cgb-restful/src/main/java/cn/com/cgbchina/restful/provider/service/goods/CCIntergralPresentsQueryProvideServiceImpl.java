package cn.com.cgbchina.restful.provider.service.goods;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.goods.CCIntergalPresentQuery;
import cn.com.cgbchina.rest.provider.model.goods.CCIntergalPresentReturn;
import cn.com.cgbchina.rest.provider.service.goods.CCIntergralPresentsQueryService;
import cn.com.cgbchina.rest.provider.vo.goods.CCIntergalPresentReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.CCIntergalPresentQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL101 CC积分商城礼品列表查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL101")
@Slf4j
public class CCIntergralPresentsQueryProvideServiceImpl
		implements SoapProvideService<CCIntergalPresentQueryVO, CCIntergalPresentReturnVO> {
	@Resource
	CCIntergralPresentsQueryService cCIntergralPresentsQueryService;

	@Override
	public CCIntergalPresentReturnVO process(SoapModel<CCIntergalPresentQueryVO> model,
			CCIntergalPresentQueryVO content) {
		CCIntergalPresentQuery ccIntergalPresentQuery = BeanUtils.copy(content, CCIntergalPresentQuery.class);
		CCIntergalPresentReturn ccIntergalPresentReturn = cCIntergralPresentsQueryService.query(ccIntergalPresentQuery);
		return BeanUtils.copy(ccIntergalPresentReturn, CCIntergalPresentReturnVO.class);
	}

}
