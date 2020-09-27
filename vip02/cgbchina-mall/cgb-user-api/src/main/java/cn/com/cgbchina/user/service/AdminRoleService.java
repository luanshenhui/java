package cn.com.cgbchina.user.service;

import java.util.List;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.user.dto.AdminRoleDto;
import cn.com.cgbchina.user.dto.RoleCreateDto;
import cn.com.cgbchina.user.dto.RoleEditDto;
import cn.com.cgbchina.user.model.AdminRoleModel;

/**
 * Created by yuxinxin on 16-4-8.
 */
public interface AdminRoleService {

	/**
	 * 创建角色
	 *
	 * @param role
	 * @return
	 */
	Response<Boolean> createRoleRoot(RoleCreateDto role, User user);

	/**
	 * 更新角色权限
	 *
	 * @param role
	 * @return
	 */
	Response<Boolean> updateRoleRoot(RoleEditDto role, String userId);

	/**
	 * 分页查询
	 *
	 * @param pageNo
	 * @return
	 */
	public Response<Pager<AdminRoleModel>> findRole(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("name") String name);

	/**
	 * 获取所有可用角色
	 *
	 * @return
	 */
	Response<List<AdminRoleDto>> allEnabledRoleDtos();

	Response<Boolean> deleteRole(Long id);

    /**
     * 根据角色名称，模糊查询所有的角色
     *
     * @return
     * add by liuhan
     */
    public Response<List<String>> findByName(String name);
}