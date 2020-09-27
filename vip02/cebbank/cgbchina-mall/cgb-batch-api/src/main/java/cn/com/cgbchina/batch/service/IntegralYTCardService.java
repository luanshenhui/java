package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.model.IntegralYTCard;

/**
 * 积分兑换报表（人保粤通卡积分兑换）
 * 
 * @see IntegralYTCard
 * @author huangcy
 */
public interface IntegralYTCardService {
	/**
	 * 积分兑换日报表（人保粤通卡积分兑换） 前一天的18：00：00到昨天17：59：59
	 */
	void exportYTCardForDay(String reportDate);
}
