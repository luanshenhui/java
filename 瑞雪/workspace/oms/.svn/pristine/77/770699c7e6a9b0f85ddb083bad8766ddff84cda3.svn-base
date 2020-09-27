package cn.rkylin.oms.system.menu.dao;

import java.sql.SQLException;
import java.util.List;

import cn.rkylin.oms.system.menu.domain.WF_ORG_MENU;

public interface IMenuDAO {

	List getUserRolesIncludeDelegates(WF_ORG_MENU menuItemVO) throws SQLException, Exception;

	List getMenuItemsByCondition(WF_ORG_MENU menuItemVO, String string) throws Exception;
	
	void updateMenuItem(WF_ORG_MENU menuItemVO)throws Exception;

	void updatePageItem(WF_ORG_MENU menuItemVO) throws Exception;
	
	void updatePageElement(WF_ORG_MENU menuItemVO) throws Exception;
	
	void insertMenuItem(WF_ORG_MENU menuItemVO) throws Exception;
	
	void insertPageElement(WF_ORG_MENU menuItemVO) throws Exception;
	
	void insertPage(WF_ORG_MENU menuItemVO) throws Exception;
	
	void deleteNode(String nodeID) throws Exception;
	
	void upNode(String itemId, String changeId) throws Exception;
	
	void downNode(String itemId, String changeId) throws Exception;
}
