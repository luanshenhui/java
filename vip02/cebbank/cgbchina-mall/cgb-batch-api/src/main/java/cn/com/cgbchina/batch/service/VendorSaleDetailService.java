package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.model.VendorSellDetail;

/**
 * (广发商城管理平台)商户销售明细报表
 * 
 * @see VendorSellDetail
 * @author huangcy
 */
public interface VendorSaleDetailService {
	/**
	 * 商户销售明细报表(日) 每日凌晨生成（统计每日0点至24点）
	 */
	void exportVenderSaleDetailForDay(String reportDate);

	/**
	 * 商户销售明细报表（周） 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportVenderSaleDetailForWeek(String reportDate);

	/**
	 * 商户销售明细报表（月） 每月一日凌晨生成（每月初至月底）
	 */
	void exportVenderSaleDetailForMonth(String reportDate);
}
