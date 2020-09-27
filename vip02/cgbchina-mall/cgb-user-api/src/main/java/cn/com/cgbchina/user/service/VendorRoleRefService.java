package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dto.UserRoleDto;
import com.spirit.common.model.Response;

/**
 * Created by 郝文佳 on 2016/5/25.
 */
public interface VendorRoleRefService {

	Response<Boolean> assignRole(UserRoleDto userRoleDto);

}
