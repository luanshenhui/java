package cn.com.cgbchina.batch.service;

import java.io.IOException;

import cn.com.cgbchina.batch.model.VendorSaleStatistics;

/**
 * 商户销售统计报表（广发商城管理平台）
 * 
 * @see VendorSaleStatistics
 * @author huangcy
 */
public interface VendorSaleStatService {
	/**
	 * 商户销售统计报表(日) 每日凌晨生成（统计每日0点至24点）
	 * 
	 * @throws IOException
	 */
	void exportVenderSaleStatForDay(String batchDate, String vendorId, String vendorNm) throws IOException;

	/**
	 * 商户销售统计报表（周） 每周日凌晨生成（每周上周日至本周六）
	 * 
	 * @throws IOException
	 */
	void exportVenderSaleStatForWeek(String batchDate, String vendorId, String vendorNm) throws IOException;

	/**
	 * 商户销售统计报表（月） 每月一日凌晨生成（每月初至月底）
	 * 
	 * @throws IOException
	 */
	void exportVenderSaleStatForMonth(String batchDate, String vendorId, String vendorNm) throws IOException;
}
