package cn.com.cgbchina.restful.provider.service.goods;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsDetailQuery;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsDetailReturn;
import cn.com.cgbchina.rest.provider.service.goods.StageMallGoodsDetailService;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsDetailReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsDetailQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL117 商品详细信息(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL117")
@Slf4j
public class StageMallGoodsDetailProvideServiceImpl implements  SoapProvideService <StageMallGoodsDetailQueryVO,StageMallGoodsDetailReturnVO>{
	@Resource
	StageMallGoodsDetailService stageMallGoodsDetailService;

	@Override
	public StageMallGoodsDetailReturnVO process(SoapModel<StageMallGoodsDetailQueryVO> model, StageMallGoodsDetailQueryVO content) {
		StageMallGoodsDetailQuery stageMallGoodsDetailQuery = BeanUtils.copy(content, StageMallGoodsDetailQuery.class);
		StageMallGoodsDetailReturn stageMallGoodsDetailReturn = stageMallGoodsDetailService.detail(stageMallGoodsDetailQuery);
		StageMallGoodsDetailReturnVO stageMallGoodsDetailReturnVO = BeanUtils.copy(stageMallGoodsDetailReturn,
				StageMallGoodsDetailReturnVO.class);
		return stageMallGoodsDetailReturnVO;
	}

}
