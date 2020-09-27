package com.dpn.ciqqlc.http.form;

/**
 * 条件查询基础类
 * @author Administrator
 *
 */
public class QueryBaseIo {

	/**要查询的列名Key*/
	private String wName;
	
	/**要查询的列逻辑运算符号*/
	private String wOpera;
	
	/**要查询的列值*/
	private String wValue;
	
	/**
	 * key
	 */
	private String key;

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getwName() {
		return wName;
	}

	public void setwName(String wName) {
		this.wName = wName;
	}

	public String getwOpera() {
		return wOpera;
	}

	public void setwOpera(String wOpera) {
		this.wOpera = wOpera;
	}

	public String getwValue() {
		return wValue;
	}

	public void setwValue(String wValue) {
		this.wValue = wValue;
	}
}
