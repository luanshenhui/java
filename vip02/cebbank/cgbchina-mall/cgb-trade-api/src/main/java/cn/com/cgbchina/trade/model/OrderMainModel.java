package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

public class OrderMainModel implements Serializable {

	private static final long serialVersionUID = 4470038849410789411L;
	@Getter
	@Setter
	private String ordermainId;// 主订单号8位日期+2为渠道代码+6位流水号如：2012032801000001
	@Getter
	@Setter
	private String ordertypeId;// 业务类型idyg:广发商城(一期)jf:积分商城fq:广发商城(分期)
	@Getter
	@Setter
	private String ordertypeNm;// 业务类型名称
	@Getter
	@Setter
	private String cardno;// 卡号
	@Getter
	@Setter
	private String sourceId;// 订单来源渠道id00: 商城01: callcenter02: ivr渠道03: 手机商城
	@Getter
	@Setter
	private String sourceNm;// 订单来源渠道名称
	@Getter
	@Setter
	private String source2Id;// 业务渠道代码00: 商城01: callcenter02: ivr渠道03: 手机商城
	@Getter
	@Setter
	private String source2Nm;// 业务渠道名称
	@Getter
	@Setter
	private Integer totalNum;// 商品总数量
	@Getter
	@Setter
	private java.math.BigDecimal totalPrice;// 商品总价格
	@Getter
	@Setter
	private Long totalBonus;// 商品总积分数量
	@Getter
	@Setter
	private java.math.BigDecimal promotDiscount;// 活动优惠总额
	@Getter
	@Setter
	private java.math.BigDecimal bonusDiscount;// 积分抵扣总额
	@Getter
	@Setter
	private java.math.BigDecimal voucherDiscount;// 优惠卷使用总额
	@Getter
	@Setter
	private java.math.BigDecimal paymentAmount;// 支付总金额
	@Getter
	@Setter
	private String isInvoice;// 是否开发票0-否，1-是
	@Getter
	@Setter
	private String invoice;// 发票抬头
	@Getter
	@Setter
	private String invoiceContent;// 发票内容
	@Getter
	@Setter
	private String bpCustGrp;// 送货时间01: 工作日、双休日与假日均可送货02: 只有工作日送货（双休日、假日不用送）03: 只有双休日、假日送货（工作日不用送货）
	@Getter
	@Setter
	private String csgName;// 收货人姓名
	@Getter
	@Setter
	private String csgIdType;// 收货人证件类型
	@Getter
	@Setter
	private String csgIdcard;// 收货人证件号码
	@Getter
	@Setter
	private String csgPostcode;// 收货人邮政编码
	@Getter
	@Setter
	private String csgAddress;// 收货人详细地址
	@Getter
	@Setter
	private String csgPhone1;// 收货人电话一
	@Getter
	@Setter
	private String csgPhone2;// 收货人电话二
	@Getter
	@Setter
	private String ordermainDesc;// 订单主表备注
	@Getter
	@Setter
	private java.math.BigDecimal permLimit;// 永久额度（默认0）
	@Getter
	@Setter
	private java.math.BigDecimal cashLimit;// 取现额度（默认0）
	@Getter
	@Setter
	private java.math.BigDecimal stagesLimit;// 分期额度（默认0）
	@Getter
	@Setter
	private String cardUserid;// 持卡人代码
	@Getter
	@Setter
	private String contIdType;// 订货人证件类型
	@Getter
	@Setter
	private String contIdcard;// 订货人证件号码
	@Getter
	@Setter
	private String contNm;// 订货人姓名
	@Getter
	@Setter
	private String contNmPy;// 订货人姓名拼音
	@Getter
	@Setter
	private String contPostcode;// 订货人邮政编码
	@Getter
	@Setter
	private String contAddress;// 订货人详细地址
	@Getter
	@Setter
	private String contMobPhone;// 订货人手机
	@Getter
	@Setter
	private String contHphone;// 订货人家里电话
	@Getter
	@Setter
	private String expDate;// 有效期
	@Getter
	@Setter
	private String foreAccdate;// 最近一期账单日
	@Getter
	@Setter
	private String cardtypeId;// 所属卡类型c -普卡g -金卡p -白金卡
	@Getter
	@Setter
	private String pdtNbr;// 卡类
	@Getter
	@Setter
	private String formatId;// 卡板
	@Getter
	@Setter
	private java.math.BigDecimal totalIncPrice;// 商品总手续费价格（无用）
	@Getter
	@Setter
	private String stateCode;// 当前原因代码（废单或联系不上-预订单）
	@Getter
	@Setter
	private String stateNm;// 当前原因名称
	@Getter
	@Setter
	private String lockedFlag;// 订单锁标记（锁住订单，订单成功后解锁，解锁才能退货）判支付网关是否重复提结果给商城的标识未0或空-没有收到过支付关结果1-已经收到过支付网关结果
	@Getter
	@Setter
	private String curStatusId;// 当前状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
	@Getter
	@Setter
	private String curStatusNm;// 当前状态名称
	@Getter
	@Setter
	private String createOper;// 创建操作员id
	@Getter
	@Setter
	private String modifyOper;// 修改操作员
	@Getter
	@Setter
	private String commDate;// 业务日期
	@Getter
	@Setter
	private String commTime;// 业务时间
	@Getter
	@Setter
	private String reserved1;// 保留字段
	@Getter
	@Setter
	private String custFlag;// 客户标志（未用）
	@Getter
	@Setter
	private String vipFlag;// vip标志（未用）
	@Getter
	@Setter
	private String acctAddFlag;// 收货地址是否是帐单地址0-否1-是
	@Getter
	@Setter
	private String custSex;// 客户性别
	@Getter
	@Setter
	private String psFlag;// 是否已将订单推送至物流商系统0或空代表未推送1代表已推送至物流商系统
	@Getter
	@Setter
	private String custEmail;// 客户email
	@Getter
	@Setter
	private String custBirthday;// 客户生日
	@Getter
	@Setter
	private String expDate2;//
	@Getter
	@Setter
	private Integer versionNum;//
	@Getter
	@Setter
	private String orgCode;//
	@Getter
	@Setter
	private String orgNm;//
	@Getter
	@Setter
	private String orgLevel;//
	@Getter
	@Setter
	private String csgProvince;// 省
	@Getter
	@Setter
	private String csgCity;// 市
	@Getter
	@Setter
	private String csgBorough;// 区
	@Getter
	@Setter
	private String acceptedNo;// 受理号
	@Getter
	@Setter
	private String serialNo;// 流水号
	@Getter
	@Setter
	private String eUpdateStatus;// 订单状态是否与企业网银更新
	@Getter
	@Setter
	private String ismerge;//
	@Getter
	@Setter
	private String integraltypeId;// 积分类型id
	@Getter
	@Setter
	private String defraytype;//
	@Getter
	@Setter
	private String merId;// 商户号
	@Getter
	@Setter
	private String errorCode;// 错误码
	@Getter
	@Setter
	private String checkStatus;// 对账成功标识
	@Getter
	@Setter
	private String payResultTime;// 支付结果时间
	@Getter
	@Setter
	private String desc1;//
	@Getter
	@Setter
	private String desc2;//
	@Getter
	@Setter
	private String desc3;//
	@Getter
	@Setter
	private String referenceNo;//
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private java.util.Date modifyTime;// 更新时间
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标记为(0未删除，1已删除)
}