package cn.com.cgbchina.item.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class GoodsDecorationDto implements Serializable{
	private static final long serialVersionUID = 1L;
	
	private String itemCode;
	
	private String goodsName;
	
	/**
	 * 是否为礼品,1为礼品,0为非礼品
	 */
	private String isGift;
}
