package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class AuctionRecordBatchModel extends BaseModel implements Serializable {

    private static final long serialVersionUID = -5405591724621813735L;
    @Getter
    @Setter
    private Long id;//自增主键
    @Getter
    @Setter
    private String custId;//客户ID
    @Getter
    @Setter
    private String cell;//客户手机号
    @Getter
    @Setter
    private String cardno;//卡号
    @Getter
    @Setter
    private String orderId;//订单号
    @Getter
    @Setter
    private String itemId;//单品ID
    @Getter
    @Setter
    private String goodsNm;//商品名称
    @Getter
    @Setter
    private String goodsPaywayId;//支付方式ID
    @Getter
    @Setter
    private java.math.BigDecimal auctionPrice;//拍卖价格
    @Getter
    @Setter
    private java.util.Date auctionTime;//拍卖时间
    @Getter
    @Setter
    private Long auctionId;//活动ID
    @Getter
    @Setter
    private Long periodId;//活动场次id
    @Getter
    @Setter
    private String isBacklock;//是否锁定库存
    @Getter
    @Setter
    private String payFlag;//是否完成支付
    @Getter
    @Setter
    private java.util.Date beginPayTime;//开始支付时间
    @Getter
    @Setter
    private java.util.Date releaseTime;//释放库存时间
    @Getter
    @Setter
    private java.util.Date modifyTime;//修改时间
}