package cn.com.cgbchina.item.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class CCJudgeGoodsDetailDto implements Serializable {
	@Getter
	@Setter
	private String goodsId;
	@Getter
	@Setter
	private String goodsXid;
	@Getter
	@Setter
	private Integer limitCount;
	@Getter
	@Setter
	private Integer virtualLimitDays;
	@Getter
	@Setter
	private String cards;
	@Getter
	@Setter
	private String regionType;
}
