package com.dhc.authorization.resource.facade;

import java.util.List;

import com.dhc.authorization.resource.facade.exception.PrivilegeFacadeException;

/**
 * brief description
 * <p>
 * Date : 2010/05/13
 * </p>
 * <p>
 * Module : 组织机构权限管理接口
 * </p>
 * <p>
 * Description: 权限接口外观
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
public interface IPrivilegeFacade {
	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据帐户获取可用的菜单
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param account
	 *            - 帐户
	 * @param menuCategory
	 *            - 取菜单时的菜单分类，用于例如不同子系统看到的菜单不一样的问题
	 * @return 用户可以访问的菜单列表
	 * @throws PrivilegeFacadeException
	 */
	public List<ResourceBean> getUserAvailableMenus(String account, String menuCategory)
			throws PrivilegeFacadeException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 判断菜单项是否可用
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param account
	 *            - 帐户
	 * @param menuID
	 *            - 菜单id
	 * @param menuCategory
	 *            - 取菜单时的菜单分类，用于例如不同子系统看到的菜单不一样的问题
	 * @return 返回true有效，返回false无效
	 * @throws PrivilegeFacadeException
	 */
	public boolean isMenuAvailable(String account, String menuID, String menuCategory) throws PrivilegeFacadeException;

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
	 * @throws PrivilegeFacadeException
	 */
	public boolean isURLAvailable(String userID, String strURL, String menuCategory) throws PrivilegeFacadeException;
}
