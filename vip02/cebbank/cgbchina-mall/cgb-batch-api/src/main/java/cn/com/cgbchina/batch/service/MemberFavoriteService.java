package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.model.MemberGoodsFavorite;

/**
 * 会员收藏夹报表
 * 
 * @see MemberGoodsFavorite
 * @author huangcy on 2016年5月31日
 */
public interface MemberFavoriteService {
	/**
	 * 会员收藏夹周报表
	 */
	void exportMemberFavoriteForWeek(String reportDate);

	/**
	 * 会员收藏夹月报表
	 */
	void exportMemberFavoriteForMonth(String reportDate);
}
