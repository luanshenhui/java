package com.dhc.organization.role.dao;

import java.util.List;

import com.dhc.base.exception.DataAccessException;
import com.dhc.base.exception.ServiceException;
import com.dhc.organization.role.domain.WF_ORG_ROLE;

public interface IRoleDAO {

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
	public void createRole(WF_ORG_ROLE roleVO) throws DataAccessException;

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
	public void updateRole(WF_ORG_ROLE roleVO) throws DataAccessException;

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
	public List getRoleByCondition(WF_ORG_ROLE roleVO) throws DataAccessException;

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
	public List getPagingRole(WF_ORG_ROLE roleVO) throws DataAccessException;

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
	public List getAllRoles(WF_ORG_ROLE roleVO) throws DataAccessException;

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
	public void deleteRole(String roleID) throws DataAccessException;

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
	public int getRoleCount(WF_ORG_ROLE roleParam) throws DataAccessException;

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
	public List getRoleByIDs(WF_ORG_ROLE roleVO) throws DataAccessException;
}
