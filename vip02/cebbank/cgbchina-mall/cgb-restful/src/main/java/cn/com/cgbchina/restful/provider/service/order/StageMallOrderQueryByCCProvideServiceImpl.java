package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderQueryByCC;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderQueryByCCReturn;
import cn.com.cgbchina.rest.provider.service.order.StageMallOrderQueryByCCService;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderQueryByCCReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderQueryByCCVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL113 CC订单查询(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL113")
@Slf4j
public class StageMallOrderQueryByCCProvideServiceImpl implements  SoapProvideService <StageMallOrderQueryByCCVO,StageMallOrderQueryByCCReturnVO>{
	@Resource
	StageMallOrderQueryByCCService stageMallOrderQueryByCCService;

	@Override
	public StageMallOrderQueryByCCReturnVO process(SoapModel<StageMallOrderQueryByCCVO> model, StageMallOrderQueryByCCVO content) {
		StageMallOrderQueryByCC stageMallOrderQueryByCC = BeanUtils.copy(content, StageMallOrderQueryByCC.class);
		StageMallOrderQueryByCCReturn stageMallOrderQueryByCCReturn = stageMallOrderQueryByCCService.query(stageMallOrderQueryByCC);
		StageMallOrderQueryByCCReturnVO stageMallOrderQueryByCCReturnVO = BeanUtils.copy(stageMallOrderQueryByCCReturn,
				StageMallOrderQueryByCCReturnVO.class);
		return stageMallOrderQueryByCCReturnVO;
	}

}
