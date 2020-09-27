package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

/**
 *
 * MAL101 积分商城礼品
 * 
 * @author lizy
 *
 */
public class CCIntergalPresentVO implements Serializable {
	private static final long serialVersionUID = 6869700590722948080L;
	@NotNull
	private String goodsId;
	@NotNull
	private String goodsName;
	@NotNull
	private String goodsFType;
	@NotNull
	private String goodsCType;
	@NotNull
	private String cusLevel;
	private String cusLevelName;
	@NotNull
	private String cusPrice;
	@NotNull
	private String payCodeByM;
	@NotNull
	private String birthPrice;
	@NotNull
	private String payCodeByB;
	@NotNull
	private String intergralPart;
	@NotNull
	@XMLNodeName("MoneyPart")
	private String moneyPart;
	@NotNull
	private String payCodeByBoth;
	@NotNull
	private String inventory;
	@NotNull
	private String jfType;
	@NotNull
	private String jfTypeName;
	private String goodsType;
	//@XMLNodeName(value="virtual_limit")
	private String virtualLimit;
	//@XMLNodeName(value="virtual_mileage")
	private String virtualMileage;
	private String goodsBid;
	//@XMLNodeName(value="virtual_price")
	private String virtualPrice;

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

	public String getGoodsFType() {
		return goodsFType;
	}

	public void setGoodsFType(String goodsFType) {
		this.goodsFType = goodsFType;
	}

	public String getGoodsCType() {
		return goodsCType;
	}

	public void setGoodsCType(String goodsCType) {
		this.goodsCType = goodsCType;
	}

	public String getCusLevel() {
		return cusLevel;
	}

	public void setCusLevel(String cusLevel) {
		this.cusLevel = cusLevel;
	}

	public String getCusLevelName() {
		return cusLevelName;
	}

	public void setCusLevelName(String cusLevelName) {
		this.cusLevelName = cusLevelName;
	}

	public String getCusPrice() {
		return cusPrice;
	}

	public void setCusPrice(String cusPrice) {
		this.cusPrice = cusPrice;
	}

	public String getPayCodeByM() {
		return payCodeByM;
	}

	public void setPayCodeByM(String payCodeByM) {
		this.payCodeByM = payCodeByM;
	}

	public String getBirthPrice() {
		return birthPrice;
	}

	public void setBirthPrice(String birthPrice) {
		this.birthPrice = birthPrice;
	}

	public String getPayCodeByB() {
		return payCodeByB;
	}

	public void setPayCodeByB(String payCodeByB) {
		this.payCodeByB = payCodeByB;
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

	public String getPayCodeByBoth() {
		return payCodeByBoth;
	}

	public void setPayCodeByBoth(String payCodeByBoth) {
		this.payCodeByBoth = payCodeByBoth;
	}

	public String getInventory() {
		return inventory;
	}

	public void setInventory(String inventory) {
		this.inventory = inventory;
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

	public String getGoodsType() {
		return goodsType;
	}

	public void setGoodsType(String goodsType) {
		this.goodsType = goodsType;
	}

	public String getVirtualLimit() {
		return virtualLimit;
	}

	public void setVirtualLimit(String virtualLimit) {
		this.virtualLimit = virtualLimit;
	}

	public String getVirtualMileage() {
		return virtualMileage;
	}

	public void setVirtualMileage(String virtualMileage) {
		this.virtualMileage = virtualMileage;
	}

	public String getGoodsBid() {
		return goodsBid;
	}

	public void setGoodsBid(String goodsBid) {
		this.goodsBid = goodsBid;
	}

	public String getVirtualPrice() {
		return virtualPrice;
	}

	public void setVirtualPrice(String virtualPrice) {
		this.virtualPrice = virtualPrice;
	}
}
