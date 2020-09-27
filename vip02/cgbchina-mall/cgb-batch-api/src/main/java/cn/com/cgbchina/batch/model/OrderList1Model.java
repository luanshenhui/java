package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.math.BigDecimal;

/**
 * 查询大订单对应的小订单
 *
 */
@Getter
@Setter
@ToString
public class OrderList1Model extends BaseModel {

    private static final long serialVersionUID = 1153884400866764350L;
    /**
     * 大订单编号
     */
    private String orderMainId;
    /**
     * 小订单编号
     */
    private String orderId;
    /**
     * 商家id  外系统提供
     */
    private String shopId;
    /**
     * 发送地址
     */
    private String actionUrl;
    /**
     * 密钥
     */
    private String shopKey;
    /**
     * 外系统编号
     */
    private String outsystemId;
    /**
     * 现金总金额
     */
    private BigDecimal totalMoney;
    /**
     * 商品数量
     */
    private Integer goodsNum;
    /**
     * 单个商品对应的价格
     */
    private BigDecimal singlePrice;
    /**
     * 单品代码
     */
    private String goodsId;
    /**
     * 业务类型代码YG:广发商城(一期)JF:积分商城FQ:广发商城(分期)
     */
    private String ordertypeId;
    /**
     * 清算总金额
     */
    private BigDecimal calMoney;
}
