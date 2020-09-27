package cn.com.cgbchina.trade.model;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

@ToString
@EqualsAndHashCode
public class OrderVirtualModel implements Serializable {

    @Getter
    @Setter
    private Long orderVirtualId;//自增主键
    @Getter
    @Setter
    private String orderId;//订单id
    @Getter
    @Setter
    private String goodsXid;//礼品编码
    @Getter
    @Setter
    private String goodsMid;//分期编码
    @Getter
    @Setter
    private String goodsOid;//一期编码
    @Getter
    @Setter
    private String goodsBid;//积分别名编码
    @Getter
    @Setter
    private String entryCard;//入帐卡号
    @Getter
    @Setter
    private String virtualCardType;//卡类
    @Getter
    @Setter
    private String goodsType;//虚拟礼品订单标志
    @Getter
    @Setter
    private Integer virtualLimit;//限购次数
    @Getter
    @Setter
    private Integer virtualSingleMileage;//单个虚拟礼品里程数
    @Getter
    @Setter
    private Integer virtualAllMileage;//总虚拟礼品里程数
    @Getter
    @Setter
    private java.math.BigDecimal virtualSinglePrice;//单个虚拟礼品兑换金额
    @Getter
    @Setter
    private java.math.BigDecimal virtualAllPrice;//总虚拟礼品兑换金额
    @Getter
    @Setter
    private String virtualMemberId;//会员号
    @Getter
    @Setter
    private String virtualMemberNm;//会员姓名
    @Getter
    @Setter
    private String virtualAviationType;//航空类型
    @Getter
    @Setter
    private String tradecode;//交易类型
    @Getter
    @Setter
    private String tradedesc;//交易描述
    @Getter
    @Setter
    private String extend1;//保留字段
    @Getter
    @Setter
    private String extend2;//保留字段
    @Getter
    @Setter
    private String extend3;//保留字段
    @Getter
    @Setter
    private String statusFlag;//充值状态
    @Getter
    @Setter
    private String centerStatus;//中间业务平台返回状态
    @Getter
    @Setter
    private String centerErrormsg;//中间业务平台返回信息
    @Getter
    @Setter
    private java.math.BigDecimal perpaidMon;// 
    @Getter
    @Setter
    private String prepaidMob;//充值电话号码
    @Getter
    @Setter
    private String handleFlag;//推送标志
    @Getter
    @Setter
    private String seqNo;//推送序列号
    @Getter
    @Setter
    private String transactionId;//操作流水号
    @Getter
    @Setter
    private String attachName;// 
    @Getter
    @Setter
    private String attachIdentityCard;// 
    @Getter
    @Setter
    private String serialno;// 
}