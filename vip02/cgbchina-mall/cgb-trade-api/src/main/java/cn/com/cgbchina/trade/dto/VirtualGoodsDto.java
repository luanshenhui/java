package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.CartItem;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Cong on 16-7-6.
 */
public class VirtualGoodsDto implements Serializable {

	private static final long serialVersionUID = 6777202067118895382L;
	@Getter
	@Setter
	private List<CartItem> allIntegralPaymentList;	//全积分付款

	@Getter
	@Setter
	private List<CartItem> virtualPaymentList;	//虚拟商品

}
