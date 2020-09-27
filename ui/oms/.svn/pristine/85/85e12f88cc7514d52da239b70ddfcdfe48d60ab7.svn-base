package cn.rkylin.oms.system.menu.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import cn.rkylin.core.service.ApolloService;
import cn.rkylin.oms.system.config.OrgI18nConsts;
import cn.rkylin.oms.system.menu.dao.IMenuDAO;
import cn.rkylin.oms.system.menu.domain.WF_ORG_MENU;
@Service("menuService")
public class MenuServiceImpl extends ApolloService implements IMenuService{
	@Autowired
	private IMenuDAO menuDAO;

	@SuppressWarnings("rawtypes")
	@Override
	public List getFormElementList(String userID, String menuItemID, String authorityType, String menuCategory) throws Exception {
		WF_ORG_MENU menuItemVO = new WF_ORG_MENU();
		menuItemVO.setUserID(userID);
		menuItemVO.setParentMenuCode(menuItemID);
		menuItemVO.setAuthorityType(authorityType);
		menuItemVO.setMenuCategory(menuCategory);
		return menuDAO.getMenuItemsByCondition(menuItemVO, "0");
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
	@Override
	public List getMenuTreeData(String userID, String expandAll, String menuType, String menuCategory,
			String authorityType) throws Exception {
		WF_ORG_MENU menuItemVO = new WF_ORG_MENU();
		// menuItemVO.setParentMenuCode(null);
		if (!expandAll.equalsIgnoreCase("1") && !expandAll.equalsIgnoreCase("true"))
			menuItemVO.setParentMenuCode("RootMenu");
		menuItemVO.setUserID(userID);
		menuItemVO.setMenuType(menuType);
		menuItemVO.setMenuCategory(menuCategory);
		menuItemVO.setAuthorityType(authorityType);
		return menuDAO.getMenuItemsByCondition(menuItemVO, expandAll);
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
	public WF_ORG_MENU getMenuItemDetail(String userID, String menuItemID) throws Exception {
		WF_ORG_MENU menuVO = new WF_ORG_MENU();
		menuVO.setUserID(userID);
		menuVO.setMenuCode(menuItemID);
		List list = null;
		try {
			list = menuDAO.getMenuItemsByCondition(menuVO, "1");
			menuVO = (WF_ORG_MENU) list.get(0);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new Exception(OrgI18nConsts.EXCEPTION_DBACCESS);
		} 
		return menuVO;
	}

	@Override
	public void saveMenuItem(WF_ORG_MENU menuItemVO) throws Exception {
		
		menuDAO.updateMenuItem(menuItemVO);
	}

	@Override
	public void savePageItem(WF_ORG_MENU pageItemVO) throws Exception {
		// TODO Auto-generated method stub
		menuDAO.updatePageItem(pageItemVO);
	}

	@Override
	public void savePageElement(WF_ORG_MENU menuItemVO) throws Exception {
		// TODO Auto-generated method stub
		menuDAO.updatePageElement(menuItemVO);
	}

	@Override
	public void createMenuItem(WF_ORG_MENU menuItemVO) throws Exception {
		// TODO Auto-generated method stub
		menuDAO.insertMenuItem(menuItemVO);
	}
	
	

	
	
}
