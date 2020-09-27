package cn.com.cgbchina.restful.provider.service.goods;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsTypeQueryReturn;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsTypeQuery;
import cn.com.cgbchina.rest.provider.service.goods.StageMallGoodsTypeQueryService;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsTypeQueryVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsTypeQueryReturnVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL311 商品类别查询(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL311")
@Slf4j
public class StageMallGoodsTypeQueryProvideServiceImpl implements  SoapProvideService < StageMallGoodsTypeQueryVO,StageMallGoodsTypeQueryReturnVO>{
	@Resource
	StageMallGoodsTypeQueryService stageMallGoodsTypeQueryService;

	@Override
	public StageMallGoodsTypeQueryReturnVO process(SoapModel<StageMallGoodsTypeQueryVO> model, StageMallGoodsTypeQueryVO content) {
		StageMallGoodsTypeQuery stageMallGoodsTypeQuery = BeanUtils.copy(content, StageMallGoodsTypeQuery.class);
		 StageMallGoodsTypeQueryReturn  stageMallGoodsTypeQueryReturn = stageMallGoodsTypeQueryService.query(stageMallGoodsTypeQuery);
		 StageMallGoodsTypeQueryReturnVO stageMallGoodsTypeQueryReturnVO = BeanUtils.copy(stageMallGoodsTypeQueryReturn,
				 StageMallGoodsTypeQueryReturnVO.class);
		return stageMallGoodsTypeQueryReturnVO;
	}

}
