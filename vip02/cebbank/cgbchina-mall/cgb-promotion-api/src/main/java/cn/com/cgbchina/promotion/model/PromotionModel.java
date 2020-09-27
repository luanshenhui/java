package cn.com.cgbchina.promotion.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class PromotionModel implements Serializable {

	private static final long serialVersionUID = 3759745030865167671L;
	@Getter
	@Setter
	private Integer id;// 活动ID
	@Getter
	@Setter
	private String ordertypeId;// 业务类型代码YG：广发JF：积分
	@Getter
	@Setter
	private String promCode;// 活动编号
	@Getter
	@Setter
	private String name;// 活动名称
	@Getter
	@Setter
	private String shortName;// 简称
	@Getter
	@Setter
	private Integer promType;// 活动类型 10 折扣 20 满减 30 秒杀 40 团购 50 荷兰拍
	@Getter
	@Setter
	private Integer isSignup;// 是否需报名活动 0否 1是
	@Getter
	@Setter
	private java.util.Date beginDate;// 开始时间
	@Getter
	@Setter
	private java.util.Date endDate;// 结束时间
	@Getter
	@Setter
	private String loopType;// 循环类型,值为d 按天循环;w 按星期循环；m 按月循环
	@Getter
	@Setter
	private String loopData;// 循环数据,格式为选中项目序号使用,分割的字符串，例如【0,3】，表示第1项和第四项被选中
	@Getter
	@Setter
	private java.util.Date loopBeginTime1;// 循环开始时间1
	@Getter
	@Setter
	private java.util.Date loopEndTime1;// 循环结束时间1
	@Getter
	@Setter
	private java.util.Date loopBeginTime2;// 循环开始时间2
	@Getter
	@Setter
	private java.util.Date loopEndTime2;// 循环结束时间2
	@Getter
	@Setter
	private java.math.BigDecimal ruleDiscountRate;// 折扣比例
	@Getter
	@Setter
	private Integer ruleLimitBuyCount;// 限购数量
	@Getter
	@Setter
	private Integer ruleLimitBuyType;// 限购种类，0 单日内限购，1 整个活动限购
	@Getter
	@Setter
	private Integer ruleFrequency;// 降价频率
	@Getter
	@Setter
	private Integer ruleLimitTicket;// 可拍次数
	@Getter
	@Setter
	private Integer ruleGroupCount;// 每组商品数
	@Getter
	@Setter
	private Integer ruleMinPay1;// 满减优惠阶梯1（满）
	@Getter
	@Setter
	private Integer ruleMinPay2;// 满减优惠阶梯2（满）
	@Getter
	@Setter
	private Integer ruleMinPay3;// 满减优惠阶梯3（满）
	@Getter
	@Setter
	private Integer ruleMinPay4;// 满减优惠阶梯4（满）
	@Getter
	@Setter
	private Integer ruleMinPay5;// 满减优惠阶梯5（满）
	@Getter
	@Setter
	private Integer ruleMinPay6;// 满减优惠阶梯6（满）
	@Getter
	@Setter
	private Integer ruleMinPay7;// 满减优惠阶梯7（满）
	@Getter
	@Setter
	private Integer ruleMinPay8;// 满减优惠阶梯8（满）
	@Getter
	@Setter
	private Integer ruleMinPay9;// 满减优惠阶梯9（满）
	@Getter
	@Setter
	private Integer ruleMinPay10;// 满减优惠阶梯10（满）
	@Getter
	@Setter
	private Integer ruleFee1;// 满减优惠阶梯1（减）
	@Getter
	@Setter
	private Integer ruleFee2;// 满减优惠阶梯2（减）
	@Getter
	@Setter
	private Integer ruleFee3;// 满减优惠阶梯3（减）
	@Getter
	@Setter
	private Integer ruleFee4;// 满减优惠阶梯4（减）
	@Getter
	@Setter
	private Integer ruleFee5;// 满减优惠阶梯5（减）
	@Getter
	@Setter
	private Integer ruleFee6;// 满减优惠阶梯6（减）
	@Getter
	@Setter
	private Integer ruleFee7;// 满减优惠阶梯7（减）
	@Getter
	@Setter
	private Integer ruleFee8;// 满减优惠阶梯8（减）
	@Getter
	@Setter
	private Integer ruleFee9;// 满减优惠阶梯9（减）
	@Getter
	@Setter
	private Integer ruleFee10;// 满减优惠阶梯10（减）
	@Getter
	@Setter
	private String sourceId;// 销售渠道（00商城，01CC，02IVR，03手机商城，04短信，05微信广发银行，06微信广发信用卡，09 APP）格式：||01||02||
	@Getter
	@Setter
	private String description;// 内容介绍
	@Getter
	@Setter
	private String feeRule;// 优惠规则，JSON串
	@Getter
	@Setter
	private Integer checkStatus;// 活动状态(添加(未提交审批) 0; 编辑(未提交审批) 1;已提交(待审批) 2;已提交(已审批通过) 3;已提交(未审批通过) 4;正在进行
								// 5;已停止[活动执行过&结束时间小于当前时间] 6;已取消 7;已失效[结束时间小于当前时间] 8;)
	@Getter
	@Setter
	private java.util.Date beginEntryDate;// 报名开始时间
	@Getter
	@Setter
	private java.util.Date endEntryDate;// 报名结束时间
	@Getter
	@Setter
	private Integer createOperType;// 创建人类型
	@Getter
	@Setter
	private Integer modifyOperType;// 修改人类型
	@Getter
	@Setter
	private String auditLog;// 审核日志
	@Getter
	@Setter
	private String auditOper;// 审核人
	@Getter
	@Setter
	private java.util.Date auditDate;// 最终审核日期
	@Getter
	@Setter
	private Integer isValid;// 有效状态：0删除，1正常
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 修改人
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
	@Setter
	@Getter
	private Integer rangeCount;//选品总数
	@Setter
	@Getter
	private Integer auditRangeCount;//通过审核的选品数
}