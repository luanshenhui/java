package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class PointPoolModel implements Serializable {

	private static final long serialVersionUID = 19502964489870249L;
	@Getter
	@Setter
	private Long id;// 自增主键
	@Getter
	@Setter
	private String curMonth;// 当前月份
	@Getter
	@Setter
	private Long maxPoint;// 最大积分数
	@Getter
	@Setter
	private Long singlePoint;// 单位积分
	@Getter
	@Setter
	private java.math.BigDecimal pointRate;// 最高倍率
	@Getter
	@Setter
	private Long usedPoint;// 已用积分
	@Getter
	@Setter
	private String createOper;// 创建者
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 更新人
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标记 0：未删除 1：已删除
}