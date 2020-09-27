package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.AdminRoleDao;
import cn.com.cgbchina.user.dao.AdminRoleMenuDao;
import cn.com.cgbchina.user.dto.RoleCreateDto;
import cn.com.cgbchina.user.dto.RoleEditDto;
import cn.com.cgbchina.user.model.AdminRoleModel;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.user.User;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 *
 */
@Component
@Transactional
public class AdminRoleManager {
	@Resource
	private AdminRoleDao adminRoleDao;
	@Resource
	private AdminRoleMenuDao adminRoleMenuDao;

	/**
	 * 添加
	 *
	 * @param role
	 * @return
	 */
	public Integer insert(AdminRoleModel role) {
		return adminRoleDao.insert(role);
	}

	/**
	 * 修改
	 *
	 * @param role
	 * @return
	 */
	public Boolean update(AdminRoleModel role) {
		return adminRoleDao.update(role) == 1;
	}

	public Boolean updateRole(Map<String, Object> map) {
		return adminRoleDao.updateRole(map) == 1;
	}

	public void createRoleRoot(RoleCreateDto role, User user) {

		AdminRoleModel adminRoleModel = new AdminRoleModel();
		adminRoleModel.setName(role.getName());// 角色名
		adminRoleModel.setCreateOper(user.getId());// 创建人
		// 新建当前角色
		adminRoleDao.insert(adminRoleModel);
		// 如果集合为空，认为只新建个角色 没有分配权限
		if (role.getResourceIds().size() > 0) {
			// 绑定当前角色与指定的资源权限
			Map<String, Object> map = Maps.newHashMap();
			map.put("roleId", adminRoleModel.getId());// 角色id
			map.put("resourceIds", role.getResourceIds());// 绑定的资源集合
			adminRoleMenuDao.insert(map);
		}
	}

	public void updateRoleRoot(RoleEditDto role, String userId) {
		// 更新角色名
		Map<String, Object> updateRole = Maps.newHashMap();
		updateRole.put("id", role.getRoleId());
		updateRole.put("modify_oper", userId);
		adminRoleDao.updateRole(updateRole);
		// 找出当前角色已经存入数据库的资源权限
		List<Long> persistMenu = adminRoleMenuDao.getMenuByRoleId(Lists.newArrayList(role.getRoleId()));
		// 找出前台经过编辑修改的资源
		List<Long> currentMenu = role.getResourceIds();
		// 需要新增的条数 在currentMenu中 但不再persistMenu中
		List<Long> readyToAdd = Lists.newArrayList();
		for (Long id : currentMenu) {
			if (!persistMenu.contains(id)) {
				readyToAdd.add(id);
			}
		}
		if (readyToAdd.size() > 0) {
			Map<String, Object> addMap = Maps.newHashMap();
			addMap.put("roleId", role.getRoleId());// 角色id
			addMap.put("resourceIds", readyToAdd);// 资源id
			adminRoleMenuDao.insert(addMap);
		}
		// 需要删除的条数 在persistMenu中 不再currentMenu中
		List<Long> readyToDelete = Lists.newArrayList();
		for (Long id : persistMenu) {
			if (!currentMenu.contains(id)) {
				readyToDelete.add(id);
			}
		}
		if (readyToDelete.size() > 0) {
			Map<String, Object> deleteMap = Maps.newHashMap();
			deleteMap.put("roleId", role.getRoleId());// 角色id
			deleteMap.put("resourceIds", readyToDelete);//
			adminRoleMenuDao.delete(deleteMap);// 逻辑删除
		}

	}

	public void logicDelete(Long id) {
		// 删除当前角色
		adminRoleDao.logicDelete(id);
		// 允许删除当前角色后 还得删除当前角色绑定的资源 逻辑删
		adminRoleMenuDao.deleteByRoleId(id);

	}

}
