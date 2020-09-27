package cn.com.cgbchina.rest.visit.vo.user;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class LoginCardInfoVO implements Serializable {
	@NotNull
	private String branchNo;
	@NotNull
	private String cardNo;
	@NotNull
	private Byte cardType;

	public String getBranchNo() {
		return branchNo;
	}

	public void setBranchNo(String branchNo) {
		this.branchNo = branchNo;
	}

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public Byte getCardType() {
		return cardType;
	}

	public void setCardType(Byte cardType) {
		this.cardType = cardType;
	}
}
