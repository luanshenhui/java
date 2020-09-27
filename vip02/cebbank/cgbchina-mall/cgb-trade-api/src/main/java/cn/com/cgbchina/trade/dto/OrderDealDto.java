package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by shangqinbin on 2016/6/29.
 */
public class OrderDealDto implements Serializable {
    private static final long serialVersionUID = 200579532754333078L;

    @Getter
    @Setter
    private List<OrderDealPayResultDto> orderList;

    @Getter
    @Setter
    private String type;

    @Getter
    @Setter
    private String errorCode;

    @Getter
    @Setter
    private String errorDesc;

    @Getter
    @Setter
    private String phone;

    @Getter
    @Setter
    private String messageFlag;

    @Getter
    @Setter
    private String orderType;

    @Getter
    @Setter
    private String sucessFlag;

    @Getter
    @Setter
    private String retcode;

    @Getter
    @Setter
    private String message;

    @Getter
    @Setter
    private String payResult;

    @Getter
    @Setter
    private String errorMsg;

    @Getter
    @Setter
    private String orderId;

    @Getter
    @Setter
    private String statusId;

    @Getter
    @Setter
    private String  money;

    @Getter
    @Setter
    private String bonus_totalvalue;
}
