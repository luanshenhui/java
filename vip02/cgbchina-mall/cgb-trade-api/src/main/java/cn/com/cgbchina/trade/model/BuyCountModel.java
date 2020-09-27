package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * 商品购买数量
 * geshuo 20160712
 */
public class BuyCountModel implements Serializable {

    private static final long serialVersionUID = -8269616033121241045L;

    /**
     * 单品编码
     */
    @Getter
    @Setter
    private String itemCode;

    /**
     * 购买数量
     */
    @Getter
    @Setter
    private Long buyCount;
}
