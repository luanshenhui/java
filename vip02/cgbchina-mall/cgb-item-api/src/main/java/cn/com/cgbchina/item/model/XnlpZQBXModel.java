package cn.com.cgbchina.item.model;

import java.io.Serializable;
import java.sql.Date;

import lombok.Getter;
import lombok.Setter;

public class XnlpZQBXModel implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4984963850388170168L;
	@Getter
	@Setter
	private String custName;//
	@Getter
	@Setter
	private String cardType;//
	@Getter
	@Setter
	private String certNbr;//
	@Getter
	@Setter
	private String card4;//
	@Getter
	@Setter
	private String serverStart;//
	@Getter
	@Setter
	private String serverEnd;//
	@Getter
	@Setter
	private String desc;//
	@Getter
	@Setter
	private String type;//
	@Getter
	@Setter
	private String hisUpdateInd;//
	@Getter
	@Setter
	private Date txDate;//
}