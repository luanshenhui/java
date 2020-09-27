package cn.com.cgbchina.batch.service;

/**
 * 积分兑换报表（新旧聪明卡兑换签帐额）
 * 
 * @author huangcy on 2016年6月3日
 */
public interface IntegralSmartCardService {

	/**
	 * 积分兑换日报表（新旧聪明卡兑换签帐额） 统计范围：每天0点到24点
	 */
	void exportSmartCardForDay(String reportDate);
}
