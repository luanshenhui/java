package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

/**
 * Created by shangqinbin on 16-6-28.
 */
@ToString
public class PayOrderInfoDto implements Serializable {

    private static final long serialVersionUID = 2069417160818324681L;

    @Getter
    @Setter
    private List<PayOrderSubDto> payOrderSubDtoList;

    @Getter
    @Setter
    private String orderid;

    @Getter
    @Setter
    private String payAccountNo;

    @Getter
    @Setter
    private String cardType;

    @Getter
    @Setter
    private String crypt;

    @Getter
    @Setter
    private String phone;

    @Getter
    @Setter
    private String sendTime;

    @Getter
    @Setter
    private Boolean isPayment;
}
