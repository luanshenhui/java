package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class UserRoleModel implements Serializable {

	private static final long serialVersionUID = -6289973691574804710L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String userId;//
	@Getter
	@Setter
	private Long roleId;//
}