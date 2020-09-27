package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.model.MemberBrowseHistory;

/**
 * 会员足迹报表
 * 
 * @see MemberBrowseHistory
 * @author huangcy on 2016年5月31日
 */
public interface MemberBrowseHisService {
	/**
	 * 会员足迹周报表
	 */
	void exportBrowseHistoryForWeek(String reportDate);

	/**
	 * 会员足迹月报表
	 */
	void exportBrowseHistoryForMonth(String reportDate);
}
