/**
 * Copyright © 2016 广东发展银行 All right reserved
 */
package cn.com.cgbchina.item.dto;


import cn.com.cgbchina.item.model.SmspMdlModel;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * @author niufw
 * @version 1.0
 * @since 2016/6/30.
 */
public class SmspMdlDto extends SmspMdlModel implements Serializable {

	private static final long serialVersionUID = 1563948749162004147L;
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

	private BigDecimal price;// 单品价格

	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}
}
