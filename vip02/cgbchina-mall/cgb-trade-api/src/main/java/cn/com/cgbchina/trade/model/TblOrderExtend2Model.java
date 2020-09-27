package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

public class TblOrderExtend2Model implements Serializable {

    @Getter
    @Setter
    private String orderId;//订单号
    @Getter
    @Setter
    private String isPartlyRefundIntegral;//
    @Getter
    @Setter
    private Long refundIntegral;//
}