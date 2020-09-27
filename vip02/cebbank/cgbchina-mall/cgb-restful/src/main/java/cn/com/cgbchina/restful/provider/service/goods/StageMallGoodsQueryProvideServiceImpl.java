package cn.com.cgbchina.restful.provider.service.goods;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsQuery;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsQueryReturn;
import cn.com.cgbchina.rest.provider.service.goods.StageMallGoodsQueryService;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL312 商品搜索列表(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL312")
@Slf4j
public class StageMallGoodsQueryProvideServiceImpl implements  SoapProvideService <StageMallGoodsQueryVO,StageMallGoodsQueryReturnVO>{
	@Resource
	StageMallGoodsQueryService stageMallGoodsQueryService;

	@Override
	public StageMallGoodsQueryReturnVO process(SoapModel<StageMallGoodsQueryVO> model, StageMallGoodsQueryVO content) {
		StageMallGoodsQuery stageMallGoodsQuery = BeanUtils.copy(content, StageMallGoodsQuery.class);
		StageMallGoodsQueryReturn stageMallGoodsQueryReturn = stageMallGoodsQueryService.query(stageMallGoodsQuery);
		StageMallGoodsQueryReturnVO stageMallGoodsQueryReturnVO = BeanUtils.copy(stageMallGoodsQueryReturn,
				StageMallGoodsQueryReturnVO.class);
		return stageMallGoodsQueryReturnVO;
	}

}
