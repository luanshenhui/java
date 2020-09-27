package cn.com.cgbchina.item.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class PromotionVendorModel implements Serializable {

	private static final long serialVersionUID = -585996720924299980L;
	@Getter
	@Setter
	private Integer id;// 活动选取范围ID
	@Getter
	@Setter
	private Integer promotionId;// 活动ID
	@Getter
	@Setter
	private Integer isValid;// 有效状态：0删除，1正常
	@Getter
	@Setter
	private java.util.Date createDate;// 创建时间
	@Getter
	@Setter
	private String vendorId;// 供应商ID
}