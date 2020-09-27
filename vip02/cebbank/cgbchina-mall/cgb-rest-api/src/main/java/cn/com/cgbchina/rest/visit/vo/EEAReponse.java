package cn.com.cgbchina.rest.visit.vo;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.utils.WebUtil;
import cn.com.cgbchina.rest.visit.model.user.EEA1Info;

public class EEAReponse<T> implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1173381566853013761L;
	private String serviceCode;
	private String sysID;
	private String appID;
	private String clientIPAddr = WebUtil.getlocalIP();
	private String transTime;
	private String transFlag = "0";
	private String userInfo;
	private String useTime;
	private String hash;
	private String responseCode;
	private String responseRemark;
	private T content;

	public T getContent() {
		return content;
	}

	public void setContent(T content) {
		this.content = content;
	}

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

	public String getUseTime() {
		return useTime;
	}

	public void setUseTime(String useTime) {
		this.useTime = useTime;
	}

	public String getHash() {
		return hash;
	}

	public void setHash(String hash) {
		this.hash = hash;
	}

	public String getResponseCode() {
		return responseCode;
	}

	public void setResponseCode(String responseCode) {
		this.responseCode = responseCode;
	}

	public String getResponseRemark() {
		return responseRemark;
	}

	public void setResponseRemark(String responseRemark) {
		this.responseRemark = responseRemark;
	}

}
