
package com.dhc.authorization.resource.privilege.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.dhc.authorization.resource.privilege.dao.IMenuGrantDAO;
import com.dhc.authorization.resource.privilege.domain.WF_ORG_RESOURCE_AUTHORITY;
import com.dhc.base.core.Service;
import com.dhc.base.exception.DataAccessException;
import com.dhc.base.exception.ServiceException;
import com.dhc.organization.config.OrgI18nConsts;

/**
 * brief description
 * <p>
 * Date : 2010/05/12
 * </p>
 * <p>
 * Module : 权限管理
 * </p>
 * <p>
 * Description: 权限管理业务对象
 * </p>
 * <p>
 * Remark :
 * </p>
 * 
 * @author 王潇艺
 * @version
 *          <p>
 * 			------------------------------------------------------------
 *          </p>
 *          <p>
 *          修改历史
 *          </p>
 *          <p>
 *          序号 日期 修改人 修改原因
 *          </p>
 *          <p>
 *          1
 *          </p>
 */
public class PrivilegeService implements Service {
	/**
	 * 授权管理数据访问对象
	 */
	private IMenuGrantDAO menuGrantDAO;

	public IMenuGrantDAO getMenuGrantDAO() {
		return menuGrantDAO;
	}

	public void setMenuGrantDAO(IMenuGrantDAO menuGrantDAO) {
		this.menuGrantDAO = menuGrantDAO;
	}

	/**
	 * 构造函数
	 */
	public PrivilegeService() {

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据角色id，获取该角色可以使用/可以分配的菜单树。返回的结果Map：key=菜单id，值= 是否有可用
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param roleID
	 *            - 角色id
	 * @param privilegeType
	 *            - 授权类型：assignable，available（可分配，可使用）
	 * @return 如果找到，返回HashMap 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public Map getRoleMenuTreePrivileges(String roleID, String privilegeType) throws ServiceException {
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据岗位id，获取该岗位可以使用/可以分配的菜单树。返回的结果Map：key=菜单id，值= 是否有可用
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param stationID
	 *            - 岗位id
	 * @param privilegeType
	 *            - 授权类型：assignable，available（可分配，可使用）
	 * @return 如果找到，返回HashMap 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public Map getStationMenuTreePrivileges(String stationID, String privilegeType) throws ServiceException {
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据角色id，菜单项id，获取该菜单项下所有元素 的可用/可分配性。返回的结果Map：key=元素id，值=是否可用
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param roleID
	 *            - 角色id
	 * @param menuID
	 *            - 菜单项id
	 * @param privilegeType
	 *            - 授权类型：assignable，available（可分配，可使用）
	 * @return 如果找到，返回HashMap 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public Map getElementPrivByMenuIDRoleID(String roleID, String type, String menuID, String privilegeType)
			throws ServiceException {
		Map resultMap = new HashMap();
		try {
			WF_ORG_RESOURCE_AUTHORITY authVO = new WF_ORG_RESOURCE_AUTHORITY();
			authVO.setAuthorityType(privilegeType);
			authVO.setRoleId(roleID);
			// authVO.setMenuId(menuID);
			authVO.setParentMenuCode(menuID);
			resultMap = menuGrantDAO.getElementPrivByMenuIDRoleID(authVO, type);
		} catch (DataAccessException e) {
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}
		return resultMap;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据岗位id，菜单项id，获取该菜单项下所有元素 的可用/可分配性。返回的结果Map：key=元素id，值=是否可用
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param stationID
	 *            - 岗位id
	 * @param privilegeType
	 *            - 授权类型：assignable，available（可分配，可使用）
	 * @return 如果找到，返回HashMap 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public Map getElementPrivByMenuIDStationID(String stationID, String menuID, String privilegeType)
			throws ServiceException {
		return null;
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
	public void savePrivileges(String roleID, String roleType, String nodes4Add, String nodes4Del, String privilegeType)
			throws ServiceException {
		try {
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

		} catch (DataAccessException e) {
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据帐户，判断url或者menuItem是否可用
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param userID
	 *            - 帐户，必填
	 * @param queryType
	 *            - 查询类型：RESOURCE_ID、URL，必填
	 * @param value
	 *            - 授权类型：资源id或者url，必填
	 * @throws ServiceException
	 */
	public boolean isResourceAvailable(String userID, String queryType, String value) throws ServiceException {
		boolean returnValue = false;
		Map queryParamMap = new HashMap();
		queryParamMap.put("userID", userID);
		if (queryType.equalsIgnoreCase("RESOURCE_ID"))
			queryParamMap.put("menuID", value);
		else
			queryParamMap.put("strURL", value);
		try {
			returnValue = menuGrantDAO.isResourceAvailable(queryParamMap);
		} catch (DataAccessException e) {
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}
		return returnValue;
	}
}
