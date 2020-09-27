package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

public class StageMallGoodsDetailByAPPGoodsInfoVO  implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 2465361074196072257L;
	@XMLNodeName(value="goods_id")
	private String goodsId;
	@XMLNodeName(value="goods_attr1")
	private String goodsAttr1;
	@XMLNodeName(value="goods_attr2")
	private String goodsAttr2;
	@XMLNodeName(value="goods_color")
	private String goodsColor;
	@XMLNodeName(value="goods_model")
	private String goodsModel;
	public String getGoodsId() {
		return goodsId;
	}
	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}
	public String getGoodsAttr1() {
		return goodsAttr1;
	}
	public void setGoodsAttr1(String goodsAttr1) {
		this.goodsAttr1 = goodsAttr1;
	}
	public String getGoodsAttr2() {
		return goodsAttr2;
	}
	public void setGoodsAttr2(String goodsAttr2) {
		this.goodsAttr2 = goodsAttr2;
	}
	public String getGoodsColor() {
		return goodsColor;
	}
	public void setGoodsColor(String goodsColor) {
		this.goodsColor = goodsColor;
	}
	public String getGoodsModel() {
		return goodsModel;
	}
	public void setGoodsModel(String goodsModel) {
		this.goodsModel = goodsModel;
	}
	
}
