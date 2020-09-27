package cn.com.cgbchina.promotion.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/14.
 */
public class AdminPromotionQueryDto implements Serializable {
	@Getter
	@Setter
	private Integer id;// 活动ID
	@Getter
	@Setter
	private String shopType;// 系统编号 yg 广发商城 jf积分商城
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
	private String loopJob;// 存储为JSON格式，其中【loopType】的值为d 按天循环;w 按星期循环；m
							// 按月循环例子：{"loop_type":"m","data":"1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31","begin_time":"10:30:30","end_time":"11:30:30"}
	@Getter
	@Setter
	private String channelTypes;// 销售渠道（0 WEB商城，1 APP商城）格式：||01||02||
	@Getter
	@Setter
	private String description;// 内容介绍
	@Getter
	@Setter
	private String feeRule;// 优惠规则，JSON串
	@Getter
	@Setter
	private Integer checkStatus;// 活动状态(添加(未提交审批) 0;
	// 编辑(未提交审批) 1;已提交(待审批) 2;
	// 已提交(已审批通过) 3;已提交(未审批通过)
	// 4;正在进行 5;已停止[活动执行过&结束时间小于当前时间] 6;已取消 7;已失效[结束时间小于当前时间] 8;)
	@Getter
	@Setter
	private Integer isValid;// 有效状态：0删除，1正常
	@Getter
	@Setter
	private java.util.Date beginEntryDate;// 报名开始时间
	@Getter
	@Setter
	private java.util.Date endEntryDate;// 报名结束时间
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
	private Integer createOperType;// 创建人类型 0内管 1供应商

}
