package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsConsultModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.ServicePromiseModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import com.spirit.common.model.Pager;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Cong on 2016/5/26.
 */
public class GoodsItemDto implements Serializable {

	private static final long serialVersionUID = -8855577370588366596L;
	@Getter
	@Setter
	private GoodsModel goodsModel;

	@Getter
	@Setter
	private ItemModel itemModel;

	@Getter
	@Setter
	private ItemGoodsDetailDto itemGoodsDetailDto;

	@Getter
	@Setter
	private ItemsAttributeDto goodAttr;

	@Getter
	@Setter
	private ItemsAttributeDto itemAttr;

	@Getter
	@Setter
	private List<ItemModel> itemModelList;

	@Getter
	@Setter
	private List<ItemGoodsDetailDto> itemGoodsDetailDtoList;

	@Getter
	@Setter
	private List<ServicePromiseModel> servicePromiseModelList;

	@Getter
	@Setter
	private Long lastSinglePoint;	//单位积分

	@Getter
	@Setter
	private List<CardScaleDto> cardScaleDtoList;		//卡优惠比例
}
