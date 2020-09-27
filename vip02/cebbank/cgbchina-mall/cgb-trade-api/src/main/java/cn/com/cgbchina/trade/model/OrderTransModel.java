package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

public class OrderTransModel implements Serializable {

	private static final long serialVersionUID = 1080609136012028006L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String orderId;// 子订单号
	@Getter
	@Setter
	private String transcorpNm;// 物流公司名称
	@Getter
	@Setter
	private String mailingNum;// 货单号
	@Getter
	@Setter
	private String mailingMan;// 物流公司投递员
	@Getter
	@Setter
	private String mailingMobile;// 投递员手机号码
	@Getter
	@Setter
	private String servicePhone;// 客服电话
	@Getter
	@Setter
	private String serviceUrl;// 客服网址
	@Getter
	@Setter
	private String doDesc;// 处理描述
	@Getter
	@Setter
	private java.util.Date doTime;// 发货时间
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String reserved1;// 保留字段一
	@Getter
	@Setter
	private Long vendorTranscorpId;//
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标记为(0未删除，1已删除)
	@Getter
	@Setter
	private String modifyOper;// 更新人
	@Getter
	@Setter
	private java.util.Date modifyTime;// 更新时间
}