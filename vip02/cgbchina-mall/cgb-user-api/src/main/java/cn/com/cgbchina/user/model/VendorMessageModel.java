package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class VendorMessageModel implements Serializable {

	private static final long serialVersionUID = -1527810741996821064L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String vendorId;// 供应商编号
	@Getter
	@Setter
	private String type;// 消息类型0交易动态1评价动态2逆向交易3物流动态4系统消息
	@Getter
	@Setter
	private String content;// 消息内容
	@Getter
	@Setter
	private String isRead;// 是否已读0未读1已读
	@Getter
	@Setter
	private java.util.Date pushTime;// 推送时间
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
	private String orderId;// 子订单号
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标记0未删除1已删除
}