package cn.com.cgbchina.promotion.dto;

import lombok.Getter;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/13.
 */
public class AdminPromotionAddDto implements Serializable {

	private static final long serialVersionUID = 8377539120872685930L;
	@Getter
	@Setter
	private String id;// 活动ID
	@Getter
	@Setter
	@NotNull
	private String name;// 活动名称
	@Getter
	@Setter
	@NotNull
	private String shortName;// 简称
	@Getter
	@Setter
	@NotNull
	private Integer promType;// 活动类型 10 折扣 20 满减 30 秒杀 40 团购 50 荷兰拍
	@Getter
	@Setter
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	@NotNull
	private java.util.Date beginDate;// 开始时间
	@Getter
	@Setter
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	@NotNull
	private java.util.Date endDate;// 结束时间
	@Getter
	@Setter
	private String loopType;// 循环类型,值为d 按天循环;w 按星期循环；m 按月循环
	@Getter
	@Setter
	private String loopData;// 循环数据,格式为选中项目序号使用,分割的字符串，例如【0,3】，表示第1项和第四项被选中
	@Getter
	@Setter
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private java.util.Date loopBeginTime1;// 循环开始时间1
	@Getter
	@Setter
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private java.util.Date loopEndTime1;// 循环结束时间1
	@Getter
	@Setter
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private java.util.Date loopBeginTime2;// 循环开始时间2
	@Getter
	@Setter
	@DateTimeFormat(pattern = "yyyy-MM-dd")
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
	@NotNull
	private String sourceId;// 销售渠道（00商城，01CC，02IVR，03手机商城，04短信，05微信广发银行，06微信广发信用卡，09 APP）格式：||01||02||
	@Getter
	@Setter
	private String description;// 内容介绍
	@Getter
	@Setter
	private Integer checkStatus;// 活动状态(添加(未提交审批) 0; 编辑(未提交审批) 1;已提交(待审批) 2;已提交(已审批通过) 3;
	// 已提交(未审批通过) 4;正在进行 5;已停止[活动执行过&结束时间小于当前时间] 6;已取消 7;已失效[结束时间小于当前时间] 8;)
	@Getter
	@Setter
	private String beginEntryDate;// 报名开始时间
	@Getter
	@Setter
	private String endEntryDate;// 报名结束时间

	@Getter
	@Setter
	private String range;//活动范围

	@Getter
	@Setter
	private String fullCut;// 满减规则的json串 不是此类型 留空
	@Getter
	@Setter
	private String saveType;

}
