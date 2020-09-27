package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.model.IntegralInsurance;

/**
 * 保险积分兑换报表
 * 
 * @see IntegralInsurance
 * @author huangcy
 */
public interface IntegralInsuranceService {
	/**
	 * 积分兑换周报表（中国人寿保险标准卡旅行意外） 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportStandardTravelForWeek(String reportDate);

	/**
	 * 积分兑换周报表（中国人寿保险标准卡重大疾病） 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportStandardDiseaseForWeek(String reportDate);

	/**
	 * 积分兑换周报表（中国人寿保险真情卡女性疾病） 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportLoveCardWomenForWeek(String reportDate);

	/**
	 * 积分兑换周报表（中国人寿保险真情卡旅行意外） 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportLoveCardTravelForWeek(String reportDate);

	/**
	 * 积分兑换周报表（中国人寿保险真情卡重大疾病） 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportLoveCardDiseaseForWeek(String reportDate);

	/**
	 * 积分兑换周报表（中国人寿保险真情卡购物保障） 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportLoveCardShopForWeek(String reportDate);

	/**
	 * 积分兑换周报表（中国人寿保险车主卡驾驶员意外） 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportCrecorderDriverForWeek(String reportDate);

	/**
	 * 积分兑换周报表（中国人民财产保险车主卡旅行交通意外） 每周日凌晨生成（每周上周日至本周六）
	 */
	void exportCrecorderTrafficForWeek(String reportDate);

	/**
	 * 积分兑换月报表（中国人寿保险标准卡旅行意外）
	 */
	void exportStandardTravelForMonth(String reportDate);

	/**
	 * 积分兑换月报表（中国人寿保险标准卡重大疾病）
	 */
	void exportStandardDiseaseForMonth(String reportDate);

	/**
	 * 积分兑换月报表（中国人寿保险真情卡女性疾病）
	 */
	void exportLoveCardWomenForMonth(String reportDate);

	/**
	 * 积分兑换月报表（中国人寿保险真情卡旅行意外）
	 */
	void exportLoveCardTravelForMonth(String reportDate);

	/**
	 * 积分兑换月报表（中国人寿保险真情卡重大疾病）
	 */
	void exportLoveCardDiseaseForMonth(String reportDate);

	/**
	 * 积分兑换月报表（中国人寿保险真情卡购物保障）
	 */
	void exportLoveCardShopForMonth(String reportDate);

	/**
	 * 积分兑换月报表（中国人寿保险车主卡驾驶员意外）
	 */
	void exportCrecorderDriverForMonth(String reportDate);

	/**
	 * 积分兑换月报表（中国人民财产保险车主卡旅行交通意外）
	 */
	void exportCrecorderTrafficForMonth(String reportDate);

	/**
	 * 积分兑换周报表（爱·宠普卡宠物饲养责任保险）
	 */
	void exportPetFeedRespForWeek(String reportDate);

	/**
	 * 积分兑换月报表（爱·宠普卡宠物饲养责任保险）
	 */
	void exportPetFeedRespForMonth(String reportDate);
}
