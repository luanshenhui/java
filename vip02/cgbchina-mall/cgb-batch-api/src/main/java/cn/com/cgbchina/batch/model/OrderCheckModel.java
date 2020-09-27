package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

@Setter
@Getter
@ToString
public class OrderCheckModel implements Serializable {
    private static final long serialVersionUID = -1820807776770388855L;
    private Long id;//自增id
    private String orderId;//订单号
    private String curStatusId;//订单即时状态
    private String curStatusNm;//状态名称
    private String doDate;//操作日期   出对账文件的时间    正交易:下单时间   负交易：负交易发生时间
    private String doTime;//操作时间
    private java.util.Date modifyTime;//更新时间
    private String doDesc;//说明
    private String ischeck;//是否需要出具优惠券对账文件   0-需要   1-不需要
    private String ispoint;//是否出具积分对账文件   0-需要  1-不需要(已将记录发给积分系统)   2-积分商城订单查的记录(现在已经不用)
    private String jfRefundSerialno;//积分退货流水号
    private String createOper;//
    private String modifyOper;//
    private java.util.Date createTime;//
    private Integer delFlag;//逻辑删除标记 0：未删除 1：已删除
}