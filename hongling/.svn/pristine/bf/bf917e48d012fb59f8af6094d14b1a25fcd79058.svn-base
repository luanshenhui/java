package chinsoft.business;


import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;

import chinsoft.core.DataAccessObject;
import chinsoft.entity.Dict;
import chinsoft.entity.Fabric;
import chinsoft.entity.GroupMenu;

public class GroupMenuManager {

	private static List<GroupMenu> groupMenus = null;
	DataAccessObject dao = new DataAccessObject();

	public GroupMenuManager() {}
	
	@SuppressWarnings("unchecked")
	private List<GroupMenu> getAllGroupMenus()
    {
        if (groupMenus == null)
        {
            groupMenus = (List<GroupMenu>) dao.getAll(GroupMenu.class);
        }
        return groupMenus;
    }

	@SuppressWarnings("unchecked")
	private List<GroupMenu> getAllGroupMenus(Session session)
    {
        if (groupMenus == null)
        {
        	String queryString = "FROM " + GroupMenu.class.getName();
            groupMenus = (List<GroupMenu>) session.createQuery(queryString).list();
        }
        return groupMenus;
    }
	
    public void saveGroupMenu(GroupMenu groupMenu)
    {
    	GroupMenu oldGroupMenu=(GroupMenu) dao.getEntityByID(GroupMenu.class, groupMenu.getID());
    	if (null==groupMenu.getMenuIDs()) {
    		groupMenu.setMenuIDs(oldGroupMenu.getMenuIDs());
		}else if(null==groupMenu.getQorderMenuIDs()){
			groupMenu.setQorderMenuIDs(oldGroupMenu.getQorderMenuIDs());
		}
        dao.saveOrUpdate(groupMenu);
        groupMenus = null;
    }

    public String getGroupFunctions(Integer nGroupID)
    {
        
        List<GroupMenu> groupMenus = this.getAllGroupMenus();
        for(GroupMenu groupMenu : groupMenus)
        {
            if (groupMenu.getID().equals(nGroupID))
            {
                return groupMenu.getMenuIDs();
            }
        }
        return "";
    }
    
    /**
     * 快速下单权限
     */
    public String getQGroupFunctions(Integer nGroupID)
    {
        
        List<GroupMenu> groupMenus = this.getAllGroupMenus();
        for(GroupMenu groupMenu : groupMenus)
        {
            if (groupMenu.getID().equals(nGroupID))
            {
                return groupMenu.getQorderMenuIDs();
            }
        }
        return "";
    }
    
    public String getGroupFunctions(Integer nGroupID, Session session)
    {
        
        List<GroupMenu> groupMenus = this.getAllGroupMenus(session);
        for(GroupMenu groupMenu : groupMenus)
        {
            if (groupMenu.getID().equals(nGroupID))
            {
                return groupMenu.getMenuIDs();
            }
        }
        return "";
    }
    
    // 3d模块 菜单及工艺权限
    public List<Dict> getAllFunctions()
    {
        List<Dict> menus = new ArrayList<Dict>();
//        menus = DictManager.getDicts(CDictCategory.ClothingCategory.getID());
        List<Dict> backendMenus = DictManager.getDicts(CDictCategory.BackendMenu.getID());
        List<Dict> newRCMTMMenus = DictManager.getDicts(55);
        List<Dict> newRCMTMMenus2 = DictManager.getDicts(54);
        
        // 3d服装大类
        String strHql = "FROM Dict WHERE id in (3,2000,3000,4000,6000,90000,18000,95000,98000,11000,103000,106000,107000,108000,109000,110000,113000,116000,119000,122000,125000,15000,5000,210000,213000) ";
        menus.addAll(DataAccessObject.openSession().createQuery(strHql).list());
        
        // 3d深度设计款式设计
        strHql = " FROM Dict WHERE parentid in (3,2000,3000,4000,6000,90000,18000,95000,98000,11000,103000,106000,107000,108000,109000,110000,113000,116000,119000,122000,125000,15000,5000,210000,213000) and name in ('设计款式','深度设计')";
        menus.addAll(DataAccessObject.openSession().createQuery(strHql).list());
        
        // 3d Menu
        strHql = " from Dict  where parentid in (select id  FROM Dict WHERE parentid in (3,2000,3000,4000,6000,90000,18000,95000,98000,11000,103000,106000,107000,108000,109000,110000,113000,116000,119000,122000,125000,15000,5000,210000,213000) and name in ('设计款式','深度设计')) and notshowonfront is null  and statusid is null";
        menus.addAll(DataAccessObject.openSession().createQuery(strHql).list());
        
        // 3d工艺
        List<Object[]> crafts = null;
        strHql = "select * FROM Dict WHERE notshowonfront is null and statusid=10001 start with parentid in (select id from dict  where parentid in (select id  FROM Dict WHERE parentid in (3,2000,3000,4000,6000,90000,18000,95000,98000,11000,103000,106000,107000,108000,109000,110000,113000,116000,119000,122000,125000,15000,5000,210000,213000) and name in ('设计款式','深度设计')) and notshowonfront is null  and statusid is null) connect by prior id=parentid";
        crafts = DataAccessObject.openSession().createSQLQuery(strHql).list();
        
        for (Object[] o : crafts) {
			Dict d = new Dict();
			d.setID(Integer.valueOf(String.valueOf(o[0] == null ? 0 : o[0])));
			d.setName(String.valueOf(o[1]));
			d.setCategoryID(Integer.parseInt(String.valueOf(o[2] == null ? 0 : o[2])));
			d.setCode(String.valueOf(o[3]));
			d.setSequenceNo(Integer.parseInt(String.valueOf(o[4] == null ? 0 : o[4])));
			d.setParentID(Integer.parseInt(String.valueOf(o[5] == null ? 0 : o[5])));
			d.setStatusID(Integer.parseInt(String.valueOf(o[6] == null ? 0 : o[6])));
			d.setConstDefine(String.valueOf(o[7]));
			d.setEcode(String.valueOf(o[8]));
			d.setExclusionGroupID(Integer.parseInt(String.valueOf(o[9] == null ? 0 : o[9])));
			d.setMediumGroupID(Integer.parseInt(String.valueOf(o[10] == null ? 0 : o[10])));
			d.setIsDefault(Integer.parseInt(String.valueOf(o[11] == null ? 0 : o[11])));
			d.setBodyType(String.valueOf(o[12]));
			d.setMemo(String.valueOf(o[13]));
			d.setZindex(Integer.parseInt(String.valueOf(o[14] == null ? 0 : o[14])));
			d.setColorLinkIDs(String.valueOf(o[15]));
			d.setShapeLinkIDs(String.valueOf(o[16]));
			d.setExtension(String.valueOf(o[17]));
			d.setIsElement(Integer.parseInt(String.valueOf(o[18] == null ? 0 : o[18])));
			d.setEn(String.valueOf(o[19]));
			d.setPosition(String.valueOf(o[20]));
			d.setIsSingleCheck(Integer.parseInt(String.valueOf(o[21] == null ? 0 : o[21])));
			d.setPrice(Double.parseDouble(String.valueOf(o[22] == null ? 0 : o[22])));
			d.setOccupyFabric(Double.parseDouble(String.valueOf(o[23] == null ? 0 : o[23])));
			d.setAffectedAllow(String.valueOf(o[24]));
			d.setAffectedDisabled(String.valueOf(o[25]));
			d.setNotShowOnFront(Integer.parseInt(String.valueOf(o[26] == null ? 0 : o[26])));
			d.setParentFabric(String.valueOf(o[27]));
			d.setDollarPrice(Double.parseDouble(String.valueOf(o[28] == null ? 0 : o[28])));
			d.setIsShow(Integer.parseInt(String.valueOf(o[32] == null ? 0 : o[32])));
			menus.add(d);
		}
        
        for(Dict d:backendMenus){
        	menus.add(d);
        }
        for(Dict d:newRCMTMMenus){
        	menus.add(d);
        }
        for(Dict d : newRCMTMMenus2){
        	menus.add(d);
        }
        return menus;
    }
    
    // 3d模块 面料权限
    @SuppressWarnings("unchecked")
	public List<Fabric> getAllFabricFunctions()
    {
        List<Fabric> menus = new ArrayList<Fabric>();
        
     // 3d客供面料
        String strHql = " FROM Fabric WHERE fabricsupplycategoryid =10321 order by categoryid ";
        menus.addAll(DataAccessObject.openSession().createQuery(strHql).list());
        
        return menus;

    }
    
    public List<Dict> getAllFunctionsQorder()
    {
    	List<Dict> ret = new ArrayList<Dict>();
    	
    	List<Dict> menus = new ArrayList<Dict>();
    	String strHQL=" FROM Dict1 WHERE categoryID=1";
    	menus=DataAccessObject.openSession().createQuery(strHQL).list();
    	
    	ret.addAll(menus);
    	
        menus = new ArrayList<Dict>();
        strHQL=" FROM Dict1 WHERE categoryID=33";
        menus=DataAccessObject.openSession().createQuery(strHQL).list();
        
        ret.addAll(menus);
        
        return ret;
    }
    
    //public List<Dict> GetAuthorityMenus(Member member)
    //{
        //int nGroupID = Utility.toSafeInt(member.getGroupID());
        //List<Dict> menus = GetGroupFunctions(nGroupID);

        //return menus.Where(menu => menu.statusID != CDict.FunctionOperation.ID).ToList<Dict>();
    //}
    
}