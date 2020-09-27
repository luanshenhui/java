package cn.com.cgbchina.rest.provider.vo.user;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL323 客户信息查询
 * 
 * @author lizy 2016/4/28.
 */
public class CustInfoVO extends BaseQueryEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4190271749944806055L;
	@NotNull
	private String origin;
	@NotNull
	private String custId;
	@NotNull
	private String certNo;
	private String isVip;
	private String birthDay;
	private String cardNo;
	@NotNull
	private String formatId;
	private String cardLevel;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	public String getCertNo() {
		return certNo;
	}

	public void setCertNo(String certNo) {
		this.certNo = certNo;
	}

	public String getIsVip() {
		return isVip;
	}

	public void setIsVip(String isVip) {
		this.isVip = isVip;
	}

	public String getBirthDay() {
		return birthDay;
	}

	public void setBirthDay(String birthDay) {
		this.birthDay = birthDay;
	}

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getFormatId() {
		return formatId;
	}

	public void setFormatId(String formatId) {
		this.formatId = formatId;
	}

	public String getCardLevel() {
		return cardLevel;
	}

	public void setCardLevel(String cardLevel) {
		this.cardLevel = cardLevel;
	}

}
