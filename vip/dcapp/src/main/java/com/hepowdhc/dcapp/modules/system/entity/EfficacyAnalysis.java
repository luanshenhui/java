/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.system.entity;

/**
 * 效能分析Entity
 * 
 * @author zhengwei.cui
 * @version 2016-12-26
 */
public class EfficacyAnalysis {
	private String type; // 类型
	private String efficacyName; // 效能名
	private String efficacyValue; // 效能值
	private String green; // 绿色临界值
	private String yellow; // 黄色临界值
	private String orange;// 橙色临界值
	private String red;// 红色临界值

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getEfficacyName() {
		return efficacyName;
	}

	public void setEfficacyName(String efficacyName) {
		this.efficacyName = efficacyName;
	}

	public String getEfficacyValue() {
		return efficacyValue;
	}

	public void setEfficacyValue(String efficacyValue) {
		this.efficacyValue = efficacyValue;
	}

	public String getGreen() {
		return green;
	}

	public void setGreen(String green) {
		this.green = green;
	}

	public String getYellow() {
		return yellow;
	}

	public void setYellow(String yellow) {
		this.yellow = yellow;
	}

	public String getOrange() {
		return orange;
	}

	public void setOrange(String orange) {
		this.orange = orange;
	}

	public String getRed() {
		return red;
	}

	public void setRed(String red) {
		this.red = red;
	}
}
