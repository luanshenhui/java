package com.dpn.ciqqlc.webservice.vo;

import javax.xml.bind.annotation.XmlAccessType;  
import javax.xml.bind.annotation.XmlAccessorType;  
import javax.xml.bind.annotation.XmlRootElement;  
import javax.xml.bind.annotation.XmlType;  
  
/** 
 * 注解：@XmlRootElement-指定XML根元素名称（可选）  
 *           @XmlAccessorType-控制属性或方法序列化 ， 四种方案：  
 *                      FIELD-对每个非静态，非瞬变属性JAXB工具自动绑定成XML，除非注明XmlTransient  
 *                      NONE-不做任何处理  
 *                      PROPERTY-对具有set/get方法的属性进行绑定，除非注明XmlTransient  
 *                      PUBLIC_MEMBER -对有set/get方法的属性或具有共公访问权限的属性进行绑定，除非注 明XmlTransient  
 *           @XmlType-映射一个类或一个枚举类型成一个XML Schema类型 
 * 
 */  
  
@XmlRootElement(name="serviceResult")  
@XmlAccessorType(XmlAccessType.FIELD)  
@XmlType(propOrder={"status", "result"})  
public class ServiceResult {
	/**
	 * 0成功 1失败
	 */
	private String status;
	
	/**
	 * 异常原因
	 */
	private String result;

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}
	
}
