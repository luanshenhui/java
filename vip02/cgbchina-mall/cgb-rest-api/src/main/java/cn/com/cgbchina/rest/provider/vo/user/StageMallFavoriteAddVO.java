package cn.com.cgbchina.rest.provider.vo.user;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL301 添加收藏商品(分期商城) 的添加对象
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallFavoriteAddVO extends BaseQueryEntityVO implements Serializable {
	private static final long serialVersionUID = -7628732905704029759L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@NotNull
	@XMLNodeName(value = "cust_id")
	private String custId;
	@NotNull
	@XMLNodeName(value = "goods_id")
	private String goodsId;
	@NotNull
	@XMLNodeName(value = "do_date")
	private String doDate;
	@NotNull
	@XMLNodeName(value = "do_time")
	private String doTime;
	@NotNull
	@XMLNodeName(value = "favorite_desc")
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
