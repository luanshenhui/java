/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * @author wusy
 * @version 1.0
 * @Since 2016/8/6.
 */

public class MessageDto implements Serializable {

	private static final long serialVersionUID = 2579035178857109244L;
	@Setter
	@Getter
	private String orderId;// 子订单号
	@Setter
	@Getter
	private String orderStatus; // 订单状态
	@Setter
	@Getter
	private String goodName;// 商品名称
	@Setter
	@Getter
	private String custId; // 会员号
	@Setter
	@Getter
	private String vendorId; // 供应商ID
	@Setter
	@Getter
	private String userType;// 用户类型 01供应商 02商城 03内管
	@Setter
	@Getter
	private String createOper;// 创建人

}
