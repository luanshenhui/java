package cn.com.cgbchina.batch.service;

import java.io.IOException;

import cn.com.cgbchina.batch.model.CreditCardReqMoneyModel;

/**
 * 信用卡请款对账明细报表(广发商城供应商平台)
 * 
 * @author huangcy
 * @see CreditCardReqMoneyModel
 */
public interface CreditCardReqMoneyService {
	/**
	 * 导出信用卡请款对账明细报表（日） 每日凌晨生成（生成当日从前天18点至昨天18点）
	 */
	void exportCreditCardReqMoneyForDay(String batchDate, String vendorId, String vendorNm) throws IOException;

	/**
	 * 导出信用卡请款对账明细报表（周） 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportCreditCardReqMoneyForWeek(String batchDate, String vendorId, String vendorNm) throws IOException;

	/**
	 * 导出信用卡请款对账明细报表（月） 每月一日凌晨生成（每月初至月底）
	 */
	void exportCreditCardReqMoneyForMonth(String batchDate, String vendorId, String vendorNm) throws IOException;
}
