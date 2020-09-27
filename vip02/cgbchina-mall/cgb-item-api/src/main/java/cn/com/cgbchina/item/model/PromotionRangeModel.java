package cn.com.cgbchina.item.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class PromotionRangeModel implements Serializable {

	private static final long serialVersionUID = -3924576108818858083L;
	@Getter
	@Setter
	private Integer id;// 活动选取范围ID
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
	private String selectId;// 选品Id，格式为JSON串
	@Getter
	@Setter
	private String selectCode;// 单品code
	@Getter
	@Setter
	private String selectName;// 选品名称
	@Getter
	@Setter
	private String goodsCode;// 商品code
	@Getter
	@Setter
	private Long backCategory1Id;// 一级分类id
	@Getter
	@Setter
	private Long backCategory2Id;// 二级分类id
	@Getter
	@Setter
	private Long backCategory3Id;// 三级分类id
//	@Getter
//	@Setter
//	private Long backCategory4Id;// 四级分类id

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
	private java.math.BigDecimal levelPrice;// 阶梯(售价)
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
	private Integer modifyOperType;// 修改者类型
	@Getter
	@Setter
	private String auditLog;// 审核日志
	@Getter
	@Setter
	private String auditOper;// 审核人
	@Getter
	@Setter
	private java.util.Date auditDate;// 最终审核日期
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 修改人
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
	@Setter
	@Getter
	private Integer saleCount;// 销量
	@Setter
	@Getter
	private Integer perStock;//每一场的库存
	@Setter
	@Getter
	private Long groupClassify;//团购商品类别
}