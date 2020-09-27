package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL202 IVR排行列表查询 商品（礼品）信息
 * 
 * @author lizy 2016/4/28.
 */
public class IVRRankListGoodsInfo implements Serializable {

	private static final long serialVersionUID = -141202645384133884L;
	private String goodsId;
	private String goodsName;
	private String goodsFType;
	private String goodsCType;
	private String cusLevel;
	private String cusLevelName;
	private String cusPrice;
	private String payCodeByM;
	private String intergralPart;
	private String MoneyPart;
	private String payCodeByBoth;
	private String inventory;
	private String jfType;
	private String jfTypeName;
	private String goodsType;

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

	public String getIntergralPart() {
		return intergralPart;
	}

	public void setIntergralPart(String intergralPart) {
		this.intergralPart = intergralPart;
	}

	public String getMoneyPart() {
		return MoneyPart;
	}

	public void setMoneyPart(String moneyPart) {
		MoneyPart = moneyPart;
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
}
