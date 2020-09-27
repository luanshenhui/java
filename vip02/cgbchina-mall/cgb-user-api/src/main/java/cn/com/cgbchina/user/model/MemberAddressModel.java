package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class MemberAddressModel implements Serializable {

    private static final long serialVersionUID = -2553080315467943825L;
    @Getter
    @Setter
    private Long id;//
    @Getter
    @Setter
    private String custId;// 会员编号
    @Getter
    @Setter
    private String consignee;// 收货人
    @Getter
    @Setter
    private String provinceId;// 省id
    @Getter
    @Setter
    private String provinceName;// 省名称
    @Getter
    @Setter
    private String cityId;// 市id
    @Getter
    @Setter
    private String cityName;// 市名称
    @Getter
    @Setter
    private String areaId;// 区县id
    @Getter
    @Setter
    private String areaName;// 区县名称
    @Getter
    @Setter
    private String address;// 详细地址
    @Getter
    @Setter
    private String postcode;// 邮编
    @Getter
    @Setter
    private String telephone;// 联系电话
    @Getter
    @Setter
    private String mobile;// 手机号

    @Getter
    @Setter
    private String idCard;//证件号码（广发微信商城需求增加）

    @Getter
    @Setter
    private Integer csgSeq;//顺序

    @Getter
    @Setter
    private String csgEmail;//邮箱

    @Getter
    @Setter
    private String isDefault;// 是否默认地址(0是1否)
    @Getter
    @Setter
    private String creatOper;// 创建人
    @Getter
    @Setter
    private java.util.Date createTime;// 创建时间
    @Getter
    @Setter
    private String modifyOper;// 更新人
    @Getter
    @Setter
    private java.util.Date modifyTime;// 更新时间
    @Getter
    @Setter
    private String delFlag;// 逻辑删除标记0未删除1已删除
}