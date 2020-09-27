package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

public class CCAddOrderByCgbGoodsAddVO implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8430252944484194365L;
	@NotNull
	@XMLNodeName(value="goods_id")
	private String goodsId;
	@NotNull
	@XMLNodeName(value="goods_num")
	private String goodsNum;
	@NotNull
	@XMLNodeName(value="goods_payway_id")
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
