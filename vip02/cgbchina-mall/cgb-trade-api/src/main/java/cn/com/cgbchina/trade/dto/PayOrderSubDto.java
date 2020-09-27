package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by shangqinbin on 16-6-28.
 */
public class PayOrderSubDto implements Serializable {
    private static final long serialVersionUID = 3273319538079342581L;
    @Getter
    @Setter
    private String vendor_id;

    @Getter
    @Setter
    private String order_id;

    @Getter
    @Setter
    private String money;

    @Getter
    @Setter
    private String returnCode;
}
