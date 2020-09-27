package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by CuiZhengwei on 2016/7/15.
 */
@Getter
@Setter
@ToString
public class ClearQueryModel extends BaseModel {
    private static final long serialVersionUID = -3305050871181476634L;

    private Long orderClearId;

    private String orderId;

    private Date createTime;

    private Date operTime;
    /**
     * 卡号
     */
    private String cardNo;
    /**
     * 现金总金额
     */
    private BigDecimal totalMoney;
    /**
     * 商户号
     */
    private String merId;
    /**
     * 商户号(发给清算系统的)
     */
    private String reserved1;
    /**
     * 特店号邮购分期费率类别码
     */
    private String specShopno;
    /**
     * 现金[或积分]分期数
     */
    private String stagesNum;
    /**
     * 积分抵扣金额=订单表.本金减免金额
     */
    private BigDecimal uitdrtamt;
    /**
     * 活动类型-团购秒杀标志1-团购2-秒杀
     */
    private String actType;

    private String orderNbr;

    private BigDecimal goodsPrice;
    /**
     * 差额（goodsPrice-totalMoney）
     */
    private BigDecimal discountMoney;
    /**
     * 银联商户号
     */
    private String unionPayNo;
    /**
     * 主订单号
     */
    private String orderMainId;
    /**
     * 清算金额
     */
    private BigDecimal calMoney;
    /**
     * 是否生日价格
     */
    private String isBirth;
    /**
     * 优惠金额
     */
    private BigDecimal voucherPrice;
    /**
     * 费用承担方（0 行方  1 供应商）
     */
    private String costBy;
    /**
     * 优惠差额
     */
    private BigDecimal fenefit;

    private int errorCnt;
}
