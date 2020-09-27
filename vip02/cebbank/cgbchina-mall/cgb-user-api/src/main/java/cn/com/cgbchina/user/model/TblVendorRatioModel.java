package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

public class TblVendorRatioModel implements Serializable {

    private static final long serialVersionUID = -8717963242188688270L;
    @Getter
    @Setter
    private Long id;//��������
    @Getter
    @Setter
    private String vendorId;//��Ӧ��id
    @Getter
    @Setter
    private Integer period;//期数
    @Getter
    @Setter
    private String fixedfeehtFlag;//手续费首位付标志
    @Getter
    @Setter
    private java.math.BigDecimal fixedamtFee;//固定金额手续费
    @Getter
    @Setter
    private java.math.BigDecimal feeratio1;//手续费费率1(月费率)
    @Getter
    @Setter
    private java.math.BigDecimal ratio1Precent;//费率1本金百分比
    @Getter
    @Setter
    private java.math.BigDecimal feeratio2;//手续费费率2(月费率)
    @Getter
    @Setter
    private java.math.BigDecimal ratio2Precent;//费率2本金百分比
    @Getter
    @Setter
    private Integer feeratio2Bill;//手续费费率2 开机期数
    @Getter
    @Setter
    private java.math.BigDecimal feeratio3;//手续费费率3(月费率)
    @Getter
    @Setter
    private java.math.BigDecimal ratio3Precent;//费率3本金百分比
    @Getter
    @Setter
    private Integer feeratio3Bill;//手续费费率3 开机期数
    @Getter
    @Setter
    private Integer reducerateFrom;//直接免除手续费期数FROM
    @Getter
    @Setter
    private Integer reducerateTo;//直接免除手续费期数To
    @Getter
    @Setter
    private Integer reducerate;//手续费免除期数
    @Getter
    @Setter
    private String htflag;//首尾付标志
    @Getter
    @Setter
    private java.math.BigDecimal htant;//首尾付本金
    @Getter
    @Setter
    private Integer delFlag;//�߼�ɾ����� 0��δɾ�� 1����ɾ��
    @Getter
    @Setter
    private String createOper;//������
    @Getter
    @Setter
    private java.util.Date createTime;//����ʱ��
    @Getter
    @Setter
    private String modifyOper;//�޸���
    @Getter
    @Setter
    private java.util.Date modifyTime;//�޸�ʱ��
    @Getter
    @Setter
    private String virtualVendorId;//虚拟特店号
}