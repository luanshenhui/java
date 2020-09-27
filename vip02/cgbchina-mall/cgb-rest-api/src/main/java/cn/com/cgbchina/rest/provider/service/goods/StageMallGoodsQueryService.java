package cn.com.cgbchina.rest.provider.service.goods;

import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsQuery;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsQueryReturn;

/**
 * MAL312 商品搜索列表(分期商城)
 * 
 * @author lizy 2016/4/29.
 */
public interface StageMallGoodsQueryService {
	StageMallGoodsQueryReturn query(StageMallGoodsQuery stageMallGoodsQuery);
}
