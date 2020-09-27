package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL103 IVR积分商城单个礼品
 *
 * @author Lizy
 */
public class IVRIntergralPresentReturnVO extends BaseEntityVO implements Serializable {
	private static final long serialVersionUID = -8394478256430883703L;
	@NotNull
	private String channelSN;
	@NotNull
	private String successCode;
	@NotNull
	private String goodsId;
	@NotNull
	private String goodsName;
	@NotNull
	private String custLevel;
	@NotNull
	private String jfType;
	@NotNull
	private String jfTypeName;
	@NotNull
	private String payCodeByM;
	@NotNull
	private String payCodeByMJf;
	@NotNull
	private String payCodeByBoth;
	@NotNull
	private String intergralPart;
	@NotNull
	private String moneyPart;
	@NotNull
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
