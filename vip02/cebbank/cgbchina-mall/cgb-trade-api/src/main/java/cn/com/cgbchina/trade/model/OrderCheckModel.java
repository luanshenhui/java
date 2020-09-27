package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

public class OrderCheckModel implements Serializable {

    private static final long serialVersionUID = -1820807776770388855L;
    @Getter
    @Setter
    private Long id;//自增id
    @Getter
    @Setter
    private String orderId;//订单号
    @Getter
    @Setter
    private String curStatusId;//订单即时状态
    @Getter
    @Setter
    private String curStatusNm;//状态名称
    @Getter
    @Setter
    private String doDate;//操作日期   出对账文件的时间    正交易:下单时间   负交易：负交易发生时间
    @Getter
    @Setter
    private String doTime;//操作时间
    @Getter
    @Setter
    private java.util.Date modifyTime;//更新时间
    @Getter
    @Setter
    private String doDesc;//说明
    @Getter
    @Setter
    private String ischeck;//是否需要出具优惠券对账文件   0-需要   1-不需要
    @Getter
    @Setter
    private String ispoint;//是否出具积分对账文件   0-需要  1-不需要(已将记录发给积分系统)   2-积分商城订单查的记录(现在已经不用)
    @Getter
    @Setter
    private String jfRefundSerialno;//积分退货流水号
    @Getter
    @Setter
    private String createOper;//
    @Getter
    @Setter
    private String modifyOper;//
    @Getter
    @Setter
    private java.util.Date createTime;//
    @Getter
    @Setter
    private Integer delFlag;//逻辑删除标记 0：未删除 1：已删除
}