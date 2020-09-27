package cn.com.cgbchina.rest.provider.service.goods;

import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsDetailQuery;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsDetailReturn;

/**
 * MAL117 商品详细信息(分期商城)
 * 
 * @author lizy
 */
public interface StageMallGoodsDetailService {
	StageMallGoodsDetailReturn detail(StageMallGoodsDetailQuery stageMallGoodsDetailQuery);
}
