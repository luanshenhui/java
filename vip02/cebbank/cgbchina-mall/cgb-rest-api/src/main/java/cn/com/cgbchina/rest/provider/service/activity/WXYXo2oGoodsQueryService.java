package cn.com.cgbchina.rest.provider.service.activity;

import cn.com.cgbchina.rest.provider.model.activity.WXYXo2oGoodsQuery;
import cn.com.cgbchina.rest.provider.model.activity.WXYXo2oGoodsQueryReturn;

/**
 * MAL421 微信易信O2O0元秒杀商品详情查询
 * 
 * @author lizy 2016/4/28.
 */
public interface WXYXo2oGoodsQueryService {
	WXYXo2oGoodsQueryReturn query(WXYXo2oGoodsQuery wxYXo2oGoodsQuery);
}
