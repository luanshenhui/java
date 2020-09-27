package cn.com.cgbchina.batch.service;

import java.io.IOException;

import cn.com.cgbchina.batch.model.StageReturnGoods;

/**
 * 分期退货报表（广发商城管理平台）
 * 
 * @see StageReturnGoods
 * @author huangcy
 */
public interface StageReturnGoodsService {
	/**
	 * 分期退货报表（日） 每日凌晨生成（每日0点至24点）
	 * 
	 * @throws IOException
	 */
	void exportStageReturnGoodsForDay(String batchDate, String vendorId, String vendorNm) throws IOException;

	/**
	 * 分期退货报表（周） 每周日凌晨生成（每周上周日至本周六）
	 * 
	 * @throws IOException
	 */
	void exportStageReturnGoodsForWeek(String batchDate, String vendorId, String vendorNm) throws IOException;

	/**
	 * 分期退货报表（月） 每月一日凌晨生成（每月初至月底）
	 * 
	 * @throws IOException
	 */
	void exportStageReturnGoodsForMonth(String batchDate, String vendorId, String vendorNm) throws IOException;
}
