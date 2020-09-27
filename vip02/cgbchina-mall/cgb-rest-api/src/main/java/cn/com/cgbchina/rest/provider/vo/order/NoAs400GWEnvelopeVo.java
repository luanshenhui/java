package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;
import java.util.List;

/**
 * 柜面网关非AS400报文对象
 *
 */
public class NoAs400GWEnvelopeVo  implements Serializable {
	private static final long serialVersionUID = 1103065028977317906L;
	// 版本号默认填1
	public String versionNo;

	// 密押标识默认填0
	public String toEncrypt;

	// 通讯代码填500001
	public String commCode;

	// 通讯类型0--同步请求(等待接收方返回业务处理结果)；1--异步请求(接收方不返回结果,由网关返回给请求方通讯回执)
	public String commType;

	// 接收方标识 填写接收方系统机器名
	public String receiverId;

	// 发起方标识
	public String senderId;

	// 发起方流水
	public String senderSN;

	// 发起方日期yyyyMMdd
	public String senderDate;

	// 发起方时间hhmmss
	public String senderTime;

	// 交易请求
	public String tradeCode;

	// 网关错误标识 网关用于表示是否处理过程发生错误。发起方填空,01:成功;00:错误
	public String gwErrorCode;

	// 网关错误代码 用于表示具体错误内容的七位的半角字符串，发起方填空
	public String gwErrorMessage;

	// 报文体 格式List<String[2]>,String[0]：报文体fieldName，String[1]：报文体fieldValue
	public List envelopeBody;

	public NoAs400GWEnvelopeVo() {
		this.versionNo = "1";
		this.toEncrypt = "0";
		this.commCode = "500001";
		this.gwErrorCode = "";
		this.gwErrorMessage = "";
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

	public List getEnvelopeBody() {
		return envelopeBody;
	}

	public void setEnvelopeBody(List envelopeBody) {
		this.envelopeBody = envelopeBody;
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

}
