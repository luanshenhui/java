package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class EspCustSignModel implements Serializable {

	private static final long serialVersionUID = -1441886876344332241L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String custId;// 客户id
	@Getter
	@Setter
	private String cardno;// 卡号
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标记0未删除1已删除
}