package com.hepowdhc.dcapp.modules.system.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

public class SysDict extends DataEntity<SysDict> {
	
	private static final long serialVersionUID = 1L;
	private String value;		// value
	private String label;		// label
	private String type;		// type
	private String description;		// description
	private String delflag;		
	
	public SysDict() {
		super();
	}
	public SysDict(String value, String label, String type, String description, String delflag) {
		super();
		this.value = value;
		this.label = label;
		this.type = type;
		this.description = description;
		this.delflag = delflag;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getLabel() {
		return label;
	}
	public void setLabel(String label) {
		this.label = label;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getDelflag() {
		return delflag;
	}
	public void setDelflag(String delflag) {
		this.delflag = delflag;
	}
	
	

}
