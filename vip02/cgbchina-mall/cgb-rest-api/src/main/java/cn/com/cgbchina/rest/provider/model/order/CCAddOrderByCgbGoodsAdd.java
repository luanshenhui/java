package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

public class CCAddOrderByCgbGoodsAdd implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4540196030158029192L;
	private String goodsId;
	private String goodsNum;
	private String goodsPaywayId;

	public String getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}

	public String getGoodsNum() {
		return goodsNum;
	}

	public void setGoodsNum(String goodsNum) {
		this.goodsNum = goodsNum;
	}

	public String getGoodsPaywayId() {
		return goodsPaywayId;
	}

	public void setGoodsPaywayId(String goodsPaywayId) {
		this.goodsPaywayId = goodsPaywayId;
	}

}
