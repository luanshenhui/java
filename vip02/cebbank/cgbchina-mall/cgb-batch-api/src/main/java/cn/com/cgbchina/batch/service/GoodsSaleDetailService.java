package cn.com.cgbchina.batch.service;

import java.io.IOException;

import cn.com.cgbchina.batch.model.GoodsSaleDetail;

/**
 * 商品销售明细报表（广发商城管理平台）
 * 
 * @see GoodsSaleDetail
 * @author huangcy
 */
public interface GoodsSaleDetailService {

	/**
	 * 商品销售明细日报表 excel 每日凌晨生成（统计每日0点至24点）
	 * 
	 * @throws IOException
	 */
	void exportGoodsSaleDetailForDay(String batchDate) throws IOException;

	/**
	 * 商品销售明细周报表 excel 每周日凌晨生成（每周上周日至本周六）
	 * 
	 * @throws IOException
	 */
	void exportGoodsSaleDetailForWeek(String batchDate) throws IOException;

	/**
	 * 商品销售明细月报表excel 每月一日凌晨生成（每月初至月底）
	 * 
	 * @throws IOException
	 */
	void exportGoodsSaleDetailForMonth(String batchDate) throws IOException;
}
