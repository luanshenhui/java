package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.model.IntegralRoadRescue;

/**
 * 积分兑换周报表（车主卡道路救援）
 * 
 * @see IntegralRoadRescue
 * @author huangcy
 */
public interface IntegralRoadServeService {
	/**
	 * 车主卡道路救援积分兑换周报表 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportRoadServeForWeek(String reportDate);
}
