package cn.com.cgbchina.rest.visit.model.user;

import java.io.Serializable;

import cn.com.cgbchina.rest.visit.model.BaseResult;

public class RandomCode extends BaseResult implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8124485560282939690L;
	private String randomPwd;
	private String transferFlowNo;

	public String getRandomPwd() {
		return randomPwd;
	}

	public void setRandomPwd(String randomPwd) {
		this.randomPwd = randomPwd;
	}

	public String getTransferFlowNo() {
		return transferFlowNo;
	}

	public void setTransferFlowNo(String transferFlowNo) {
		this.transferFlowNo = transferFlowNo;
	}

}
