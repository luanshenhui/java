package cn.com.cgbchina.item.model;

import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

public class GoodsModel implements Serializable {

	private static final long serialVersionUID = 3080854346961348131L;
	@Getter
	@Setter
	private String code;// 商品编码
	@Getter
	@Setter
	private String ordertypeId;// 业务类型代码YG：广发JF：积分
	@Getter
	@Setter
	private String name;// 名称
	@Getter
	@Setter
	private Long productId;// 产品id
	@Getter
	@Setter
	private String createType;// 创建类型0平台创建1供应商创建
	@Getter
	@Setter
	private String vendorId;// 供应商id
	@Getter
	@Setter
	private String manufacturer;// 生产企业
	@Getter
	@Setter
	private Long goodsBrandId;// 品牌id
	@Getter
	@Setter
	private Long backCategory1Id;// 一级后台类目
	@Getter
	@Setter
	private Long backCategory2Id;// 二级后台类目
	@Getter
	@Setter
	private Long backCategory3Id;// 三级后台类目
	@Getter
	@Setter
	private String channelMall;// 广发商城状态0已上架1未上架
	@Getter
	@Setter
	private String channelCc;// CC状态0已上架1未上架
	@Getter
	@Setter
	private String channelMallWx;// 广发商城-微信状态0已上架1未上架
	@Getter
	@Setter
	private String channelCreditWx;// 信用卡中心-微信状态0已上架1未上架
	@Getter
	@Setter
	private String channelPhone;// 手机商城状态0已上架1未上架
	@Getter
	@Setter
	private String channelApp;// APP状态0已上架1未上架
	@Getter
	@Setter
	private String channelSms;// 短信状态0已上架1未上架
	@Getter
	@Setter
	private String channelPoints;
	@Getter
	@Setter
	private String channelIvr;
	@Getter
	@Setter
	private String goodsType;// 商品类型
	@Getter
	@Setter
	private String isInner;// 是否内宣商品0是1否
	@Getter
	@Setter
	private String mailOrderCode;// 邮购分期类别码
	@Getter
	@Setter
	private String promotionTitle;// 营销语
	@Getter
	@Setter
	private String adWord;// 商品卖点
	@Getter
	@Setter
	private String keyword;// 商品搜索关键字
	@Getter
	@Setter
	private String giftDesc;// 赠品信息
	@Getter
	@Setter
	private String introduction;// 商品描述
	@Getter
	@Setter
	private String serviceType;// 服务承诺 多个值逗号分割
	@Getter
	@Setter
	private String recommendGoods1Code;// 关联推荐商品1
	@Getter
	@Setter
	private String recommendGoods2Code;// 关联推荐商品2
	@Getter
	@Setter
	private String recommendGoods3Code;// 关联推荐商品3
	@Getter
	@Setter
	private String regionType;// 分区(礼品用)
	@Getter
	@Setter
	private String approveStatus;// 商品审核状态值00编辑中01待初审02待复审03初审拒绝04复审拒绝05待上架
	@Getter
	@Setter
	private Integer limitCount;// 限购数量
	@Getter
	@Setter
	private String pointsType;// 积分类型
	@Getter
	@Setter
	private String cards;// 第三级卡产品编码，逗号分割
	@Getter
	@Setter
	private java.util.Date onShelfMallDate;// 广发商城上架时间
	@Getter
	@Setter
	private java.util.Date offShelfMallDate;// 广发商城下架时间
	@Getter
	@Setter
	private java.util.Date onShelfCcDate;// cc上架时间
	@Getter
	@Setter
	private java.util.Date offShelfCcDate;// cc下架时间
	@Getter
	@Setter
	private java.util.Date onShelfMallWxDate;// 广发商城-微信上架时间
	@Getter
	@Setter
	private java.util.Date offShelfMallWxDate;// 广发商城-微信下架时间
	@Getter
	@Setter
	private java.util.Date onShelfCreditWxDate;// 信用卡中心-微信上架时间
	@Getter
	@Setter
	private java.util.Date offShelfCreditWxDate;// 信用卡中心-微信下架时间
	@Getter
	@Setter
	private java.util.Date onShelfPhoneDate;// 手机商城上架时间
	@Getter
	@Setter
	private java.util.Date offShelfPhoneDate;// 手机商城下架时间
	@Getter
	@Setter
	private java.util.Date onShelfAppDate;// app上架时间
	@Getter
	@Setter
	private java.util.Date offShelfAppDate;// app下架时间
	@Getter
	@Setter
	private java.util.Date onShelfSmsDate;// 短信上架时间
	@Getter
	@Setter
	private java.util.Date offShelfSmsDate;// 短信下架时间
	@Getter
	@Setter
	private String freightSize;// 商品的尺寸数据
	@Getter
	@Setter
	private String freightWeight;// 商品的重量数据
	@Getter
	@Setter
	private String approveDifferent;// 审核数据diff
	@Getter
	@Setter
	private String attribute;// 属性
	@Getter
	@Setter
	private String currType;// 币种
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标示0未删除1已删除
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
	@Getter
	@Setter
	private java.util.Date onShelfTime;// 上架时间
	@Getter
	@Setter
	private Integer eachCount;// 每种商品的个数
	@Getter
	@Setter
	private Integer installmentNumber;// 最高期数

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;

		GoodsModel that = (GoodsModel) o;

		return Objects.equal(this.code, that.code) &&
				Objects.equal(this.ordertypeId, that.ordertypeId) &&
				Objects.equal(this.name, that.name) &&
				Objects.equal(this.productId, that.productId) &&
				Objects.equal(this.createType, that.createType) &&
				Objects.equal(this.vendorId, that.vendorId) &&
				Objects.equal(this.manufacturer, that.manufacturer) &&
				Objects.equal(this.goodsBrandId, that.goodsBrandId) &&
				Objects.equal(this.backCategory1Id, that.backCategory1Id) &&
				Objects.equal(this.backCategory2Id, that.backCategory2Id) &&
				Objects.equal(this.backCategory3Id, that.backCategory3Id) &&
				Objects.equal(this.channelMall, that.channelMall) &&
				Objects.equal(this.channelCc, that.channelCc) &&
				Objects.equal(this.channelMallWx, that.channelMallWx) &&
				Objects.equal(this.channelCreditWx, that.channelCreditWx) &&
				Objects.equal(this.channelPhone, that.channelPhone) &&
				Objects.equal(this.channelApp, that.channelApp) &&
				Objects.equal(this.channelSms, that.channelSms) &&
				Objects.equal(this.goodsType, that.goodsType) &&
				Objects.equal(this.isInner, that.isInner) &&
				Objects.equal(this.mailOrderCode, that.mailOrderCode) &&
				Objects.equal(this.promotionTitle, that.promotionTitle) &&
				Objects.equal(this.adWord, that.adWord) &&
				Objects.equal(this.keyword, that.keyword) &&
				Objects.equal(this.giftDesc, that.giftDesc) &&
				Objects.equal(this.introduction, that.introduction) &&
				Objects.equal(this.serviceType, that.serviceType) &&
				Objects.equal(this.recommendGoods1Code, that.recommendGoods1Code) &&
				Objects.equal(this.recommendGoods2Code, that.recommendGoods2Code) &&
				Objects.equal(this.recommendGoods3Code, that.recommendGoods3Code) &&
				Objects.equal(this.regionType, that.regionType) &&
				Objects.equal(this.approveStatus, that.approveStatus) &&
				Objects.equal(this.limitCount, that.limitCount) &&
				Objects.equal(this.pointsType, that.pointsType) &&
				Objects.equal(this.cards, that.cards) &&
				Objects.equal(this.onShelfMallDate, that.onShelfMallDate) &&
				Objects.equal(this.offShelfMallDate, that.offShelfMallDate) &&
				Objects.equal(this.onShelfCcDate, that.onShelfCcDate) &&
				Objects.equal(this.offShelfCcDate, that.offShelfCcDate) &&
				Objects.equal(this.onShelfMallWxDate, that.onShelfMallWxDate) &&
				Objects.equal(this.offShelfMallWxDate, that.offShelfMallWxDate) &&
				Objects.equal(this.onShelfCreditWxDate, that.onShelfCreditWxDate) &&
				Objects.equal(this.offShelfCreditWxDate, that.offShelfCreditWxDate) &&
				Objects.equal(this.onShelfPhoneDate, that.onShelfPhoneDate) &&
				Objects.equal(this.offShelfPhoneDate, that.offShelfPhoneDate) &&
				Objects.equal(this.onShelfAppDate, that.onShelfAppDate) &&
				Objects.equal(this.offShelfAppDate, that.offShelfAppDate) &&
				Objects.equal(this.onShelfSmsDate, that.onShelfSmsDate) &&
				Objects.equal(this.offShelfSmsDate, that.offShelfSmsDate) &&
				Objects.equal(this.freightSize, that.freightSize) &&
				Objects.equal(this.freightWeight, that.freightWeight) &&
				Objects.equal(this.approveDifferent, that.approveDifferent) &&
				Objects.equal(this.attribute, that.attribute) &&
				Objects.equal(this.currType, that.currType) &&
				Objects.equal(this.delFlag, that.delFlag) &&
				Objects.equal(this.createOper, that.createOper) &&
				Objects.equal(this.createTime, that.createTime) &&
				Objects.equal(this.modifyOper, that.modifyOper) &&
				Objects.equal(this.modifyTime, that.modifyTime) &&
				Objects.equal(this.onShelfTime, that.onShelfTime) &&
				Objects.equal(this.eachCount, that.eachCount);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(code, ordertypeId, name, productId, createType, vendorId,
				manufacturer, goodsBrandId, backCategory1Id, backCategory2Id, backCategory3Id,
				channelMall, channelCc, channelMallWx, channelCreditWx, channelPhone,
				channelApp, channelSms, goodsType, isInner, mailOrderCode,
				promotionTitle, adWord, keyword, giftDesc, introduction,
				serviceType, recommendGoods1Code, recommendGoods2Code, recommendGoods3Code, regionType,
				approveStatus, limitCount, pointsType, cards, onShelfMallDate,
				offShelfMallDate, onShelfCcDate, offShelfCcDate, onShelfMallWxDate, offShelfMallWxDate,
				onShelfCreditWxDate, offShelfCreditWxDate, onShelfPhoneDate, offShelfPhoneDate, onShelfAppDate,
				offShelfAppDate, onShelfSmsDate, offShelfSmsDate, freightSize, freightWeight,
				approveDifferent, attribute, currType, delFlag, createOper,
				createTime, modifyOper, modifyTime, onShelfTime, eachCount);
	}

	@Override
	public String toString() {
		return Objects.toStringHelper(this)
				.add("code", code)
				.add("ordertypeId", ordertypeId)
				.add("name", name)
				.add("productId", productId)
				.add("createType", createType)
				.add("vendorId", vendorId)
				.add("manufacturer", manufacturer)
				.add("goodsBrandId", goodsBrandId)
				.add("backCategory1Id", backCategory1Id)
				.add("backCategory2Id", backCategory2Id)
				.add("backCategory3Id", backCategory3Id)
				.add("channelMall", channelMall)
				.add("channelCc", channelCc)
				.add("channelMallWx", channelMallWx)
				.add("channelCreditWx", channelCreditWx)
				.add("channelPhone", channelPhone)
				.add("channelApp", channelApp)
				.add("channelSms", channelSms)
				.add("goodsType", goodsType)
				.add("isInner", isInner)
				.add("mailOrderCode", mailOrderCode)
				.add("promotionTitle", promotionTitle)
				.add("adWord", adWord)
				.add("keyword", keyword)
				.add("giftDesc", giftDesc)
				.add("introduction", introduction)
				.add("serviceType", serviceType)
				.add("recommendGoods1Code", recommendGoods1Code)
				.add("recommendGoods2Code", recommendGoods2Code)
				.add("recommendGoods3Code", recommendGoods3Code)
				.add("regionType", regionType)
				.add("approveStatus", approveStatus)
				.add("limitCount", limitCount)
				.add("pointsType", pointsType)
				.add("cards", cards)
				.add("onShelfMallDate", onShelfMallDate)
				.add("offShelfMallDate", offShelfMallDate)
				.add("onShelfCcDate", onShelfCcDate)
				.add("offShelfCcDate", offShelfCcDate)
				.add("onShelfMallWxDate", onShelfMallWxDate)
				.add("offShelfMallWxDate", offShelfMallWxDate)
				.add("onShelfCreditWxDate", onShelfCreditWxDate)
				.add("offShelfCreditWxDate", offShelfCreditWxDate)
				.add("onShelfPhoneDate", onShelfPhoneDate)
				.add("offShelfPhoneDate", offShelfPhoneDate)
				.add("onShelfAppDate", onShelfAppDate)
				.add("offShelfAppDate", offShelfAppDate)
				.add("onShelfSmsDate", onShelfSmsDate)
				.add("offShelfSmsDate", offShelfSmsDate)
				.add("freightSize", freightSize)
				.add("freightWeight", freightWeight)
				.add("approveDifferent", approveDifferent)
				.add("attribute", attribute)
				.add("currType", currType)
				.add("delFlag", delFlag)
				.add("createOper", createOper)
				.add("createTime", createTime)
				.add("modifyOper", modifyOper)
				.add("modifyTime", modifyTime)
				.add("onShelfTime", onShelfTime)
				.add("eachCount", eachCount)
				.toString();
	}
}