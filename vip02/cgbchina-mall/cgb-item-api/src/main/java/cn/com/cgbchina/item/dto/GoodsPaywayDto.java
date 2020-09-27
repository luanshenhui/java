package cn.com.cgbchina.item.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

public class GoodsPaywayDto implements Serializable {

	private static final long serialVersionUID = 1936652060296713708L;

	@Getter
	@Setter
	private String goodsCode;// 商品编号
	@Getter
	@Setter
	private String itemId;// 单品编号
	@Getter
	@Setter
	private Long gold;// 金普
	@Getter
	@Setter
	private Long titanium;// 钛金/臻享白金
	@Getter
	@Setter
	private Long topLevel;// 顶级/增值白金
	@Getter
	@Setter
	private Long vip;// VIP
	@Getter
	@Setter
	private Long birthday;// 生日
	@Getter
	@Setter
	private Long points;// 积分
	@Getter
	@Setter
	private BigDecimal price;// 现金
	@Getter
	@Setter
	private List<GoodsPaywayDto> goodsPaywayDtos;
	@Getter
	@Setter
	private java.math.BigDecimal calMoney;//清算金额 用于定价审核更新时的数据 add by zhoupeng
}