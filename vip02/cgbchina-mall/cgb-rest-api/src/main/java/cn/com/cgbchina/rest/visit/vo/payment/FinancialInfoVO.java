package cn.com.cgbchina.rest.visit.vo.payment;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

public class FinancialInfoVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 5886189669968151178L;
	@XMLNodeName("PROPTYPE")
	private String propType;
	@XMLNodeName("PROPSUBTYPE")
	private String propSubType;
	@XMLNodeName("PROPOWNER")
	private String propOwner;
	@XMLNodeName("PROPVALUE")
	private String propValue;
	@XMLNodeName("PROPMEMO")
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
