package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.*;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by yanjie.cao on 16-4-26.
 */
public class OrderDetailDto extends OrderInfoDto implements Serializable {
	private static final long serialVersionUID = -247529224875719860L;


	@Getter
	@Setter
	private OrderMainModel orderMainModel; // 主订单信息
	@Getter
	@Setter
	private OrderTransModel orderTransModel; // 物流信息

	@Getter
	@Setter
	private List<OrderDoDetailModel> orderDoDetailModels; // 订单履历
	@Getter
	@Setter
	private TblOrderExtend1Model tblOrderExtend1Model; //订单信息扩展表
	@Getter
	@Setter
	private String  verifyCode; //020码
	@Getter
	@Setter
	private String validateStatus; //020码状态 00未使用 01已使用
	@Getter
	@Setter
	private OrderVirtualModel orderVirtualModel; //虚拟礼品订单扩展表
	@Getter
	@Setter
	private Boolean otherFlag; //积分商城其他信息展示标识 true展示

}
