package cn.rkylin.oms.system.messageDefine.domain;

import cn.rkylin.oms.common.base.BaseEntity;

public class OMS_MESSAGE extends BaseEntity {
	/**
	 * 序列
	 */
	private static final long serialVersionUID = 6888637244431821029L;

	private String msgId;
	
	private String msgCode;//编码

	private String msgName;//名称
	
	private String sendWay;//发送方式
	
	private String title;//邮件标题
	
	private Integer retries;//从复次数
	
	public Integer getRetries() {
		return retries;
	}

	public void setRetries(Integer retries) {
		this.retries = retries;
	}

	private String retryInterval;//重复间隔
	
	private String template;//消息模版
	
	private String enabled;//状态
	
	private String deleted;
	public String getMsgId() {
		return msgId;
	}

	public void setMsgId(String msgId) {
		this.msgId = msgId;
	}

	public String getMsgCode() {
		return msgCode;
	}

	public void setMsgCode(String msgCode) {
		this.msgCode = msgCode;
	}

	public String getMsgName() {
		return msgName;
	}

	public void setMsgName(String msgName) {
		this.msgName = msgName;
	}

	public String getSendWay() {
		return sendWay;
	}

	public void setSendWay(String sendWay) {
		this.sendWay = sendWay;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getRetryInterval() {
		return retryInterval;
	}

	public void setRetryInterval(String retryInterval) {
		this.retryInterval = retryInterval;
	}

	public String getTemplate() {
		return template;
	}

	public void setTemplate(String template) {
		this.template = template;
	}

	public String getEnabled() {
		return enabled;
	}

	public void setEnabled(String enabled) {
		this.enabled = enabled;
	}

	public String getDeleted() {
		return deleted;
	}

	public void setDeleted(String deleted) {
		this.deleted = deleted;
	}
}
