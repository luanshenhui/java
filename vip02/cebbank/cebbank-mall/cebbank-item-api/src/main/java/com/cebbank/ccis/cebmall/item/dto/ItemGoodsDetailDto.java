package com.cebbank.ccis.cebmall.item.dto;

import com.cebbank.ccis.cebmall.item.model.ItemModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by zhanglin on 2016/7/4.
 */
public class ItemGoodsDetailDto extends ItemModel implements Serializable {

	private static final long serialVersionUID = 8890934807676287592L;

	@Setter
	@Getter
	private String maxNumber;// 最高期数

	@Setter
	@Getter
	private String goodsName;// 商品名称

	@Setter
	@Getter
	private Boolean allPointFlag;// 是否显示全积分

	@Setter
	@Getter
	private String vendorId;//供应商id

	@Setter
	@Getter
	private String goodsType;//商品类型（00实物01虚拟02O2O）

	@Setter
	@Getter
	private String pointsType;//积分类型id

	@Setter
	@Getter
	private String goodsBrandName;//品牌名称

	@Setter
	@Getter
	private String channelCc;//CC状态00处理中 01在库 02上架

	@Setter
	@Getter
	private String channelIvr;//ivr状态00处理中 01在库 02上架

}
