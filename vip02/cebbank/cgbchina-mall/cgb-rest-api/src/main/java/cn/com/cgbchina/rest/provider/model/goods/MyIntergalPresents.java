package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL118 适合我的积分礼品查询的礼品信息
 * 
 * @author lizy 2016/4/28.
 */
public class MyIntergalPresents extends BaseEntity implements Serializable {
	private static final long serialVersionUID = -5727879197570351996L;
	private String goodsId;
	private String goodsXid;
	private String goodsNm;
	private String jpBonus;
	private String vendorFnm;
	private String pictureUrl;
	private String goodsUrl;

	public String getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}

	public String getGoodsXid() {
		return goodsXid;
	}

	public void setGoodsXid(String goodsXid) {
		this.goodsXid = goodsXid;
	}

	public String getGoodsNm() {
		return goodsNm;
	}

	public void setGoodsNm(String goodsNm) {
		this.goodsNm = goodsNm;
	}

	public String getJpBonus() {
		return jpBonus;
	}

	public void setJpBonus(String jpBonus) {
		this.jpBonus = jpBonus;
	}

	public String getVendorFnm() {
		return vendorFnm;
	}

	public void setVendorFnm(String vendorFnm) {
		this.vendorFnm = vendorFnm;
	}

	public String getPictureUrl() {
		return pictureUrl;
	}

	public void setPictureUrl(String pictureUrl) {
		this.pictureUrl = pictureUrl;
	}

	public String getGoodsUrl() {
		return goodsUrl;
	}

	public void setGoodsUrl(String goodsUrl) {
		this.goodsUrl = goodsUrl;
	}
}
