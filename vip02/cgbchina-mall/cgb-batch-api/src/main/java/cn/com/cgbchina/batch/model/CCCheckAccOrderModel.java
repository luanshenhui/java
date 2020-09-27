package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class CCCheckAccOrderModel extends BaseModel implements Serializable {

    private static final long serialVersionUID = -5845220167765327181L;
    @Getter
    @Setter
    private Long id;//自增主键
    @Getter
    @Setter
    private String ordermainId;//主订单号
    @Getter
    @Setter
    private String cardNo;//卡号
    @Getter
    @Setter
    private java.util.Date txnDate;//交易日期
    @Getter
    @Setter
    private String serialNo;//交易流水号
    @Getter
    @Setter
    private String defrayType;//消费类型
    @Getter
    @Setter
    private java.math.BigDecimal amount;//金额
    @Getter
    @Setter
    private String bonusType;//积分类型
    @Getter
    @Setter
    private Long bonusValue;//积分值
    @Getter
    @Setter
    private String bonusTxnCode;//积分交易码
    @Getter
    @Setter
    private String checkStatus;//对账成功标识
    @Getter
    @Setter
    private String ismerge;
    @Getter
    @Setter
    private java.util.Date createTime;


}