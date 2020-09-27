package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.VendorRoleRefDao;
import cn.com.cgbchina.user.dto.UserRoleDto;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/5/31.
 */
@Component
@Transactional
public class VendorRoleRefManager {
	@Resource
	private VendorRoleRefDao vendorRoleRefDao;

	public void changeRoleRef(UserRoleDto userRoleDto) {
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