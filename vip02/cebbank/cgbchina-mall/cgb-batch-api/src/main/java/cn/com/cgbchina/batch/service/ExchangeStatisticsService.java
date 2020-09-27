package cn.com.cgbchina.batch.service;

import java.io.IOException;

import cn.com.cgbchina.batch.model.ExchangeStatisticsDetail;

/**
 * 兑换统计月报表
 * 
 * @see ExchangeStatisticsDetail
 * @author huangcy
 */
public interface ExchangeStatisticsService {
	/**
	 * 兑换统计月报表 每月一日凌晨生成（每月初至月底）
	 */
	void exportStatisticsDetailForMonth(String batchDate) throws IOException;
}
