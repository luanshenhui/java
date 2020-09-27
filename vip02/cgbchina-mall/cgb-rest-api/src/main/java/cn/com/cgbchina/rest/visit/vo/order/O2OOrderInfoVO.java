package cn.com.cgbchina.rest.visit.vo.order;

import java.math.BigDecimal;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class O2OOrderInfoVO {
	@XMLNodeName("suborderno")
	private String subOrderId;
	@XMLNodeName("sorder_id")
	private String sOrderId;
	@XMLNodeName("goods_id")
	private String goodsId;
	private Integer type;
	private BigDecimal price;
	private Integer number;
	private BigDecimal amount;
	private String mobile;

	public String getSubOrderId() {
		return subOrderId;
	}

	public void setSubOrderId(String subOrderId) {
		this.subOrderId = subOrderId;
	}

	public String getSOrderId() {
		return sOrderId;
	}

	public void setSOrderId(String sOrderId) {
		this.sOrderId = sOrderId;
	}

	public String getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}

	public Integer getNumber() {
		return number;
	}

	public void setNumber(Integer number) {
		this.number = number;
	}

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
}
