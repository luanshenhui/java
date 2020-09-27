package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * @author lizy MAL102 CC积分商城单个礼品的查询对象
 */
public class CCIntergalPresentDetailQuery extends BaseQueryEntity implements Serializable {
	private static final long serialVersionUID = -3143123673161464156L;
	private String goodsId;
	private String origin;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}
}
