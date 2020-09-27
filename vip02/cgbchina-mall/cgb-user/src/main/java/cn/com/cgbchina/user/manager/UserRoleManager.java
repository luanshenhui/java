package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.AdminRoleDao;
import cn.com.cgbchina.user.dao.UserInfoDao;
import cn.com.cgbchina.user.dao.UserRoleDao;
import cn.com.cgbchina.user.dto.UserRoleDto;
import cn.com.cgbchina.user.model.AdminRoleModel;
import cn.com.cgbchina.user.model.UserInfoModel;
import cn.com.cgbchina.user.model.UserRoleModel;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * Created by 11141021040453 on 16-4-21.
 */
@Component
@Transactional
public class UserRoleManager {
	@Resource
	private UserInfoDao userInfoDao;
	@Resource
	private AdminRoleDao adminRoleDao;
	@Resource
	private UserRoleDao userRoleDao;

	public Boolean insert(UserInfoModel userInfo, AdminRoleModel role, UserRoleModel roleUser) {
		Integer roleResult = adminRoleDao.insert(role);
		if (roleResult != 1) {
			return Boolean.FALSE;
		}
		Integer roleUserResult = userRoleDao.insert(roleUser);
		if (roleUserResult != 1) {
			return Boolean.FALSE;
		}
		Integer userInfoResult = userInfoDao.insert(userInfo);
		if (userInfoResult != 1) {
			return Boolean.FALSE;
		}
		return Boolean.TRUE;
	}

	public Boolean update(UserInfoModel userInfo, AdminRoleModel role, UserRoleModel roleUser) {
		Integer roleResult = adminRoleDao.update(role);
		if (roleResult != 1) {
			return Boolean.FALSE;
		}
		Integer roleUserResult = userRoleDao.update(roleUser);
		if (roleUserResult != 1) {
			return Boolean.FALSE;
		}
		return userInfoDao.update(userInfo);
	}

	public Boolean insertUserRole(UserRoleDto userRoleDto) {
		return userRoleDao.insertUserRole(userRoleDto) > 0;
	}

	public Boolean deleteUserRole(Map<String, Object> map) {
		return userRoleDao.deleteUserRole(map) > 0;
	}

	public void changeUserRole(UserRoleDto userRoleDto) {
		// 当前已经存在的角色
		List<Long> persistRoles = userRoleDao.getRoleIdByUserId(userRoleDto.getUserId());
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
			userRoleDao.insertUserRole(insert);
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
			userRoleDao.deleteUserRole(deleteMap);
		}
	}
}
