package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class BusinessConfig implements Serializable {


	private static final long serialVersionUID = -7988678840411404177L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String code;// 业务代码,积分兑换比例price_jfdh采购价上浮系数price_cgsf
	@Getter
	@Setter
	private String value1;// 值1
	@Getter
	@Setter
	private java.math.BigDecimal value2;// 值2
	@Getter
	@Setter
	private Long value3;// 值3
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标示0未删除1已删除
	@Getter
	@Setter
	private String createOper;// 创建者
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 修改者
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
}