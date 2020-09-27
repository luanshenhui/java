package cn.com.cgbchina.rest.provider.model.user;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL301 添加收藏商品(分期商城) 的添加对象
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallFavoriteAdd extends BaseQueryEntity implements Serializable {
	private static final long serialVersionUID = -7628732905704029759L;
	private String origin;
	private String mallType;
	private String custId;
	private String goodsId;
	private String doDate;
	private String doTime;
	private String favoriteDesc;

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

	public String getDoDate() {
		return doDate;
	}

	public void setDoDate(String doDate) {
		this.doDate = doDate;
	}

	public String getDoTime() {
		return doTime;
	}

	public void setDoTime(String doTime) {
		this.doTime = doTime;
	}

	public String getFavoriteDesc() {
		return favoriteDesc;
	}

	public void setFavoriteDesc(String favoriteDesc) {
		this.favoriteDesc = favoriteDesc;
	}
}
