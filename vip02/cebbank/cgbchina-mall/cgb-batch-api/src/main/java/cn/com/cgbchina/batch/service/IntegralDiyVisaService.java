package cn.com.cgbchina.batch.service;

/**
 * 积分兑换报表（DIY卡免还款签账额）
 * 
 * @author huangcy on 2016年6月3日
 */
public interface IntegralDiyVisaService {

	/**
	 * 积分兑换日报表（DIY卡免还款签账额） 每日凌晨生成（每天0点到24点）
	 */
	void exportDiyVisaForDay(String reportDate);
}
