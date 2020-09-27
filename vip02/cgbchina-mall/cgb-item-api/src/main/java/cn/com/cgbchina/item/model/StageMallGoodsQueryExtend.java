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
 *	日期		:	2016-7-19<br>
 *	作者		:	xiewl<br>
 *	项目		:	cgb-item-api<br>
 *	功能		:	<br>
 */
public class StageMallGoodsQueryExtend implements Serializable{

	private static final long serialVersionUID = -6629434733175659030L;
	@Getter
	@Setter
	private String goodsId;
	@Getter
	@Setter
	private String goodsNm;
	@Getter
	@Setter
	private String goodsMid;
	@Getter
	@Setter
	private String goodsOid;
	@Getter
	@Setter
	private String goodsXid;
	@Getter
	@Setter
	private String stagesNum;
	@Getter
	@Setter
	private String perStage;
	@Getter
	@Setter
	private String goodsPrice;
	@Getter
	@Setter
	private String goodsType;
	@Getter
	@Setter
	private String jpPrice;
	@Getter
	@Setter
	private String tzPrice;
	@Getter
	@Setter
	private String dzPrice;
	@Getter
	@Setter
	private String vipPrice;
	@Getter
	@Setter
	private String brhPrice;
	@Getter
	@Setter
	private String jfPart;
	@Getter
	@Setter
	private String xjPart;
	@Getter
	@Setter
	private String pictureUrl;
	@Getter
	@Setter
	private String marketPrice;
	@Getter
	@Setter
	private String goodsTotal;
	@Getter
	@Setter
	private String goodsBacklog;
	@Getter
	@Setter
	private String beginDate;
	@Getter
	@Setter
	private String beginTime;
	@Getter
	@Setter
	private String endDate;
	@Getter
	@Setter
	private String endTime;
	@Getter
	@Setter
	private String goodsActType;
	@Getter
	@Setter
	private String collectStatus;
	@Getter
	@Setter
	private Double bestRate;
	

}
