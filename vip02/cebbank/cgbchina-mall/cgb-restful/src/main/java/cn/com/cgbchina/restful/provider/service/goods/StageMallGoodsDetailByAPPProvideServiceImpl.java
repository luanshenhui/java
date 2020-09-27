package cn.com.cgbchina.restful.provider.service.goods;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsDetailByAPPQuery;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsDetailByAPPReturn;
import cn.com.cgbchina.rest.provider.service.goods.StageMallGoodsDetailByAPPService;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsDetailByAPPReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsDetailByAPPQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL313 商品详细信息(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL313")
@Slf4j
public class StageMallGoodsDetailByAPPProvideServiceImpl implements  SoapProvideService <StageMallGoodsDetailByAPPQueryVO,StageMallGoodsDetailByAPPReturnVO>{
	@Resource
	StageMallGoodsDetailByAPPService stageMallGoodsDetailByAPPService;

	@Override
	public StageMallGoodsDetailByAPPReturnVO process(SoapModel<StageMallGoodsDetailByAPPQueryVO> model, StageMallGoodsDetailByAPPQueryVO content) {
		StageMallGoodsDetailByAPPQuery stageMallGoodsDetailByAPPQuery = BeanUtils.copy(content, StageMallGoodsDetailByAPPQuery.class);
		StageMallGoodsDetailByAPPReturn stageMallGoodsDetailByAPPReturn = stageMallGoodsDetailByAPPService.detail(stageMallGoodsDetailByAPPQuery);
		StageMallGoodsDetailByAPPReturnVO stageMallGoodsDetailByAPPReturnVO = BeanUtils.copy(stageMallGoodsDetailByAPPReturn,
				StageMallGoodsDetailByAPPReturnVO.class);
		return stageMallGoodsDetailByAPPReturnVO;
	}

}
