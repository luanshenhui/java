package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderTransModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by yanjie.cao on 16-4-26.
 */
public class OrderDetailDto extends OrderInfoDto implements Serializable {
	private static final long serialVersionUID = -247529224875719860L;

	// 主订单信息
	@Getter
	@Setter
	private OrderMainModel orderMainModel;

	// 物流信息
	@Getter
	@Setter
	private OrderTransModel orderTransModel;

	// 订单履历
	@Getter
	@Setter
	private List<OrderDoDetailModel> orderDoDetailModels;
}
