package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.dto.EnvolopeDto;

/**
 * 非As400机器的报文，标志性
 *
 * @author Administrator
 *
 */
public abstract class NoAs400EnvolopeDto implements EnvolopeDto {
	public String isSucess = "";// 代表返回报文是成功报文还是失败报文,此字段在报文里面没有，只为了用来在程序标识成功失败报文
	// 0:成功 1:失败
	private String totalLength = "";

	private String versionNo = "";

	private String toEncrypt = "";

	private String commCode = "";

	private String commType = "";

	private String receiverId = "";

	private String senderId = "";

	private String senderSN = "";

	private String senderDate = "";

	private String senderTime = "";

	private String tradeCode = "";

	private String gwErrorCode = "";

	private String gwErrorMessage = "";

	private String reserved1 = "";

	private String xmlString = "";
	public String getIsSucess() {
		return isSucess;
	}

	public void setIsSucess(String isSucess) {
		this.isSucess = isSucess;
	}

	public String getCommCode() {
		return commCode;
	}

	public void setCommCode(String commCode) {
		this.commCode = commCode;
	}

	public String getCommType() {
		return commType;
	}

	public void setCommType(String commType) {
		this.commType = commType;
	}

	public String getGwErrorCode() {
		return gwErrorCode;
	}

	public void setGwErrorCode(String gwErrorCode) {
		this.gwErrorCode = gwErrorCode;
	}

	public String getGwErrorMessage() {
		return gwErrorMessage;
	}

	public void setGwErrorMessage(String gwErrorMessage) {
		this.gwErrorMessage = gwErrorMessage;
	}

	public String getReceiverId() {
		return receiverId;
	}

	public void setReceiverId(String receiverId) {
		this.receiverId = receiverId;
	}

	public String getReserved1() {
		return reserved1;
	}

	public void setReserved1(String reserved1) {
		this.reserved1 = reserved1;
	}

	public String getSenderDate() {
		return senderDate;
	}

	public void setSenderDate(String senderDate) {
		this.senderDate = senderDate;
	}

	public String getSenderId() {
		return senderId;
	}

	public void setSenderId(String senderId) {
		this.senderId = senderId;
	}

	public String getSenderSN() {
		return senderSN;
	}

	public void setSenderSN(String senderSN) {
		this.senderSN = senderSN;
	}

	public String getSenderTime() {
		return senderTime;
	}

	public void setSenderTime(String senderTime) {
		this.senderTime = senderTime;
	}

	public String getToEncrypt() {
		return toEncrypt;
	}

	public void setToEncrypt(String toEncrypt) {
		this.toEncrypt = toEncrypt;
	}

	public String getTotalLength() {
		return totalLength;
	}

	public void setTotalLength(String totalLength) {
		this.totalLength = totalLength;
	}

	public String getTradeCode() {
		return tradeCode;
	}

	public void setTradeCode(String tradeCode) {
		this.tradeCode = tradeCode;
	}

	public String getVersionNo() {
		return versionNo;
	}

	public void setVersionNo(String versionNo) {
		this.versionNo = versionNo;
	}

	public String getXmlString() {
		return xmlString;
	}

	public void setXmlString(String xmlString) {
		this.xmlString = xmlString;
	}

}
