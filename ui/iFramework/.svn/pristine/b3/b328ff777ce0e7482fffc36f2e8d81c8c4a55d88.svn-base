package com.dhc.authorization.resource.menu.service;

import java.util.List;

import com.dhc.authorization.resource.menu.dao.IMenuDAO;
import com.dhc.authorization.resource.menu.domain.WF_ORG_MENU;
import com.dhc.authorization.resource.privilege.dao.IMenuGrantDAO;
import com.dhc.authorization.resource.privilege.domain.WF_ORG_RESOURCE_AUTHORITY;
import com.dhc.base.core.Service;
import com.dhc.base.exception.DataAccessException;
import com.dhc.base.exception.ServiceException;
import com.dhc.organization.config.OrgI18nConsts;

/**
 * brief description
 * <p>
 * Date : 2010/05/05
 * </p>
 * <p>
 * Module : 菜单管理
 * </p>
 * <p>
 * Description: 菜单业务对象
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
public class MenuService implements Service {
	private IMenuDAO imenuDAO;

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

	public MenuService() {
		super();
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取所有的菜单，用于显示MenuTree
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userID
	 *            - 用户id
	 * @param expandAll
	 *            - 是否获取全部结点
	 * @param menuType
	 *            - 需要获取的结点类型
	 * @param menuCategory
	 *            - 取菜单时的菜单分类，用于例如不同子系统看到的菜单不一样的问题
	 * @return 如果找到，返回List<WF_ORG_MENU> 如果没有找到，返回null
	 * @param authorityType
	 *            - 授权类型（assignable、available）
	 * @throws ServiceException
	 */
	public List getMenuTreeData(String userID, String expandAll, String menuType, String menuCategory,
			String authorityType) throws ServiceException {
		WF_ORG_MENU menuItemVO = new WF_ORG_MENU();
		// menuItemVO.setParentMenuCode(null);
		if (!expandAll.equalsIgnoreCase("1") && !expandAll.equalsIgnoreCase("true"))
			menuItemVO.setParentMenuCode("RootMenu");
		menuItemVO.setUserID(userID);
		menuItemVO.setMenuType(menuType);
		menuItemVO.setMenuCategory(menuCategory);
		menuItemVO.setAuthorityType(authorityType);
		List list = null;
		try {
			list = imenuDAO.getMenuItemsByCondition(menuItemVO, expandAll);
		} catch (DataAccessException ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_DBACCESS);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}
		return list;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取菜单项的明细信息
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param menuItemID
	 *            - 菜单项id
	 * @return 如果找到，返回WF_ORG_MENU 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public WF_ORG_MENU getMenuItemDetail(String userID, String menuItemID) throws ServiceException {
		WF_ORG_MENU menuVO = new WF_ORG_MENU();
		menuVO.setUserID(userID);
		menuVO.setMenuCode(menuItemID);
		List list = null;
		try {
			list = imenuDAO.getMenuItemsByCondition(menuVO, "1");
			menuVO = (WF_ORG_MENU) list.get(0);
		} catch (DataAccessException ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_DBACCESS);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}
		return menuVO;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取菜单项的明细信息
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param formElementID
	 *            - 页面元素id
	 * @return 如果找到，返回WF_ORG_MENU 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public WF_ORG_MENU getFormElementDetail(String formElementID) throws ServiceException {
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据menuItemID获取下面的所有PageElements
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param menuItemID
	 *            - 菜单项id
	 * @param authorityType
	 *            - 授权类型
	 * @return 如果找到，返回List<WF_ORG_MENU> 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public List getFormElementList(String userID, String menuItemID, String authorityType, String menuCategory)
			throws ServiceException {
		WF_ORG_MENU menuItemVO = new WF_ORG_MENU();
		menuItemVO.setUserID(userID);
		menuItemVO.setParentMenuCode(menuItemID);
		menuItemVO.setAuthorityType(authorityType);
		menuItemVO.setMenuCategory(menuCategory);

		List list = null;
		try {
			list = imenuDAO.getMenuItemsByCondition(menuItemVO, "0");
		} catch (DataAccessException ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_DBACCESS);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}
		return list;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 保存菜单项的更新
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param menuItemVO
	 *            - 要保存的菜单项vo
	 * @throws ServiceException
	 */
	public void saveMenuItem(WF_ORG_MENU menuItemVO) throws ServiceException {
		try {
			imenuDAO.updateMenuItem(menuItemVO);
		} catch (DataAccessException ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_DBACCESS);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 保存页面的更新
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param menuItemVO
	 *            - 要保存的菜单项vo
	 * @throws ServiceException
	 */
	public void savePageItem(WF_ORG_MENU pageItemVO) throws ServiceException {
		try {
			imenuDAO.updatePageItem(pageItemVO);
		} catch (DataAccessException ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_DBACCESS);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 创建新的菜单项
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param menuItemVO
	 *            - 要保存的菜单项vo
	 * @throws ServiceException
	 */
	public void createMenuItem(WF_ORG_MENU menuItemVO) throws ServiceException {
		try {
			imenuDAO.insertMenuItem(menuItemVO);
		} catch (DataAccessException ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_DBACCESS);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 保存页面元素的更新
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param menuItemVO
	 *            - 要保存的菜单项vo
	 * @throws ServiceException
	 */
	public void savePageElement(WF_ORG_MENU menuItemVO) throws ServiceException {
		try {
			imenuDAO.updatePageElement(menuItemVO);
		} catch (DataAccessException ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_DBACCESS);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 创建新的页面元素
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param menuItemVO
	 *            - 要保存的菜单项vo
	 * @throws ServiceException
	 */
	public void createPageElement(WF_ORG_MENU menuItemVO) throws ServiceException {
		try {
			imenuDAO.insertPageElement(menuItemVO);
		} catch (DataAccessException ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_DBACCESS);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 创建新的页面
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param menuItemVO
	 *            - 要保存的菜单项vo
	 * @throws ServiceException
	 */
	public void createPage(WF_ORG_MENU menuItemVO) throws ServiceException {
		try {
			imenuDAO.insertPage(menuItemVO);
		} catch (DataAccessException ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_DBACCESS);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}

	}

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
	 * @throws ServiceException
	 */
	public void deleteNode(String nodeID) throws ServiceException {
		try {
			imenuDAO.deleteNode(nodeID);
			WF_ORG_RESOURCE_AUTHORITY delParam = new WF_ORG_RESOURCE_AUTHORITY();
			delParam.setResourceId(nodeID);
			menuGrantDAO.deletePrivileges(delParam);
			menuGrantDAO.deleteUserExclude(null, nodeID);
		} catch (DataAccessException ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_DATA_IN_USE);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 节点向上移动。
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param nodeID
	 *            - 结点主键
	 * @throws ServiceException
	 */
	public void upNode(String itemId, String changeId) throws ServiceException {
		try {
			imenuDAO.upNode(itemId, changeId);
		} catch (DataAccessException ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_DBACCESS);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 节点向下移动。
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param nodeID
	 *            - 结点主键
	 * @throws ServiceException
	 */
	public void downNode(String itemId, String changeId) throws ServiceException {
		try {
			imenuDAO.downNode(itemId, changeId);
		} catch (DataAccessException ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_DBACCESS);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}

	}

	public void setImenuDAO(IMenuDAO imenuDAO) {
		this.imenuDAO = imenuDAO;
	}

	public IMenuDAO getImenuDAO() {
		return imenuDAO;
	}
}
