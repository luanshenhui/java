package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.model.IntegralGiftCode;

/**
 * 积分兑换周报表（录入组赠品代码）
 * 
 * @see IntegralGiftCode
 * @author huangcy
 */
public interface IntegralGiftCodeService {
	/**
	 * 录入组赠品代码积分兑换周报表 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportGiftCodeForWeek(String reportDate);
}
