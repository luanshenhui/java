package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.CartItem;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Cong on 16-7-6..
 */
public class GaterialGoodsDto implements Serializable {

	private static final long serialVersionUID = -3749905282656214531L;
	@Getter
	@Setter
	private List<CartItem> installmentsList; // 多期信用卡付款

	@Getter
	@Setter
	private List<CartItem> immediatePaymentList; // 立即付款

}
