package cn.com.cgbchina.item.model;

import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

public class Goods implements Serializable {


	private static final long serialVersionUID = 55440913585165112L;
	@Getter
	@Setter
	private String goodsId;// 商品编码
	@Getter
	@Setter
	private String goodsPid;// 业务类型代码YG：广发JF：积分
	@Getter
	@Setter
	private String goodsMid;// 名称
	@Getter
	@Setter
	private String goodsOid;// 产品id
	@Getter
	@Setter
	private String goodsXid;// 创建类型0平台创建1供应商创建
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
	private String goodsType;// 商品类型
	@Getter
	@Setter
	private String isInner;// 是否内宣商品0是1否
	@Getter
	@Setter
	private Integer installmentNumber;// 最高期数
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
	private Date onShelfMallDate;// 广发商城上架时间
	@Getter
	@Setter
	private Date offShelfMallDate;// 广发商城下架时间
	@Getter
	@Setter
	private Date onShelfCcDate;// cc上架时间
	@Getter
	@Setter
	private Date offShelfCcDate;// cc下架时间
	@Getter
	@Setter
	private Date onShelfMallWxDate;// 广发商城-微信上架时间
	@Getter
	@Setter
	private Date offShelfMallWxDate;// 广发商城-微信下架时间
	@Getter
	@Setter
	private Date onShelfCreditWxDate;// 信用卡中心-微信上架时间
	@Getter
	@Setter
	private Date offShelfCreditWxDate;// 信用卡中心-微信下架时间
	@Getter
	@Setter
	private Date onShelfPhoneDate;// 手机商城上架时间
	@Getter
	@Setter
	private Date offShelfPhoneDate;// 手机商城下架时间
	@Getter
	@Setter
	private Date onShelfAppDate;// app上架时间
	@Getter
	@Setter
	private Date offShelfAppDate;// app下架时间
	@Getter
	@Setter
	private Date onShelfSmsDate;// 短信上架时间
	@Getter
	@Setter
	private Date offShelfSmsDate;// 短信下架时间
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
	private Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 修改者
	@Getter
	@Setter
	private Date modifyTime;// 修改时间
	@Getter
	@Setter
	private Date onShelfTime;// 上架时间
	@Getter
	@Setter
	private Integer eachCount;// 每种商品的个数
	@Getter
	@Setter
	private BigDecimal minPrice;// 最小售价
	@Getter
	@Setter
	private BigDecimal maxPrice;// 最大售价

}