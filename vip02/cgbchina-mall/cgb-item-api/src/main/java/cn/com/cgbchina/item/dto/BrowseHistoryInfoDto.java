package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.user.model.MemberGoodsFavoriteModel;
import cn.com.cgbchina.user.model.MemberBrowseHistoryModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 张成 on 16-4-28.
 */
public class BrowseHistoryInfoDto implements Serializable {

	private static final long serialVersionUID = 7999227826143662653L;

	@Getter
	@Setter
	private MemberBrowseHistoryModel memberBrowseHistoryModel;

	@Getter
	@Setter
	private ItemModel itemModel;

	@Getter
	@Setter
	private GoodsModel goodsModel;

	@Getter
	@Setter
	private String priceType;// 降价区分（0：原价 1：直降）

	@Getter
	@Setter
	private String itemPrice;// 单品价格

	@Getter
	@Setter
	private Long goodsPoint;//积分商品获取积分数
}
