package cn.com.cgbchina.item.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 活动范围
 *
 * @author wangqi
 * @version 1.0
 * @Since 2016/6/13.
 */
public class PromItemDtoStr implements Serializable {

	private static final long serialVersionUID = 2781082178466313570L;

	@Setter
	@Getter
	private Integer id;// id
	@Setter
	@Getter
	private String sort;// 排序
	@Setter
	@Getter
	private String backCategoryName;// 分类
	@Setter
	@Getter
	private String backCategory;// 类目id集合
	@Setter
	@Getter
	private String goodsBrandName;// 品牌
	@Setter
	@Getter
	private String itemCode;// 单品编码
	@Setter
	@Getter
	private String goodsName;// 商品名称
	@Setter
	@Getter
	private String price;// 售价
	@Setter
	@Getter
	private String stock;// 数量
	@Setter
	@Getter
	private String vendor;// 供应商
	@Setter
	@Getter
	private String costBy;// 费用承担方
	@Setter
	@Getter
	private String checkStatus;// 审核状态
	@Setter
	@Getter
	private String auditLog;// 审核日志
	@Getter
	@Setter
	private String backCategory1Name;// 第一级后台类目
	@Getter
	@Setter
	private String backCategory2Name;// 第二级后台类目
	@Getter
	@Setter
	private String backCategory3Name;// 第三级后台类目
	@Getter
	@Setter
	private String promotionId;// 活动ID
	@Getter
	@Setter
	private String vendorId;// 供应商ID
	@Getter
	@Setter
	private String rangeType;// 范围类型（0 单品）
	@Getter
	@Setter
	private String seq;// 排序
	@Getter
	@Setter
	private String couponEnable;// 是否可以使用优惠卷(1 可以 0 不可以)
	@Getter
	@Setter
	private String levelPrice;// 阶梯1(售价)
	@Getter
	@Setter
	private String startPrice;// 起拍价
	@Getter
	@Setter
	private String minPrice;// 最低价
	@Getter
	@Setter
	private String feeRange;// 降价金额
	@Setter
	@Getter
	private String perStock; //单场库存
	@Setter
	@Getter
	private Long groupClassify;//团购商品类别
	@Setter
	@Getter
	private String groupClassifyName;//团购商品类别名称

}