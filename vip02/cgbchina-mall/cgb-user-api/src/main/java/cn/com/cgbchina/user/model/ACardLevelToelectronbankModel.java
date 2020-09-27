package cn.com.cgbchina.user.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class ACardLevelToelectronbankModel implements Serializable {

	private static final long serialVersionUID = 3941150349631883589L;
	@Getter
	@Setter
	private java.util.Date dataDt;
	@Getter
	@Setter
	private String cardLevelNbr;
	@Getter
	@Setter
	private String cardLevelDesc;
	@Getter
	@Setter
	private String etlSysDttime;
	@Getter
	@Setter
	private String hisUpdateInd;
	@Getter
	@Setter
	private String txDate;
}
