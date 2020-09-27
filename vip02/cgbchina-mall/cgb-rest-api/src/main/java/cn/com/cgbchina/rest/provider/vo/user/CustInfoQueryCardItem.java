package cn.com.cgbchina.rest.provider.vo.user;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * 供电子商城卡客户明细信息
 * 
 * @author geshuo 20160721
 */
public class CustInfoQueryCardItem extends BaseEntity {

	private static final long serialVersionUID = -1884639453950090139L;

	private String cardNo;//卡号
	private String cardFormatNo;//卡板代码
	private String cardTypeNo;//卡类代码
	private String cardLevel;//卡等级
	private String cardLevelDesc;//卡等级描述
	private String bankNo;//分行号

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getCardFormatNo() {
		return cardFormatNo;
	}

	public void setCardFormatNo(String cardFormatNo) {
		this.cardFormatNo = cardFormatNo;
	}

	public String getCardTypeNo() {
		return cardTypeNo;
	}

	public void setCardTypeNo(String cardTypeNo) {
		this.cardTypeNo = cardTypeNo;
	}

	public String getCardLevel() {
		return cardLevel;
	}

	public void setCardLevel(String cardLevel) {
		this.cardLevel = cardLevel;
	}

	public String getCardLevelDesc() {
		return cardLevelDesc;
	}

	public void setCardLevelDesc(String cardLevelDesc) {
		this.cardLevelDesc = cardLevelDesc;
	}

	public String getBankNo() {
		return bankNo;
	}

	public void setBankNo(String bankNo) {
		this.bankNo = bankNo;
	}

}
