package cn.com.cgbchina.batch.model;

import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class PromotionBatchModel extends BaseModel implements Serializable {


	private static final long serialVersionUID = -7593712653214922300L;
	@Getter
	@Setter
	private Integer id;// 活动ID
	@Getter
	@Setter
	private String name;// 活动名称
	@Getter
	@Setter
	private String shortName;// 简称
	@Getter
	@Setter
	private Integer promType;// 活动类型 10 折扣 20 满减 30 秒杀 40 团购 50 荷兰拍
	@Getter
	@Setter
	private java.util.Date beginDate;// 开始时间
	@Getter
	@Setter
	private java.util.Date endDate;// 结束时间
	@Getter
	@Setter
	private String loopType;// 循环类型,值为d 按天循环;w 按星期循环；m 按月循环
	@Getter
	@Setter
	private java.math.BigDecimal ruleDiscountRate;// 折扣比例
	@Getter
	@Setter
	private Integer ruleLimitBuyCount;// 限购数量
	@Getter
	@Setter
	private Integer ruleLimitBuyType;// 限购种类，0 单日内限购，1 整个活动限购
	@Getter
	@Setter
	private Integer ruleFrequency;// 降价频率
	@Getter
	@Setter
	private Integer ruleLimitTicket;// 可拍次数
	@Getter
	@Setter
	private Integer ruleGroupCount;// 每组商品数
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
    @Setter
	@Getter
	private String sourceId;//渠道字符串 用||分割


	@Override
	public boolean equals(Object o) {
		if(this == o) return true;
		if(o == null || getClass() != o.getClass()) return false;

		PromotionBatchModel that = (PromotionBatchModel) o;

		return Objects.equal(this.id, that.id) &&
				Objects.equal(this.name, that.name) &&
				Objects.equal(this.shortName, that.shortName) &&
				Objects.equal(this.promType, that.promType) &&
				Objects.equal(this.beginDate, that.beginDate) &&
				Objects.equal(this.endDate, that.endDate) &&
				Objects.equal(this.loopType, that.loopType) &&
				Objects.equal(this.ruleDiscountRate, that.ruleDiscountRate) &&
				Objects.equal(this.ruleLimitBuyCount, that.ruleLimitBuyCount) &&
				Objects.equal(this.ruleLimitBuyType, that.ruleLimitBuyType) &&
				Objects.equal(this.ruleFrequency, that.ruleFrequency) &&
				Objects.equal(this.ruleLimitTicket, that.ruleLimitTicket) &&
				Objects.equal(this.ruleGroupCount, that.ruleGroupCount) &&
				Objects.equal(this.ruleMinPay1, that.ruleMinPay1) &&
				Objects.equal(this.ruleMinPay2, that.ruleMinPay2) &&
				Objects.equal(this.ruleMinPay3, that.ruleMinPay3) &&
				Objects.equal(this.ruleMinPay4, that.ruleMinPay4) &&
				Objects.equal(this.ruleMinPay5, that.ruleMinPay5) &&
				Objects.equal(this.ruleMinPay6, that.ruleMinPay6) &&
				Objects.equal(this.ruleMinPay7, that.ruleMinPay7) &&
				Objects.equal(this.ruleMinPay8, that.ruleMinPay8) &&
				Objects.equal(this.ruleMinPay9, that.ruleMinPay9) &&
				Objects.equal(this.ruleMinPay10, that.ruleMinPay10) &&
				Objects.equal(this.ruleFee1, that.ruleFee1) &&
				Objects.equal(this.ruleFee2, that.ruleFee2) &&
				Objects.equal(this.ruleFee3, that.ruleFee3) &&
				Objects.equal(this.ruleFee4, that.ruleFee4) &&
				Objects.equal(this.ruleFee5, that.ruleFee5) &&
				Objects.equal(this.ruleFee6, that.ruleFee6) &&
				Objects.equal(this.ruleFee7, that.ruleFee7) &&
				Objects.equal(this.ruleFee8, that.ruleFee8) &&
				Objects.equal(this.ruleFee9, that.ruleFee9) &&
				Objects.equal(this.ruleFee10, that.ruleFee10) &&
				Objects.equal(this.sourceId, that.sourceId) &&
				Objects.equal(this.serialVersionUID, that.serialVersionUID);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(id, name, shortName, promType, beginDate, endDate,
				loopType, ruleDiscountRate, ruleLimitBuyCount, ruleLimitBuyType, ruleFrequency,
				ruleLimitTicket, ruleGroupCount, ruleMinPay1, ruleMinPay2, ruleMinPay3,
				ruleMinPay4, ruleMinPay5, ruleMinPay6, ruleMinPay7, ruleMinPay8,
				ruleMinPay9, ruleMinPay10, ruleFee1, ruleFee2, ruleFee3,
				ruleFee4, ruleFee5, ruleFee6, ruleFee7, ruleFee8,
				ruleFee9, ruleFee10, sourceId, serialVersionUID);
	}

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this)
				.add("id", id)
				.add("name", name)
				.add("shortName", shortName)
				.add("promType", promType)
				.add("beginDate", beginDate)
				.add("endDate", endDate)
				.add("loopType", loopType)
				.add("ruleDiscountRate", ruleDiscountRate)
				.add("ruleLimitBuyCount", ruleLimitBuyCount)
				.add("ruleLimitBuyType", ruleLimitBuyType)
				.add("ruleFrequency", ruleFrequency)
				.add("ruleLimitTicket", ruleLimitTicket)
				.add("ruleGroupCount", ruleGroupCount)
				.add("ruleMinPay1", ruleMinPay1)
				.add("ruleMinPay2", ruleMinPay2)
				.add("ruleMinPay3", ruleMinPay3)
				.add("ruleMinPay4", ruleMinPay4)
				.add("ruleMinPay5", ruleMinPay5)
				.add("ruleMinPay6", ruleMinPay6)
				.add("ruleMinPay7", ruleMinPay7)
				.add("ruleMinPay8", ruleMinPay8)
				.add("ruleMinPay9", ruleMinPay9)
				.add("ruleMinPay10", ruleMinPay10)
				.add("ruleFee1", ruleFee1)
				.add("ruleFee2", ruleFee2)
				.add("ruleFee3", ruleFee3)
				.add("ruleFee4", ruleFee4)
				.add("ruleFee5", ruleFee5)
				.add("ruleFee6", ruleFee6)
				.add("ruleFee7", ruleFee7)
				.add("ruleFee8", ruleFee8)
				.add("ruleFee9", ruleFee9)
				.add("ruleFee10", ruleFee10)
				.add("sourceId", sourceId)
				.add("serialVersionUID", serialVersionUID)
				.toString();
	}
}