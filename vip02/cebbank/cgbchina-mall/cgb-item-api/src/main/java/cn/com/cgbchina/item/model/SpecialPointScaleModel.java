package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class SpecialPointScaleModel implements Serializable {

	private static final long serialVersionUID = 4431723941260495766L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private java.math.BigDecimal scale;// 兑换比例
	@Getter
	@Setter
	private String type;// 类型 0：供应商 1：品牌 2：类目 3：商品
	@Getter
	@Setter
	private String typeVal;// 类型值
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标记 0：未删除 1：已删除
	@Getter
	@Setter
	private String createOper;// 创建人
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
	private String typeId;// 类型ID
}