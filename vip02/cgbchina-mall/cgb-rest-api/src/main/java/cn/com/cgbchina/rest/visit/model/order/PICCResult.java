package cn.com.cgbchina.rest.visit.model.order;

import cn.com.cgbchina.rest.visit.model.BaseResult;

import java.io.Serializable;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class PICCResult extends BaseResult implements Serializable {
	private static final long serialVersionUID = -1731708380734898518L;
	private String serialNo;
	private String senderSN;

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getSenderSN() {
		return senderSN;
	}

	public void setSenderSN(String senderSN) {
		this.senderSN = senderSN;
	}
}
