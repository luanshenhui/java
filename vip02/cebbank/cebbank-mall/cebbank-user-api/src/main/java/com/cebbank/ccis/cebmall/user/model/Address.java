package com.cebbank.ccis.cebmall.user.model;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@EqualsAndHashCode
public class Address implements Serializable {
	private static final long serialVersionUID = -5476090056354498704L;
	@Getter
	@Setter
	private Integer id;

	@Getter
	@Setter
	private Integer parentId;

	@Getter
	@Setter
	private String name;

	@Getter
	@Setter
	private Integer level;
}
