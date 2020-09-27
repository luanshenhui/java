package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

public class CCAddOrderByCgbPropAdd implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4830942615671123528L;
	private String propType;
	private String propSubtype;
	private String propValue;
	private String propOwner;
	private String propMemo;

	public String getPropType() {
		return propType;
	}

	public void setPropType(String propType) {
		this.propType = propType;
	}

	public String getPropSubtype() {
		return propSubtype;
	}

	public void setPropSubtype(String propSubtype) {
		this.propSubtype = propSubtype;
	}

	public String getPropValue() {
		return propValue;
	}

	public void setPropValue(String propValue) {
		this.propValue = propValue;
	}

	public String getPropOwner() {
		return propOwner;
	}

	public void setPropOwner(String propOwner) {
		this.propOwner = propOwner;
	}

	public String getPropMemo() {
		return propMemo;
	}

	public void setPropMemo(String propMemo) {
		this.propMemo = propMemo;
	}

}
