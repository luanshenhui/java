package cn.com.cgbchina.rest.provider.service.activity;

import cn.com.cgbchina.rest.provider.model.activity.SPGoodsQuery;
import cn.com.cgbchina.rest.provider.model.activity.SPGoodsReturn;

/**
 * MAL335 特殊商品列表查询
 * 
 * @author lizy 2016/4/28.
 */
public interface SPGoodsQueryService {
	SPGoodsReturn query(SPGoodsQuery spGoodsQuery);
}
