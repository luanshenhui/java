package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

public class CCAddOrderByCgbPropAddVO implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8740378802355626908L;
	@XMLNodeName(value="PROPTYPE")
	private String propType;
	@XMLNodeName(value="PROPSUBTYPE")
	private String propSubtype;
	@XMLNodeName(value="PROPVALUE")
	private String propValue;
	@XMLNodeName(value="PROPOWNER")
	private String propOwner;
	@XMLNodeName(value="PROPMEMO")
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
