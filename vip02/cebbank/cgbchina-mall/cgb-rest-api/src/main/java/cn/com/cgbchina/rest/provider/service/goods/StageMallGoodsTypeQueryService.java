package cn.com.cgbchina.rest.provider.service.goods;

import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsTypeQueryReturn;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsTypeQuery;

/**
 * MAL311 商品类别查询(分期商城)
 * 
 * @author lizy 2016/4/29.
 */
public interface StageMallGoodsTypeQueryService {
	// StageMallGoodsTypeQueryReturn query(StageMallGoodsTypeQuery stageMallGoodsTypeQueryObj);
	StageMallGoodsTypeQueryReturn query(StageMallGoodsTypeQuery stageMallGoodsTypeQueryObj);
}
