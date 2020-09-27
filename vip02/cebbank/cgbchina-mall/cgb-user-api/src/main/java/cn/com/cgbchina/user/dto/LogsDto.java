package cn.com.cgbchina.user.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class LogsDto implements Serializable {
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String shopType;// 平台类型 yg：广发商城，jf：积分商城
	@Getter
	@Setter
	private String action;// 操作动作(0 添加1删除3修改)
	@Getter
	@Setter
	private String user;// 操作用户
	@Getter
	@Setter
	private java.util.Date time;// 操作时间
	@Getter
	@Setter
	private String content;// 操作内容
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标记 0：未删除 1：已删除
	@Getter
	@Setter
	private String creatOper;// 创建人
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
	private String startTime;
	@Getter
	@Setter
	private String endTime;
	@Getter
	@Setter
	private String shopTypeName;
	@Getter
	@Setter
	private String actionName;

}