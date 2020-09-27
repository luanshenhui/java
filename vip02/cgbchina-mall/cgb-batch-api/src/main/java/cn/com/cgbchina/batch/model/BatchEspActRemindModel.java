package cn.com.cgbchina.batch.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class BatchEspActRemindModel implements Serializable {

	private static final long serialVersionUID = 8528536969354907045L;
	@Getter
	@Setter
	private Long id;// 自增主键
	@Getter
	@Setter
	private Long actId;// 活动id
	@Getter
	@Setter
	private String goodsId;// 商品id
	@Getter
	@Setter
	private String custId;// 客户id
	@Getter
	@Setter
	private java.util.Date mesDatetime;// 提醒时间
	@Getter
	@Setter
	private String custMobile;// 客户手机号
	@Getter
	@Setter
	private String ordertypeId;// 业务类型代码
	@Getter
	@Setter
	private java.util.Date sendDatetime;// 发送时间
	@Getter
	@Setter
	private String sendFlag;// 是否发送
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标记 0：未删除 1：已删除
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
}