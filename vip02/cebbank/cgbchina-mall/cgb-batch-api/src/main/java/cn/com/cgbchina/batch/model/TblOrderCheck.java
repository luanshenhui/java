package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 张成 on 16-6-27.
 */
public class TblOrderCheck implements Serializable {

    private static final long serialVersionUID = 881538158689442288L;

    @Setter
    @Getter
    private Long id;
    @Setter
    @Getter
    private String orderId;
    @Setter
    @Getter
    private String curStatusId;
    @Setter
    @Getter
    private String curStatusNm;
    @Setter
    @Getter
    private String doDate;
    @Setter
    @Getter
    private String doTime;
    @Setter
    @Getter
    private String updateDate;
    @Setter
    @Getter
    private String updateTime;
    @Setter
    @Getter
    private String doDesc;
    @Setter
    @Getter
    private String ischeck;
    @Setter
    @Getter
    private String ispoint;
    @Setter
    @Getter
    private String jfRefundSerialno;//hwh 20150202 增加主动退积分字段
}
