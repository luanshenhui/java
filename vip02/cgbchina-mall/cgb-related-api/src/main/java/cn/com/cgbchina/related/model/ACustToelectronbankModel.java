package cn.com.cgbchina.related.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class ACustToelectronbankModel implements Serializable {
	@Getter
	@Setter
	private java.util.Date dataDt;// 日期
	@Getter
	@Setter
	private String certNbr;// 证件号码
	@Getter
	@Setter
	private String cardLevelCd;// 卡等级代码
	@Getter
	@Setter
	private String vipTpCd;// 客户vip标志
	@Getter
	@Setter
	private java.util.Date birthDay;// 生日日期
	@Getter
	@Setter
	private String custAddr;// 账单地址
	@Getter
	@Setter
	private java.util.Date etlSysDttime;//
	@Getter
	@Setter
	private String engName;// 英文名称
	@Getter
	@Setter
	private String incrInd;//
	@Getter
	@Setter
	private String hisAddInd;//
	@Getter
	@Setter
	private String hisUpdateInd;//
	@Getter
	@Setter
	private java.util.Date txDate;//
}