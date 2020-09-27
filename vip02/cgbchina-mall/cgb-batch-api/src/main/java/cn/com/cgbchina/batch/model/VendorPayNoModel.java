package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class VendorPayNoModel implements Serializable {

	private static final long serialVersionUID = 170514045170596403L;
	@Getter
	@Setter
	private Long id;// 自增ID
	@Getter
	@Setter
	private String vendorInfId;// 合作商ID
	@Getter
	@Setter
	private Integer period;// 期数
	@Getter
	@Setter
	private String payNo;// 缴款方案代码
	@Getter
	@Setter
	private String payName;// 缴款方案名称
	@Getter
	@Setter
	private String product;// 产品
	@Getter
	@Setter
	private String createOper;// 创建用户
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 最后修改用户
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
	@Getter
	@Setter
	private String delFlag;// 删除标志0-未删除1-删除
}