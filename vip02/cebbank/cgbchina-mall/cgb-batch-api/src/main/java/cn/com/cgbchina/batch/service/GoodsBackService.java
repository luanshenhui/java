package cn.com.cgbchina.batch.service;

import java.io.IOException;

import cn.com.cgbchina.batch.model.GoodsBackDetail;

/**
 * 退货报表（积分商城）
 * 
 * @see GoodsBackDetail
 * @author huangcy
 */
public interface GoodsBackService {
	/**
	 * 礼品退货周报表 每日凌晨生成（统计每日0点至24点）
	 * 
	 * @param vendorId 供应商ID 为空则导出全部数据
	 * @param vendorNm 供应商名称 为空则导出全部数据
	 * @throws IOException
	 */
	void exportGoodsBackForDay(String batchDate, String vendorId, String vendorNm) throws IOException;

	/**
	 * 礼品退货周报表 每周日凌晨生成（每周上周日至本周六）
	 * 
	 * @param vendorId 供应商ID 为空则导出全部数据
	 * @param vendorNm 供应商名称 为空则导出全部数据
	 * @throws IOException
	 */
	void exportGoodsBackForWeek(String batchDate, String vendorId, String vendorNm) throws IOException;

	/**
	 * 礼品退货月报表 每月一日凌晨生成（每月初至月底）
	 * 
	 * @param vendorId 供应商ID 为空则导出全部数据
	 * @param vendorNm 供应商名称 为空则导出全部数据
	 * @throws IOException
	 */
	void exportGoodsBackForMonth(String batchDate, String vendorId, String vendorNm) throws IOException;
}
