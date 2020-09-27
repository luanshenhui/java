package cn.com.cgbchina.trade.dto;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by Congzy
 */
public class VoucherInfoDto implements Serializable {

	private static final long serialVersionUID = -6641724299074742698L;

	@Getter
	@Setter
	private String voucherId;	//优惠券id

	@Getter
	@Setter
	private String voucherNo;	//优惠券No

	@Getter
	@Setter
	private String voucherName;//优惠券名称

	@Getter
	@Setter
	private String voucherFigure;//优惠券金额

	@Getter
	@Setter
	private Integer isReceived;//是否已经领取 0是，1否

	@Getter
	@Setter
	private String startTime;//有效开始时间

	@Getter
	@Setter
	private String endTime;//有效结束时间

	@Getter
	@Setter
	private BigDecimal limitMoney;//最低使用价格（单品）
}
