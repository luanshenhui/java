package cn.com.cgbchina.trade.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/** 
 * 会员报表
 * @author huangcy
 * 
 */
public class MemberCountBatchDto implements Serializable{
	private static final long serialVersionUID = 1516806230643610815L;
	/**
	 * 序号
	 */
	@Getter@Setter
	private Integer index;
	/**
	 * 商品编号(广发商城)
	 */
	@Getter@Setter
	private String goodsCodeYG;
	/**
	 * 商品名称(广发商城)
	 */
	@Getter@Setter
	private String goodsNameYG;
	/**
	 * 次数(广发商城)
	 */
	@Getter@Setter
	private Integer timeYG;
	/**
	 * 商品编号(积分商城)
	 */
	@Getter@Setter
	private String goodsCodeJF;
	/**
	 * 商品名称(积分商城)
	 */
	@Getter@Setter
	private String goodsNameJF;
	/**
	 * 次数(积分商城)
	 */
	@Getter@Setter
	private Integer timeJF;
}
