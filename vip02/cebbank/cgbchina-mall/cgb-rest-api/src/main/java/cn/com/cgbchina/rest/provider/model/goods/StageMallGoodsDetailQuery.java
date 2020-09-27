package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL117 商品详细信息(分期商城)的返回对象
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallGoodsDetailQuery extends BaseQueryEntity implements Serializable {
	private static final long serialVersionUID = 212415537352811468L;
	private String origin;
	private String mallType;
	private String goodsId;
	private String goodsOmid;
	private String contIdCard;

	public String getContIdCard() {
		return contIdCard;
	}

	public void setContIdCard(String contIdCard) {
		this.contIdCard = contIdCard;
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

	public String getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}

	public String getGoodsOmid() {
		return goodsOmid;
	}

	public void setGoodsOmid(String goodsOmid) {
		this.goodsOmid = goodsOmid;
	}

}
