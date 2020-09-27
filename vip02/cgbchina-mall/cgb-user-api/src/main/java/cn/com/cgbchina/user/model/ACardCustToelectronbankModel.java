package cn.com.cgbchina.user.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class ACardCustToelectronbankModel implements Serializable {

	private static final long serialVersionUID = -8052771333857715179L;
	@Getter
	@Setter
	private java.util.Date dataDt;// 日期
	@Getter
	@Setter
	private String cardNbr;// 卡号
	@Getter
	@Setter
	private String custNbr;// 客户号
	@Getter
	@Setter
	private String bankNbr;// 分行号
	@Getter
	@Setter
	private String cardTpCd;// 卡类代码
	@Getter
	@Setter
	private String cardFormatNbr;// 卡板代码
	@Getter
	@Setter
	private String cardLevelCd;// 卡等级代码
	@Getter
	@Setter
	private java.util.Date birthDay;// 生日日期
	@Getter
	@Setter
	private String certNbr;// 证件号码
	@Getter
	@Setter
	private String etlSysDttime;
	@Getter
	@Setter
	private String incrInd;
	@Getter
	@Setter
	private String hisAddInd;
	@Getter
	@Setter
	private String hisUpdateInd;
	@Getter
	@Setter
	private String txDate;
}
