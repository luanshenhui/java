package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.model.IntegralAirlineMileage;

/**
 * 积分兑换报表（南航里程）
 * 
 * @see IntegralAirlineMileage
 * @author huangcy
 */
public interface IntegralAirlineMileageService {
	/**
	 * 南航里程积分兑换周报表excel 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportAirlineIntegralForWeek(String reportDate);

	/**
	 * 积分兑换月报表(南航里程) 月次，每月一日凌晨生成
	 */
	void exportAirlineIntegralForMonth(String reportDate);
}
