package cn.com.cgbchina.item.dto;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import cn.com.cgbchina.item.model.GoodsDetaillModel;

public class GoodsDetailExtend extends GoodsDetaillModel {
	@Getter
	@Setter
	private String channelMallWx;
	@Getter
	@Setter
	private String channelCreditWx;
	@Getter
	@Setter
	private String marketPrice;
	@Getter
	@Setter
	private String image1;
	@Setter
	@Getter
	private String goodsTotal;
	@Setter
	@Getter
	private String bestRate;
	@Setter
	@Getter
	private String goodsDesc;
	@Getter
	@Setter
	private List<RestGoodsPayWayDto> goodsPayWayDtos;
}
