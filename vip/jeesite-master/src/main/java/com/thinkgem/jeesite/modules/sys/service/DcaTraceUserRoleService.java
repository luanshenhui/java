/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.sys.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.TreeService;
import com.thinkgem.jeesite.modules.sys.dao.DcaTraceUserRoleDao;
import com.thinkgem.jeesite.modules.sys.entity.DcaTraceUserRole;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 岗位管理Service
 * 
 * @author zhengwei.cui
 * @version 2016-12-15
 */
@Service
@Transactional(readOnly = true)
public class DcaTraceUserRoleService extends TreeService<DcaTraceUserRoleDao, DcaTraceUserRole> {

	@Autowired
	private DcaTraceUserRoleDao dcaTraceUserRoleDao;

	/**
	 * 根据岗位id查询
	 * 
	 * @param id
	 * @return
	 */
	public DcaTraceUserRole findById(String id) {
		return dcaTraceUserRoleDao.findById(id);
	}

	public List<DcaTraceUserRole> findList(DcaTraceUserRole dcaTraceUserRole) {
		return super.findList(dcaTraceUserRole);
	}

	public List<DcaTraceUserRole> findAllList() {
		return dcaTraceUserRoleDao.findAllList();
	}

	public Page<DcaTraceUserRole> findPage(Page<DcaTraceUserRole> page, DcaTraceUserRole dcaTraceUserRole) {
		return super.findPage(page, dcaTraceUserRole);
	}

	/**
	 * 查询树形岗位列表
	 * 
	 * @param dcaTraceUserRole
	 * @return
	 */
	public List<DcaTraceUserRole> findTreeList(DcaTraceUserRole dcaTraceUserRole) {
		if (dcaTraceUserRole != null) {
			dcaTraceUserRole.setRoleParentId("%");
			List<DcaTraceUserRole> list = dcaTraceUserRoleDao.findByParentIdsLike(dcaTraceUserRole);
			for (DcaTraceUserRole dca : list) {
				// 查出父岗位名称(如果父id为ROOT，则是最高层领导)
				if (dca.getRoleParentId() != null && dca.getRoleParentId() != "ROOT") {
					DcaTraceUserRole parentRole = dcaTraceUserRoleDao.get(dca.getRoleParentId());
					if (parentRole != null) {
						dca.setRoleParentName(parentRole.getRoleName());
					}
				}
				// 查出用户list
				String userIdList = dca.getUserIdList();
				if (userIdList != null) {
					// 以分号分割，循环查出用户名称
					String[] splits = userIdList.split(";");
					String users = "";
					for (int i = 0; i < splits.length; i++) {
						User user = UserUtils.get(splits[i]);
						if (user != null) {
							users = users + ((i == splits.length - 1) ? user.getName() : user.getName() + ",");
						}
					}
					dca.setUserNameList(users);
				}
			}
			return list;
		}
		return new ArrayList<DcaTraceUserRole>();
	}

	/**
	 * 根据用户id查出岗位信息
	 * 
	 * @param userId
	 * @return
	 */
	public List<DcaTraceUserRole> findByUserId(String userId) {
		return dcaTraceUserRoleDao.findByUserId(userId);
	}

	/**
	 * 根据parentId查询下属岗位
	 * 
	 * @param parentId
	 * @return
	 */
	public List<DcaTraceUserRole> findByParentId(String parentId) {
		return dcaTraceUserRoleDao.findByParentId(parentId);
	}

}