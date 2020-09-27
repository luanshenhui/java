package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Created by 张成 on 16-6-27.
 */
public class TblOrder implements Serializable {

    private static final long serialVersionUID = 2991841250878635443L;

    @Setter
    private String orderId;// 子订单号为：主订单号+2位顺序号如：201203280100000101一个主订单支持最多99个子订单
    @Getter
    @Setter
    private String ordermainId;// 主订单号
    @Getter
    @Setter
    private Integer operSeq;// 业务订单同步序号和电子商务保持一致默认0
    @Getter
    @Setter
    private String ordertypeId;// 业务类型代码YG:广发商城(一期)JF:积分商城FQ:广发商城(分期)
    @Getter
    @Setter
    private String ordertypeNm;// 业务类型名称
    @Getter
    @Setter
    private String paywayCode;// 支付方式代码0001: 现金0002: 积分0003: 积分+现金0004: 手续费0005: 现金+手续费0006: 积分+手续费0007: 积分+现金+手续费
    @Getter
    @Setter
    private String paywayNm;// 支付方式名称
    @Getter
    @Setter
    private String cardno;// 卡号
    @Getter
    @Setter
    private String verifyFlag;// 下单验证标记
    @Getter
    @Setter
    private String vendorId;// 供应商代码
    @Getter
    @Setter
    private String vendorSnm;// 供应商名称简写
    @Getter
    @Setter
    private String sourceId;// 渠道代码00: 商城01: CallCenter02: IVR渠道03: 手机商城04: 短信渠道05: 微信广发银行06：微信广发信用卡
    @Getter
    @Setter
    private String sourceNm;// 渠道名称
    @Getter
    @Setter
    private String otSourceId;// 业务渠道代码
    @Getter
    @Setter
    private String otSourceNm;// 业务渠道名称
    @Getter
    @Setter
    private String goodsId;// 商（单）品代码
    @Getter
    @Setter
    private String bankNbr;// 银行号
    @Getter
    @Setter
    private Long bonusTotalvalue;// 积分总数
    @Getter
    @Setter
    private java.math.BigDecimal calMoney;// 清算总金额
    @Getter
    @Setter
    private java.math.BigDecimal origMoney;// 原始现金总金额(未用)
    @Getter
    @Setter
    private java.math.BigDecimal totalMoney;// 现金总金额
    @Getter
    @Setter
    private String actType;// 活动类型-团购秒杀标志1-团购2-秒杀
    @Getter
    @Setter
    private String voucherId;// 优惠券代码
    @Getter
    @Setter
    private String voucherNm;// 优惠券名称
    @Getter
    @Setter
    private java.math.BigDecimal voucherPrice;// 优惠金额
    @Getter
    @Setter
    private String voucherNo;// 优惠券编码
    @Getter
    @Setter
    private String actId;// 活动id
    @Getter
    @Setter
    private String acctNo;// 账户号码
    @Getter
    @Setter
    private java.math.BigDecimal singlePrice;// 单个商品对应的价格
    @Getter
    @Setter
    private Long singleBonus;// 单个商品对应的积分
    @Getter
    @Setter
    private String bonusType;// 积分类型
    @Getter
    @Setter
    private String bonusTypeNm;// 积分类型名称
    @Getter
    @Setter
    private String goodsType;// 商品类型（00实物01虚拟02O2O）
    @Getter
    @Setter
    private String goodsTypeName;// 商品类型
    @Getter
    @Setter
    private String isTieinSale;// 是否搭销1是，其余不是搭销
    @Getter
    @Setter
    private String balanceStatus;// 结算状态积分商城为结算状态：0000--结算成功0001--结算失败广发商城为搭销状态订单：0000--待处理0001--处理中0002--已完成0003--已拒绝0004--已撤销
    @Getter
    @Setter
    private String batchNo;// 批次号
    @Getter
    @Setter
    private String eUpdateStatus;// 通知入账标识位否已经通知电子支付平台入账的标识位 0:初始1:成功通知入账 2:通知入账出错
    @Getter
    @Setter
    private String orderDesc;// 订单表备注
    @Getter
    @Setter
    private String cardnoBenefit;// 受益卡号
    @Getter
    @Setter
    private String validateCode;// 验证码
    @Getter
    @Setter
    private String goodsPaywayId;// 商品支付编码
    @Getter
    @Setter
    private Integer goodsNum;// 商品数量
    @Getter
    @Setter
    private String goodsNm;// 商品名称
    @Getter
    @Setter
    private String machCode;// 商品条行码
    @Getter
    @Setter
    private String currType;// 商品币种
    @Getter
    @Setter
    private java.math.BigDecimal exchangeRate;// 对人民币的汇率值
    @Getter
    @Setter
    private String typeId;// 商品类别id
    @Getter
    @Setter
    private String levelNm;// 商品类别名称
    @Getter
    @Setter
    private String goodsBrand;// 品牌
    @Getter
    @Setter
    private String goodsModel;// 型号
    @Getter
    @Setter
    private String goodsColor;// 商品颜色
    @Getter
    @Setter
    private String goodsPresent;// 赠品
    @Getter
    @Setter
    private String goodsPresentDesc;// 赠品说明
    @Getter
    @Setter
    private String specFlag;// 是否特选商品(未用)1-是0-否
    @Getter
    @Setter
    private String specDesc;// 特别备注信息
    @Getter
    @Setter
    private String goodsRange;// 送货范围
    @Getter
    @Setter
    private String goodsLocal;// 是否现场兑换(未用)0－否1－是
    @Getter
    @Setter
    private String goodssendFlag;// 发货标记0－未发货[默认]1－已发货2－已签收
    @Getter
    @Setter
    private String goodsaskforFlag;// 请款标记0－未请款[默认]1－已请款
    @Getter
    @Setter
    private String goodsBill;// 商品账单描述
    @Getter
    @Setter
    private String goodsDesc;//
    @Getter
    @Setter
    private String goodsResv1;// 商品备注
    @Getter
    @Setter
    private String specShopnoType;// 退货流转标志0:流转到合作商 1:流转到商城后台
    @Getter
    @Setter
    private String payType;// 佣金代码(未用)
    @Getter
    @Setter
    private String payTypeNm;// 佣金代码名称
    @Getter
    @Setter
    private String incCode;// 手续费率代码(未用)
    @Getter
    @Setter
    private String incCodeNm;// 手续费率名称
    @Getter
    @Setter
    private Integer stagesNum;// 现金[或积分]分期数
    @Getter
    @Setter
    private String commissionType;// 佣金计算类别(未用)
    @Getter
    @Setter
    private java.math.BigDecimal commissionRate;// 佣金区间佣金率(不包含%)
    @Getter
    @Setter
    private java.math.BigDecimal commission;// 佣金金额【与币种一致】
    @Getter
    @Setter
    private String specShopno;// 特店号邮购分期费率类别码
    @Getter
    @Setter
    private String bonusBankNbr;// 积分银行号
    @Getter
    @Setter
    private String bonusSpecShopno;// 积分特店号
    @Getter
    @Setter
    private String payCode;// 缴款方案代码(未用)
    @Getter
    @Setter
    private String prodCode;// 分期产品代码(未用)
    @Getter
    @Setter
    private String planCode;// 分期计划代码(未用)
    @Getter
    @Setter
    private String stagesDesc;// 分期描述
    @Getter
    @Setter
    private String mcc;// mcc号
    @Getter
    @Setter
    private String incWay;// 手续费获取方式00－无手续费01－电子商务获取02－业务系统获取
    @Getter
    @Setter
    private String incTakeWay;// 手续费计算方式0：一次收取（与商品数量无关）1：按商品数量收取(按商品数量收取)
    @Getter
    @Setter
    private String incType;// 手续费类别00-无手续费01-固定手续费金额02-固定手续费率03-手续费率范围区间
    @Getter
    @Setter
    private java.math.BigDecimal incRate;// 手续费率(不包含%)(未用)
    @Getter
    @Setter
    private java.math.BigDecimal incMoney;// 手续费总金额(未用)如：手续费正常应收100，又减免了20，这里记录100
    @Getter
    @Setter
    private String incDesc;// 手续费描述(未用)
    @Getter
    @Setter
    private String uitopsfee;// 手续费收取方式(未用)F：一次性收取I：分期收取（即：手续费分期）
    @Getter
    @Setter
    private Integer uitfeeflg;// 手续费减免期数(未用)
    @Getter
    @Setter
    private java.math.BigDecimal uitfeedam;// 手续费减免金额(未用)
    @Getter
    @Setter
    private String uitopsdate;// 分期开始日期(未用)
    @Getter
    @Setter
    private Integer uitdrtuit;// 本金减免期数(未用)
    @Getter
    @Setter
    private java.math.BigDecimal uitdrtamt;// 本金减免金额(未用)
    @Getter
    @Setter
    private String incBackway;// 手续费退回方式(未用)
    @Getter
    @Setter
    private java.math.BigDecimal incBackPrice;// 手续费退回指定金额(未用)
    @Getter
    @Setter
    private java.math.BigDecimal incTakePrice;// 退单时收取指定金额手续费(未用)
    @Getter
    @Setter
    private String creditFlag;// 授权额度不足处理方式--是否转信贷0－不转信贷1－转信贷
    @Getter
    @Setter
    private String cashAuthType;// 现金授权类型分期订单电子支付是否已经验证标识null或’’:电子支付平台未验证1:电子支付平台已验证
    @Getter
    @Setter
    private String accreditDate;// 授权日期
    @Getter
    @Setter
    private String accreditTime;// 授权时间
    @Getter
    @Setter
    private String authCode;// 授权码
    @Getter
    @Setter
    private String rtnCode;// 主机授权回应代码
    @Getter
    @Setter
    private String rtnDesc;// 主机授权回应代码说明
    @Getter
    @Setter
    private String txnMsg1Desc;// 通讯消息说明1
    @Getter
    @Setter
    private String txnMsg2Desc;// 通讯消息说明2
    @Getter
    @Setter
    private String hostAccCode;// 主机入账回应代码
    @Getter
    @Setter
    private String hostAccDesc;// 主机入账回应代码说明
    @Getter
    @Setter
    private String bonusTrnDate;// 支付日期
    @Getter
    @Setter
    private String bonusTrnTime;// 支付时间
    @Getter
    @Setter
    private String bonusTraceNo;// 系统跟踪号
    @Getter
    @Setter
    private String bonusAuthType;// 积分授权类型
    @Getter
    @Setter
    private String bonusAccreditDate;// bonus授权日期
    @Getter
    @Setter
    private String bonusAccreditTime;// bonus授权时间
    @Getter
    @Setter
    private String bonusAuthCode;// bonus授权码
    @Getter
    @Setter
    private String bonusRtnCode;// bonus主机授权回应代码
    @Getter
    @Setter
    private String bonusRtnDesc;// bonus主机授权回应代码说明
    @Getter
    @Setter
    private String bonusTxnMsgDesc;// bonus通讯消息说明
    @Getter
    @Setter
    private String calWay;// 退货方式0-直接退货1-提交退货处理
    @Getter
    @Setter
    private String lockedFlag;// 订单锁标记0-未加锁1-加锁
    @Getter
    @Setter
    private String vendorOperFlag;// 供应商操作标记0－未操作1－操作过
    @Getter
    @Setter
    private String msgContent;// 上行短信内容
    @Getter
    @Setter
    private String tmpStatusId;// 临时状态代码0000－正常状态(默认状态)****－处理中状态
    @Getter
    @Setter
    private String curStatusId;// 当前状态代码-订单状态0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
    @Getter
    @Setter
    private String curStatusNm;// 当前状态名称
    @Getter
    @Setter
    private String sinStatusId;// 请款状态代码0332--请款申请0350--同意请款0351--请款中0311--请款成功0333--拒绝请款0352--请款失败
    @Getter
    @Setter
    private String sinStatusNm;// 请款状态名称
    @Getter
    @Setter
    private String createOper;// 创建操作员id
    @Getter
    @Setter
    private String modifyOper;// 修改操作员id
    @Getter
    @Setter
    private String commDate;// 业务日期
    @Getter
    @Setter
    private String commTime;// 业务时间
    @Getter
    @Setter
    private Integer versionNum;// 记录更新控制版本号
    @Getter
    @Setter
    private String ext1;// 扩展属性一人为撤单标识 0是人为，1为非人为
    @Getter
    @Setter
    private String ext2;// 分期为biu的分期代码
    @Getter
    @Setter
    private String ext3;// 撤单是否生产报表标识位01-生成报表, 02-不生成报表
    @Getter
    @Setter
    private String reserved1;// 商户号(发给清算系统的)
    @Getter
    @Setter
    private String ruleId;// 规则id
    @Getter
    @Setter
    private String ruleNm;// 规则名称
    @Getter
    @Setter
    private String limitCode;// 规则限制代码
    @Getter
    @Setter
    private String custType;// 客户类型(未用)
    @Getter
    @Setter
    private String accreditType;// 授权类型
    @Getter
    @Setter
    private String appFlag;// 随意借业务使用(未用)
    @Getter
    @Setter
    private String cashTraceNo1;// 现金交易流水号1(转出卡号) (未用)
    @Getter
    @Setter
    private String cashTraceNo2;// 现金交易流水号2(转入卡号) (未用)
    @Getter
    @Setter
    private String bankNbr2;// 银行号[卡号2] (未用)
    @Getter
    @Setter
    private String specShopno2;// 特店号[卡号2] (未用)
    @Getter
    @Setter
    private String accreditDate2;// 授权日期[卡号2] (未用)
    @Getter
    @Setter
    private String accreditTime2;// 授权时间[卡号2] (未用)
    @Getter
    @Setter
    private String authCode2;// 授权码[卡号2] (未用)
    @Getter
    @Setter
    private String actCategory;// 活动种类(未用)
    @Getter
    @Setter
    private String actName;// 活动名称
    @Getter
    @Setter
    private String userAsscNbr;// 会员号码
    @Getter
    @Setter
    private String vendorPhone;// 合作商电话
    @Getter
    @Setter
    private String dfacct;//
    @Getter
    @Setter
    private String dfname;//
    @Getter
    @Setter
    private String dfhnbr;//
    @Getter
    @Setter
    private String dfhname;//
    @Getter
    @Setter
    private String cvv2;//
    @Getter
    @Setter
    private String logisticsSynFlag;//
    @Getter
    @Setter
    private String memberLevel;// 价格等级id0000: 金普卡类型0001: 顶级/增值白金类型0002: vip类型0003: 生日类型0004: 积分+现金类型
    @Getter
    @Setter
    private String integraltypeId;// 积分类型id
    @Getter
    @Setter
    private String merId;// 商户号
    @Getter
    @Setter
    private String errorCode;// 错误码
    @Getter
    @Setter
    private String cardtype;// 卡标志C：信用卡Y：借记卡
    @Getter
    @Setter
    private String receiver;// 签收人
    @Getter
    @Setter
    private java.util.Date receivedTime;// 签收时间
    @Getter
    @Setter
    private String custCartId;// 此订单对应的购物车id
    @Getter
    @Setter
    private Integer miaoshaActionFlag;// 商品活动标志
    @Getter
    @Setter
    private String delFlag;// 逻辑删除标志0未删1已删
    @Getter
    @Setter
    private String goodsAttr1;// 销售属性（json串）
    @Getter
    @Setter
    private String goodsAttr2;//
    @Getter
    @Setter
    private String referenceNo;//
    @Getter
    @Setter
    private String orderIdHost;//
    @Getter
    @Setter
    private java.util.Date createTime;// 创建时间
    @Getter
    @Setter
    private java.util.Date modifyTime;// 更新时间
    @Getter
    @Setter
    private java.math.BigDecimal installmentPrice;// 分期价格
    @Getter
    @Setter
    private String memberName;// 会员名称
    @Getter
    @Setter
    private java.util.Date firstRemindeTime;// 首次催单时间
    @Getter
    @Setter
    private Integer remindeTimes;// 催单次数
    @Getter
    @Setter
    private String o2oVoucherCode;// o2o商品兑换码
    @Getter
    @Setter
    private String itemSmallPic;// 单品小图标
    @Getter
    @Setter
    private String saleAfterStatus;// 售后状态0334--退货申请0327--退货成功0335--拒绝退货申请0312--已撤单
    @Getter
    @Setter
    private java.math.BigDecimal bonusPrice;// 积分抵扣金额
    @Getter
    @Setter
    private String payCount;// 待付款的订单
    @Getter
    @Setter
    private String deliverCount;// 待发货的订单
    @Getter
    @Setter
    private String signCount;// 待签收的订单
    @Getter
    @Setter
    private String requestCount;// 待请款的订单
    @Getter
    @Setter
    private String disposeCount;// 待处理的退货
    @Getter
    @Setter
    private String eachCount;// 每种订单的个数
    @Getter
    @Setter
    private String orderCount;// 热门交易TOP10交易数
    @Getter
    @Setter
    private String personCount;// 热门交易TOP10交易数
    @Getter
    @Setter
    private String tieinSaleMemo;// 搭销审核意见
    @Getter
    @Setter
    private String sinApplyMemo;// 请款审核意见
    /** default constructor */
    public TblOrder() {
    }

    /** minimal constructor */
    public TblOrder(String orderId, Integer operSeq, String ordertypeId, String ordertypeNm, String paywayCode, String paywayNm, String ordermainId, String cardno, String verifyFlag, String vendorId, String vendorSnm, String sourceId, String sourceNm, String goodsId, String goodsPaywayId, Integer goodsNum, String goodsNm, String currType, Double exchangeRate, String goodssendFlag, String goodsaskforFlag, String specShopnoType, String payType, String payTypeNm, String incCode, String incCodeNm, Short stagesNum, String commissionType, Double commissionRate, Double commission, Long bonusTotalvalue, Double calMoney, Double origMoney, Double totalMoney, String incWay, Double incRate, Double incMoney, Short uitfeeflg, Double uitfeedam, Short uitdrtuit, BigDecimal uitdrtamt, Double incBackPrice, Double incTakePrice, BigDecimal voucherPrice, String creditFlag, String calWay, String lockedFlag, String vendorOperFlag, String curStatusId, String curStatusNm, String createOper, String createDate, String createTime, Integer versionNum) {
        this.orderId = orderId;
        this.operSeq = operSeq;
        this.ordertypeId = ordertypeId;
        this.ordertypeNm = ordertypeNm;
        this.paywayCode = paywayCode;
        this.paywayNm = paywayNm;
        this.ordermainId = ordermainId;
        this.cardno = cardno;
        this.verifyFlag = verifyFlag;
        this.vendorId = vendorId;
        this.vendorSnm = vendorSnm;
        this.sourceId = sourceId;
        this.sourceNm = sourceNm;
        this.goodsId = goodsId;
        this.goodsPaywayId = goodsPaywayId;
        this.goodsNum = goodsNum;
        this.goodsNm = goodsNm;
        this.currType = currType;
        this.goodssendFlag = goodssendFlag;
        this.goodsaskforFlag = goodsaskforFlag;
        this.specShopnoType = specShopnoType;
        this.payType = payType;
        this.payTypeNm = payTypeNm;
        this.incCode = incCode;
        this.incCodeNm = incCodeNm;
        this.commissionType = commissionType;
        this.bonusTotalvalue = bonusTotalvalue;
        this.incWay = incWay;
        this.creditFlag = creditFlag;
        this.calWay = calWay;
        this.lockedFlag = lockedFlag;
        this.vendorOperFlag = vendorOperFlag;
        this.curStatusId = curStatusId;
        this.curStatusNm = curStatusNm;
        this.createOper = createOper;
        this.versionNum = versionNum;
    }




    // Property accessors

    public TblOrder(String orderId, String referenceNo, Integer operSeq, String orderIdHost, String ordertypeId, String ordertypeNm, String paywayCode, String paywayNm, String ordermainId, String cardno, String cardnoBenefit, String validateCode, String verifyFlag, String vendorId, String vendorSnm, String sourceId, String sourceNm, String otSourceId, String otSourceNm, String goodsId, String goodsPaywayId, Integer goodsNum, String goodsNm, String machCode, String currType, Double exchangeRate, String typeId, String levelNm, String goodsBrand, String goodsModel, String goodsColor, String goodsPresent, String goodsPresentDesc, String specFlag, String specDesc, String goodsRange, String goodsLocal, String goodssendFlag, String goodsaskforFlag, String goodsBill, String goodsDesc, String goodsResv1, String specShopnoType, String payType, String payTypeNm, String incCode, String incCodeNm, Short stagesNum, String commissionType, Double commissionRate, Double commission, String bankNbr, String specShopno, String bonusBankNbr, String bonusSpecShopno, String payCode, String prodCode, String planCode, String stagesDesc, String mcc, Long bonusTotalvalue, Double calMoney, Double origMoney, Double totalMoney, String incWay, String incTakeWay, String incType, Double incRate, Double incMoney, String incDesc, String uitopsfee, Short uitfeeflg, Double uitfeedam, String uitopsdate, Short uitdrtuit, BigDecimal uitdrtamt, String incBackway, Double incBackPrice, Double incTakePrice, String actType, String voucherId, String voucherNm, BigDecimal voucherPrice, String creditFlag, String cashAuthType, String accreditDate, String accreditTime, String authCode, String rtnCode, String rtnDesc, String txnMsg1Desc, String txnMsg2Desc, String hostAccCode, String hostAccDesc, String bonusTrnDate, String bonusTrnTime, String bonusTraceNo, String bonusAuthType, String bonusAccreditDate, String bonusAccreditTime, String bonusAuthCode, String bonusRtnCode, String bonusRtnDesc, String bonusTxnMsgDesc, String calWay, String lockedFlag, String vendorOperFlag, String msgContent, String orderDesc, String tmpStatusId, String curStatusId, String curStatusNm, String sinStatusId, String sinStatusNm, String createOper, String modifyOper, String createDate, String createTime, String commDate, String commTime, String modifyDate, String modifyTime, Integer versionNum, String ext1, String ext2, String ext3, String reserved1, String ruleId, String ruleNm, String limitCode, String voucherNo, String actId, String custType, String accreditType, String acctNo, String appFlag, String cashTraceNo1, String cashTraceNo2, String bankNbr2, String specShopno2, String accreditDate2, String accreditTime2, String authCode2, String actCategory, String actName, String userAsscNbr, String vendorPhone, String dfacct, String dfname, String dfhnbr, String dfhname, String cvv2, String logisticsSynFlag, Double singlePrice, Long singleBonus, String bonusType, String bonusTypeNm, String balanceStatus, String batchNo, String updateStatus, String memberLevel, String integraltypeId, String merId, String errorCode, String cardtype, String receivedTime, Long custCartId, Integer miaosha_action_flag) {
        super();
        this.orderId = orderId;
        this.referenceNo = referenceNo;
        this.operSeq = operSeq;
        this.orderIdHost = orderIdHost;
        this.ordertypeId = ordertypeId;
        this.ordertypeNm = ordertypeNm;
        this.paywayCode = paywayCode;
        this.paywayNm = paywayNm;
        this.ordermainId = ordermainId;
        this.cardno = cardno;
        this.cardnoBenefit = cardnoBenefit;
        this.validateCode = validateCode;
        this.verifyFlag = verifyFlag;
        this.vendorId = vendorId;
        this.vendorSnm = vendorSnm;
        this.sourceId = sourceId;
        this.sourceNm = sourceNm;
        this.otSourceId = otSourceId;
        this.otSourceNm = otSourceNm;
        this.goodsId = goodsId;
        this.goodsPaywayId = goodsPaywayId;
        this.goodsNum = goodsNum;
        this.goodsNm = goodsNm;
        this.machCode = machCode;
        this.currType = currType;
        this.typeId = typeId;
        this.levelNm = levelNm;
        this.goodsBrand = goodsBrand;
        this.goodsModel = goodsModel;
        this.goodsColor = goodsColor;
        this.goodsPresent = goodsPresent;
        this.goodsPresentDesc = goodsPresentDesc;
        this.specFlag = specFlag;
        this.specDesc = specDesc;
        this.goodsRange = goodsRange;
        this.goodsLocal = goodsLocal;
        this.goodssendFlag = goodssendFlag;
        this.goodsaskforFlag = goodsaskforFlag;
        this.goodsBill = goodsBill;
        this.goodsDesc = goodsDesc;
        this.goodsResv1 = goodsResv1;
        this.specShopnoType = specShopnoType;
        this.payType = payType;
        this.payTypeNm = payTypeNm;
        this.incCode = incCode;
        this.incCodeNm = incCodeNm;
        this.commissionType = commissionType;
        this.bankNbr = bankNbr;
        this.specShopno = specShopno;
        this.bonusBankNbr = bonusBankNbr;
        this.bonusSpecShopno = bonusSpecShopno;
        this.payCode = payCode;
        this.prodCode = prodCode;
        this.planCode = planCode;
        this.stagesDesc = stagesDesc;
        this.mcc = mcc;
        this.bonusTotalvalue = bonusTotalvalue;
        this.incWay = incWay;
        this.incTakeWay = incTakeWay;
        this.incType = incType;
        this.incDesc = incDesc;
        this.uitopsfee = uitopsfee;
        this.uitopsdate = uitopsdate;
        this.incBackway = incBackway;
        this.actType = actType;
        this.voucherId = voucherId;
        this.voucherNm = voucherNm;
        this.creditFlag = creditFlag;
        this.cashAuthType = cashAuthType;
        this.accreditDate = accreditDate;
        this.accreditTime = accreditTime;
        this.authCode = authCode;
        this.rtnCode = rtnCode;
        this.rtnDesc = rtnDesc;
        this.txnMsg1Desc = txnMsg1Desc;
        this.txnMsg2Desc = txnMsg2Desc;
        this.hostAccCode = hostAccCode;
        this.hostAccDesc = hostAccDesc;
        this.bonusTrnDate = bonusTrnDate;
        this.bonusTrnTime = bonusTrnTime;
        this.bonusTraceNo = bonusTraceNo;
        this.bonusAuthType = bonusAuthType;
        this.bonusAccreditDate = bonusAccreditDate;
        this.bonusAccreditTime = bonusAccreditTime;
        this.bonusAuthCode = bonusAuthCode;
        this.bonusRtnCode = bonusRtnCode;
        this.bonusRtnDesc = bonusRtnDesc;
        this.bonusTxnMsgDesc = bonusTxnMsgDesc;
        this.calWay = calWay;
        this.lockedFlag = lockedFlag;
        this.vendorOperFlag = vendorOperFlag;
        this.msgContent = msgContent;
        this.orderDesc = orderDesc;
        this.tmpStatusId = tmpStatusId;
        this.curStatusId = curStatusId;
        this.curStatusNm = curStatusNm;
        this.sinStatusId = sinStatusId;
        this.sinStatusNm = sinStatusNm;
        this.createOper = createOper;
        this.modifyOper = modifyOper;
        this.commDate = commDate;
        this.commTime = commTime;
        this.versionNum = versionNum;
        this.ext1 = ext1;
        this.ext2 = ext2;
        this.ext3 = ext3;
        this.reserved1 = reserved1;
        this.ruleId = ruleId;
        this.ruleNm = ruleNm;
        this.limitCode = limitCode;
        this.voucherNo = voucherNo;
        this.actId = actId;
        this.custType = custType;
        this.accreditType = accreditType;
        this.acctNo = acctNo;
        this.appFlag = appFlag;
        this.cashTraceNo1 = cashTraceNo1;
        this.cashTraceNo2 = cashTraceNo2;
        this.bankNbr2 = bankNbr2;
        this.specShopno2 = specShopno2;
        this.accreditDate2 = accreditDate2;
        this.accreditTime2 = accreditTime2;
        this.authCode2 = authCode2;
        this.actCategory = actCategory;
        this.actName = actName;
        this.userAsscNbr = userAsscNbr;
        this.vendorPhone = vendorPhone;
        this.dfacct = dfacct;
        this.dfname = dfname;
        this.dfhnbr = dfhnbr;
        this.dfhname = dfhname;
        this.cvv2 = cvv2;
        this.logisticsSynFlag = logisticsSynFlag;
        this.singleBonus = singleBonus;
        this.bonusType = bonusType;
        this.bonusTypeNm = bonusTypeNm;
        this.balanceStatus = balanceStatus;
        this.batchNo = batchNo;
        this.memberLevel = memberLevel;
        this.integraltypeId = integraltypeId;
        this.merId = merId;
        this.errorCode = errorCode;
        this.cardtype = cardtype;
    }
}
