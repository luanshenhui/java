package cn.com.cgbchina.trade.vo;

import java.util.List;
import java.util.Map;

/**
 * <p>Title: CustLevelInfo</p>
 * 
 * <p>Description: </p>
 * 
 * <p>Company: Shanghai Huateng Software Systems Co., Ltd.</p> 
 * 
 * @author <a href="mailto:wendeson@163.com">Wendeson</a>
 *
 * @date   2012-8-13
 *
 * @version 1.0
 */
public class CustLevelInfo implements java.io.Serializable {
	private static final long serialVersionUID = 1L;

	public String certNbr;

	public String cardLevelCd;

	public String vipTpCd;

	public String birthDay;

	public String custAddr;

	public String memberLevel;

	public boolean vipFlag;
	
	public String custType;//�ͻ��ȼ�
	
	public List aCardCustToelectronbanks;
	
	public Map cardFormatNbr;
	
	public List custFomat;

	public CustLevelInfo() {

	}

	public boolean isVipFlag() {
		return vipFlag;
	}

	public void setVipFlag(boolean vipFlag) {
		this.vipFlag = vipFlag;
	}

	public String getBirthDay() {
		return birthDay;
	}

	public void setBirthDay(String birthDay) {
		this.birthDay = birthDay;
	}

	public String getCardLevelCd() {
		return cardLevelCd;
	}

	public void setCardLevelCd(String cardLevelCd) {
		this.cardLevelCd = cardLevelCd;
	}

	public String getCertNbr() {
		return certNbr;
	}

	public void setCertNbr(String certNbr) {
		this.certNbr = certNbr;
	}

	public String getCustAddr() {
		return custAddr;
	}

	public void setCustAddr(String custAddr) {
		this.custAddr = custAddr;
	}

	public String getVipTpCd() {
		return vipTpCd;
	}

	public void setVipTpCd(String vipTpCd) {
		this.vipTpCd = vipTpCd;
	}

	public String getMemberLevel() {
		return memberLevel;
	}

	public void setMemberLevel(String memberLevel) {
		this.memberLevel = memberLevel;
	}

	public List getACardCustToelectronbanks() {
		return aCardCustToelectronbanks;
	}

	public void setACardCustToelectronbanks(List cardCustToelectronbanks) {
		aCardCustToelectronbanks = cardCustToelectronbanks;
	}

	public String getCustType() {
		return custType;
	}

	public void setCustType(String custType) {
		this.custType = custType;
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