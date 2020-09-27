/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.dto;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-7-14.
 */
public class MyCouponDto implements Serializable {

	private static final long serialVersionUID = 195080732198435056L;
	@Getter
	@Setter
	private String projectNO;
	@Getter
	@Setter
	private String privilegeName;
	@Getter
	@Setter
	private BigDecimal privilegeMoney;
	@Getter
	@Setter
	private BigDecimal limitMoney;
	@Getter
	@Setter
	private String beginDate;
	@Getter
	@Setter
	private String endDate;
	@Getter
	@Setter
	private String regulation;

}
