package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dao.AdminRoleDao;
import cn.com.cgbchina.user.dao.UserRoleDao;
import cn.com.cgbchina.user.dto.AdminRoleDto;
import cn.com.cgbchina.user.dto.RoleCreateDto;
import cn.com.cgbchina.user.dto.RoleEditDto;
import cn.com.cgbchina.user.manager.AdminRoleManager;
import cn.com.cgbchina.user.model.AdminRoleModel;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * Created by yuxinxin on 16-4-8.
 */
@Service
@Slf4j
public class AdminRoleServiceImpl implements AdminRoleService {
	@Resource
	private AdminRoleManager adminRoleManager;
	@Resource
	private AdminRoleDao adminRoleDao;
	@Resource
	private UserRoleDao userRoleDao;

	/**
	 * 添加角色
	 *
	 * @param role
	 * @return
	 */
	@Override
	public Response<Boolean> createRoleRoot(RoleCreateDto role, User user) {
		Response<Boolean> response = new Response<>();
		try {
			// 首先对角色名判重
			if (adminRoleDao.duplicateCheck(role.getName()) > 0) {
				response.setError("role.name.duplicated");
				return response;
			}
			adminRoleManager.createRoleRoot(role, user);// 两个dao抽取到一个manager 使用事务
			response.setResult(Boolean.TRUE);

		} catch (Exception e) {
			log.error("failed to create role", role, e);
			response.setError("create.role.error");
		}
		return response;
	}

	/**
	 * 更新权限
	 *
	 * @param role
	 * @return
	 */
	@Override
	public Response<Boolean> updateRoleRoot(RoleEditDto role, String userId) {
		Response<Boolean> response = new Response<>();
		try {
			adminRoleManager.updateRoleRoot(role, userId);// 两个dao抽取到一个manager 使用事务
			response.setResult(Boolean.TRUE);
			return response;
		} catch (Exception e) {
			log.error("update role error", Throwables.getStackTraceAsString(e));
			response.setError("update.error");
			return response;
		}

	}

	@Override
	public Response<Pager<AdminRoleModel>> findRole(Integer pageNo, Integer size, String name) {
		Response<Pager<AdminRoleModel>> response = new Response<>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> param = Maps.newHashMap();
		if (!Strings.isNullOrEmpty(name)) {
			param.put("name", name);
		}
		try {
			Pager<AdminRoleModel> pager = adminRoleDao.findByPage(param, pageInfo.getOffset(), pageInfo.getLimit());
			response.setResult(pager);
		} catch (Exception e) {
			log.error("find role error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("find.role.error");

		}
		return response;
	}

	@Override
	public Response<List<AdminRoleDto>> allEnabledRoleDtos() {
		Response<List<AdminRoleDto>> response = new Response<>();
		try {
			List<AdminRoleDto> adminRoleDtos = adminRoleDao.allEnabledRoleDtos();
			response.setResult(adminRoleDtos);
			return response;
		} catch (Exception e) {
			log.error("find role failed", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
			return response;
		}
	}

	@Override
	public Response<Boolean> deleteRole(Long id) {
		Response<Boolean> response = new Response<>();
		try {
			/* 查看当前角色是否有人在用 */
			Integer exists = userRoleDao.roleExists(id);
			if (exists > 0) {
				/* 说明有账户绑定 不让删 */
				response.setError("role.exist.error");
				return response;
			}
			// 允许删除
			adminRoleManager.logicDelete(id);
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("fail to delete role", e);
			response.setError("delete.error");
		}
		return response;
	}

    /**
     * 根据角色名称，模糊查询所有的角色
     *
     * @return
     * add by liuhan
     */
    @Override
    public Response<List<String>> findByName(String name) {
        Response<List<String>> result = new Response<List<String>>();
        try {
            List<Integer> roleId = adminRoleDao.findByName(name);
            List<String> list = userRoleDao.findByIdList(roleId);
            result.setResult(list);
            return result;
        } catch (Exception e) {
            log.error("role get error,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("role.find.error");
            return result;
        }
    }

}
