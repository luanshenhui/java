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
	private String image;//单品图片
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
	private String backCategory4Name;// 第四级后台类目
	@Getter
	@Setter
	private String channelMallWx; // 广发银行（微信）
	@Getter
	@Setter
	private String channelCreditWx; // 广发信用卡（微信）
	@Getter
	@Setter
	private Integer installmentNumber;// 最高期数
	@Getter
	@Setter
	private String code;// 单品编码
	@Getter
	@Setter
	private String mid;//单品mid
	@Getter
	@Setter
	private java.math.BigDecimal price;// 实际价格
	@Getter
	@Setter
	private Long wxOrder;// 微信商品显示顺序
}
