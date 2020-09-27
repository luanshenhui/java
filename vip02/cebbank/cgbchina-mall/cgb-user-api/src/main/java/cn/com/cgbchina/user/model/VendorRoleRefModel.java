package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class VendorRoleRefModel implements Serializable {

	private static final long serialVersionUID = 6416043495126497389L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private Long userId;// 供应商ID
	@Getter
	@Setter
	private Long roleId;// 角色ID
}