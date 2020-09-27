package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dto.UserRoleDto;
import cn.com.cgbchina.user.manager.UserRoleManager;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * Created by 郝文佳 on 2016/5/25.
 */
@Slf4j
@Service
public class UserRoleServiceImpl implements UserRoleService {
	@Resource
	private UserRoleManager userRoleManager;

	@Override
	public Response<Boolean> assignRole(UserRoleDto userRoleDto) {
		Response<Boolean> result = new Response<>();
		try {
			userRoleManager.changeUserRole(userRoleDto);
			result.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("failed to assign role", userRoleDto, e);
			result.setError("acount.assign.role.error");
		}
		return result;
	}
}
