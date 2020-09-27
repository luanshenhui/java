package com.dhc.organization.user.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.security.providers.encoding.PasswordEncoder;

import com.dhc.authorization.resource.menu.dao.IMenuDAO;
import com.dhc.authorization.resource.menu.domain.WF_ORG_MENU;
import com.dhc.authorization.resource.privilege.dao.IMenuGrantDAO;
import com.dhc.authorization.resource.privilege.domain.WF_ORG_RESOURCE_AUTHORITY;
import com.dhc.base.core.Service;
import com.dhc.base.exception.DataAccessException;
import com.dhc.base.exception.ServiceException;
import com.dhc.base.security.SecurityUserHoder;
import com.dhc.organization.config.OrgI18nConsts;
import com.dhc.organization.position.dao.IPositionDAO;
import com.dhc.organization.position.domain.WF_ORG_STATION;
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
 * Module : 用户管理
 * </p>
 * <p>
 * Description: 用户业务对象
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
public class UserService implements Service {
	/**
	 * 用户数据访问对象
	 */
	private IUserDAO iuserDAO;

	/**
	 * 组织单元数据访问对象
	 */
	private IUnitDAO iunitDAO;

	/**
	 * 角色数据访问对象
	 */
	private IRoleDAO iroleDAO;

	/**
	 * 岗位数据访问对象
	 */
	private IPositionDAO istationDAO;

	/**
	 * 授权管理数据访问对象
	 */
	private IMenuGrantDAO menuGrantDAO;

	private IMenuDAO imenuDAO;

	public IMenuDAO getImenuDAO() {
		return imenuDAO;
	}

	public void setImenuDAO(IMenuDAO imenuDAO) {
		this.imenuDAO = imenuDAO;
	}

	/**
	 * 密码加密机制
	 */
	private PasswordEncoder passwordEncoder;

	public IMenuGrantDAO getMenuGrantDAO() {
		return menuGrantDAO;
	}

	public void setMenuGrantDAO(IMenuGrantDAO menuGrantDAO) {
		this.menuGrantDAO = menuGrantDAO;
	}

	/**
	 * 构造函数
	 */
	public UserService() {

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 分页获取用户
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param currentPage
	 *            - 当前是第几页
	 * @param rowsPerPage
	 *            - 每页行数
	 * @param pagingType
	 *            - 分页类型 1：首页 2：上一页 3：下一页 4：尾页
	 * @return 无
	 * @throws ServiceException
	 */
	public List getUsers(String currentPage, String rowsPerPage, String pagingType) throws ServiceException {
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获取用户
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param userAccount
	 *            - 用户帐号
	 * @param userName
	 *            - 用户名称
	 * @param unitID
	 *            - 组织单元 id
	 * @return 如果找到，返回List<WF_ORG_USER> 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public List getUserByCondition(WF_ORG_USER userVO, boolean needUserUnits, boolean needUserStation,
			boolean needUserRoles, boolean needUserExtInfo) throws ServiceException {
		if (iuserDAO == null)
			throw new ServiceException("数据访问对象为空，请检查dataAccessContext文件");
		List returnValue = new ArrayList();
		try {
			returnValue = iuserDAO.getUserByCondition(userVO);

			// 2011年5月11日 增加对委托权限的提取
			WF_ORG_USER jtUser = new WF_ORG_USER();
			if (returnValue.size() > 0) {
				jtUser = (WF_ORG_USER) returnValue.get(0);
			} else {
				return returnValue;
			}
			List delegateRoleIdList = null;
			// 正常的用户管理不需要取委托权限
			if (userVO.getStartRow() == 0 && userVO.getEndRow() == 0) {
				WF_ORG_MENU menuItemVO = new WF_ORG_MENU();
				menuItemVO.setUserID(jtUser.getUserId());
				// bizRole代表只能获取业务角色，不要获取管理角色。（权限委托不能委托管理角色）
				menuItemVO.setRoleType("bizRole");
				// 获取用户被委托的所有角色、组织、岗位
				delegateRoleIdList = imenuDAO.getUserRolesIncludeDelegates(menuItemVO);
			}
			// over

			// 设置用户组织单元
			if (needUserUnits) {
				for (int i = 0; i < returnValue.size(); i++) {
					WF_ORG_USER user = (WF_ORG_USER) returnValue.get(i);
					WF_ORG_UNIT unitParam = new WF_ORG_UNIT();
					unitParam.setUserId(user.getUserId());
					// 2011年5月11日 增加对委托权限的提取
					unitParam.setDelegateUnitIdList(delegateRoleIdList);
					List unitList = iunitDAO.getUnitByCondition(unitParam);
					// 获取组织单元的扩展信息
					if (unitList != null && unitList.size() > 0) {
						for (int j = 0; j < unitList.size(); j++) {
							WF_ORG_UNIT unit = (WF_ORG_UNIT) unitList.get(j);
							if (unit.getExtInfoMap() == null) {
								unit.setExtInfoMap(iunitDAO.getExtInfo("unit", unit.getUnitId()));
							}
						}
					}
					user.setUserUnitList(unitList);
				}
			}
			// 设置用户岗位
			if (needUserStation) {
				for (int i = 0; i < returnValue.size(); i++) {
					WF_ORG_USER user = (WF_ORG_USER) returnValue.get(i);
					WF_ORG_STATION stationParam = new WF_ORG_STATION();
					stationParam.setUserId(user.getUserId());
					// 2011年5月11日 增加对委托权限的提取
					stationParam.setDelegateStationIdList(delegateRoleIdList);
					List stationList = istationDAO.getStationByCondition(stationParam);
					user.setStationList(stationList);
				}
			}
			// 设置用户角色
			if (needUserRoles) {
				for (int i = 0; i < returnValue.size(); i++) {
					WF_ORG_USER user = (WF_ORG_USER) returnValue.get(i);
					WF_ORG_ROLE unitParam = new WF_ORG_ROLE();
					unitParam.setUserId(user.getUserId());
					// 2011年5月11日 增加对委托权限的提取
					unitParam.setDelegateRoleIdList(delegateRoleIdList);
					// unitParam.setIsAdminrole("否");
					List roleList = iroleDAO.getRoleByCondition(unitParam);
					user.setUserRoleList(roleList);
				}
			}
			// 设置用户扩展信息
			if (needUserExtInfo) {
				for (int i = 0; i < returnValue.size(); i++) {
					WF_ORG_USER user = (WF_ORG_USER) returnValue.get(i);
					user.setExtInfoMap(iuserDAO.getExtInfo("user", user.getUserId()));
				}
			}
		} catch (DataAccessException dae) {
			dae.printStackTrace();
			throw new ServiceException(dae.getMessage());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnValue;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据userid数组获取用户
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param userVO
	 *            - 用户VO
	 * @return 如果找到，返回ArrayList<WF_ORG_USER> 如果没有找到，返回new ArrayList
	 * @throws ServiceException
	 */
	public List getUserByIDs(WF_ORG_USER userVO) throws ServiceException {
		List returnValue = new ArrayList();
		try {
			returnValue = iuserDAO.getUserByIDs(userVO);
		} catch (DataAccessException dae) {
			dae.printStackTrace();
			throw new ServiceException(dae.getMessage());
		}
		return returnValue;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获取用户（分页）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param userVO
	 *            - 用户帐号
	 * @return 如果找到，返回List<WF_ORG_USER> 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public List getPagingUser(WF_ORG_USER userVO) throws ServiceException {

		List returnValue = new ArrayList();
		try {
			returnValue = iuserDAO.getUserByCondition(userVO);
		} catch (DataAccessException dae) {
			dae.printStackTrace();
			throw new ServiceException(dae.getMessage());
		}
		return returnValue;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取用户的总数，用于表格分页
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @return 用户总数
	 * @throws ServiceException
	 */
	public int getUserCount(String userID, String userAccount, String userName, String unitID, String password,
			String adminRoleID, String currLoginUserID, String userAccountLocked) throws ServiceException {
		int roleCount = 0;
		try {
			WF_ORG_USER userVO = new WF_ORG_USER();
			userVO.setUserId(userID);
			userVO.setUserAccount(userAccount);
			userVO.setUserFullname(userName);
			userVO.setUnitID(unitID);
			userVO.setUserPassword(password);
			userVO.setRoleId(null);
			userVO.setAdminRoleID(adminRoleID);
			userVO.setCurrentLoginUserID(currLoginUserID);
			userVO.setUserAccountLocked(userAccountLocked);

			roleCount = iuserDAO.getUserCount(userVO);
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
	 * 描述: 保存用户，包括（人员基本信息、人员扩展信息、人员的组织单元、人员的岗位、人员的角 色）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param userVO
	 *            - 人员vo，包括（人员基本信息、人员扩展信息、人员的组织单元、人员的岗位、人员的角色 ）
	 * @param saveType
	 *            - 保存类型，0：新增保存，1：修改保存
	 * @param extTableName
	 *            - 扩展表名称
	 * @param idColumnName
	 *            - 扩展表id名称
	 * @return 保存后的WF_ORG_USER
	 * @throws ServiceException
	 */
	public void saveUser(WF_ORG_USER userVO, String saveType, String extTableName, String idColumnName)
			throws ServiceException {
		try {
			// 修改时没有密码，所以不需要加密。
			if (userVO.getUserPassword() != null) {
				String saltKey = SecurityUserHoder.getCurrentUser().getSaltkey();
				userVO.setUserPassword(passwordEncoder.encodePassword(userVO.getUserPassword(), saltKey));
			}
			// 如果是新增保存
			if (saveType.equals("0")) {
				// 检测帐户是否已经存在
				WF_ORG_USER userParam = new WF_ORG_USER();
				userParam.setUserAccount(userVO.getUserAccount());
				List userListTemp = iuserDAO.getUserByCondition(userParam);
				if (userListTemp == null || userListTemp.size() > 0) {
					throw new DataAccessException("用户帐户已经存在!");
				}
				iuserDAO.createUser(userVO, extTableName, idColumnName);
			} else {
				iuserDAO.updateUser(userVO, extTableName, idColumnName);
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
	 * 描述: 删除人员，如果人员已经被使用则不被删除
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param userIDs
	 *            - 用户id
	 * @throws ServiceException
	 */
	public void deleteUser(List userIDs, String extTableName, String idColumnName) throws ServiceException {
		try {
			for (int i = 0; i < userIDs.size(); i++) {
				// userID不为“”
				if (!userIDs.get(i).toString().equals("")) {
					iuserDAO.deleteUser(userIDs.get(i).toString(), extTableName, idColumnName);
					WF_ORG_RESOURCE_AUTHORITY delParam = new WF_ORG_RESOURCE_AUTHORITY();
					delParam.setRoleId(userIDs.get(i).toString());
					menuGrantDAO.deletePrivileges(delParam);
					menuGrantDAO.deleteUserExclude(userIDs.get(i).toString(), null);
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
	 * 描述: 锁定用户
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param userID
	 *            - 用户id
	 * @throws ServiceException
	 */
	public void lockUser(String userID, String isLocked) throws ServiceException {
		try {
			iuserDAO.lockUser(userID, isLocked);
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
	 * 描述: 根据条件获取人员，包括（人员基本信息、人员扩展信息、人员的组织单元、人员的岗位、 人员的角色）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param userID
	 *            - 人员ID
	 * @return 如果找到，返回WF_ORG_USER 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public WF_ORG_USER getUserDetail(String userID) throws ServiceException {
		WF_ORG_USER returnUser = null;
		List userList = new ArrayList();
		try {
			WF_ORG_USER userVO = new WF_ORG_USER();
			userVO.setUserId(userID);
			userList = iuserDAO.getUserByCondition(userVO);
			if (userList != null && userList.size() > 0) {
				returnUser = (WF_ORG_USER) userList.get(0);
				// 设置用户组织
				WF_ORG_UNIT unitParam = new WF_ORG_UNIT();
				unitParam.setUserId(userID);
				List unitList = iunitDAO.getUnitByCondition(unitParam);
				returnUser.setUnitList(unitList);
				// 设置用户角色
				WF_ORG_ROLE roleParam = new WF_ORG_ROLE();
				roleParam.setUserId(userID);
				List roleList = iroleDAO.getRoleByCondition(roleParam);
				returnUser.setRoleList(roleList);
				// 设置用户岗位
				WF_ORG_STATION stationParam = new WF_ORG_STATION();
				stationParam.setUserId(userID);
				List stationList = istationDAO.getStationByCondition(stationParam);
				returnUser.setStationList(stationList);

				returnUser.setExtInfoMap(iuserDAO.getExtInfo("user", userID));
			}
		} catch (DataAccessException dae) {
			dae.printStackTrace();
			throw new ServiceException(dae.getMessage());
		}
		return returnUser;
	}

	public void setIunitDAO(IUnitDAO iunitDAO) {
		this.iunitDAO = iunitDAO;
	}

	public IUnitDAO getIunitDAO() {
		return iunitDAO;
	}

	public IUserDAO getIuserDAO() {
		return iuserDAO;
	}

	public void setIuserDAO(IUserDAO iuserDAO) {
		this.iuserDAO = iuserDAO;
	}

	public IRoleDAO getIroleDAO() {
		return iroleDAO;
	}

	public void setIroleDAO(IRoleDAO iroleDAO) {
		this.iroleDAO = iroleDAO;
	}

	public IPositionDAO getIstationDAO() {
		return istationDAO;
	}

	public void setIstationDAO(IPositionDAO istationDAO) {
		this.istationDAO = istationDAO;
	}

	public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
	}

	public PasswordEncoder getPasswordEncoder() {
		return passwordEncoder;
	}

}
