package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class EspCustVoucherModel implements Serializable {

	private static final long serialVersionUID = -2035364434283356081L;
	@Getter
	@Setter
	private String voucherNo;// 优惠券编码
	@Getter
	@Setter
	private String custIdNbr;// 证件号码
	@Getter
	@Setter
	private String custIdType;// 证件类别
	@Getter
	@Setter
	private String voucherId;// 优惠卷类别
	@Getter
	@Setter
	private String curStatus;// 当前状态0未使用1已使用
	@Getter
	@Setter
	private String orderId;// 使用的单号
	@Getter
	@Setter
	private String custVoucherDesc;// 备注
	@Getter
	@Setter
	private String createOper;// 创建用户
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 最近修改用户
	@Getter
	@Setter
	private java.util.Date modifyTime;// 最近修改时间
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标记0未删除1已删除
}