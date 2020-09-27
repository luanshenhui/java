package cn.com.cgbchina.item.dto;

import java.io.Serializable;

import com.google.common.base.Objects;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import lombok.Getter;
import lombok.Setter;

/**
 * Created by wangqi on 2016/6/21.
 */
public class ItemPromDto implements Serializable {

	private static final long serialVersionUID = -7890238669140759315L;
	@Getter
	@Setter
	private String itemCode;// 单品编码
	@Getter
	@Setter
	private String goodsCode;// 商品编码
	@Getter
	@Setter
	private String goodsName;// 商品名称
	@Getter
	@Setter
	private String vendorId;// 供应商id
	@Getter
	@Setter
	private String vendorName;// 供应商名称
	@Getter
	@Setter
	private Long goodsBrandId;// 品牌id
	@Getter
	@Setter
	private String goodsBrandName;// 品牌名称
	@Getter
	@Setter
	private Long backCategory1Id;// 一级后台类目
	@Getter
	@Setter
	private Long backCategory2Id;// 二级后台类目
	@Getter
	@Setter
	private Long backCategory3Id;// 三级后台类目
//	@Getter
//	@Setter
//	private Long backCategory4Id;// 三级后台类目
	@Getter
	@Setter
	private String backCategory1Name;// 一级后台类目名称
	@Getter
	@Setter
	private String backCategory2Name;// 二级后台类目名称
	@Getter
	@Setter
	private String backCategory3Name;// 三级后台类目名称
//	@Getter
//	@Setter
//	private String backCategory4Name;// 三级后台类目名称
	@Getter
	@Setter
	private Long stock;// 实际库存
	@Getter
	@Setter
	private java.math.BigDecimal price;// 实际价格

}
