package cn.com.cgbchina.rest.visit.model.user;

import java.io.Serializable;

public class EEA1Info implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -986281512676271223L;
	private String pinBlock;
	//private String rsaName;
	//private String zakName;
	private String random;
	public String getPinBlock() {
		return pinBlock;
	}
	public void setPinBlock(String pinBlock) {
		this.pinBlock = pinBlock;
	}
	public String getRandom() {
		return random;
	}
	public void setRandom(String random) {
		this.random = random;
	}
 
	
}
