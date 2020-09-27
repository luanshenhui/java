package com.cebbank.ccis.cebmall.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class TblParametersModel implements Serializable {

	private static final long serialVersionUID = 1479023662491134177L;
	@Getter
	@Setter
	private Long parametersId;// 自增主键
	@Getter
	@Setter
	private Integer parametersType;// 业务类型 0:登陆 2:支付
	@Getter
	@Setter
	private String parametersTypeNm;// 业务类型名 0:登陆 2:支付
	@Getter
	@Setter
	private String ordertypeId;// 子业务类型 dq:登录启停 db:登录白名单 yg:广发商城 jf:积分商城
	@Getter
	@Setter
	private String ordertypeIdNm;// 子业务类型名
	@Getter
	@Setter
	private String sourceId;// 渠道 00:web 01:call center 02:ivr 03:手机渠道
	@Getter
	@Setter
	private String sourceIdNm;// 渠道名称
	@Getter
	@Setter
	private String prompt;//提示语
	@Getter
	@Setter
	private Integer openCloseFlag;// 启动停止标示 0:启动 1:停止
	@Getter
	@Setter
	private Integer isPrompt;// 是否需要提示语 0:不需要 1:需要
	@Getter
	@Setter
	private String extend1;// 保留1
	@Getter
	@Setter
	private String extend2;// 保留2
	@Getter
	@Setter
	private String extend3;// 保留3
}