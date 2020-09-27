package cn.com.cgbchina.rest.provider.service.user;

import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteDel;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteDelReturn;

/**
 * MAL303 删除收藏商品(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public interface StageMallFavoriteDelService {
	StageMallFavoriteDelReturn del(StageMallFavoriteDel stageMallFavoriteDelObj);
}
