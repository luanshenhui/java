package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.model.IntegralLinkCard;

/**
 * 积分兑换报表（联通卡）
 * 
 * @see IntegralLinkCard
 * @author huangcy
 */
public interface IntegralLinkCardService {
	/**
	 * 联通卡积分兑换周报表 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportLinkCardForWeek(String reportDate);

	/**
	 * 联通卡积分兑换月报表
	 */
	void exportLinkCardForMonth(String reportDate);
}
