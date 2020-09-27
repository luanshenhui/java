package cn.com.cgbchina.rest.provider.vo.order;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL324 积分商城下单list泛型类
 * 
 * @author zjq 2016/6/24.
 */
public class GoodsInfoVo extends BaseQueryEntity {

	private static final long serialVersionUID = -7146074707681971877L;
	@NotNull
	@XMLNodeName(value = "goods_id")
	private String goodsId;
	@NotNull
	@XMLNodeName(value = "goods_num")
	private String goodsNum;
	@NotNull
	@XMLNodeName(value = "goods_payway_id")
	private String goodsPaywayId;
	@NotNull
	private String custCartId;

	public String getGoodsId() {
		return goodsId;
	}

	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}

	public String getGoodsNum() {
		return goodsNum;
	}

	public void setGoodsNum(String goodsNum) {
		this.goodsNum = goodsNum;
	}

	public String getGoodsPaywayId() {
		return goodsPaywayId;
	}

	public void setGoodsPaywayId(String goodsPaywayId) {
		this.goodsPaywayId = goodsPaywayId;
	}

	public String getCustCartId() {
		return custCartId;
	}

	public void setCustCartId(String custCartId) {
		this.custCartId = custCartId;
	}
}
