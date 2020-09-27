package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL313 商品详细信息(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallGoodsDetailByAPPQueryVO extends BaseQueryEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7321636123129595788L;
	@NotNull
	private String origin;
	@XMLNodeName(value = "goods_id")
	private String goodsId;
	@XMLNodeName(value = "cont_idcard")
	private String contIdcard;
	@XMLNodeName(value = "query_type")
	private String queryType;
	@XMLNodeName(value = "cust_id")
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
