package cn.com.cgbchina.trade.model;

import cn.com.cgbchina.trade.dto.CartItemsAttributeSkuDto;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

public class CartItem implements Serializable {
	private static final long serialVersionUID = -6698597450849302906L;

	// private ItemMode sku;// 单品
	@Getter
	@Setter
	private String itemId;

	@Getter
	@Setter
	private String goodsCode;

	@Getter
	@Setter
	private String status;

	@Getter
	@Setter
	private String itemImage;

	@Getter
	@Setter
	private String itemName;

	@Getter
	@Setter
	private String instalments; // 分期数

	@Getter
	@Setter
	private String payType; // 支付方式区分

	@Getter
	@Setter
	private BigDecimal price; // 单价

	@Getter
	@Setter
	private BigDecimal totalPrice;

	@Getter
	@Setter
	private String shopId;

	@Getter
	@Setter
	private Integer count;

	@Getter
	@Setter
	private String region;

	@Getter
	@Setter
	private Long stock;// 实际库存

	@Getter
	@Setter
	private String favoriteStatus;// 收藏状态

	@Getter
	@Setter
	private List<CartItemsAttributeSkuDto> attribute;// 单品属性

	@Getter
	@Setter
	private Long fixPoint;//固定积分

	@Getter
	@Setter
	private String availablePoint; //可用积分

	@Getter
	@Setter
	private String goodsType;	//商品类型（00实物01虚拟02O2O）

	@Getter
	@Setter
	private String amount;	//用户积分

	@Getter
	@Setter
	private String pointsType;	//积分类型

	@Getter
	@Setter
	private String imgShow;	//图片展示

//	@Getter
//	@Setter
//	private String commonAmount;	//用户普通积分
//
//	@Getter
//	@Setter
//	private String hopeAmount;//用户希望积分
//
//	@Getter
//	@Setter
//	private String truthAmount;//用户真情积分

}
