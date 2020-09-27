/**
 * Copyright © 2016 广东发展银行 All right reserved
 */
package cn.com.cgbchina.related.dto;

import java.io.Serializable;
import java.math.BigDecimal;

import cn.com.cgbchina.related.model.SmspMdlModel;

/**
 * @author niufw
 * @version 1.0
 * @since 2016/6/30.
 */
public class SmspMdlDto extends SmspMdlModel implements Serializable {

	private static final long serialVersionUID = -2132702471888947630L;
	private String goodsName;// 单品名称

	public String getGoodsName() {
		return goodsName;
	}

	public void setGoodsName(String goodsName) {
		this.goodsName = goodsName;
	}

	private Integer installmentNumber;// 最高分期数

	public Integer getInstallmentNumber() {
		return installmentNumber;
	}

	public void setInstallmentNumber(Integer installmentNumber) {
		this.installmentNumber = installmentNumber;
	}

	private java.math.BigDecimal price;// 单品价格

	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}
}
