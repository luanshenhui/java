package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.model.IntegralSST;

/**
 * 积分兑换周报表（录入组瞬时通） {@link IntegralSST}
 * 
 * @author huangcy
 */
public interface IntegralInGroupSSTService {
	/**
	 * 录入组瞬时通积分兑换周报表 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportInGroupSSTForWeek(String reportDate);
}
