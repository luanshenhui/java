package com.cebbank.ccis.cebmall.user.service;

import com.cebbank.ccis.cebmall.user.dto.UserRoleDto;
import com.spirit.common.model.Response;

/**
 * Created by 郝文佳 on 2016/5/25.
 */
public interface UserRoleService {

	Response<Boolean> assignRole(UserRoleDto userRoleDto);

}
