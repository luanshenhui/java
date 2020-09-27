package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class TblOrderExtend1Model implements Serializable {

    private static final long serialVersionUID = 4792219113244268558L;
    @Getter
    @Setter
    private Long orderExtend1Id;//自增主键
    @Getter
    @Setter
    private String orderId;//订单号
    @Getter
    @Setter
    private String errorcode;//
    @Getter
    @Setter
    private String approveresult;//
    @Getter
    @Setter
    private String followdir;//
    @Getter
    @Setter
    private String caseid;//
    @Getter
    @Setter
    private String specialcust;//
    @Getter
    @Setter
    private String releasetype;//
    @Getter
    @Setter
    private String rejectcode;//
    @Getter
    @Setter
    private String aprtcode;//
    @Getter
    @Setter
    private String ordernbr;//
    @Getter
    @Setter
    private String processstatus;//
    @Getter
    @Setter
    private String processresult;//
    @Getter
    @Setter
    private String creator;//
    @Getter
    @Setter
    private String regulator;//
    @Getter
    @Setter
    private String michelleid;//
    @Getter
    @Setter
    private String incomingtel;//
    @Getter
    @Setter
    private String extend1;//保留字段
    @Getter
    @Setter
    private String extend2;//保留字段
    @Getter
    @Setter
    private String extend3;//保留字段
}