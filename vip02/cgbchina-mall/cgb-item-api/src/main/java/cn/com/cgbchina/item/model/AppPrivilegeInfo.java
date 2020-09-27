package cn.com.cgbchina.item.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 
 */
public class AppPrivilegeInfo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1477750345759122368L;
	@Getter
	@Setter
	private String privilegeId;
	@Getter
	@Setter
	private String privilegeName;
	@Getter
	@Setter
	private String projectNO;
	@Getter
	@Setter
	private Double liquidateRatio;
	@Getter
	@Setter
	private Double privilegeMoney;
	@Getter
	@Setter
	private String useActivatiState;
	@Getter
	@Setter
	private String pastDueState;
	@Getter
	@Setter
	private Double limitMoney;
	@Getter
	@Setter
	private String regulation;
	@Getter
	@Setter
	private String beginDate;
	@Getter
	@Setter
	private String endDate;
}
