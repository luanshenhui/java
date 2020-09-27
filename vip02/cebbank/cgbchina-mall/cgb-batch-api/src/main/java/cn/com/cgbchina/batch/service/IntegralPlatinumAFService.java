package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.model.IntegralPlatinumAF;

/**
 * 积分兑换报表（白金卡换年费）
 * 
 * @see IntegralPlatinumAF
 * @author huangcy
 */
public interface IntegralPlatinumAFService {
	/**
	 * 白金卡换年费积分兑换周报表 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportPlatinumAFeeForWeek(String reportDate);

	/**
	 * 积分兑换月报表（白金卡换年费）
	 */
	void exportPlatinumAFeeForMonth(String reportDate);
}
