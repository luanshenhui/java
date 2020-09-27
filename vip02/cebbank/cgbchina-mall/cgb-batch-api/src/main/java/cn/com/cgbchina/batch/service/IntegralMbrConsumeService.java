package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.model.IntegralMbrConsume;

/**
 * 积分兑换周报表（ALL常旅客会员消费）
 * 
 * @see IntegralMbrConsume
 * @author huangcy
 */
public interface IntegralMbrConsumeService {
	/**
	 * ALL常旅客会员消费积分兑换周报表 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportMbrConsumeForWeek(String reportDate);

	/**
	 * ALL常旅客会员消费积分兑换月报表
	 */
	void exportMbrConsumeForMonth(String reportDate);
}
