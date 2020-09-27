package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderUpdate;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderUpdateReturn;
import cn.com.cgbchina.rest.provider.service.order.StageMallOrderUpdateService;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderUpdateReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderUpdateVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL109 订单修改(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL109")
@Slf4j
public class StageMallOrderUpdateProvideServiceImpl implements  SoapProvideService <StageMallOrderUpdateVO,StageMallOrderUpdateReturnVO>{
	@Resource
	StageMallOrderUpdateService stageMallOrderUpdateService;

	@Override
	public StageMallOrderUpdateReturnVO process(SoapModel<StageMallOrderUpdateVO> model, StageMallOrderUpdateVO content) {
		StageMallOrderUpdate stageMallOrderUpdate = BeanUtils.copy(content, StageMallOrderUpdate.class);
		StageMallOrderUpdateReturn stageMallOrderUpdateReturn = stageMallOrderUpdateService.update(stageMallOrderUpdate);
		StageMallOrderUpdateReturnVO stageMallOrderUpdateReturnVO = BeanUtils.copy(stageMallOrderUpdateReturn,
				StageMallOrderUpdateReturnVO.class);
		return stageMallOrderUpdateReturnVO;
	}

}
