package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL313 商品详细信息(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallGoodsDetailByAPPQuery extends BaseQueryEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7321636123129595788L;
	private String origin;
	private String goodsId;
	private String contIdcard;
	private String queryType;
	private String custId;

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

	public String getContIdcard() {
		return contIdcard;
	}

	public void setContIdcard(String contIdcard) {
		this.contIdcard = contIdcard;
	}

	public String getQueryType() {
		return queryType;
	}

	public void setQueryType(String queryType) {
		this.queryType = queryType;
	}

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

}
