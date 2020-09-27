package com.dhc.base.menu.service.impl;

import java.util.Iterator;
import java.util.List;

import com.dhc.authorization.resource.facade.IPrivilegeFacade;
import com.dhc.authorization.resource.facade.exception.PrivilegeFacadeException;
import com.dhc.base.menu.dao.MenuTreeDAO;
import com.dhc.base.menu.service.MenuTreeService;
import com.dhc.base.menu.vo.MenuTreeVO;

public class MenuTreeServiceImpl implements MenuTreeService {
	private IPrivilegeFacade privilegeFacade;
	private MenuTreeDAO menuTreeDAO;

	public void setPrivilegeFacade(IPrivilegeFacade privilegeFacade) {
		this.privilegeFacade = privilegeFacade;
	}

	public IPrivilegeFacade getPrivilegeFacade() {
		return privilegeFacade;
	}

	/**
	 * @return the menuTreeDAO
	 */
	public MenuTreeDAO getMenuTreeDAO() {
		return menuTreeDAO;
	}

	/**
	 * @param menuTreeDAO
	 *            the menuTreeDAO to set
	 */
	public void setMenuTreeDAO(MenuTreeDAO menuTreeDAO) {
		this.menuTreeDAO = menuTreeDAO;
	}

	public List getUserAvailableMenus(String username, String appName) throws PrivilegeFacadeException {
		return privilegeFacade.getUserAvailableMenus(username, appName);
	}

	public List getFavouriteMenuList(String username) {
		return menuTreeDAO.getFavouriteMenuList(username);
	}

	public MenuTreeVO getNewFavMenuInfo(String targetMenuId, String username) {

		MenuTreeVO vo = (MenuTreeVO) menuTreeDAO.getMenuByMenuId(targetMenuId);
		int favMenuCount = menuTreeDAO.getFavMenuCountByUserId(username);

		if (vo != null) {
			vo.setFavouriteOrder(favMenuCount + 1);
			vo.setUserID(username);
		}
		return vo;
	}

	public MenuTreeVO getFavMenuInof(MenuTreeVO vo) {
		MenuTreeVO resultVo = (MenuTreeVO) menuTreeDAO.getFavMenuInof(vo);
		return resultVo;
	}

	public void insertMenuTree(MenuTreeVO vo) {
		menuTreeDAO.insertMenuTree(vo);
	}

	public void updateMenuTree(List voList, String username) {
		menuTreeDAO.deleteMenuTreeByUserID(username);
		if (voList == null || voList.size() == 0) {

		} else {
			Iterator it = voList.iterator();
			while (it.hasNext()) {
				MenuTreeVO tmpVo = (MenuTreeVO) it.next();
				menuTreeDAO.insertMenuTree(tmpVo);
			}
		}
	}
}
