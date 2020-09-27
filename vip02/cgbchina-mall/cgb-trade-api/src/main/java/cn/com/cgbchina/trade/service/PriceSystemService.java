package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.vo.CustLevelInfo;
import cn.com.cgbchina.trade.vo.PriceSystem;


public interface PriceSystemService {

	/**
	 * 通过卡号获取客户证件号
	 * @param cardNbr 卡号获
	 * @return
	 */
	public String getCertNbrByCard(String cardNbr);
	/**
	 * 通过客户号获取客户信息
	 * @param certNbr 证件号
	 * @return
	 */
	public CustLevelInfo getCustLevelInfo(String certNbr);
	/**
	 * 通过卡号获取客户信息
	 * @param cardNbr  卡号获
	 * @return
	 */
	public CustLevelInfo getCustLevelInfoByCard(String cardNbr);
	/**
	 * 通过客户最优级别和商品ID获取客户最优的兑换价格
	 * @param custLevel 客优级别
	 * @param goodsId
	 * @return
	 */
	public PriceSystem getPriceSystem(String custLevel, String goodsId);
	/**
	 * 校验客户的卡片等级和礼品维护的卡片等级是否一致
	 * @param goodsId
	 * @param certNbr 证件号
	 * @param cardNbr 卡号
	 * @return
	 */
	public boolean checkCardLevel(String goodsId, String certNbr, String cardNbr);

}
