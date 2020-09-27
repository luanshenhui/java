package cn.com.cgbchina.related.model;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

public class CustLevelInfo implements Serializable {
	public String certNbr;

	public String cardLevelCd;

	public String vipTpCd;

	public String birthDay;

	public String custAddr;

	public String memberLevel;

	public boolean vipFlag;
	
	public String custType;//客户等级
	
	public List aCardCustToelectronbanks;
	
	public Map cardFormatNbr;
	
	public List custFomat;

	public String getCertNbr() {
		return certNbr;
	}

	public void setCertNbr(String certNbr) {
		this.certNbr = certNbr;
	}

	public String getCardLevelCd() {
		return cardLevelCd;
	}

	public void setCardLevelCd(String cardLevelCd) {
		this.cardLevelCd = cardLevelCd;
	}

	public String getVipTpCd() {
		return vipTpCd;
	}

	public void setVipTpCd(String vipTpCd) {
		this.vipTpCd = vipTpCd;
	}

	public String getBirthDay() {
		return birthDay;
	}

	public void setBirthDay(String birthDay) {
		this.birthDay = birthDay;
	}

	public String getCustAddr() {
		return custAddr;
	}

	public void setCustAddr(String custAddr) {
		this.custAddr = custAddr;
	}

	public String getMemberLevel() {
		return memberLevel;
	}

	public void setMemberLevel(String memberLevel) {
		this.memberLevel = memberLevel;
	}

	public boolean isVipFlag() {
		return vipFlag;
	}

	public void setVipFlag(boolean vipFlag) {
		this.vipFlag = vipFlag;
	}

	public String getCustType() {
		return custType;
	}

	public void setCustType(String custType) {
		this.custType = custType;
	}

	public List getaCardCustToelectronbanks() {
		return aCardCustToelectronbanks;
	}

	public void setaCardCustToelectronbanks(List aCardCustToelectronbanks) {
		this.aCardCustToelectronbanks = aCardCustToelectronbanks;
	}

	public Map getCardFormatNbr() {
		return cardFormatNbr;
	}

	public void setCardFormatNbr(Map cardFormatNbr) {
		this.cardFormatNbr = cardFormatNbr;
	}

	public List getCustFomat() {
		return custFomat;
	}

	public void setCustFomat(List custFomat) {
		this.custFomat = custFomat;
	}
	
}
