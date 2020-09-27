package cn.rkylin.oms.system.menu.service;

import java.util.List;

import cn.rkylin.oms.system.facade.ResourceBean;
import cn.rkylin.oms.system.menu.domain.WF_ORG_MENU;



public interface IMenuService {

	List getFormElementList(String userID, String parentMenuCode, String showAllMenu, String menuCategory) throws Exception;

	List getMenuTreeData(String userID, String expandAll, String boo, String menuCategory, String showAllMenu) throws Exception;

	WF_ORG_MENU getMenuItemDetail(String userID, String menuItemID) throws Exception;
	
    void saveMenuItem(WF_ORG_MENU menuItemVO) throws Exception;
    
    void savePageItem(WF_ORG_MENU pageItemVO) throws Exception;
    
    void savePageElement(WF_ORG_MENU menuItemVO) throws Exception;
    
    void createMenuItem(WF_ORG_MENU menuItemVO) throws Exception;
    
    void createPageElement(WF_ORG_MENU menuItemVO) throws Exception;
    
    void createPage(WF_ORG_MENU menuItemVO) throws Exception;
    
    void deleteNode(String nodeID) throws Exception;
    
    void upNode(String itemId, String changeId) throws Exception;
    
    void downNode(String itemId, String changeId) throws Exception;
    
    List<ResourceBean> getUserAvailableMenus(String userID, String menuCategory, boolean includePages) throws Exception;
}
