package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class CouponScaleModel implements Serializable {

	private static final long serialVersionUID = -6866237792451819076L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String type;// 类型 0：普卡/金卡 1：钛金卡/臻享白金卡 2：顶级/增值白金卡 3：vip 4：生日
	@Getter
	@Setter
	private java.math.BigDecimal scale;//
	@Getter
	@Setter
	private String creatOper;// 创建人
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 更新人
	@Getter
	@Setter
	private java.util.Date modifyTime;// 更新时间
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标记 0：未删除 1：已删除
}