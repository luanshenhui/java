package cn.com.cgbchina.batch.service;

/**
 * 商户兑换统计报表
 * 
 * @author huangcy on 2016年6月17日
 */
public interface VendorExchangeStatService {
	/**
	 * 商户兑换统计月报表 范围：每月月初至月底 频率：月次，每月一日凌晨生成
	 * 
	 * @param reportDate
	 */
	void exportVendorExchangeStatForMonth(String reportDate);
}
