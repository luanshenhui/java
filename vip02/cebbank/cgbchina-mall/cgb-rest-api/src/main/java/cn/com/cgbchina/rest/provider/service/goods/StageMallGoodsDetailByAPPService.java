package cn.com.cgbchina.rest.provider.service.goods;

import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsDetailByAPPQuery;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsDetailByAPPReturn;

/**
 * MAL313 商品详细信息(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public interface StageMallGoodsDetailByAPPService {
	StageMallGoodsDetailByAPPReturn detail(StageMallGoodsDetailByAPPQuery stageMallGoodsDetailByAPPQuery);

}
