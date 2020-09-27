package cn.com.cgbchina.related.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class CouponInfModel implements Serializable {

    private static final long serialVersionUID = -4604333448801559329L;
    @Getter
    @Setter
    private Integer id;//自增主键
    @Getter
    @Setter
    private String couponId;//项目编号
    @Getter
    @Setter
    private String couponNm;//项目名称
    @Getter
    @Setter
    private String backCategoryId;//后台类目id
    @Getter
    @Setter
    private String backCategoryNm;//后台类目名称
    @Getter
    @Setter
    private String vendorId;//合作商id
    @Getter
    @Setter
    private String vendorNms;//合作商名称
    @Getter
    @Setter
    private String brandId;//品牌id
    @Getter
    @Setter
    private String brandName;//品牌名称
    @Getter
    @Setter
    private String goodsId;//商品id
    @Getter
    @Setter
    private String goodsName;//商品名称
    @Getter
    @Setter
    private Integer isManual;//是否手动领取 0否，1是 
    @Getter
    @Setter
    private Integer isFirstlogin;//是否开启首次登陆 0否，1是 
    @Getter
    @Setter
    private java.util.Date startTime;//可领取有效开始时间
    @Getter
    @Setter
    private java.util.Date endTime;//可领取有效结束时间
    @Getter
    @Setter
    private java.util.Date beginDate;//优惠券使用有效开始时间
    @Getter
    @Setter
    private java.util.Date endDate;//优惠券使用有效结束时间
    @Getter
    @Setter
    private Integer delFlag;//逻辑删除标记 0：未删除 1：已删除
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

}