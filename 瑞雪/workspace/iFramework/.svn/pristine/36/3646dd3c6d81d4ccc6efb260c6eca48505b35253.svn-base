package com.dhc.organization.user.dao;

import java.util.List;
import java.util.Map;

import com.dhc.base.exception.DataAccessException;
import com.dhc.base.exception.ServiceException;
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
 * Description: 用户数据访问对象接口
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
public interface IUserDAO {

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获用户
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userVO
	 *            - 用户VO
	 * @return 如果找到，返回ArrayList<WF_ORG_USER> 如果没有找到，返回new ArrayList
	 * @throws DataAccessException
	 */
	public List getUserByCondition(WF_ORG_USER userVO) throws DataAccessException;

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
	 * @throws DataAccessException
	 */
	public List getUserByIDs(WF_ORG_USER userVO) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获用户(分页)
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userVO
	 *            - 用户VO
	 * @return 如果找到，返回ArrayList<WF_ORG_USER> 如果没有找到，返回new ArrayList
	 * @throws DataAccessException
	 */
	public List getPagingUser(WF_ORG_USER userVO) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据组织单元id获用户
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param unitID
	 *            - 组织单元id
	 * @return 如果找到，返回ArrayList<WF_ORG_USER> 如果没有找到，返回new ArrayList
	 * @throws DataAccessException
	 */
	public List getUserByUnitID(String unitID) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 分页获取用户
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param condMap
	 *            - 分页查询条件
	 * @return 无
	 * @throws DataAccessException
	 */
	public List getPagingUsers(Map condMap) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 新建人员，包括（人员基本信息、人员扩展信息、人员的组织单元、人员的岗位、人员的角 色）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userVO
	 *            - 人员VO，包括（人员基本信息、人员扩展信息、人员的组织单元、人员的岗位、人员的角色 ）
	 * @param extTableName
	 *            - 扩展表名称
	 * @param idColName
	 *            - 扩展表id列名称
	 * @throws DataAccessException
	 */
	public void createUser(WF_ORG_USER userVO, String extTableName, String idColName) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 修改人员，包括（人员基本信息、人员扩展信息、人员的组织单元、人员的岗位、人员的角 色）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userVO
	 *            - 人员vo，包括（人员基本信息、人员扩展信息、人员的组织单元、人员的岗位、人员的角色 ）
	 * @return 无
	 * @throws DataAccessException
	 */
	public void updateUser(WF_ORG_USER userVO, String extTableName, String idColName) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 删除人员。如果人员已经被使用则不会被删除且抛出DataAccessException
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userID
	 *            - 人员id
	 * @throws DataAccessException
	 */
	public void deleteUser(String userID, String extTableName, String idColumnName) throws DataAccessException;

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
	 * @throws DataAccessException
	 */
	public void lockUser(String userID, String isLocked) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取人员，包括（人员基本信息、人员扩展信息、人员的组织单元、人员的岗位、人员的角 色）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param roleID
	 *            - 角色主键
	 * @return 如果找到，返回WF_ORG_USER,包括（人员基本信息、人员扩展信息、人员的组织单元、人员 的岗位、人员的角色）
	 *         如果没有找到，返回null
	 * @throws DataAccessException
	 */
	public WF_ORG_USER getUserDetail(String roleID) throws DataAccessException;

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
	public int getUserCount(WF_ORG_USER userVO) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取扩展信息
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param extTableName
	 *            - 扩展表名称
	 * @throws DataAccessException
	 */
	public Map getExtInfo(String bizType, String idColumnValue) throws DataAccessException;
}
