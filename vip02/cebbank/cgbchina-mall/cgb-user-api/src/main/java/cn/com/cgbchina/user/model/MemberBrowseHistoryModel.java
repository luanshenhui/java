package cn.com.cgbchina.user.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class MemberBrowseHistoryModel implements Serializable {

	private static final long serialVersionUID = -2185107326124285554L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String goodsCode;// 商品编码
	@Getter
	@Setter
	private String itemCode;// 单品编码
	@Getter
	@Setter
	private java.math.BigDecimal price;// 实际价格
	@Getter
	@Setter
	private String custId;// 会员编号
	@Getter
	@Setter
	private java.util.Date createTime;// 浏览时间
	@Getter
	@Setter
	private String browseType;// 浏览类型
	@Getter
	@Setter
	private String source;// 来源
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标记 0：未删除 1：已删除
	@Getter
	@Setter
	private Integer installmentNumber;// 最高期数
}