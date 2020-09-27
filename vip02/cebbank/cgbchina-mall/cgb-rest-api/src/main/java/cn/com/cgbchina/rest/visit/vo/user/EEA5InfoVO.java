package cn.com.cgbchina.rest.visit.vo.user;

import java.io.Serializable;

public class EEA5InfoVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4539035788047792730L;
	private String pinByPK;
	private String keyName;
	private String zakName;
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
