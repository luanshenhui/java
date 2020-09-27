package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 11141021040453 on 16-4-15.
 */
public class BuyerInfo implements Serializable {
	private static final long serialVersionUID = 8770814186757135903L;

	@Getter
	@Setter
	private String name;// 收货人姓名

	@Getter
	@Setter
	private String code;// 收货人证件号码

	@Getter
	@Setter
	private String mobile1;// 收货人电话1

	@Getter
	@Setter
	private String mobile2;// 收货人电话2

	@Getter
	@Setter
	private String postcode;// 收货人邮编

	@Getter
	@Setter
	private String address;// 收货人地址

	@Getter
	@Setter
	private String requestTime;// 送货时间要求

	@Getter
	@Setter
	private String message;// 订单留言

}
