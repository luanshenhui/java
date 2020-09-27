package cn.com.cgbchina.restful.provider.service.goods;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.goods.StageMallAdvertise;
import cn.com.cgbchina.rest.provider.model.goods.StageMallAdvertiseQueryReturn;
import cn.com.cgbchina.rest.provider.service.goods.StageMallAdvertiseQueryService;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallAdvertiseQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallAdvertiseVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL321 广告查询(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL321")
@Slf4j
public class StageMallAdvertiseQueryProvideServiceImpl implements  SoapProvideService <StageMallAdvertiseVO,StageMallAdvertiseQueryReturnVO>{
	@Resource
	StageMallAdvertiseQueryService stageMallAdvertiseQueryService;

	@Override
	public StageMallAdvertiseQueryReturnVO process(SoapModel<StageMallAdvertiseVO> model, StageMallAdvertiseVO content) {
		StageMallAdvertise stageMallAdvertise = BeanUtils.copy(content, StageMallAdvertise.class);
		StageMallAdvertiseQueryReturn stageMallAdvertiseQueryReturn = stageMallAdvertiseQueryService.query(stageMallAdvertise);
		StageMallAdvertiseQueryReturnVO stageMallAdvertiseQueryReturnVO = BeanUtils.copy(stageMallAdvertiseQueryReturn,
				StageMallAdvertiseQueryReturnVO.class);
		return stageMallAdvertiseQueryReturnVO;
	}

}
