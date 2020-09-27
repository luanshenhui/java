package cn.com.cgbchina.user.dto;

import cn.com.cgbchina.user.model.UserInfoModel;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

/**
 * Created by 11140721050130 on 2016/5/13.
 */
@ToString
public class UserInfoDto extends UserInfoModel implements Serializable {

	private static final long serialVersionUID = -369136834438740406L;
	@Getter
	@Setter
	private String orgSimpleName;// 机构简称

	@Getter
	@Setter
	private String orgFullName;// 机构简称
	@Getter
	@Setter
	private List<AdminRoleDto> adminRoleDtos;// 当前账户关联的角色
}
