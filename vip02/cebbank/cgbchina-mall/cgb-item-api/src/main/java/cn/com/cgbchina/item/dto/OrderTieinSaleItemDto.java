/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * @author yanjie.cao
 * @version 1.0
 * @Since 2016/6/13.
 */
public class OrderTieinSaleItemDto implements Serializable {

	private static final long serialVersionUID = 2261733972908237174L;

	@Getter
	@Setter
	private ItemModel itemModel;

	@Getter
	@Setter
	private GoodsModel goodsModel;

	@Getter
	@Setter
	private GoodsBrandModel goodsBrandModel;
}
