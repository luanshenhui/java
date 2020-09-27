package cn.com.cgbchina.rest.provider.service.user;

import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteAdd;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteAddReturn;

/**
 * MAL301 添加收藏商品(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public interface StageMallFavoriteAddService {
	StageMallFavoriteAddReturn add(StageMallFavoriteAdd stageMallFavoriteAddObj);
}
