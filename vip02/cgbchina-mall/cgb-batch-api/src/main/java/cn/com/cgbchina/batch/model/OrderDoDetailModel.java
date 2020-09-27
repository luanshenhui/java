package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
@Getter
@Setter
@ToString
public class OrderDoDetailModel implements Serializable {

	private static final long serialVersionUID = 5487755532651315679L;
	private Long id;// id
	private String orderId;// 订单号
	private java.util.Date doTime;// 处理时间
	private String doUserid;// 处理用户
	private String userType;// 用户类型0：系统用户[批量]1：内部用户[cc]2：供应商3：持卡人
	private String statusId;// 状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
	private String statusNm;// 状态名称
	private String msgContent;// 短信内容
	private String doDesc;// 处理备注
	private String ruleId;// 规则代码
	private String ruleNm;// 规则名称
	private String createOper;// 创建人
	private java.util.Date createTime;// 创建时间
	private String modifyOper;// 更新人
	private java.util.Date modifyTime;// 更新时间
	private Integer delFlag;// 逻辑删除标记为(0未删除，1已删除)
}