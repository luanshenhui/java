package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
@Getter
@Setter
@ToString
public class OrderClearModel implements Serializable {

    private static final long serialVersionUID = 2953427379721562123L;
    private Long id;//自增id
    private String ordertypeId;//业务类型代码
    private String orderId;//订单号
    private String statusId;//订单状态
    private String clearflag;//清算标记
    private java.util.Date cleartime;//清算时间
    private java.util.Date opertime;//操作时间
    private String extend1;//保留字段1
    private String extend2;//保留字段2
    private String extend3;//保留字段3
}