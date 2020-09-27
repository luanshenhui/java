package cn.com.cgbchina.batch.service;

import java.io.IOException;

import cn.com.cgbchina.batch.model.CommonGiftSaleDetail;

/**
 * 普通礼品销售报表（积分商城） {@link CommonGiftSaleDetail}
 * 
 * @author huangcy
 */
public interface CommonGiftSaleService {
	/**
	 * 普通礼品销售报表(日) 每日凌晨生成（统计每日0点至24点）
	 * 
	 * @param vendorId 供应商ID 为空则导出全部数据
	 * @param vendorNm 供应商名称 为空则导出全部数据
	 * @throws IOException
	 * @see CommonGiftSaleDetailForDay
	 */
	void exportGiftSaleXlsForDay(String batchDate, String vendorId, String vendorNm) throws IOException;

	/**
	 * 普通礼品销售报表(周) 每周日凌晨生成（统计每周上周日至本周六）
	 * 
	 * @param vendorId 供应商ID 为空则导出全部数据
	 * @param vendorNm 供应商名称 为空则导出全部数据
	 * @throws IOException
	 */
	void exportGiftSaleXlsForWeek(String batchDate, String vendorId, String vendorNm) throws IOException;

	/**
	 * 普通礼品销售报表(月) 每月一日凌晨生成（统计每月初至月底）
	 * 
	 * @param vendorId 供应商ID 为空则导出全部数据
	 * @param vendorNm 供应商名称 为空则导出全部数据
	 * @throws IOException
	 */
	void exportGiftSaleXlsForMonth(String batchDate, String vendorId, String vendorNm) throws IOException;
}
