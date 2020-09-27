package cn.com.cgbchina.rest.provider.service.goods;

import cn.com.cgbchina.rest.provider.model.goods.IVRRankListReturn;
import cn.com.cgbchina.rest.provider.model.goods.IVRRankListQuery;

/**
 * MAL202 IVR排行列表查询
 * 
 * @author lizy 2016/4/28.
 */
public interface IVRRankListService {
	IVRRankListReturn getRankList(IVRRankListQuery ivrRankListServiceQueryObj);
}
