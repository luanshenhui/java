package cn.com.cgbchina.rest.provider.model.user;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

public class CustCarUpdateInfo extends BaseEntity implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 6398126344599289160L;
	private String id;
	private String goodsNum;
	private String goodsId;

	public String getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getGoodsNum() {
		return goodsNum;
	}

	public void setGoodsNum(String goodsNum) {
		this.goodsNum = goodsNum;
	}

}
