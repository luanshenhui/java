package cn.com.cgbchina.batch.service;

import java.io.IOException;

/**
 * (供应商平台) 商户退货明细
 * 
 * @author xiewl
 * @version 2016年6月16日 上午11:49:54
 */
public interface VendorGoodsBackService {

	/**
	 * 商户退货明细 excel 每日凌晨生成（统计每日0点至24点）
	 * 
	 * @throws IOException
	 */
	void exportVendorGoodsBackForDay(String batchDate, String vendorId, String vendorNm) throws IOException;

	/**
	 * 商户退货明细 excel 每周日凌晨生成（每周上周日至本周六）
	 * 
	 * @throws IOException
	 */
	void exportVendorGoodsBackForWeek(String batchDate, String vendorId, String vendorNm) throws IOException;

	/**
	 * 商户退货明细excel 每月一日凌晨生成（每月初至月底）
	 * 
	 * @throws IOException
	 */
	void exportVendorGoodsBackForMonth(String batchDate, String vendorId, String vendorNm) throws IOException;
}
