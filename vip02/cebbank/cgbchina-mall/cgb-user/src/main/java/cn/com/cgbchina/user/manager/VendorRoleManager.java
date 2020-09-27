package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.VendorRoleDao;
import cn.com.cgbchina.user.dao.VendorRoleMenuDao;
import cn.com.cgbchina.user.dao.VendorRoleRefDao;
import cn.com.cgbchina.user.dto.UserRoleDto;
import cn.com.cgbchina.user.dto.VendorRoleCreateDto;
import cn.com.cgbchina.user.dto.VendorRoleDto;
import cn.com.cgbchina.user.dto.VendorRoleEditDto;
import cn.com.cgbchina.user.model.VendorModel;
import cn.com.cgbchina.user.model.VendorRoleModel;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.user.User;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * Created by yuxinxin on 16-4-21.
 */
@Component
@Transactional(propagation = Propagation.REQUIRES_NEW)
public class VendorRoleManager {
	@Resource
	private VendorRoleDao vendorRoleDao;

	@Resource
	private VendorRoleMenuDao vendorRoleMenuDao;
	@Resource
	private AdminRoleMenuManager adminRoleMenuManager;
    @Resource
    private VendorRoleRefDao vendorRoleRefDao;

	public Integer insert(Map<String, Object> map) {
		return vendorRoleMenuDao.insert(map);
	}

	/**
	 * 添加
	 *
	 * @param role
	 * @return
	 */
	public Integer insert(VendorRoleModel role) {
		return vendorRoleDao.insert(role);
	}

	/**
	 * 修改
	 *
	 * @param role
	 * @return
	 */
	public Boolean update(VendorRoleModel role) {
		return vendorRoleDao.update(role) == 1;
	}

	public Boolean updateRole(Map<String, Object> map) {
		return vendorRoleDao.updateRole(map) == 1;
	}

	public void createRoleRoot(VendorRoleCreateDto role, User user) {

		VendorRoleModel adminRoleModel = new VendorRoleModel();
		adminRoleModel.setName(role.getName());// 角色名
		adminRoleModel.setCreateOper(user.getId());// 创建人
		adminRoleModel.setShopType("YG");// todo 设置商城类型 广发YG 积分JF
		adminRoleModel.setVendorId(user.getVendorId());// 通过User拿到供应商id 角色跟供应商挂钩
        adminRoleModel.setCreateOper(user.getName());
        adminRoleModel.setType("0");//todo 角色类型未知
        adminRoleModel.setDelFlag("0");
		// 新建当前角色
		vendorRoleDao.insert(adminRoleModel);
		// 如果集合为空，认为只新建个角色 没有分配权限
		if (role.getResourceIds().size() > 0) {
			// 绑定当前角色与指定的资源权限
			Map<String, Object> map = Maps.newHashMap();
			map.put("roleId", adminRoleModel.getId());// 角色id
			map.put("resourceIds", role.getResourceIds());// 绑定的资源集合
			vendorRoleMenuDao.insert(map);
		}
	}

	/**
	 * @param role
	 * @param userId
	 */
	public void updateRoleRoot(VendorRoleEditDto role, String userId) {
		// 更新角色名
		Map<String, Object> updateRole = Maps.newHashMap();
		updateRole.put("id", role.getRoleId());
		updateRole.put("modifyOper", userId);
		vendorRoleDao.updateRole(updateRole);
		// 找出当前角色已经存入数据库的资源权限
		List<Long> persistMenu = vendorRoleMenuDao.getMenuByRoleId(Lists.newArrayList(role.getRoleId()));
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
			addMap.put("resourceIds", readyToAdd);//
			vendorRoleMenuDao.insert(addMap);
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
			vendorRoleMenuDao.delete(deleteMap);// 无逻辑删除字段 做物理删除
		}
	}

	public void delete(Long id) {
		// 删除角色以后 还需要删除角色绑定的资源
		vendorRoleDao.delete(id);
		vendorRoleMenuDao.deleteByRoleId(id);
	}

    public void changeUserRole(UserRoleDto userRoleDto) {
        // 当前已经存在的角色
        List<Long> persistRoles = vendorRoleRefDao.getRoleIdByUserId(userRoleDto.getUserId());
        // 前台传过来的角色
        List<Long> updateRoles = userRoleDto.getRoles();
        // 需要插入的
        List<Long> readyInsert = Lists.newArrayList();
        for (Long id : updateRoles) {
            if (!persistRoles.contains(id)) {
                readyInsert.add(id);
            }
        }
        if (readyInsert.size() != 0) {
            UserRoleDto insert = new UserRoleDto();
            insert.setUserId(userRoleDto.getUserId());
            insert.setRoles(readyInsert);
            vendorRoleRefDao.insertUserRole(insert);
        }
        // 需要删除的
        List<Long> readyDelete = Lists.newArrayList();
        for (Long id : persistRoles) {
            if (!updateRoles.contains(id)) {
                readyDelete.add(id);
            }
        }
        if (readyDelete.size() != 0) {
            Map<String, Object> deleteMap = Maps.newHashMap();
            deleteMap.put("deleteList", readyDelete);
            deleteMap.put("userId", userRoleDto.getUserId());
            vendorRoleRefDao.deleteUserRole(deleteMap);
        }
    }

}
