package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * Created by 陈乐 on 2016/3/29.
 */
public class ItemDto implements Serializable {

	private static final long serialVersionUID = -1441607729652550696L;
	@Getter
	@Setter
	private ItemModel itemModel;
	@Getter
	@Setter
	private ItemsAttributeDto itemsAttributeDto;// 销售属性相关信息
	@Getter
	@Setter
	private String itemDescription;// 单品描述
	@Getter
	@Setter
	private GoodsModel goodsModel;
	@Getter
	@Setter
	private List<TblGoodsPaywayModel> payways; // 支付方式

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		ItemDto that = (ItemDto) o;

		return Objects.equal(this.itemModel, that.itemModel)
				&& Objects.equal(this.itemsAttributeDto, that.itemsAttributeDto)
				&& Objects.equal(this.itemDescription, that.itemDescription)
				&& Objects.equal(this.goodsModel, that.goodsModel);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(itemModel, itemsAttributeDto, itemDescription, goodsModel);
	}

	@Override
	public String toString() {
		return Objects.toStringHelper(this).add("itemModel", itemModel).add("itemsAttributeDto", itemsAttributeDto)
				.add("itemDescription", itemDescription).add("goodsModel", goodsModel).toString();
	}
}
