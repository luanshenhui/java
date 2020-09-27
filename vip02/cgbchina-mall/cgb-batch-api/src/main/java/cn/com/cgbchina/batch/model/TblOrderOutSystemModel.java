package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class TblOrderOutSystemModel extends BaseModel {

    private static final long serialVersionUID = 4577000467955914671L;
    @Getter
    @Setter
    private Long id;
    @Getter
    @Setter
    private String orderMainId; // 大订单号
    @Getter
    @Setter
    private String orderId; // 小订单号
    @Getter
    @Setter
    private Integer times; // 推送次数
    @Getter
    @Setter
    private String tuisongFlag; // 是否推送成功标志
    @Getter
    @Setter
    private String systemRole; // 外系统标志
    @Getter
    @Setter
    private String createOper; // 创建人
    @Getter
    @Setter
    private java.util.Date createTime;// 创建时间
    @Getter
    @Setter
    private String modifyOper;//修改人
    @Getter
    @Setter
    private java.util.Date modifyTime;//修改时间
}