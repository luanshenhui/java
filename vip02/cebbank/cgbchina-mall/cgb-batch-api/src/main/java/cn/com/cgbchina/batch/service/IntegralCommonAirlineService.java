package cn.com.cgbchina.batch.service;

/**
 * 普通积分兑换报表（南航里程）
 * 
 * @author huangcy on 2016年6月3日
 */
public interface IntegralCommonAirlineService {
	/**
	 * 普通积分兑换周报表（南航里程） 统计范围：每周上周日至本周六
	 */
	void exportCommonAirlineForWeek(String reportDate);

	/**
	 * 普通积分兑换月报表（南航里程） 统计范围：每月月初至月底
	 */
	void exportCommonAirlineForMonth(String reportDate);
}
