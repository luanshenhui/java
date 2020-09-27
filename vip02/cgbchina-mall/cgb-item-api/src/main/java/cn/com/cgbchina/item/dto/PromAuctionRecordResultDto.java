package cn.com.cgbchina.item.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 秒杀获取场次选品信息DTO
 *
 * @author huangfuchangyu
 * @version 1.0
 * @Since 2016/7/20
 */
public class PromAuctionRecordResultDto extends AuctionRecordDto implements Serializable {
	private static final long serialVersionUID = 2781082178466313570L;
	@Setter
	@Getter
	private Integer maxNumber;// 最高期
	@Setter
	@Getter
	private java.math.BigDecimal oldPrice;// 原价
	@Setter
	@Getter
	private java.math.BigDecimal perStage;// 每期
	@Getter
	@Setter
	private String nowDate; // 当前时间
	@Getter
	@Setter
	private String image1;// 图片1
}
