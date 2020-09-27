package cn.com.cgbchina.batch.service;

import java.io.IOException;

import cn.com.cgbchina.batch.model.VendorSaleDetail;

/**
 * (供应商平台)商户销售明细报表
 * 
 * @see VendorSaleDetail
 * @author huangcy on 2016年5月10日
 */
public interface VendorSellDetailService {
	/**
	 * 商户销售明细报表 每日凌晨生成（统计每日0点至24点）
	 */
	void exportVendorSellDetailForDay(String batchDate, String vendorId, String vendorNm) throws IOException;

	/**
	 * 商户销售明细报表（周） 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportVendorSellDetailForWeek(String batchDate, String vendorId, String vendorNm) throws IOException;

	/**
	 * 商户销售明细报表（月） 每月一日凌晨生成（每月初至月底）
	 */
	void exportVendorSellDetailForMonth(String batchDate, String vendorId, String vendorNm) throws IOException;
}
