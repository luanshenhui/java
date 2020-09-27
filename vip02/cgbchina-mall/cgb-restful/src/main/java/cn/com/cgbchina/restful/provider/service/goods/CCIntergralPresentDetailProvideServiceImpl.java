package cn.com.cgbchina.restful.provider.service.goods;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.goods.CCIntergalPresentDetailQuery;
import cn.com.cgbchina.rest.provider.model.goods.CCIntergalPresentDetail;
import cn.com.cgbchina.rest.provider.service.goods.CCIntergralPresentDetailService;
import cn.com.cgbchina.rest.provider.vo.goods.CCIntergalPresentDetailVO;
import cn.com.cgbchina.rest.provider.vo.goods.CCIntergalPresentDetailQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL102 CC积分商城单个礼品查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL102")
@Slf4j
public class CCIntergralPresentDetailProvideServiceImpl implements  SoapProvideService <CCIntergalPresentDetailQueryVO,CCIntergalPresentDetailVO>{
	@Resource
	CCIntergralPresentDetailService cCIntergralPresentDetailService;

	@Override
	public CCIntergalPresentDetailVO process(SoapModel<CCIntergalPresentDetailQueryVO> model, CCIntergalPresentDetailQueryVO content) {
		CCIntergalPresentDetailQuery cCIntergalPresentDetailQuery = BeanUtils.copy(content, CCIntergalPresentDetailQuery.class);
		CCIntergalPresentDetail cCIntergalPresentDetail = cCIntergralPresentDetailService.detail(cCIntergalPresentDetailQuery);
		CCIntergalPresentDetailVO cCIntergalPresentDetailVO = BeanUtils.copy(cCIntergalPresentDetail,
				CCIntergalPresentDetailVO.class);
		//cCIntergalPresentDetailVO.setSuccessCode("00");
		return cCIntergalPresentDetailVO;
	}

}
