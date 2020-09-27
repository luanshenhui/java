package cn.com.cgbchina.rest.provider.service.user;

import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteQuery;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoritesReturn;

/**
 * MAL302 查询收藏商品(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public interface StageMallFavoriteQueryService {
	StageMallFavoritesReturn query(StageMallFavoriteQuery stageMallFavoriteQueryObj);
}
