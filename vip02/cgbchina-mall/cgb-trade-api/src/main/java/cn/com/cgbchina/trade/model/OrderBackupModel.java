package cn.com.cgbchina.trade.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class OrderBackupModel implements Serializable {

    private static final long serialVersionUID = -3779425100109288408L;
    @Getter
    @Setter
    private String orderId;//子订单号
    @Getter
    @Setter
    private String ordermainId;//主订单号
    @Getter
    @Setter
    private Integer operSeq;//业务订单同步序号和电子商务保持一致默认0
    @Getter
    @Setter
    private String ordertypeId;//业务类型代码yg:广发商城(一期)jf:积分商城fq:广发商城(分期)
    @Getter
    @Setter
    private String ordertypeNm;//业务类型名称
    @Getter
    @Setter
    private String paywayCode;//支付方式代码
    @Getter
    @Setter
    private String paywayNm;//支付方式名称
    @Getter
    @Setter
    private String cardno;//卡号
    @Getter
    @Setter
    private String verifyFlag;//下单验证标记
    @Getter
    @Setter
    private String vendorId;//供应商代码
    @Getter
    @Setter
    private String vendorSnm;//供应商名称简写
    @Getter
    @Setter
    private String sourceId;//渠道代码
    @Getter
    @Setter
    private String sourceNm;//渠道名称
    @Getter
    @Setter
    private String otSourceId;//业务渠道代码
    @Getter
    @Setter
    private String otSourceNm;//业务渠道名称
    @Getter
    @Setter
    private String goodsCode;//商品id（新加）
    @Getter
    @Setter
    private String goodsId;//单品代码
    @Getter
    @Setter
    private String bankNbr;//银行号
    @Getter
    @Setter
    private Long bonusTotalvalue;//积分总数
    @Getter
    @Setter
    private java.math.BigDecimal calMoney;//清算总金额
    @Getter
    @Setter
    private java.math.BigDecimal origMoney;//原始现金总金额(未用)
    @Getter
    @Setter
    private java.math.BigDecimal totalMoney;//现金总金额
    @Getter
    @Setter
    private String actType;//活动类型
    @Getter
    @Setter
    private String voucherId;//优惠券代码
    @Getter
    @Setter
    private String voucherNm;//优惠券名称
    @Getter
    @Setter
    private java.math.BigDecimal voucherPrice;//优惠金额
    @Getter
    @Setter
    private String voucherNo;//优惠券编码
    @Getter
    @Setter
    private String actId;//活动id
    @Getter
    @Setter
    private String acctNo;//账户号码
    @Getter
    @Setter
    private java.math.BigDecimal singlePrice;//单个商品对应的价格
    @Getter
    @Setter
    private Long singleBonus;//单个商品对应的积分
    @Getter
    @Setter
    private String bonusType;//积分类型
    @Getter
    @Setter
    private String bonusTypeNm;//积分类型名称
    @Getter
    @Setter
    private String goodsType;//商品类型
    @Getter
    @Setter
    private String goodsTypeName;//商品类型
    @Getter
    @Setter
    private String isTieinSale;//是否搭销
    @Getter
    @Setter
    private String balanceStatus;//结算状态积分商城为结算状态
    @Getter
    @Setter
    private String batchNo;//批次号
    @Getter
    @Setter
    private String eUpdateStatus;//通知入账标识位否已经通知电子支付平台入账的标识位
    @Getter
    @Setter
    private String orderDesc;//订单表备注
    @Getter
    @Setter
    private String cardnoBenefit;//受益卡号
    @Getter
    @Setter
    private String validateCode;//验证码
    @Getter
    @Setter
    private String goodsPaywayId;//商品支付编码
    @Getter
    @Setter
    private Integer goodsNum;//商品数量
    @Getter
    @Setter
    private String goodsNm;//商品名称
    @Getter
    @Setter
    private String machCode;//商品条行码
    @Getter
    @Setter
    private String currType;//商品币种
    @Getter
    @Setter
    private java.math.BigDecimal exchangeRate;//对人民币的汇率值
    @Getter
    @Setter
    private String typeId;//商品类别id
    @Getter
    @Setter
    private String levelNm;//商品类别名称
    @Getter
    @Setter
    private String goodsBrand;//品牌
    @Getter
    @Setter
    private String goodsModel;//型号
    @Getter
    @Setter
    private String goodsColor;//商品颜色
    @Getter
    @Setter
    private String goodsPresent;//赠品
    @Getter
    @Setter
    private String goodsPresentDesc;//赠品说明
    @Getter
    @Setter
    private String specFlag;//是否特选商品
    @Getter
    @Setter
    private String specDesc;//特别备注信息
    @Getter
    @Setter
    private String goodsRange;//送货范围
    @Getter
    @Setter
    private String goodsLocal;//是否现场兑换
    @Getter
    @Setter
    private String goodssendFlag;//发货标记
    @Getter
    @Setter
    private String goodsaskforFlag;//请款标记
    @Getter
    @Setter
    private String goodsBill;//商品账单描述
    @Getter
    @Setter
    private String goodsDesc;//商品描述
    @Getter
    @Setter
    private String goodsResv1;//商品备注
    @Getter
    @Setter
    private String specShopnoType;//退货流转标志
    @Getter
    @Setter
    private String payTypeNm;//佣金代码名称
    @Getter
    @Setter
    private String incCode;//手续费率代码(未用)
    @Getter
    @Setter
    private String incCodeNm;//手续费率名称
    @Getter
    @Setter
    private Integer stagesNum;//现金[或积分]分期数
    @Getter
    @Setter
    private String commissionType;//佣金计算类别(未用)
    @Getter
    @Setter
    private java.math.BigDecimal commissionRate;//佣金区间佣金率(不包含%)
    @Getter
    @Setter
    private java.math.BigDecimal commission;//佣金金额【与币种一致】
    @Getter
    @Setter
    private String specShopno;//特店号邮购分期费率类别码
    @Getter
    @Setter
    private String bonusBankNbr;//积分银行号
    @Getter
    @Setter
    private String bonusSpecShopno;//积分特店号
    @Getter
    @Setter
    private String payCode;//缴款方案代码(未用)
    @Getter
    @Setter
    private String prodCode;//分期产品代码(未用)
    @Getter
    @Setter
    private String planCode;//分期计划代码(未用)
    @Getter
    @Setter
    private String stagesDesc;//分期描述
    @Getter
    @Setter
    private String mcc;//mcc号
    @Getter
    @Setter
    private String incWay;//手续费获取方式
    @Getter
    @Setter
    private String incTakeWay;//手续费计算方式
    @Getter
    @Setter
    private String incType;//手续费类别
    @Getter
    @Setter
    private java.math.BigDecimal incRate;//手续费率
    @Getter
    @Setter
    private java.math.BigDecimal incMoney;//手续费总金额
    @Getter
    @Setter
    private String incDesc;//手续费描述(未用)
    @Getter
    @Setter
    private String uitopsfee;//手续费收取方式
    @Getter
    @Setter
    private Integer uitfeeflg;//手续费减免期数
    @Getter
    @Setter
    private java.math.BigDecimal uitfeedam;//手续费减免金额
    @Getter
    @Setter
    private String uitopsdate;//分期开始日期
    @Getter
    @Setter
    private Integer uitdrtuit;//本金减免期数
    @Getter
    @Setter
    private java.math.BigDecimal uitdrtamt;//本金减免金额
    @Getter
    @Setter
    private String incBackway;//手续费退回方式
    @Getter
    @Setter
    private java.math.BigDecimal incBackPrice;//手续费退回指定金额(未用)
    @Getter
    @Setter
    private java.math.BigDecimal incTakePrice;//退单时收取指定金额手续费
    @Getter
    @Setter
    private String creditFlag;//授权额度不足处理方式
    @Getter
    @Setter
    private String cashAuthType;//现金授权类型分期订单电子支付是否已经验证标识null或’’
    @Getter
    @Setter
    private String accreditDate;//授权日期
    @Getter
    @Setter
    private String accreditTime;//授权时间
    @Getter
    @Setter
    private String authCode;//授权码
    @Getter
    @Setter
    private String rtnCode;//主机授权回应代码
    @Getter
    @Setter
    private String rtnDesc;//主机授权回应代码说明
    @Getter
    @Setter
    private String txnMsg1Desc;//通讯消息说明1
    @Getter
    @Setter
    private String txnMsg2Desc;//通讯消息说明2
    @Getter
    @Setter
    private String hostAccCode;//主机入账回应代码
    @Getter
    @Setter
    private String hostAccDesc;//主机入账回应代码说明
    @Getter
    @Setter
    private String bonusTrnDate;//支付日期
    @Getter
    @Setter
    private String bonusTrnTime;//支付时间
    @Getter
    @Setter
    private String bonusTraceNo;//系统跟踪号
    @Getter
    @Setter
    private String bonusAuthType;//积分授权类型
    @Getter
    @Setter
    private String bonusAccreditDate;//bonus授权日期
    @Getter
    @Setter
    private String bonusAccreditTime;//bonus授权时间
    @Getter
    @Setter
    private String bonusAuthCode;//bonus授权码
    @Getter
    @Setter
    private String bonusRtnCode;//bonus主机授权回应代码
    @Getter
    @Setter
    private String bonusRtnDesc;//bonus主机授权回应代码说明
    @Getter
    @Setter
    private String bonusTxnMsgDesc;//bonus通讯消息说明
    @Getter
    @Setter
    private String calWay;//退货方式
    @Getter
    @Setter
    private String lockedFlag;//订单锁定标记
    @Getter
    @Setter
    private String vendorOperFlag;//供应商操作标记
    @Getter
    @Setter
    private String msgContent;//上行短信内容
    @Getter
    @Setter
    private String tmpStatusId;//临时状态代码
    @Getter
    @Setter
    private String curStatusId;//当前状态代码
    @Getter
    @Setter
    private String curStatusNm;//当前状态名称
    @Getter
    @Setter
    private String sinStatusId;//请款状态代码
    @Getter
    @Setter
    private String sinStatusNm;//请款状态名称
    @Getter
    @Setter
    private String createOper;//创建操作员id
    @Getter
    @Setter
    private String modifyOper;//修改操作员id
    @Getter
    @Setter
    private String commDate;//业务日期
    @Getter
    @Setter
    private String commTime;//业务时间
    @Getter
    @Setter
    private Integer versionNum;//记录更新控制版本号
    @Getter
    @Setter
    private String ext1;//扩展属性一人为撤单标识
    @Getter
    @Setter
    private String ext2;//分期为biu的分期代码
    @Getter
    @Setter
    private String ext3;//撤单是否生产报表标识位
    @Getter
    @Setter
    private String reserved1;//商户号
    @Getter
    @Setter
    private String ruleId;//规则id
    @Getter
    @Setter
    private String ruleNm;//规则名称
    @Getter
    @Setter
    private String limitCode;//规则限制代码
    @Getter
    @Setter
    private String custType;//客户类型
    @Getter
    @Setter
    private String accreditType;//授权类型
    @Getter
    @Setter
    private String appFlag;//随意借业务使用
    @Getter
    @Setter
    private String cashTraceNo1;//现金交易流水号1
    @Getter
    @Setter
    private String cashTraceNo2;//现金交易流水号2
    @Getter
    @Setter
    private String bankNbr2;//银行号[卡号2]
    @Getter
    @Setter
    private String specShopno2;//特店号[卡号2]
    @Getter
    @Setter
    private String accreditDate2;//授权日期[卡号2]
    @Getter
    @Setter
    private String accreditTime2;//授权时间[卡号2]
    @Getter
    @Setter
    private String authCode2;//授权码[卡号2]
    @Getter
    @Setter
    private String actCategory;//活动种类
    @Getter
    @Setter
    private String actName;//活动名称
    @Getter
    @Setter
    private String userAsscNbr;//会员号码
    @Getter
    @Setter
    private String vendorPhone;//合作商电话
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
    private String memberLevel;//价格等级id
    @Getter
    @Setter
    private String integraltypeId;//积分类型id
    @Getter
    @Setter
    private String merId;//商户号
    @Getter
    @Setter
    private String errorCode;//错误码
    @Getter
    @Setter
    private String cardtype;//卡标志
    @Getter
    @Setter
    private String receiver;//签收人
    @Getter
    @Setter
    private String receivedTime;//签收时间
    @Getter
    @Setter
    private Long custCartId;//此订单对应的购物车id
    @Getter
    @Setter
    private Integer miaoshaActionFlag;//商品活动标志
    @Getter
    @Setter
    private String referenceNo;//
    @Getter
    @Setter
    private String orderIdHost;//
    @Getter
    @Setter
    private java.math.BigDecimal installmentPrice;//分期价格
    @Getter
    @Setter
    private String memberName;//会员名称
    @Getter
    @Setter
    private java.util.Date firstRemindeTime;//首次催单时间
    @Getter
    @Setter
    private Integer remindeTimes;//催单次数
    @Getter
    @Setter
    private Integer remindeFlag;//提醒发货标识
    @Getter
    @Setter
    private String o2oVoucherCode;//o2o商品兑换码
    @Getter
    @Setter
    private Integer o2oExpireFlag;//o2o已过期操作标志
    @Getter
    @Setter
    private String itemSmallPic;//单品小图标
    @Getter
    @Setter
    private String saleAfterStatus;//售后状态
    @Getter
    @Setter
    private String tieinSaleMemo;//搭销审核意见
    @Getter
    @Setter
    private String sinApplyMemo;//请款审核意见
    @Getter
    @Setter
    private Integer delFlag;//逻辑删除标记
    @Getter
    @Setter
    private String goodsAttr1;//销售属性
    @Getter
    @Setter
    private String goodsAttr2;//销售属性
    @Getter
    @Setter
    private java.math.BigDecimal fenefit;//优惠差额
    @Getter
    @Setter
    private Integer costby;//费用承担方
    @Getter
    @Setter
    private Integer periodId;//场次id
    @Getter
    @Setter
    private java.util.Date createTime;//创建时间
    @Getter
    @Setter
    private java.util.Date modifyTime;//更新时间
    @Getter
    @Setter
    private java.util.Date orderSuccTime;//电子支付支付成功时间
}