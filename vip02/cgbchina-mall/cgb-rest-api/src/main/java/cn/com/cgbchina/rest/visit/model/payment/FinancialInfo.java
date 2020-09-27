package cn.com.cgbchina.rest.visit.model.payment;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

import java.io.Serializable;

public class FinancialInfo implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 5886189669968151178L;
	private String propType;
	private String propSubType;
	private String propOwner;
	private String propValue;
	private String propMemo;

	public String getPropType() {
		return propType;
	}

	public void setPropType(String propType) {
		this.propType = propType;
	}

	public String getPropSubType() {
		return propSubType;
	}

	public void setPropSubType(String propSubType) {
		this.propSubType = propSubType;
	}

	public String getPropOwner() {
		return propOwner;
	}

	public void setPropOwner(String propOwner) {
		this.propOwner = propOwner;
	}

	public String getPropValue() {
		return propValue;
	}

	public void setPropValue(String propValue) {
		this.propValue = propValue;
	}

	public String getPropMemo() {
		return propMemo;
	}

	public void setPropMemo(String propMemo) {
		this.propMemo = propMemo;
	}

}
