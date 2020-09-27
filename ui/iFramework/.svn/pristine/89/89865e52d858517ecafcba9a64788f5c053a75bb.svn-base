package com.dhc.organization.role.dao.ibatis;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import com.dhc.base.exception.DataAccessException;
import com.dhc.base.exception.ServiceException;
import com.dhc.organization.role.dao.IRoleDAO;
import com.dhc.organization.role.domain.WF_ORG_ROLE;
import com.dhc.organization.role.domain.WF_ORG_ROLE_UNIT;
import com.dhc.organization.role.domain.WF_ORG_USER_ROLE;

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
public class RoleDAOImpl extends SqlMapClientDaoSupport implements IRoleDAO {

	/**
	 * 构造函数
	 */
	public RoleDAOImpl() {

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 新建角色，包括（角色中的人员、角色可管理的组织单元）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param roleVO
	 *            - 角色vo，包含角色下的人员、角色可管理的组织列表
	 * @return 无
	 * @throws DataAccessException
	 */
	public void createRole(WF_ORG_ROLE roleVO) throws DataAccessException {
		try {
			this.getSqlMapClient().insert("WF_ORG_ROLE.insert", roleVO);
			// 插角色能管理的组织单元
			if (roleVO.getRoleManageUnitList() != null && roleVO.getRoleManageUnitList().size() > 0) {
				for (int i = 0; i < roleVO.getRoleManageUnitList().size(); i++) {
					String roleUnit = (String) roleVO.getRoleManageUnitList().get(i);
					WF_ORG_ROLE_UNIT ru = new WF_ORG_ROLE_UNIT();
					ru.setRoleId(roleVO.getRoleId());
					ru.setUnitId(roleUnit);
					this.getSqlMapClient().insert("WF_ORG_ROLE.insertRoleUnit", ru);
				}
			}
			// 插角色下的人员
			if (roleVO.getRoleUsersList() != null && roleVO.getRoleUsersList().size() > 0) {
				for (int i = 0; i < roleVO.getRoleUsersList().size(); i++) {
					String roleUser = (String) roleVO.getRoleUsersList().get(i);
					WF_ORG_USER_ROLE ur = new WF_ORG_USER_ROLE();
					ur.setRoleId(roleVO.getRoleId());
					ur.setUserId(roleUser);
					this.getSqlMapClient().insert("WF_ORG_ROLE.insertRoleUser", ur);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("数据库操作异常");
		}
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 修改角色，包括（角色下的人员、角色可管理的组织单元）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param roleVO
	 *            - 角色vo，包含角色下的人员、角色可管理的组织列表
	 * @return 无
	 * @throws DataAccessException
	 */
	public void updateRole(WF_ORG_ROLE roleVO) throws DataAccessException {
		try {
			this.getSqlMapClient().update("WF_ORG_ROLE.update", roleVO);
			// 删除角色可以管理的组织单元
			this.getSqlMapClient().delete("WF_ORG_ROLE.deleteRoleUnit", roleVO.getRoleId());
			// 删除角色下的所有人员
			this.getSqlMapClient().delete("WF_ORG_ROLE.deleteRoleUser", roleVO.getRoleId());
			// 插角色能管理的组织单元
			if (roleVO.getRoleManageUnitList() != null && roleVO.getRoleManageUnitList().size() > 0) {
				for (int i = 0; i < roleVO.getRoleManageUnitList().size(); i++) {
					String roleUnit = (String) roleVO.getRoleManageUnitList().get(i);
					WF_ORG_ROLE_UNIT ru = new WF_ORG_ROLE_UNIT();
					ru.setRoleId(roleVO.getRoleId());
					ru.setUnitId(roleUnit);
					this.getSqlMapClient().insert("WF_ORG_ROLE.insertRoleUnit", ru);
				}
			}
			// 插角色下的人员
			if (roleVO.getRoleUsersList() != null && roleVO.getRoleUsersList().size() > 0) {
				for (int i = 0; i < roleVO.getRoleUsersList().size(); i++) {
					String roleUser = (String) roleVO.getRoleUsersList().get(i);
					WF_ORG_USER_ROLE ur = new WF_ORG_USER_ROLE();
					ur.setRoleId(roleVO.getRoleId());
					ur.setUserId(roleUser);
					this.getSqlMapClient().insert("WF_ORG_ROLE.insertRoleUser", ur);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("数据库操作异常");
		}
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
	 * @param roleVO
	 *            - 角色条件值对象
	 * @return 如果找到，返回ArrayList<WF_ORG_ROLE> 如果没有找到，返回new ArrayList
	 * @throws DataAccessException
	 */
	public List getRoleByCondition(WF_ORG_ROLE roleVO) throws DataAccessException {
		List resultList = new ArrayList();
		try {
			if (roleVO.getEndRow() == 0)
				resultList = this.getSqlMapClient().queryForList("WF_ORG_ROLE.select", roleVO);
			else
				resultList = this.getSqlMapClient().queryForList("WF_ORG_ROLE.paging", roleVO);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("RoleDAO数据访问错误");
		}
		return resultList;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据多个roleID获取role
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @return 附件条件的角色列表
	 * @throws ServiceException
	 */
	public List getRoleByIDs(WF_ORG_ROLE roleVO) throws DataAccessException {
		List roleList = new ArrayList();
		try {
			roleList = getSqlMapClient().queryForList("WF_ORG_ROLE.selectByIDs", roleVO);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("根据条件查询角色时发生错误");
		}

		return roleList;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获取角色(分页)
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param roleVO
	 *            - 角色条件值对象
	 * @return 如果找到，返回ArrayList<WF_ORG_ROLE> 如果没有找到，返回new ArrayList
	 * @throws DataAccessException
	 */
	public List getPagingRole(WF_ORG_ROLE roleVO) throws DataAccessException {
		List resultList = new ArrayList();
		try {
			resultList = this.getSqlMapClient().queryForList("WF_ORG_ROLE.paging", roleVO);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("RoleDAO数据访问错误");
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
	 * @param 角色vo
	 * @return 如果找到，返回List<JT_UNIT_ROLE> 如果没有找到，返回null
	 * @throws DataAccessException
	 */
	public List getAllRoles(WF_ORG_ROLE roleVO) throws DataAccessException {
		List resultList = new ArrayList();
		try {
			resultList = this.getSqlMapClient().queryForList("WF_ORG_ROLE.select", roleVO);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("RoleDAO数据访问错误");
		}
		return resultList;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 删除角色。如果角色已经被使用则不会被删除且抛出DataAccessException
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param roleID
	 *            - 角色id
	 * @throws DataAccessException
	 */
	public void deleteRole(String roleID) throws DataAccessException {
		try {
			WF_ORG_ROLE delParam = new WF_ORG_ROLE();
			delParam.setRoleId(roleID);
			this.getSqlMapClient().delete("WF_ORG_ROLE.delete", roleID);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("角色已被使用，不能删除");
		}
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
	public int getRoleCount(WF_ORG_ROLE roleParam) throws DataAccessException {
		int returnValue = 0;
		try {
			returnValue = (Integer) this.getSqlMapClient().queryForObject("WF_ORG_ROLE.count", roleParam);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("角色已被使用，不能删除");
		}
		return returnValue;
	}
}
