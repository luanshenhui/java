package cn.com.cgbchina.promotion.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/21.
 */
public class PromotionRangeAddDto implements Serializable {

	private static final long serialVersionUID = 487288949360484024L;

	@Getter
	@Setter
	private Integer promotionId;// 活动ID
	@Getter
	@Setter
	private String vendorId;// 供应商ID
	@Getter
	@Setter
	private Integer rangeType;// 范围类型（0 单品）
	@Getter
	@Setter
	private String selectCode;// 选品编码
	@Getter
	@Setter
	private String selectName;// 选品名称
	@Getter
	@Setter
	private String checkStatus;// 选品状态 0 待审核，1 已通过，2 已拒绝
	@Getter
	@Setter
	private Integer isValid;// 有效状态：0删除，1正常
	@Getter
	@Setter
	private Integer seq;// 排序
	@Getter
	@Setter
	private java.math.BigDecimal price;// 售价
	@Getter
	@Setter
	private Integer stock;// 活动商品数量
	@Getter
	@Setter
	private Integer costBy;// 费用承担方(0 行方 1 供应商)
	@Getter
	@Setter
	private Integer couponEnable;// 是否可以使用优惠卷(1 可以 0 不可以)
	@Getter
	@Setter
	private Integer levelMinCount;// 阶梯1(参团人数)
	@Getter
	@Setter
	private java.math.BigDecimal levelPrice;// 阶梯1(售价)
	@Getter
	@Setter
	private java.math.BigDecimal startPrice;// 起拍价
	@Getter
	@Setter
	private java.math.BigDecimal minPrice;// 最低价
	@Getter
	@Setter
	private java.math.BigDecimal feeRange;// 降价金额
	@Getter
	@Setter
	private Integer createOperType;// 创建者类型
	@Getter
	@Setter
	private String createOper;// 创建人

}
