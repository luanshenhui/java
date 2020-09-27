package com.dhc.organization.role.service;

import java.util.ArrayList;
import java.util.List;

import com.dhc.authorization.resource.privilege.dao.IMenuGrantDAO;
import com.dhc.authorization.resource.privilege.domain.WF_ORG_RESOURCE_AUTHORITY;
import com.dhc.base.core.Service;
import com.dhc.base.exception.DataAccessException;
import com.dhc.base.exception.ServiceException;
import com.dhc.organization.config.OrgI18nConsts;
import com.dhc.organization.role.dao.IRoleDAO;
import com.dhc.organization.role.domain.WF_ORG_ROLE;
import com.dhc.organization.unit.dao.IUnitDAO;
import com.dhc.organization.unit.domain.WF_ORG_UNIT;
import com.dhc.organization.user.dao.IUserDAO;
import com.dhc.organization.user.domain.WF_ORG_USER;

/**
 * brief description
 * <p>
 * Date : 2010/05/06
 * </p>
 * <p>
 * Module : 角色管理
 * </p>
 * <p>
 * Description: 角色业务对象
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
public class RoleService implements Service {
	/**
	 * 角色数据访问对象
	 */
	private IRoleDAO iroleDAO;

	/**
	 * 岗位数据访问对象
	 */
	private IUnitDAO iunitDAO;

	/**
	 * 用户数据访问对象
	 */
	private IUserDAO iuserDAO;

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
	public RoleService() {

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获取角色
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param roleName
	 *            - 角色名称
	 * @param isAdminRole
	 *            - 角色类型：是，否
	 * @return 如果找到，返回List<JT_UNIT_ROLE> 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public List getRoleByCondition(WF_ORG_ROLE roleVO) throws ServiceException {
		List resultList = new ArrayList();
		try {
			resultList = iroleDAO.getRoleByCondition(roleVO);
		} catch (DataAccessException e) {
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}
		return resultList;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获取角色
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param roleName
	 *            - 角色名称
	 * @param isAdminRole
	 *            - 角色类型：是，否
	 * @return 如果找到，返回List<JT_UNIT_ROLE> 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public List getRoleByIDs(WF_ORG_ROLE roleVO) throws ServiceException {
		List resultList = new ArrayList();
		try {
			resultList = iroleDAO.getRoleByIDs(roleVO);
		} catch (DataAccessException e) {
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}
		return resultList;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获取角色（分页）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param roleName
	 *            - 角色名称
	 * @param isAdminRole
	 *            - 角色类型：是，否
	 * @return 如果找到，返回List<JT_UNIT_ROLE> 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public List getPagingRole(WF_ORG_ROLE roleVO) throws ServiceException {
		List resultList = new ArrayList();
		try {
			resultList = iroleDAO.getPagingRole(roleVO);
		} catch (DataAccessException e) {
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}
		return resultList;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取所有角色
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param roleName
	 *            - 角色名称
	 * @param isAdminRole
	 *            - 角色类型：是，否
	 * @return 如果找到，返回List<JT_UNIT_ROLE> 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public List getAllRoles(WF_ORG_ROLE roleVO) throws ServiceException {
		List returnList = new ArrayList();
		try {
			returnList = iroleDAO.getAllRoles(roleVO);
		} catch (DataAccessException e) {
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}
		return returnList;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取角色的总数，用于表格分页
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @return 角色总数
	 * @throws ServiceException
	 */
	public int getRoleCount(WF_ORG_ROLE roleParam) throws ServiceException {
		int roleCount = 0;
		try {
			roleCount = iroleDAO.getRoleCount(roleParam);
		} catch (DataAccessException e) {
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}
		return roleCount;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 保存组织单元，包括（角色包含的人员信息、角色可以管理的组织单元）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param roleVO
	 *            - 含有人员列表的组织单元vo
	 * @param saveType
	 *            - 保存类型，0：新增保存，1：修改保存
	 * @return 保存后的WF_ORG_ROLE
	 * @throws ServiceException
	 */
	public void saveRole(WF_ORG_ROLE roleVO, String saveType) throws ServiceException {
		try {
			// 检测角色的用户数限制
			if (roleVO.getUserNumbers() >= 0 && roleVO.getRoleUsersList() != null) {
				if (roleVO.getRoleUsersList().size() > roleVO.getUserNumbers()) {
					throw new DataAccessException("角色的用户数超过上限");
				}
			}
			// 如果是新增保存
			if (saveType.equals("0")) {
				iroleDAO.createRole(roleVO);
			} else {
				// 如果有人数限制，则先检查角色的人数限制
				// WF_ORG_USER userVO = new WF_ORG_USER();
				// userVO.setRoleId(roleVO.getRoleId());
				// if (!roleVO.getUserNumbers().toString().equals("-1")){
				// int roleCount = iuserDAO.getUserCount(userVO);
				// if (roleCount > roleVO.getUserNumbers())
				// throw new DataAccessException("角色的用户数超过上限");
				// }
				iroleDAO.updateRole(roleVO);
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
	 * 描述: 删除角色，如果角色已经被使用则不被删除
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param roleID
	 *            - 角色id
	 * @throws ServiceException
	 */
	public void deleteRole(List roleIDs) throws ServiceException {
		try {
			for (int i = 0; i < roleIDs.size(); i++) {
				// roleID不为“”
				if (!roleIDs.get(i).toString().equals("")) {
					iroleDAO.deleteRole(roleIDs.get(i).toString());
					WF_ORG_RESOURCE_AUTHORITY delParam = new WF_ORG_RESOURCE_AUTHORITY();
					delParam.setRoleId(roleIDs.get(i).toString());
					menuGrantDAO.deletePrivileges(delParam);
				}
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
	 * 描述: 根据条件获取角色,包含角色可管理的组织单元信息、角色下包含的人员
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param roleID
	 *            - 角色ID
	 * @return 如果找到，返回WF_ORG_ROLE 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public WF_ORG_ROLE getRoleDetail(String roleID) throws ServiceException {
		WF_ORG_ROLE returnRole = null;

		try {
			// 取role信息
			WF_ORG_ROLE roleParam = new WF_ORG_ROLE();
			roleParam.setRoleId(roleID);
			List roleList = iroleDAO.getRoleByCondition(roleParam);
			if (roleList != null || roleList.size() > 0) {
				returnRole = (WF_ORG_ROLE) roleList.get(0);

				// 取role可管理的组织单元
				WF_ORG_UNIT unitParam = new WF_ORG_UNIT();
				unitParam.setRoleId(roleID);
				List unitList = new ArrayList();
				unitList = iunitDAO.getUnitByCondition(unitParam);
				returnRole.setRoleManageUnitList(unitList);

				// 取role下的所有人
				WF_ORG_USER userParam = new WF_ORG_USER();
				userParam.setRoleId(roleID);
				List userList = iuserDAO.getUserByCondition(userParam);
				returnRole.setRoleUsersList(userList);
			} else {
				returnRole = null;
			}

		} catch (DataAccessException e) {
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}
		return returnRole;
	}

	public void setIroleDAO(IRoleDAO iroleDAO) {
		this.iroleDAO = iroleDAO;
	}

	public IRoleDAO getIroleDAO() {
		return iroleDAO;
	}

	public IUserDAO getIuserDAO() {
		return iuserDAO;
	}

	public void setIuserDAO(IUserDAO iuserDAO) {
		this.iuserDAO = iuserDAO;
	}

	public IUnitDAO getIunitDAO() {
		return iunitDAO;
	}

	public void setIunitDAO(IUnitDAO iunitDAO) {
		this.iunitDAO = iunitDAO;
	}

}