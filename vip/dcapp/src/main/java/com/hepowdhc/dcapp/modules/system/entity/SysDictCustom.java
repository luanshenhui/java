/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.system.entity;

import org.hibernate.validator.constraints.Length;
import javax.validation.constraints.NotNull;
import com.fasterxml.jackson.annotation.JsonBackReference;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 定制字典表Entity
 * @author dhc
 * @version 2017-01-09
 */
public class SysDictCustom extends DataEntity<SysDictCustom> {
	
	private static final long serialVersionUID = 1L;
	private String value;		// value
	private String label;		// label
	private String type;		// type
	private String description;		// description
	private Integer sort;		// sort
	private SysDictCustom parent;		// parent_id
	
	public SysDictCustom() {
		super();
	}

	public SysDictCustom(String id){
		super(id);
	}

	@Length(min=1, max=100, message="value长度必须介于 1 和 100 之间")
	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}
	
	@Length(min=1, max=100, message="label长度必须介于 1 和 100 之间")
	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}
	
	@Length(min=1, max=100, message="type长度必须介于 1 和 100 之间")
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	@Length(min=1, max=100, message="description长度必须介于 1 和 100 之间")
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
	
	@NotNull(message="sort不能为空")
	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}
	
	@JsonBackReference
	public SysDictCustom getParent() {
		return parent;
	}

	public void setParent(SysDictCustom parent) {
		this.parent = parent;
	}
	
}