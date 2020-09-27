package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class StageRateModel implements Serializable {

	private static final long serialVersionUID = -4651747040262936877L;
	@Getter
	@Setter
	private Long id;// 分期汇率id
	@Getter
	@Setter
	private String type;// 分期类型
	@Getter
	@Setter
	private String name;// 分期名称
	@Getter
	@Setter
	private String businessScenario;// 业务场景
	@Getter
	@Setter
	private java.math.BigDecimal orderAmount;// 订单金额
	@Getter
	@Setter
	private Integer totalStage;// 订单总期数
	@Getter
	@Setter
	private String endPaySign;// 首尾付标志
	@Getter
	@Setter
	private java.math.BigDecimal endPayCorpus;// 首尾付本金
	@Getter
	@Setter
	private String fixFeeSign;// 固定费用首尾付标志
	@Getter
	@Setter
	private Integer fixAmountFee;// 固定金额手续费
	@Getter
	@Setter
	private java.math.BigDecimal r1Rate;// 第一阶段费率
	@Getter
	@Setter
	private java.math.BigDecimal r1Percent;// 第一阶段本金百分比
	@Getter
	@Setter
	private java.math.BigDecimal r2Rate;// 第二阶段费率
	@Getter
	@Setter
	private java.math.BigDecimal r2Percent;// 第二阶段本金百分比
	@Getter
	@Setter
	private Integer r2Stage;// 第二阶段开始期数
	@Getter
	@Setter
	private java.math.BigDecimal r3Rate;// 第三阶段费率
	@Getter
	@Setter
	private java.math.BigDecimal r3Percent;// 第三阶段本金百分比
	@Getter
	@Setter
	private Integer r3Stage;// 第三阶段开始期数
	@Getter
	@Setter
	private Integer freeStageFrom;// 直接免除手续费期数from
	@Getter
	@Setter
	private Integer freeStageTo;// 直接免除手续费期数to
	@Getter
	@Setter
	private Integer freeStage;// 手续费免除期数
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标记 0：未删除 1：已删除
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private String modifyOper;// 更新人
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private java.util.Date modifyTime;// 更新时间
	@Getter
	@Setter
	private String vendorId;// 供应商ID
}