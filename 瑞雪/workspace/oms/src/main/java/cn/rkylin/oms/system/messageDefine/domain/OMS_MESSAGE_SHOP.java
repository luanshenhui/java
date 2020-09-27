package cn.rkylin.oms.system.messageDefine.domain;

import cn.rkylin.oms.common.base.BaseEntity;

public class OMS_MESSAGE_SHOP extends BaseEntity {
	
	/**
	 * 序列
	 */
	private static final long serialVersionUID = -7511432441339731483L;
	private String msId;
	private String msgId;
	private String shopId;
	private String template;
	public String getMsId() {
		return msId;
	}
	public void setMsId(String msId) {
		this.msId = msId;
	}
	public String getMsgId() {
		return msgId;
	}
	public void setMsgId(String msgId) {
		this.msgId = msgId;
	}
	public String getShopId() {
		return shopId;
	}
	public void setShopId(String shopId) {
		this.shopId = shopId;
	}
	public String getTemplate() {
		return template;
	}
	public void setTemplate(String template) {
		this.template = template;
	}
	
	

}
