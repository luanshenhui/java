package cn.com.cgbchina.item.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class ItemWechatDto implements Serializable {

	private static final long serialVersionUID = -5825898301856225232L;
	@Getter
	@Setter
	private String name;// 商品名称
	@Getter
	@Setter
	private String vendorName;// 供应商
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
	private String channelMallWxName; // 广发银行（微信）
	@Getter
	@Setter
	private String channelCreditWxName; // 广发信用卡（微信）
	@Getter
	@Setter
	private Integer installmentNumber;// 最高期数
	@Getter
	@Setter
	private String code;// 单品编码
	@Getter
	@Setter
	private String goodsCode;// 商品code
	@Getter
	@Setter
	private java.math.BigDecimal marketPrice;// 市场价格
	@Getter
	@Setter
	private java.math.BigDecimal price;// 实际价格
	@Getter
	@Setter
	private Long stock;// 实际库存
	@Getter
	@Setter
	private String o2oCode;// o2o商品编码
	@Getter
	@Setter
	private String o2oVoucherCode;// o2o兑换券编码
	@Getter
	@Setter
	private Long stockWarning;// 库存预警
	@Getter
	@Setter
	private java.util.Date nostockNotifyTime;// 库存预警消息发送时间
	@Getter
	@Setter
	private String image1;// 图片1
	@Getter
	@Setter
	private String image2;// 图片2
	@Getter
	@Setter
	private String image3;// 图片3
	@Getter
	@Setter
	private String image4;// 图片4
	@Getter
	@Setter
	private String image5;// 图片5
	@Getter
	@Setter
	private String freightSize;// 商品体积
	@Getter
	@Setter
	private String freightWeight;// 商品重量
	@Getter
	@Setter
	private String machCode;// 条形码
	@Getter
	@Setter
	private Long goodsTotal;//
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标示0未删除1已删除
	@Getter
	@Setter
	private String createOper;// 创建者
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 修改者
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
	@Getter
	@Setter
	private String attribute;// 单品属性list
	@Getter
	@Setter
	private Long wxOrder;// 微信商品显示顺序
	@Getter
	@Setter
	private Integer stickFlag;// 置顶标志
	@Getter
	@Setter
	private Integer stickOrder;// 置顶商品显示顺序
}
