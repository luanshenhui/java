package cn.com.cgbchina.rest.visit.vo.user;

import java.io.Serializable;

public class EEA1InfoVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -986281512676271223L;
	private String pinBlock;
	private String rsaName;
	private String zakName;
	private String random;

	public String getPinBlock() {
		return pinBlock;
	}

	public void setPinBlock(String pinBlock) {
		this.pinBlock = pinBlock;
	}

	public String getRsaName() {
		return rsaName;
	}

	public void setRsaName(String rsaName) {
		this.rsaName = rsaName;
	}

	public String getZakName() {
		return zakName;
	}

	public void setZakName(String zakName) {
		this.zakName = zakName;
	}

	public String getRandom() {
		return random;
	}

	public void setRandom(String random) {
		this.random = random;
	}

}
