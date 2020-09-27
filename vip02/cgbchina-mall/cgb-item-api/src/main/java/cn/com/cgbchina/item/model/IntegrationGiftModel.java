package cn.com.cgbchina.item.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class IntegrationGiftModel implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Getter
	@Setter
	private String itemCode;// 单品编码

	@Getter
	@Setter
	private String xid;// 礼品编码

	@Getter
	@Setter
	private String vendorId;// 礼品编码

	@Getter
	@Setter
	private String name;// 礼品编码

	@Getter
	@Setter
	private String vendorFnm;// 供应商全名
	@Getter
	@Setter
	private Long jpBonus;// 积分数量

	@Getter
	@Setter
	private String pictureUrl;// 商品中型图标

	@Getter
	@Setter
	private String goodsUrl;// 商品访问RUL
	
	@Getter
	@Setter
	private String goodsCode;
}