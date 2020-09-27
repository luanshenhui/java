package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.ServicePromiseModel;
import com.spirit.category.dto.AttributeDto;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * Created by zhanglin on 2016/8/10.
 */
@ToString
@EqualsAndHashCode
public class GiftItemDto implements Serializable {

	private static final long serialVersionUID = 4196710403967291731L;
	@Getter
	@Setter
	private GoodsModel goodsModel;// 商品

	@Getter
	@Setter
	private ItemModel itemModel;// 单品

	@Getter
	@Setter
	private List<ItemModel> itemModelList;// 单品List

	@Getter
	@Setter
	private AttributeDto goodAttr;// 商品有效规格信息

	@Getter
	@Setter
	private AttributeDto itemAttr;// 单品信息

	@Getter
	@Setter
	private List<ItemGoodsDetailDto> itemGoodsDetailDtoList;// 单品价格

	@Getter
	@Setter
	private List<ServicePromiseModel> servicePromiseModelList;// 服务承诺

	@Getter
	@Setter
	private ItemGoodsDetailDto itemGoodsDetailDto;// 默认单品

	@Setter
	@Getter
	private String pointsTypeName;// 积分类型名

	@Setter
	@Getter
	private Map<String, Object> fictitiousGiftType;//虚拟礼品编号对应值

}
