package cn.com.cgbchina.rest.provider.service.goods;

import cn.com.cgbchina.rest.provider.model.goods.StageMallAdvertise;
import cn.com.cgbchina.rest.provider.model.goods.StageMallAdvertiseQueryReturn;

/**
 * MAL321 广告查询(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public interface StageMallAdvertiseQueryService {
	StageMallAdvertiseQueryReturn query(StageMallAdvertise stageMallAdvertise);
}
