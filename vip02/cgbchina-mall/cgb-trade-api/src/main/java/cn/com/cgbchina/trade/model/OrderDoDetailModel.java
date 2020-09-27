package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

public class OrderDoDetailModel implements Serializable {

	private static final long serialVersionUID = 5487755532651315679L;
	@Getter
	@Setter
	private Long id;// id
	@Getter
	@Setter
	private String orderId;// 订单号
	@Getter
	@Setter
	private java.util.Date doTime;// 处理时间
	@Getter
	@Setter
	private String doUserid;// 处理用户
	@Getter
	@Setter
	private String userType;// 用户类型0：系统用户[批量]1：内部用户[cc]2：供应商3：持卡人
	@Getter
	@Setter
	private String statusId;// 状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
	@Getter
	@Setter
	private String statusNm;// 状态名称
	@Getter
	@Setter
	private String msgContent;// 短信内容
	@Getter
	@Setter
	private String doDesc;// 处理备注
	@Getter
	@Setter
	private String ruleId;// 规则代码
	@Getter
	@Setter
	private String ruleNm;// 规则名称
	@Getter
	@Setter
	private String createOper;// 创建人
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
	private Integer delFlag;// 逻辑删除标记为(0未删除，1已删除)
}