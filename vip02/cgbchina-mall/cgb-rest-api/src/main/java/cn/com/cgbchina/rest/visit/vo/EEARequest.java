package cn.com.cgbchina.rest.visit.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class EEARequest<T> implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5366079048304725051L;
	private String serviceCode;
	private String sysID;
	private String appID;
	private String clientIPAddr;
	private String transTime;
	private String transFlag = "1";
	private String userInfo;
	private String hash;
	private T content;

	public String getServiceCode() {
		return serviceCode;
	}

	public void setServiceCode(String serviceCode) {
		this.serviceCode = serviceCode;
	}

	public String getSysID() {
		return sysID;
	}

	public void setSysID(String sysID) {
		this.sysID = sysID;
	}

	public String getAppID() {
		return appID;
	}

	public void setAppID(String appID) {
		this.appID = appID;
	}

	public String getClientIPAddr() {
		return clientIPAddr;
	}

	public void setClientIPAddr(String clientIPAddr) {
		this.clientIPAddr = clientIPAddr;
	}

	public String getTransTime() {
		return transTime;
	}

	public void setTransTime(String transTime) {
		this.transTime = transTime;
	}

	public String getTransFlag() {
		return transFlag;
	}

	public void setTransFlag(String transFlag) {
		this.transFlag = transFlag;
	}

	public String getUserInfo() {
		return userInfo;
	}

	public void setUserInfo(String userInfo) {
		this.userInfo = userInfo;
	}

	public String getHash() {
		return hash;
	}

	public void setHash(String hash) {
		this.hash = hash;
	}

	public T getContent() {
		return content;
	}

	public void setContent(T content) {
		this.content = content;
	}

}
