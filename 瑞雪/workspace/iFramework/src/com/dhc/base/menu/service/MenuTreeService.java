package com.dhc.base.menu.service;

import java.util.List;

import com.dhc.authorization.resource.facade.exception.PrivilegeFacadeException;
import com.dhc.base.core.Service;
import com.dhc.base.menu.vo.MenuTreeVO;

public interface MenuTreeService extends Service {
	public List getUserAvailableMenus(String username, String appName) throws PrivilegeFacadeException;

	public List getFavouriteMenuList(String username);

	public MenuTreeVO getNewFavMenuInfo(String targetMenuId, String username);

	public void insertMenuTree(MenuTreeVO vo);

	public MenuTreeVO getFavMenuInof(MenuTreeVO vo);

	public void updateMenuTree(List voList, String username);
}
