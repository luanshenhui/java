package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

public class TblOrderCancelModel implements Serializable {

    @Getter
    @Setter
    private Long orderCancelId;//自增主键
    @Getter
    @Setter
    private String orderId;//子订单号
    @Getter
    @Setter
    private String cancelCheckStatus;// 
    @Getter
    @Setter
    private java.util.Date cancelTime;//取消时间
    @Getter
    @Setter
    private java.util.Date updateTime;//更新时间
    @Getter
    @Setter
    private String curStatusId;//当前状态
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