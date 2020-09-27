package cn.com.cgbchina.log.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class MessageLogModel implements Serializable {

    @Getter
    @Setter
    private Long logId;//自增主键
    @Getter
    @Setter
    private String sendersn;//交易流水
    @Getter
    @Setter
    private String tradecode;//交易码
    @Getter
    @Setter
    private String senderid;//发送系统标识
    @Getter
    @Setter
    private String receiverid;//接收系统标识
    @Getter
    @Setter
    private String orderid;//订单号
    @Getter
    @Setter
    private String serviceid;//服务id
    @Getter
    @Setter
    private java.util.Date opertime;//操作时间
    @Getter
    @Setter
    private String sendflag;//发送接收报文标识
    @Getter
    @Setter
    private String errflag;//成功标记
    @Getter
    @Setter
    private String errcode;//错误码
    @Getter
    @Setter
    private String messagecontent;//流水号
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