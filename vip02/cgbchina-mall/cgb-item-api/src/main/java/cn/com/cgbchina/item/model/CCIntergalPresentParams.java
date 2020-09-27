/*
 * 
 * Copyright 2016 by www.cgbchina.com.cn All rights reserved.
 * 
 */
package cn.com.cgbchina.item.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 *  MAL101  CC积分商城礼品列表查询参数
 *	日期		:	2016-8-1<br>
 *	作者		:	xiewenliang<br>
 *	项目		:	cgb-item-api<br>
 *	功能		:	<br>
 */
public class CCIntergalPresentParams implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -1517756222855587497L;
	@Getter
	@Setter
	private String currentPage;
	@Getter
	@Setter
	private String cardNo;
	@Getter
	@Setter
	private String jfType;
	@Getter
	@Setter
	private String keyValue;
	@Getter
	@Setter
	private String goodsXid;
	@Getter
	@Setter
	private String bonusRegion;
	@Getter
	@Setter
	private String origin;
}
