package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class TblOrderMainHisModel implements Serializable {

    @Getter
    @Setter
    private Long hisId;//自增主键
    @Getter
    @Setter
    private String ordermainId;//大订单编号
    @Getter
    @Setter
    private String ordertypeId;//业务类型代码
    @Getter
    @Setter
    private String ordertypeNm;//业务类型名称
    @Getter
    @Setter
    private String curStatusId;//订单状态
    @Getter
    @Setter
    private String curStatusNm;//订单名称
    @Getter
    @Setter
    private String cardno;//卡号
    @Getter
    @Setter
    private String contIdType;//订货人证件类型
    @Getter
    @Setter
    private String contIdcard;//订货人证件号码
    @Getter
    @Setter
    private String contNm;//订货人姓名
    @Getter
    @Setter
    private String contNmPy;//订货人姓名拼音
    @Getter
    @Setter
    private String contPostcode;//订货人邮政编码
    @Getter
    @Setter
    private String contAddress;//订货人详细地址
    @Getter
    @Setter
    private String contMobPhone;//订货人手机
    @Getter
    @Setter
    private String contHphone;//订货人家里电话
    @Getter
    @Setter
    private String csgName;//收货人姓名
    @Getter
    @Setter
    private String csgIdType;//收货人证件类型
    @Getter
    @Setter
    private String csgIdcard;//收货人证件号码
    @Getter
    @Setter
    private String csgPostcode;//收货人邮政编码
    @Getter
    @Setter
    private String csgAddress;//收货人详细地址
    @Getter
    @Setter
    private String csgPhone1;//收货人电话一
    @Getter
    @Setter
    private String csgPhone2;//收货人电话二
    @Getter
    @Setter
    private String csgProvince;//收货人省
    @Getter
    @Setter
    private String csgCity;//收货人市
    @Getter
    @Setter
    private String csgBorough;//收货人区
    @Getter
    @Setter
    private String serialNo;//流水号
    @Getter
    @Setter
    private String acceptedNo;//受理号
    @Getter
    @Setter
    private String modifyOrdertypeId;//修改业务类型代码
    @Getter
    @Setter
    private String promotors;//发起人
    @Getter
    @Setter
    private String modifyOper;//修改人
    @Getter
    @Setter
    private java.util.Date modifyTime;//修改时间
}