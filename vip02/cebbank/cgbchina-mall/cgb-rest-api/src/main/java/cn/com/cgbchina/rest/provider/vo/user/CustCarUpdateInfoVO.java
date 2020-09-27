package cn.com.cgbchina.rest.provider.vo.user;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

public class CustCarUpdateInfoVO extends BaseEntityVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 6398126344599289160L;
	@NotNull
	private String id;
	@NotNull
	@XMLNodeName("goods_num")
	private String goodsNum;
	@XMLNodeName("goods_id")
	private String goodsId;

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
