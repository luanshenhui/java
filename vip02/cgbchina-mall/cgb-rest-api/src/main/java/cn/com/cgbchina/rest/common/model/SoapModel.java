package cn.com.cgbchina.rest.common.model;

/**
 * Comment: Created by 11150321050126 on 2016/4/21.
 */
public class SoapModel<T> {
	private String versionNo;
	private String toEncrypt;
	private String commCode;
	private String commType;
	private String receiverId;
	private String senderId;
	private String senderSN;
	private String senderDate;
	private String senderTime;
	private String tradeCode;
	private String gwErrorCode;
	private String gwErrorMessage;
	private T content;

	public T getContent() {
		return content;
	}

	public void setContent(T content) {
		this.content = content;
	}

	public String getVersionNo() {
		return versionNo;
	}

	public void setVersionNo(String versionNo) {
		this.versionNo = versionNo;
	}

	public String getToEncrypt() {
		return toEncrypt;
	}

	public void setToEncrypt(String toEncrypt) {
		this.toEncrypt = toEncrypt;
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

	public String getReceiverId() {
		return receiverId;
	}

	public void setReceiverId(String receiverId) {
		this.receiverId = receiverId;
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

	public String getSenderDate() {
		return senderDate;
	}

	public void setSenderDate(String senderDate) {
		this.senderDate = senderDate;
	}

	public String getSenderTime() {
		return senderTime;
	}

	public void setSenderTime(String senderTime) {
		this.senderTime = senderTime;
	}

	public String getTradeCode() {
		return tradeCode;
	}

	public void setTradeCode(String tradeCode) {
		this.tradeCode = tradeCode;
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
}
