package cn.com.cgbchina.rest.provider.service.goods;

import cn.com.cgbchina.rest.provider.model.goods.StageMallUserCommentQuery;
import cn.com.cgbchina.rest.provider.model.goods.StageMallUserCommentQueryReturn;

/**
 * MAL320 用户点评(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public interface StageMallUserCommentQueryService {
	StageMallUserCommentQueryReturn query(StageMallUserCommentQuery stageMallUserCommentQuery);
}
