package cn.com.cgbchina.user.dto;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by Tanliang on 16-5-23.
 */
public class PersonalMessageDto {
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String custId;// 会员编号
	@Getter
	@Setter
	private String type;// 消息类型0交易动态1售后信息2促销活动
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
	private java.util.Date createDate;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 更新人
	@Getter
	@Setter
	private java.util.Date modifyTime;// 更新时间
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标记0未删除1已删除
	@Getter
	@Setter
	private String userType;// 用户类型01商家中心02会员03内管
	@Getter
	@Setter
	private String typeName; // 消息类型0交易动态1售后信息2促销活动
}
