package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL103 IVR积分商城单个礼品
 *
 * @author Lizy
 */
public class IVRIntergralPresentReturn extends BaseEntity implements Serializable {
	private static final long serialVersionUID = -8394478256430883703L;
	private String channelSN;
	private String successCode;
	private String goodsId;
	private String goodsName;
	private String custLevel;
	private String jfType;
	private String jfTypeName;
	private String payCodeByM;
	private String payCodeByMJf;
	private String payCodeByBoth;
	private String intergralPart;
	private String moneyPart;
	private String inventory;

	public String getChannelSN() {
		return channelSN;
	}

	public void setChannelSN(String channelSN) {
		this.channelSN = channelSN;
	}

	public String getSuccessCode() {
		return successCode;
	}

	public void setSuccessCode(String successCode) {
		this.successCode = successCode;
	}

	public String getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}

	public String getGoodsName() {
		return goodsName;
	}

	public void setGoodsName(String goodsName) {
		this.goodsName = goodsName;
	}

	public String getCustLevel() {
		return custLevel;
	}

	public void setCustLevel(String custLevel) {
		this.custLevel = custLevel;
	}

	public String getJfType() {
		return jfType;
	}

	public void setJfType(String jfType) {
		this.jfType = jfType;
	}

	public String getJfTypeName() {
		return jfTypeName;
	}

	public void setJfTypeName(String jfTypeName) {
		this.jfTypeName = jfTypeName;
	}

	public String getPayCodeByM() {
		return payCodeByM;
	}

	public void setPayCodeByM(String payCodeByM) {
		this.payCodeByM = payCodeByM;
	}

	public String getPayCodeByMJf() {
		return payCodeByMJf;
	}

	public void setPayCodeByMJf(String payCodeByMJf) {
		this.payCodeByMJf = payCodeByMJf;
	}

	public String getPayCodeByBoth() {
		return payCodeByBoth;
	}

	public void setPayCodeByBoth(String payCodeByBoth) {
		this.payCodeByBoth = payCodeByBoth;
	}

	public String getIntergralPart() {
		return intergralPart;
	}

	public void setIntergralPart(String intergralPart) {
		this.intergralPart = intergralPart;
	}

	public String getMoneyPart() {
		return moneyPart;
	}

	public void setMoneyPart(String moneyPart) {
		this.moneyPart = moneyPart;
	}

	public String getInventory() {
		return inventory;
	}

	public void setInventory(String inventory) {
		this.inventory = inventory;
	}
}
