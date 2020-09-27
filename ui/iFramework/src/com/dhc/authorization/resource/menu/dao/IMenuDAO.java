
package com.dhc.authorization.resource.menu.dao;

import java.sql.SQLException;
import java.util.List;

import com.dhc.authorization.resource.menu.domain.WF_ORG_MENU;
import com.dhc.base.exception.DataAccessException;

public interface IMenuDAO {

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获取菜单项（不包括页面元素）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param menuItemVO
	 *            - 菜单vo，作为查询条件
	 * @return 如果找到，返回List<WF_ORG_MENU> 如果没有找到，返回null
	 * @throws DataAccessException
	 */
	public List getMenuItemsByCondition(WF_ORG_MENU menuItemVO, String expandAll) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 保存对菜单项的修改
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param menuItemVO
	 *            - 菜单项vo
	 * @throws DataAccessException
	 */
	public void updateMenuItem(WF_ORG_MENU menuItemVO) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 保存对菜单项的修改
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param menuItemVO
	 *            - 菜单项vo
	 * @throws DataAccessException
	 */
	public void updatePageItem(WF_ORG_MENU pageItemVO) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 新建一个菜单项，需要给MenuItem创建一个uuid
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param menuItemVO
	 *            - 菜单项vo
	 * @throws DataAccessException
	 */
	public void insertMenuItem(WF_ORG_MENU menuItemVO) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 保存对页面元素的修改
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param menuItemVO
	 *            - 菜单项vo
	 * @throws DataAccessException
	 */
	public void updatePageElement(WF_ORG_MENU menuItemVO) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 新建页面元素，需要给PageElement创建一个uuid
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param menuItemVO
	 *            - 菜单项vo
	 * @throws DataAccessException
	 */
	public void insertPageElement(WF_ORG_MENU menuItemVO) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 新建页面，需要给Page创建一个uuid
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param menuItemVO
	 *            - 菜单项vo
	 * @throws DataAccessException
	 */
	public void insertPage(WF_ORG_MENU menuItemVO) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 删除菜单树上的结点，可能是菜单项，也可能是元素。菜单项下如果存在元素则先删除子菜 单项。
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param nodeID
	 *            - 结点主键
	 * @throws DataAccessException
	 */
	public void deleteNode(String nodeID) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 树上节点上移。
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param nodeID
	 *            - 结点主键
	 * @throws DataAccessException
	 */
	public void upNode(String itemId, String changeId) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 树上节点下移。
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param nodeID
	 *            - 结点主键
	 * @throws DataAccessException
	 */
	public void downNode(String itemId, String changeId) throws DataAccessException;

	/**
	 * 获取某用户的所有角色、组织、岗位id，包括被委托的。
	 * 
	 * @param menuItemVO
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	public List getUserRolesIncludeDelegates(WF_ORG_MENU menuItemVO) throws SQLException, Exception;
}
