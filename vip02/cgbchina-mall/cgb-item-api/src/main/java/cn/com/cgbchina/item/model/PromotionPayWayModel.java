package cn.com.cgbchina.item.model;

import java.io.Serializable;

import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;

import lombok.Getter;
import lombok.Setter;

public class PromotionPayWayModel implements Serializable {

	private static final long serialVersionUID = -7561937286975774580L;
	@Getter
	@Setter
	private Long id;
	@Getter
	@Setter
	private String goodsPaywayId;// 活动支付编码
	@Getter
	@Setter
	private String goodsId;// 单品编码
	@Getter
	@Setter
	private String promId;// 活动ID
	@Getter
	@Setter
	private Integer promType;// 活动类型 10 折扣 20 满减 30 秒杀 40 团购 50 荷兰拍
	@Getter
	@Setter
	private String paywayCode;// 支付方式代码
	@Getter
	@Setter
	private String payType;// 佣金代码
	@Getter
	@Setter
	private Long incCode;// 手续费率代码
	@Getter
	@Setter
	private Integer stagesCode;// 分期方式代码
	@Getter
	@Setter
	private String ruleId;// 商品应用规则id
	@Getter
	@Setter
	private String authFlat1;// 限制1
	@Getter
	@Setter
	private String authFlat2;// 限制2
	@Getter
	@Setter
	private java.math.BigDecimal perStage;// 每期
	@Getter
	@Setter
	private String stagesFlagCash;// 是否支持分期[现金]（无用）
	@Getter
	@Setter
	private String stagesFlagPoint;// 是否支持分期[积分]（无用）
	@Getter
	@Setter
	private String stagesFlagInc;// 是否支持分期[手续费]
	@Getter
	@Setter
	private Long goodsPoint;// 积分数量
	@Getter
	@Setter
	private String memberLevel;// 会员等级(0000 金普,0001 钛金/臻享白金,0002 顶级/增值白金,0003 VIP,0004 生日,0005 积分+现金)
	@Getter
	@Setter
	private java.math.BigDecimal goodsPrice;// 现金
	@Getter
	@Setter
	private java.math.BigDecimal calMoney;// 清算金额
	@Getter
	@Setter
	private String goodsPaywayDesc;// 备注
	@Getter
	@Setter
	private String ischeck;// 状态 00编辑中 01待初审 02待复审 03商品变更审核 04价格变更审核 05下架申请审核 06审核通过 07待定价 08定价审核 70初审拒绝 71复审拒绝
							// 72商品变更审核拒绝 73 价格变更审核拒绝 74下架申请审核拒绝 75定价审核拒绝 d 删除
	@Getter
	@Setter
	private String curStatus;// 当前状态(0101：未启用，0102：已启用)
	@Getter
	@Setter
	private String categoryNo;// 分期费率码
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 修改人
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
	@Getter
	@Setter
	private String reserved1;// 保留字段

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		PromotionPayWayModel that = (PromotionPayWayModel) o;

		return Objects.equal(this.goodsPaywayId, that.goodsPaywayId) && Objects.equal(this.goodsId, that.goodsId)
				&& Objects.equal(this.promId, that.promId) && Objects.equal(this.promType, that.promType)
				&& Objects.equal(this.paywayCode, that.paywayCode) && Objects.equal(this.payType, that.payType)
				&& Objects.equal(this.incCode, that.incCode) && Objects.equal(this.stagesCode, that.stagesCode)
				&& Objects.equal(this.ruleId, that.ruleId) && Objects.equal(this.authFlat1, that.authFlat1)
				&& Objects.equal(this.authFlat2, that.authFlat2) && Objects.equal(this.perStage, that.perStage)
				&& Objects.equal(this.stagesFlagCash, that.stagesFlagCash)
				&& Objects.equal(this.stagesFlagPoint, that.stagesFlagPoint)
				&& Objects.equal(this.stagesFlagInc, that.stagesFlagInc)
				&& Objects.equal(this.goodsPoint, that.goodsPoint) && Objects.equal(this.memberLevel, that.memberLevel)
				&& Objects.equal(this.goodsPrice, that.goodsPrice) && Objects.equal(this.calMoney, that.calMoney)
				&& Objects.equal(this.goodsPaywayDesc, that.goodsPaywayDesc)
				&& Objects.equal(this.ischeck, that.ischeck) && Objects.equal(this.curStatus, that.curStatus)
				&& Objects.equal(this.categoryNo, that.categoryNo) && Objects.equal(this.createOper, that.createOper)
				&& Objects.equal(this.createTime, that.createTime) && Objects.equal(this.modifyOper, that.modifyOper)
				&& Objects.equal(this.modifyTime, that.modifyTime) && Objects.equal(this.reserved1, that.reserved1);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(goodsPaywayId, goodsId, promId, promType, paywayCode, payType, incCode, stagesCode,
				ruleId, authFlat1, authFlat2, perStage, stagesFlagCash, stagesFlagPoint, stagesFlagInc, goodsPoint,
				memberLevel, goodsPrice, calMoney, goodsPaywayDesc, ischeck, curStatus, categoryNo, createOper,
				createTime, modifyOper, modifyTime, reserved1);
	}

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("goodsPaywayId", goodsPaywayId).add("goodsId", goodsId)
				.add("promId", promId).add("promType", promType).add("paywayCode", paywayCode).add("payType", payType)
				.add("incCode", incCode).add("stagesCode", stagesCode).add("ruleId", ruleId).add("authFlat1", authFlat1)
				.add("authFlat2", authFlat2).add("perStage", perStage).add("stagesFlagCash", stagesFlagCash)
				.add("stagesFlagPoint", stagesFlagPoint).add("stagesFlagInc", stagesFlagInc)
				.add("goodsPoint", goodsPoint).add("memberLevel", memberLevel).add("goodsPrice", goodsPrice)
				.add("calMoney", calMoney).add("goodsPaywayDesc", goodsPaywayDesc).add("ischeck", ischeck)
				.add("curStatus", curStatus).add("categoryNo", categoryNo).add("createOper", createOper)
				.add("createTime", createTime).add("modifyOper", modifyOper).add("modifyTime", modifyTime)
				.add("reserved1", reserved1).toString();
	}
}