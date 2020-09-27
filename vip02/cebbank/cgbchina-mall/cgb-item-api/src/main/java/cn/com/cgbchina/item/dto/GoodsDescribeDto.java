package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsConsultModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import com.spirit.common.model.Pager;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Cong on 2016/5/26.
 */
public class GoodsDescribeDto implements Serializable {

	private static final long serialVersionUID = -5706998971424735245L;
	@Getter
	@Setter
	private GoodsModel goodsModel;

	@Getter
	@Setter
	private Pager<GoodsConsultModel> goodsConsultModelPager;

	@Getter
	@Setter
	private VendorInfoModel vendorInfoModel;

	@Getter
	@Setter
	private ItemModel itemModel;

	@Getter
	@Setter
	private ItemsAttributeDto goodAttr;
}
