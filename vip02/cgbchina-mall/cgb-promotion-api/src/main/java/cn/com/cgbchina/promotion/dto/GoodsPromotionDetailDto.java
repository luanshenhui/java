package cn.com.cgbchina.promotion.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class GoodsPromotionDetailDto implements Serializable {
	@Getter
	@Setter
	private String goodsId;
	@Getter
	@Setter
	private String goodsPaywayId;
	@Getter
	@Setter
	private String acttionType;
	@Getter
	@Setter
	private String actFrequency;
	@Getter
	@Setter
	private String beginDate1;
	@Getter
	@Setter
	private String beginTime1;
	@Getter
	@Setter
	private String endDate1;
	@Getter
	@Setter
	private String endTime1;
	@Getter
	@Setter
	private String beginDate2;
	@Getter
	@Setter
	private String beginTime2;
	@Getter
	@Setter
	private String endDate2;
	@Getter
	@Setter
	private String endTime2;
	@Getter
	@Setter
	private String goodsCount;
	@Getter
	@Setter
	private String goodsCount2;
	@Getter
	@Setter
	private String buyingRestrictions;
	@Getter
	@Setter
	private String limitedNumber;
	@Getter
	@Setter
	private String goodsBacklog;
	@Getter
	@Setter
	private String goodsTotal;
	@Getter
	@Setter
	private String goodsPrice;

}
