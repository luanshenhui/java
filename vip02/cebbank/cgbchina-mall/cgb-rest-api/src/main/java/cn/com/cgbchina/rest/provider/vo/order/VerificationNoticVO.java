package cn.com.cgbchina.rest.provider.vo.order;

import java.util.Date;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * 验证通知接口 根据xml返回的接口
 * 
 * @author Lizy
 *
 */
public class VerificationNoticVO extends BaseQueryEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8277219283369448302L;
	@NotNull
	@XMLNodeName(value = "orderno")
	private String orderNo;

	@NotNull
	@XMLNodeName(value = "suborderno")
	private String subOrderNo;

	@NotNull
	@XMLNodeName(value = "verifyid")
	private Integer verifyId;

	@NotNull
	@XMLNodeName(value = "verifynum")
	private Integer verifyNum;

	@NotNull
	@XMLNodeName(value = "codedata")
	private String codeData;

	@NotNull
	@XMLNodeName(value = "verifytime")
	private Date verifyTime;

	@NotNull
	@XMLNodeName(value = "verifytype")
	private Integer verifyType;

	@NotNull
	@XMLNodeName(value = "verifyopor")
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
