package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.model.VendorModel;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

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

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		GoodsInfoDto that = (GoodsInfoDto) o;

		return Objects.equal(this.brandName, that.brandName) && Objects.equal(this.goods, that.goods)
				&& Objects.equal(this.vendorName, that.vendorName)
				&& Objects.equal(this.backCategory1Name, that.backCategory1Name)
				&& Objects.equal(this.backCategory2Name, that.backCategory2Name)
				&& Objects.equal(this.backCategory3Name, that.backCategory3Name)
				&& Objects.equal(this.itemModelList, that.itemModelList)
				&& Objects.equal(this.itemModel, that.itemModel)
				&& Objects.equal(this.channelMallWxName, that.channelMallWxName)
				&& Objects.equal(this.channelCreditWxName, that.channelCreditWxName);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(brandName, goods, vendorName, backCategory1Name, backCategory2Name, backCategory3Name,
				itemModelList, itemModel, channelMallWxName, channelCreditWxName);
	}

	@Override
	public String toString() {
		return Objects.toStringHelper(this).add("brandName", brandName).add("goods", goods)
				.add("vendorName", vendorName).add("backCategory1Name", backCategory1Name)
				.add("backCategory2Name", backCategory2Name).add("backCategory3Name", backCategory3Name)
				.add("itemModelList", itemModelList).add("itemModel", itemModel)
				.add("channelMallWxName", channelMallWxName).add("channelCreditWxName", channelCreditWxName).toString();
	}
}
