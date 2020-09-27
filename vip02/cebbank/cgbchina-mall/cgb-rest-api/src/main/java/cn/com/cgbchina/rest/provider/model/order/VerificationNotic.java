package cn.com.cgbchina.rest.provider.model.order;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

import java.util.Date;

/**
 * 验证通知接口
 * 
 * @author Lizy
 *
 */
public class VerificationNotic extends BaseQueryEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8277219283369448302L;
	private String orderNo;
	private String subOrderNo;
	private Integer verifyId;
	private Integer verifyNum;
	private String codeData;
	private Date verifyTime;
	private Integer verifyType;
	private String verifyopor;

	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	public String getSubOrderNo() {
		return subOrderNo;
	}

	public void setSubOrderNo(String subOrderNo) {
		this.subOrderNo = subOrderNo;
	}

	public Integer getVerifyId() {
		return verifyId;
	}

	public void setVerifyId(Integer verifyId) {
		this.verifyId = verifyId;
	}

	public Integer getVerifyNum() {
		return verifyNum;
	}

	public void setVerifyNum(Integer verifyNum) {
		this.verifyNum = verifyNum;
	}

	public String getCodeData() {
		return codeData;
	}

	public void setCodeData(String codeData) {
		this.codeData = codeData;
	}

	public Date getVerifyTime() {
		return verifyTime;
	}

	public void setVerifyTime(Date verifyTime) {
		this.verifyTime = verifyTime;
	}

	public Integer getVerifyType() {
		return verifyType;
	}

	public void setVerifyType(Integer verifyType) {
		this.verifyType = verifyType;
	}

	public String getVerifyopor() {
		return verifyopor;
	}

	public void setVerifyopor(String verifyopor) {
		this.verifyopor = verifyopor;
	}

}
