package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

public class OrderClearModel implements Serializable {

    private static final long serialVersionUID = 2953427379721562123L;

    @Getter
    @Setter
    private Long id;//自增id
    @Getter
    @Setter
    private String ordertypeId;//业务类型代码
    @Getter
    @Setter
    private String orderId;//订单号
    @Getter
    @Setter
    private String statusId;//订单状态
    @Getter
    @Setter
    private String clearflag;//清算标记
    @Getter
    @Setter
    private java.util.Date cleartime;//清算时间
    @Getter
    @Setter
    private java.util.Date opertime;//操作时间
    @Getter
    @Setter
    private String extend1;//保留字段1
    @Getter
    @Setter
    private String extend2;//保留字段2
    @Getter
    @Setter
    private String extend3;//保留字段3
}