package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.CartItem;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * Created by 张成 on 16-4-28.
 */
public class  CartResultDto implements Serializable {

	private static final long serialVersionUID = 7831708519174827609L;

	@Getter
	@Setter
	private GaterialGoodsDto gaterialGoodsDtoList;	//实物商品

	@Getter
	@Setter
	private VirtualGoodsDto virtualGoodsDtoList;	//虚拟商品

	@Getter
	@Setter
	private String surplusPoint;  //积分池剩余

	@Getter
	@Setter
	private String singlePoint; //单位积分 兑换比例

	@Getter
	@Setter
	private String commonAmount;    //用户普通积分

	@Getter
	@Setter
	private String hopeAmount;  //用户希望积分

	@Getter
	@Setter
	private String truthAmount; //用户真情积分

}
