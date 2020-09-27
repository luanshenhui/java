package cn.com.cgbchina.rest.provider.vo.user;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL304 加入购物车(分期商城)
 */

public class CustCarAddVO extends BaseQueryEntityVO implements Serializable {

	private static final long serialVersionUID = -800068614622375745L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@NotNull
	private String ordertypeId;
	@NotNull
	@XMLNodeName(value = "cust_id")
	private String custId;
	@NotNull
	@XMLNodeName(value = "goods_id")
	private String goodsId;
	@NotNull
	@XMLNodeName(value = "goods_payway_id")
	private String goodsPaywayId;
	@NotNull
	@XMLNodeName(value = "goods_num")
	private String goodsNum;
	@XMLNodeName(value = "bonus_value")
	private String bonusValue;
	@XMLNodeName(value = "add_date")
	private String addDate;
	@XMLNodeName(value = "add_time")
	private String addTime;

	public String getAddDate() {
		return addDate;
	}

	public void setAddDate(String addDate) {
		this.addDate = addDate;
	}

	public String getAddTime() {
		return addTime;
	}

	public void setAddTime(String addTime) {
		this.addTime = addTime;
	}

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getMallType() {
		return mallType;
	}

	public void setMallType(String mallType) {
		this.mallType = mallType;
	}

	public String getOrdertypeId() {
		return ordertypeId;
	}

	public void setOrdertypeId(String ordertypeId) {
		this.ordertypeId = ordertypeId;
	}

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	public String getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}

	public String getGoodsPaywayId() {
		return goodsPaywayId;
	}

	public void setGoodsPaywayId(String goodsPaywayId) {
		this.goodsPaywayId = goodsPaywayId;
	}

	public String getGoodsNum() {
		return goodsNum;
	}

	public void setGoodsNum(String goodsNum) {
		this.goodsNum = goodsNum;
	}

	public String getBonusValue() {
		return bonusValue;
	}

	public void setBonusValue(String bonusValue) {
		this.bonusValue = bonusValue;
	}

}
