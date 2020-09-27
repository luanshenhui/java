package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Congzy
 */
public class CartJFShopDto implements Serializable {
	//	积分商城返回数据
	private static final long serialVersionUID = -4266941189425268328L;

	@Getter
	@Setter
	List<CartItemDto> payForPointList;

	@Getter
	@Setter
	List<CartItemDto> virtualList;

}
