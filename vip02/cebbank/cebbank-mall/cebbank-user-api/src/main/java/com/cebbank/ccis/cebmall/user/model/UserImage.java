package com.cebbank.ccis.cebmall.user.model;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Date;

@EqualsAndHashCode
public class UserImage implements Serializable {

	private static final long serialVersionUID = -1243485028985616187L;
	@Getter
	@Setter
	private Long id;

	@Getter
	@Setter
	private String userId;

	@Getter
	@Setter
	private String category;

	@Getter
	@Setter
	private String fileName;

	@Getter
	@Setter
	private Integer fileSize;

	@Getter
	@Setter
	private Date createdAt;

}
