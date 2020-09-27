package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by shangqinbin on 2016/7/1.
 */
public class OrderDealPayResultDto implements Serializable {

    private static final long serialVersionUID = -475690146263427076L;

    @Getter
    @Setter
    private String seq;

    @Getter
    @Setter
    private String orderId;

    @Getter
    @Setter
    private String statusId;

    @Getter
    @Setter
    private String money;

    @Getter
    @Setter
    private String goodsId;

    @Getter
    @Setter
    private String goodName;

    @Getter
    @Setter
    private String privilegeMoney;

    @Getter
    @Setter
    private String single_bonus;

    @Getter
    @Setter
    private String errorCode;

    @Getter
    @Setter
    private String cardType;

    @Getter
    @Setter
    private String errorMsg;

    @Getter
    @Setter
    private String act_type;

    @Getter
    @Setter
    private String payResult;

    @Getter
    @Setter
    private String bonus_totalvalue;

    @Getter
    @Setter
    private String goods_type;
}
