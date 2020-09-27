package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Date;

public class VendorInfoModel implements Serializable {

	private static final long serialVersionUID = -2322322955245995072L;
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
	@Getter
	@Setter
	private String provinceId;// 省id（增加字段）
	@Getter
	@Setter
	private String province;// 省（增加字段）
	@Getter
	@Setter
	private String cityId;// 城市id（增加字段）
	@Getter
	@Setter
	private String city;// 城市（增加字段）
	@Getter
	@Setter
	private String areaId;// 区id（增加字段）
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
	private String debtMan;// 负责人（未用）
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
	private String serviceTime;// 供应商服务时间
	@Getter
	@Setter
	private String specShopno;// 特店号（未用）
	@Getter
	@Setter
	private String specShopnoType;// 特店类型（未用)1-供应商唯一特店2-供应商分期特店
	@Getter
	@Setter
	private String bankNo;// 银行号
	@Getter
	@Setter
	private String payCode;// 缴款方案代码（未用）
	@Getter
	@Setter
	private String prodCode;// 分期产品代码（未用）
	@Getter
	@Setter
	private String planCode;// 分期计划代码（未用）
	@Getter
	@Setter
	private String stagesDesc;// 分期描述（未用）
	@Getter
	@Setter
	private String mcc;// MCC（未用）
	@Getter
	@Setter
	private java.math.BigDecimal fixFee;// 固定费用（未用）
	@Getter
	@Setter
	private String netStatus;// 供应商端登录（未用） 0101：未启用0102：已启用
	@Getter
	@Setter
	private String rightCode;// 权限位
	@Getter
	@Setter
	private String vendorDesc;// 供应商备注（未用）
	@Getter
	@Setter
	private String vendorType;// 类型（增加字段）
	@Getter
	@Setter
	private String createOper;// 创建者
	@Getter
	@Setter
	private String modifyOper;// 修改者
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
	@Getter
	@Setter
	private String reserved1;// 保留字段一
	@Getter
	@Setter
	private String eposVendorId;// EPOS_VENDOR_ID(未用)
	@Getter
	@Setter
	private java.math.BigDecimal maximumAmt;// MAXIMUM_AMT(未用)
	@Getter
	@Setter
	private String vendorNo;// 合作商代码
	@Getter
	@Setter
	private String actionFlag;// 是否实时推送标志 00：实时推送 01:批量推送
	@Getter
	@Setter
	private Long outSystemId;// 绑定o2o商户id对应vendorinf_outsystem表中的id
	@Getter
	@Setter
	private String isSecKill;// 是否0元秒杀0-0元秒杀1-其他
	@Getter
	@Setter
	private String virtualVendorId;//
	@Getter
	@Setter
	private String vendorTime;//
	@Getter
	@Setter
	private String delFlag;// 删除标志0-未删除1-删除
	@Getter
	@Setter
	private String orderStageCode;// 邮购分期类别码
	@Getter
	@Setter
	private String diffinfoForUpdate;// 在未审核状态下，不能把信息更新到DB下，所以将修改信息暂时保存
}