package cn.com.cgbchina.rest.provider.model.user;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL323 客户信息查询
 * 
 * @author lizy 2016/4/28.
 */
public class CustInfoQueryReturn extends BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3404853584817626427L;
	private String custLevel;
	private String brthDate;
	private String brthTimes;
	private String cardNo;
	private String cardFormatNo;
	private String cardTypeNo;
	private String cardLevel;
	private String cardLevelDesc;
	private String bankNo;

	public String getCustLevel() {
		return custLevel;
	}

	public void setCustLevel(String custLevel) {
		this.custLevel = custLevel;
	}

	public String getBrthDate() {
		return brthDate;
	}

	public void setBrthDate(String brthDate) {
		this.brthDate = brthDate;
	}

	public String getBrthTimes() {
		return brthTimes;
	}

	public void setBrthTimes(String brthTimes) {
		this.brthTimes = brthTimes;
	}

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
