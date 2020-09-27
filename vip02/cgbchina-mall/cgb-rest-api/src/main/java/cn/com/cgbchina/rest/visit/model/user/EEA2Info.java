package cn.com.cgbchina.rest.visit.model.user;

import java.io.Serializable;

public class EEA2Info implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -986281512676271223L;
	private String pinBlock;
	private String rsaName;
	private String pan;
	private String zpk;
	private String random;

	public String getPan() {
		return pan;
	}

	public void setPan(String pan) {
		this.pan = pan;
	}

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

	public String getZpk() {
		return zpk;
	}

	public void setZpk(String zpk) {
		this.zpk = zpk;
	}

	public String getRandom() {
		return random;
	}

	public void setRandom(String random) {
		this.random = random;
	}

}
