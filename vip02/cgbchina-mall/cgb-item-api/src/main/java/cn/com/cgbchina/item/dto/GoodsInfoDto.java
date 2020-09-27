package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.model.VendorModel;
import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

@EqualsAndHashCode
public class GoodsInfoDto implements Serializable {

	private static final long serialVersionUID = -3891217438273736795L;
	@Getter
	@Setter
	private String brandName;// 品牌名称
	@Getter
	@Setter
	private GoodsModel goods;// 商品信息
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
	private List<ItemModel> itemModelList;// 单品信息list
	@Getter
	@Setter
	private ItemModel itemModel;// 单品Model
	@Getter
	@Setter
	private String channelMallWxName; // 广发银行（微信）
	@Getter
	@Setter
	private String channelCreditWxName; // 广发信用卡（微信）
	@Getter
	@Setter
	private String modifyTimeLong;//修改时间
}
