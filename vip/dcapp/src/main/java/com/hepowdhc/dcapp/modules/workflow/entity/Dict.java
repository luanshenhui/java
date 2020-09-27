package com.hepowdhc.dcapp.modules.workflow.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;

public class Dict extends DataEntity<Dict> {
	private String value;
	private String label;

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
}
