package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL313 商品详细信息(分期商城) 商品属性
 * 
 * @author lizy 2016/5/3.
 */
public class StageMallGoodsDetailAttrInfoByApp extends BaseEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6477094064399164584L;
	private String goodsId;
	private String goodsAttr1;
	private String goodsAttr2;
	private String goodsColor;
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
