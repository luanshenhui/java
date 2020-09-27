package cn.com.cgbchina.user.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * 根据user id查出来的关联角色 Created by 郝文佳 on 2016/5/25.
 */
public class VendorRoleDto implements Serializable {

	private static final long serialVersionUID = 5930491765597502819L;
	@Setter
	@Getter
	private Long roleId;
	@Setter
	@Getter
	private String roleName;
}
