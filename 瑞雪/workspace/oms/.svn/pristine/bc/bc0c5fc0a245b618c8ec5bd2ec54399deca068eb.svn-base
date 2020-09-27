package cn.rkylin.oms.system.privilege.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import cn.rkylin.core.exception.BusinessException;
import cn.rkylin.core.service.ApolloService;
import cn.rkylin.oms.system.privilege.dao.IMenuGrantDAO;
import cn.rkylin.oms.system.privilege.domain.WF_ORG_RESOURCE_AUTHORITY;
@Service("privilegeService")
public class PrivilegeServiceImpl extends ApolloService implements IPrivilegeService{
	@Autowired
	private IMenuGrantDAO menuGrantDAO;

	@SuppressWarnings("rawtypes")
	@Override
	public Map getElementPrivByMenuIDRoleID(String roleID, String type, String menuID, String privilegeType) throws Exception {
		Map resultMap = new HashMap();
		WF_ORG_RESOURCE_AUTHORITY authVO = new WF_ORG_RESOURCE_AUTHORITY();
		authVO.setAuthorityType(privilegeType);
		authVO.setRoleId(roleID);
		// authVO.setMenuId(menuID);
		authVO.setParentMenuCode(menuID);
		resultMap = menuGrantDAO.getElementPrivByMenuIDRoleID(authVO, type);	
		return resultMap;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 保存权限修改（仅对新增的权限和删除的权限进行处理，需要考虑用户权限调整问题）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param nodes4Add
	 *            - 用户要添加的菜单项或元素
	 * @param nodes4Del
	 *            - 用户要删除的菜单项或元素
	 * @param privilegeType
	 *            - 授权类型：assignable，available
	 * @throws ServiceException
	 */
	@Override
	public void savePrivileges(String roleID, String roleType, String nodes4Add, String nodes4Del, String privilegeType)
			throws Exception {
		// 删除授权
		String[] resourceArray4Del = nodes4Del.split(",");
		for (int i = 0; i < resourceArray4Del.length; i++) {
			String resourceID = resourceArray4Del[i];
			if (resourceID.equals(""))
				continue;
			WF_ORG_RESOURCE_AUTHORITY delParam = new WF_ORG_RESOURCE_AUTHORITY();
			delParam.setRoleId(roleID);
			delParam.setResourceId(resourceID);
			// Mon Aug 29 11:14:40 2011 删除管理角色的时候不要影响业务角色，反之亦然
			delParam.setAuthorityType(privilegeType);// 对应改xml文件
			// Over
			// 如果roleType是"user"，则需要考虑权限排除问题
			if (!roleType.equalsIgnoreCase("user")) {
				menuGrantDAO.deletePrivileges(delParam);
			} else {
				// 如果要删除的用户授权在授权表里不存在，则插入到用户授权排除中
				List authList = menuGrantDAO.getResourceAuthority(delParam);
				if (authList == null || authList.size() <= 0) {
					menuGrantDAO.insertUserExclude(roleID, resourceID);
				} else {
					menuGrantDAO.deletePrivileges(delParam);
				}
			}
		}

		// 添加授权
		String[] resourceArray4Add = nodes4Add.split(",");
		for (int i = 0; i < resourceArray4Add.length; i++) {
			String resourceID = resourceArray4Add[i];
			if (resourceID.equals(""))
				continue;
			// 如果是用户权限调整，则先删除该用户的“权限排除”
			if (roleType.equalsIgnoreCase("user")) {
				menuGrantDAO.deleteUserExclude(roleID, resourceID);
				// 看看此user的组织、岗位、角色是否具有此“资源”的权限，如果有，就不用加了
				if (menuGrantDAO.ifUserResourceAvailable(roleID, resourceID))
					continue;
			}
			WF_ORG_RESOURCE_AUTHORITY authVO = new WF_ORG_RESOURCE_AUTHORITY();
			authVO.setResourceAuthorityId(java.util.UUID.randomUUID().toString().replaceAll("-", ""));
			authVO.setAuthorityType(privilegeType);
			authVO.setRoleId(roleID);
			authVO.setRoleType(roleType);
			authVO.setResourceId(resourceID);
			menuGrantDAO.insertPrivilege(authVO);
		}
	}

}
