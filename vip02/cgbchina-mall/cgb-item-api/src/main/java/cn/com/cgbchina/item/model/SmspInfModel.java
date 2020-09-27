package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class SmspInfModel implements Serializable {

    private static final long serialVersionUID = 430174893368712866L;
    @Getter
    @Setter
    private Long id;//自增主键
    @Getter
    @Setter
    private String itemCode;//单品编码
    @Getter
    @Setter
    private String itemName;//单品名称
    @Getter
    @Setter
    private java.math.BigDecimal perStage;//单期金额
    @Getter
    @Setter
    private Integer stagesCode;//分期
    @Getter
    @Setter
    private java.math.BigDecimal goodsPrice;//单品价格
    @Getter
    @Setter
    private String smspId;//短信模板id
    @Getter
    @Setter
    private java.util.Date beginDate;//有效开始日期
    @Getter
    @Setter
    private java.util.Date endDate;//有效结束日期
    @Getter
    @Setter
    private java.math.BigDecimal voucherPrice;//优惠券金额
    @Getter
    @Setter
    private String couponId;//项目编号
    @Getter
    @Setter
    private String couponNm;//项目名称
    @Getter
    @Setter
    private String ifPoint;//是否使用积分
    @Getter
    @Setter
    private String status;//当前状态
    @Getter
    @Setter
    private String otherMess;//手工参数
    @Getter
    @Setter
    private java.util.Date subDatetime;//提交时间
    @Getter
    @Setter
    private java.util.Date checkDatetime;//审核通过时间
    @Getter
    @Setter
    private String sendDatetime;//发送时间
    @Getter
    @Setter
    private String loadStatus;//导入状态
    @Getter
    @Setter
    private java.util.Date loadDatetime;//导入时间
    @Getter
    @Setter
    private Integer delFlag;//逻辑删除标记 0：未删除 1：已删除
    @Getter
    @Setter
    private String dealFlag;// 
    @Getter
    @Setter
    private String createOper;//创建人
    @Getter
    @Setter
    private java.util.Date createTime;//创建时间
    @Getter
    @Setter
    private String modifyOper;//修改人
    @Getter
    @Setter
    private java.util.Date modifyTime;//修改时间
    @Getter
    @Setter
    private String seq;
}