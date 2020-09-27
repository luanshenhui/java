package cn.com.cgbchina.rest.visit.model.user;

import java.io.Serializable;

public class EEA6Info implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4539035788047792730L;
	private String pinByPK;
	private String keyName;
	private String zpkName;
	private String pan;
	private String random;

	public String getPinByPK() {
		return pinByPK;
	}

	public void setPinByPK(String pinByPK) {
		this.pinByPK = pinByPK;
	}

	public String getKeyName() {
		return keyName;
	}

	public void setKeyName(String keyName) {
		this.keyName = keyName;
	}

	public String getZpkName() {
		return zpkName;
	}

	public void setZpkName(String zpkName) {
		this.zpkName = zpkName;
	}

	public String getPan() {
		return pan;
	}

	public void setPan(String pan) {
		this.pan = pan;
	}

	public String getRandom() {
		return random;
	}

	public void setRandom(String random) {
		this.random = random;
	}

}
