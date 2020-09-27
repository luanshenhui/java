package cn.com.cgbchina.item.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class RestGoodsPayWayDto implements Serializable {
	@Setter
	@Getter
	private String goodsPaywayId;
	@Setter
	@Getter
	private String goodsPrice;
}
