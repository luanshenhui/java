package cn.com.cgbchina.trade.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Map;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by Congzy
 */
public class CartDbResultDto implements Serializable {

	private static final long serialVersionUID = 1950509546469358933L;

	@Getter
	@Setter
	private CartGfShopDto cartGfShopDto;	//广发商城购物车信息

	@Getter
	@Setter
	private CartJFShopDto cartJFShopDto;	//积分商城购物车信息

	@Getter
	@Setter
	private Map<String,BigDecimal> userPointDto;		//用户积分信息

	@Getter
	@Setter
	private String surplusPoint;  //积分池剩余

	@Getter
	@Setter
	private AuctionRecordDto auctionRecordDto;	//荷兰拍信息

	@Getter
	@Setter
	private Integer countCartsInfo;	//获取购物车内有效数据的总条数
}
