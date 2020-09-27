/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-7-20.
 */
public class VendorInfoUploadDto implements Serializable{

    private static final long serialVersionUID = -4628582624665168076L;

    @Getter
    @Setter
    private String uploadFlag; // 导入成功标识
    @Getter
    @Setter
    private String uploadFailedReason;//失败原因
    @Getter
    @Setter
    private String vendorId;// 供应商代码
    @Getter
    @Setter
    private String merId;// 商户号
    @Getter
    @Setter
    private String fullName;// 供应商全称
    @Getter
    @Setter
    private String simpleName;// 供应商简称
    @Getter
    @Setter
    private String taxCode;// 纳税登记号（增加字段）
    @Getter
    @Setter
    private String businessTypeId;// 业务类型id
    @Getter
    @Setter
    private String payCondition;// 付款条件（增加字段）
    @Getter
    @Setter
    private String payGroup;// 支付组（增加字段）
    @Getter
    @Setter
    private java.math.BigDecimal commision;// 佣金率
    @Getter
    @Setter
    private String payWay;// 付款方法（增加字段）
    @Getter
    @Setter
    private String payCurrency;// 付款币种（增加字段）
    @Getter
    @Setter
    private String freightTip;// 运费条款（增加字段）
    @Getter
    @Setter
    private String feeType;// 收取方式 1：按月收取 2：按季收取 3：按年收取 4：一次性收取
/*    @Getter
    @Setter
    private String provinceId;// 省id（增加字段）*/
    @Getter
    @Setter
    private String province;// 省（增加字段）
/*    @Getter
    @Setter
    private String cityId;// 城市id（增加字段）*/
    @Getter
    @Setter
    private String city;// 城市（增加字段）
/*    @Getter
    @Setter
    private String areaId;// 区id（增加字段）*/
    @Getter
    @Setter
    private String area;// 区（增加字段）
    @Getter
    @Setter
    private String cooperAddress;// 合作商地址
    @Getter
    @Setter
    private String enterpriseAddress;// 企业地址（增加字段）
    @Getter
    @Setter
    private String postCode;// 邮政编码（增加字段）
    @Getter
    @Setter
    private String payAddress;// 用于支付地点（增加字段）
    @Getter
    @Setter
    private String buyAddress;// 用于采购地点（增加字段）
    @Getter
    @Setter
    private String payConditionAddress;// 付款条件地点（增加字段）
    @Getter
    @Setter
    private String payGroupAddress;// 支付组地点（增加字段）
    @Getter
    @Setter
    private String address;// 地址
    @Getter
    @Setter
    private String debtAccount;// 负债账户（增加字段）
    @Getter
    @Setter
    private String prepayAccount;// 预付款账户（增加字段）
    @Getter
    @Setter
    private String contact;// 联系人
    @Getter
    @Setter
    private String phone;// 客服咨询电话
    @Getter
    @Setter
    private String contactTax;// 联系人传真（增加字段）
    @Getter
    @Setter
    private String email;// EMAIL
    @Getter
    @Setter
    private String invoice;// 发票匹配选项（增加字段）
    @Getter
    @Setter
    private String accBank;// 供应商开户银行（未用）
    @Getter
    @Setter
    private String accNo;// 供应商开户账号
    @Getter
    @Setter
    private String status;// 当前状态 0101：未启用 0102：已启用
    @Getter
    @Setter
    private String vendorRole;// 合作商角色（增加字段）
    @Getter
    @Setter
    private String unionPayNo;// 银联商户号
    @Getter
    @Setter
    private String vendorNo;// 供应商代码
    @Getter
    @Setter
    private String specShopno;// 特店号（未用）
    @Getter
    @Setter
    private String serviceTime;// 供应商服务时间

}
