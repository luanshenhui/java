package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dao.VendorRoleDao;
import cn.com.cgbchina.user.dao.VendorRoleRefDao;
import cn.com.cgbchina.user.dto.UserRoleDto;
import cn.com.cgbchina.user.dto.VendorRoleCreateDto;
import cn.com.cgbchina.user.dto.VendorRoleDto;
import cn.com.cgbchina.user.dto.VendorRoleEditDto;
import cn.com.cgbchina.user.manager.VendorRoleManager;
import cn.com.cgbchina.user.model.VendorRoleModel;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 */
@Service
@Slf4j
public class VendorRoleServiceImpl implements VendorRoleService {
	@Resource
	private VendorRoleManager vendorRoleManager;
	@Resource
	private VendorRoleDao vendorRoleDao;
	@Resource
	private VendorRoleRefDao vendorRoleRefDao;

	/**
	 * 添加角色
	 *
	 * @param role
	 * @return
	 */
	@Override
	public Response<Boolean> createRoleRoot(VendorRoleCreateDto role, User user) {
		Response<Boolean> response = new Response<>();
		try {
			// 首先对角色名判重
			if (vendorRoleDao.duplicateCheck(role.getName(),user.getVendorId()) > 0) {
				response.setError("role.name.duplicated");
				return response;
			}
			vendorRoleManager.createRoleRoot(role, user);
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
	public Response<Boolean> updateRoleRoot(VendorRoleEditDto role, String userId) {
		Response<Boolean> response = new Response<>();
		try {
			vendorRoleManager.updateRoleRoot(role, userId);
			response.setResult(Boolean.TRUE);
			return response;
		} catch (Exception e) {
			log.error("update role error", Throwables.getStackTraceAsString(e));
			response.setError("update.error");
			return response;
		}

	}

	@Override
	public Response<Pager<VendorRoleModel>> findRole(Integer pageNo, Integer size, String name,User user) {
		Response<Pager<VendorRoleModel>> response = new Response<>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> param = Maps.newHashMap();
		if (!Strings.isNullOrEmpty(name)) {
			param.put("name", name);
		}
        param.put("vendorId", user.getVendorId());
		try {
			Pager<VendorRoleModel> pager = vendorRoleDao.findByPage(param, pageInfo.getOffset(), pageInfo.getLimit());
			response.setResult(pager);
		} catch (Exception e) {
			log.error("find role error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("find.role.error");

		}
		return response;
	}

	@Override
	public Response<List<VendorRoleDto>> allEnabledRoleDtos(User user) {
		Response<List<VendorRoleDto>> response = new Response<>();
		try {
			Map<String, Object> map = new HashMap<>();
			map.put("vendorId", user.getVendorId());// 每个供应商只有他账号下的角色可以分配 其他的无权获取
			map.put("shopType", user.getUserType());// TODO 查询的角色输入那个商城 避免同一个供应商入驻两个商城角色混乱
			List<VendorRoleDto> vendorRoleDtos = vendorRoleDao.allEnabledRoleDtos(map);
			response.setResult(vendorRoleDtos);
			return response;
		} catch (Exception e) {
			log.error("find role failed", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
			return response;
		}
	}

	@Override
	public Response<Boolean> delete(Long id) {
		Response<Boolean> response = new Response<>();
		try {
			// 查看当前角色有没有账户绑定 有的话不允许删除
			Integer isUsed = vendorRoleRefDao.roleExists(id);
			if (isUsed > 0) {
				response.setError("role.exist.error");
				return response;
			}
			// 允许删除了
			vendorRoleManager.delete(id);
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("failed to delele role", id, e);
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
            List<Integer> roleId = vendorRoleDao.findByName(name);
            List<String> list = vendorRoleRefDao.findByIdList(roleId);
            result.setResult(list);
            return result;
        } catch (Exception e) {
            log.error("role get error,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("role.find.error");
            return result;
        }
    }

    /**
     * 供应商分配角色
     * @param userRoleDto
     * @return
     */
    @Override
    public Response<Boolean> assignRole(UserRoleDto userRoleDto) {
        Response<Boolean> result = new Response<>();
        try {
            vendorRoleManager.changeUserRole(userRoleDto);
            result.setResult(Boolean.TRUE);
        } catch (Exception e) {
            log.error("failed to assign role", userRoleDto, e);
            result.setError("acount.assign.role.error");
        }
        return result;
    }
}
