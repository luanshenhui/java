package cn.com.cgbchina.user.service;

import java.util.List;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.user.dto.UserRoleDto;
import cn.com.cgbchina.user.dto.VendorRoleCreateDto;
import cn.com.cgbchina.user.dto.VendorRoleDto;
import cn.com.cgbchina.user.dto.VendorRoleEditDto;
import cn.com.cgbchina.user.model.VendorRoleModel;

/**
 * Created by yuxinxin on 16-4-8.
 */
public interface VendorRoleService {

	/**
	 * 创建角色
	 *
	 * @param role
	 * @return
	 */
	Response<Boolean> createRoleRoot(VendorRoleCreateDto role, User user);

	/**
	 * 更新角色权限
	 *
	 * @param role
	 * @return
	 */
	Response<Boolean> updateRoleRoot(VendorRoleEditDto role, String userId);

	/**
	 * 分页查询
	 *
	 * @param pageNo
	 * @return
	 */
	public Response<Pager<VendorRoleModel>> findRole(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("name") String name,@Param("user") User user);

	/**
	 * 获取所有可用角色
	 *
	 * @return
	 */
	Response<List<VendorRoleDto>> allEnabledRoleDtos(User user);

	Response<Boolean> delete(Long id);

    /**
     * 根据角色名称，模糊查询所有的角色
     *
     * @return
     * add by liuhan
     */
    public Response<List<String>> findByName(String name);

    /**
     * 供应商分配角色
     * @param userRoleDto
     * @return
     */
    public Response<Boolean> assignRole(UserRoleDto userRoleDto);
}
