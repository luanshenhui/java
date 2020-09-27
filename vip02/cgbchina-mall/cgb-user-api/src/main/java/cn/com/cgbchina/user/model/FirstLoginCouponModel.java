package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class FirstLoginCouponModel implements Serializable {

	private static final long serialVersionUID = 5720962347656287798L;
	@Getter
	@Setter
	private Long id;// 自增主键
	@Getter
	@Setter
	private String couponId;// 项目编号
	@Getter
	@Setter
	private java.util.Date startTime;// 开始时间
	@Getter
	@Setter
	private java.util.Date endTime;// 结束时间
	@Getter
	@Setter
	private String isStarted;// 是否开始
	@Getter
	@Setter
	private String delFlag;// 删除标志 0未删除1已删除
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 修改人员
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
	@Getter
	@Setter
	private String createOper;// 创建人
}