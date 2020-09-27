package com.dhc.base.menu.dao.ibatis;

import java.util.List;

import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import com.dhc.base.menu.dao.MenuTreeDAO;
import com.dhc.base.menu.vo.MenuTreeVO;

public class MenuTreeDAOImpl extends SqlMapClientDaoSupport implements MenuTreeDAO {

	public List getFavouriteMenuList(String username) {

		List list = (List) getSqlMapClientTemplate().queryForList("FAVOURITE_MENU.queryFavouriteMenu", username);
		return list;
	}

	public MenuTreeVO getMenuByMenuId(String targetMenuId) {
		MenuTreeVO vo = (MenuTreeVO) getSqlMapClientTemplate().queryForObject("FAVOURITE_MENU.getMenuByMenuId",
				targetMenuId);
		return vo;
	}

	public int getFavMenuCountByUserId(String username) {
		int favMenuCount = (Integer) getSqlMapClientTemplate().queryForObject("FAVOURITE_MENU.getFavMenuCountByUserId",
				username);
		return favMenuCount;
	}

	public void insertMenuTree(MenuTreeVO vo) {
		getSqlMapClientTemplate().insert("FAVOURITE_MENU.insertFavMenu", vo);
	}

	public MenuTreeVO getFavMenuInof(MenuTreeVO vo) {
		MenuTreeVO resultVo = (MenuTreeVO) getSqlMapClientTemplate().queryForObject("FAVOURITE_MENU.getFavMenuInof",
				vo);

		return resultVo;
	}

	public void deleteMenuTreeByUserID(String username) {
		getSqlMapClientTemplate().delete("FAVOURITE_MENU.deleteMenuTreeByUserID", username);

	}
}
