package com.dhc.authorization.resource.facade.impl;

import java.util.ArrayList;
import java.util.List;

import com.dhc.authorization.resource.facade.IPrivilegeFacade;
import com.dhc.authorization.resource.facade.ResourceBean;
import com.dhc.authorization.resource.facade.exception.PrivilegeFacadeException;
import com.dhc.authorization.resource.menu.domain.WF_ORG_MENU;
import com.dhc.authorization.resource.menu.service.MenuService;
import com.dhc.authorization.resource.privilege.service.PrivilegeService;
import com.dhc.organization.facade.exception.OrgFacadeException;

/**
 * brief description
 * <p>
 * Date : 2010/05/13
 * </p>
 * <p>
 * Module : 组织机构权限管理接口
 * </p>
 * <p>
 * Description: 权限接口外观实现
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
public class PrivilegeFacadeImpl implements IPrivilegeFacade {

	private static final String QUERY_TYPE_RESOURCE_ID = "RESOURCE_ID";
	private static final String QUERY_TYPE_URL = "URL";

	/**
	 * 菜单管理业务服务对象
	 */
	private MenuService menuService;

	/**
	 * 在获取用户“菜单权限”的时候，是否要一并获取用户的“页面权限”
	 */
	private boolean includePages = false;

	/**
	 * 权限业务服务对象
	 */
	private PrivilegeService privilegeService;

	/**
	 * 构造函数
	 */
	public PrivilegeFacadeImpl() {

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据帐户获取菜单权限
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userID
	 *            - 帐户
	 * @param menuCategory
	 *            - 取菜单时的菜单分类，用于例如不同子系统看到的菜单不一样的问题
	 * @return 用户可以访问的菜单列表
	 * @throws OrgFacadeException
	 */
	public List<ResourceBean> getUserAvailableMenus(String userID, String menuCategory)
			throws PrivilegeFacadeException {
		// menuService不可为空
		if (menuService == null)
			throw new PrivilegeFacadeException("PrivilegeFacade没有被正确初始化");
		// 帐户和资源类型不可为空
		if (userID == null || userID.equals(""))
			throw new PrivilegeFacadeException("帐户不可为空");
		// menuCategory如果是空串，则置为null
		menuCategory = (menuCategory == null || menuCategory.equalsIgnoreCase("iFramework") || menuCategory.equals(""))
				? null : menuCategory;

		List<ResourceBean> resourceList = new ArrayList<ResourceBean>();
		try {
			// 获取整个菜单树，如果传false则只获取一级菜单
			List tempList = menuService.getMenuTreeData(userID, "true", (includePages ? null : "MENU"), // (有时需要判断page的权限，不仅是menu。)
					menuCategory, "available");
			for (int i = 0; i < tempList.size(); i++) {
				WF_ORG_MENU menu = (WF_ORG_MENU) tempList.get(i);
				ResourceBean rb = new ResourceBean();
				rb.setParentResourceID(menu.getParentMenuCode());
				rb.setResourceArea(menu.getMenuArea());
				rb.setResourceDesc(menu.getMenuDesc());
				rb.setResourceElementId(menu.getMenuElementId());
				rb.setResourceElementType(menu.getMenuElementType());
				rb.setResourceID(menu.getMenuCode());
				rb.setResourceImgLocation(menu.getMenuImgLocation());
				rb.setResourceIsDefault(menu.getMenuIsDefault());
				rb.setResourceLevel(menu.getMenuLevel());
				rb.setResourceLocation(menu.getMenuLocation());
				rb.setResourceName(menu.getMenuName());
				rb.setResourceType(menu.getMenuType());
				rb.setResourceOrder(menu.getMenuOrder());
				resourceList.add(rb);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			new PrivilegeFacadeException("菜单权限计算异常");
		}
		return resourceList;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 判断菜单项是否可用
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userID
	 *            - 帐户
	 * @param menuID
	 *            - 菜单id
	 * @param menuCategory
	 *            - 取菜单时的菜单分类，用于例如不同子系统看到的菜单不一样的问题
	 * @return 返回true有效，返回false无效
	 * @throws OrgFacadeException
	 */
	public boolean isMenuAvailable(String userID, String menuID, String menuCategory) throws PrivilegeFacadeException {
		boolean isAvailable = false;
		try {
			if (userID == null)
				throw new PrivilegeFacadeException("userID is null!");
			if (userID.equalsIgnoreCase("adminUser"))
				isAvailable = true;
			else {
				includePages = true;
				List<ResourceBean> rbList = this.getUserAvailableMenus(userID, menuCategory);
				includePages = false;
				if (rbList != null) {
					for (int i = 0; i < rbList.size(); i++) {
						ResourceBean rb = rbList.get(i);
						if (rb.getResourceLocation() != null && rb.getResourceLocation().equalsIgnoreCase(menuID)) {
							isAvailable = true;
							break;
						}
					}
				}
				// 下面因为修改而注释，获取资源需要考虑授权问题，暂时使用getUserAvailableMenus的实现来解决。
				// isAvailable = privilegeService.isResourceAvailable(userID,
				// QUERY_TYPE_RESOURCE_ID, menuID);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new PrivilegeFacadeException("用户菜单权限判断异常");
		}
		return isAvailable;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 判断资源是否可用
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userID
	 *            - 用户ID
	 * @param URL
	 *            - 资源的URL（不带应用名，以“\”开始）
	 * @param menuCategory
	 *            - 取菜单时的菜单分类，用于例如不同子系统看到的菜单不一样的问题
	 * @return 返回true有效，返回false无效
	 * @throws OrgFacadeException
	 */
	public boolean isURLAvailable(String userID, String strURL, String menuCategory) throws PrivilegeFacadeException {
		boolean isAvailable = false;
		try {
			if (userID == null)
				throw new PrivilegeFacadeException("userID is null!");
			if (userID.equalsIgnoreCase("adminUser"))
				isAvailable = true;
			else {
				includePages = true;
				List<ResourceBean> rbList = this.getUserAvailableMenus(userID, menuCategory);
				includePages = false;
				if (rbList != null) {
					for (int i = 0; i < rbList.size(); i++) {
						ResourceBean rb = rbList.get(i);
						if (rb.getResourceLocation() != null && rb.getResourceLocation().equalsIgnoreCase(strURL)) {
							isAvailable = true;
							break;
						}
					}
				}
				// 下面因为修改而注释，获取资源需要考虑授权问题，暂时使用getUserAvailableMenus的实现来解决。
				// isAvailable = privilegeService.isResourceAvailable(userID,
				// QUERY_TYPE_URL, strURL);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			new PrivilegeFacadeException("用户URL权限判断异常");
		}
		return isAvailable;
	}

	public void setMenuService(MenuService menuService) {
		this.menuService = menuService;
	}

	public MenuService getMenuService() {
		return menuService;
	}

	public void setPrivilegeService(PrivilegeService privilegeService) {
		this.privilegeService = privilegeService;
	}

	public PrivilegeService getPrivilegeService() {
		return privilegeService;
	}
}
