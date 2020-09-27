package cn.com.cgbchina.user.dto;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/25.
 */
public class UserRoleDto implements Serializable {

	private static final long serialVersionUID = -2440014231237139426L;
	@Setter
	@Getter
	@NotNull
	private String userId;
	@Setter
	@Getter
	private List<Long> roles;

}
