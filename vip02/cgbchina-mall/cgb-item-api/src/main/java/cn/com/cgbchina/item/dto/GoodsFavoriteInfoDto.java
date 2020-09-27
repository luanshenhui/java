package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.user.model.MemberGoodsFavoriteModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 张成 on 16-4-28.
 */
public class GoodsFavoriteInfoDto implements Serializable {

	private static final long serialVersionUID = 7999227826143662653L;

	@Getter
	@Setter
	private MemberGoodsFavoriteModel memberGoodsFavoriteModel;

	@Getter
	@Setter
	private ItemModel itemModel;

	@Getter
	@Setter
	private GoodsModel goodsModel;

	@Getter
	@Setter
	private String goodsFavoriteType;// 已收藏单品状态（0：正常 1：直降 2：失效）

	@Getter
	@Setter
	private String itemName;// 单品名称

	@Getter
	@Setter
	private String itemPrice;// 单品价格

	@Getter
	@Setter
	private String maxInstallmentNumber;// 最高期

	@Getter
	@Setter
	private String itemPoint;//	单品积分

	@Getter
	@Setter
	private String orderTypeId;// 业务区分
}
