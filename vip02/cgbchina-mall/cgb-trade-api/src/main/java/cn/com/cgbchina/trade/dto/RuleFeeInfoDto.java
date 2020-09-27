package cn.com.cgbchina.trade.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by
 */
public class RuleFeeInfoDto implements Serializable {

	private static final long serialVersionUID = 3737605992476459103L;

	@Getter
	@Setter
	private Integer ruleMinPay1;// 满减优惠阶梯1（满）
	@Getter
	@Setter
	private Integer ruleMinPay2;// 满减优惠阶梯2（满）
	@Getter
	@Setter
	private Integer ruleMinPay3;// 满减优惠阶梯3（满）
	@Getter
	@Setter
	private Integer ruleMinPay4;// 满减优惠阶梯4（满）
	@Getter
	@Setter
	private Integer ruleMinPay5;// 满减优惠阶梯5（满）
	@Getter
	@Setter
	private Integer ruleMinPay6;// 满减优惠阶梯6（满）
	@Getter
	@Setter
	private Integer ruleMinPay7;// 满减优惠阶梯7（满）
	@Getter
	@Setter
	private Integer ruleMinPay8;// 满减优惠阶梯8（满）
	@Getter
	@Setter
	private Integer ruleMinPay9;// 满减优惠阶梯9（满）
	@Getter
	@Setter
	private Integer ruleMinPay10;// 满减优惠阶梯10（满）
	@Getter
	@Setter
	private Integer ruleFee1;// 满减优惠阶梯1（减）
	@Getter
	@Setter
	private Integer ruleFee2;// 满减优惠阶梯2（减）
	@Getter
	@Setter
	private Integer ruleFee3;// 满减优惠阶梯3（减）
	@Getter
	@Setter
	private Integer ruleFee4;// 满减优惠阶梯4（减）
	@Getter
	@Setter
	private Integer ruleFee5;// 满减优惠阶梯5（减）
	@Getter
	@Setter
	private Integer ruleFee6;// 满减优惠阶梯6（减）
	@Getter
	@Setter
	private Integer ruleFee7;// 满减优惠阶梯7（减）
	@Getter
	@Setter
	private Integer ruleFee8;// 满减优惠阶梯8（减）
	@Getter
	@Setter
	private Integer ruleFee9;// 满减优惠阶梯9（减）
	@Getter
	@Setter
	private Integer ruleFee10;// 满减优惠阶梯10（减）
}
