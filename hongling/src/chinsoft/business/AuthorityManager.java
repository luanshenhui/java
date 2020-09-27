package chinsoft.business;

import java.util.List;

import chinsoft.core.DataAccessObject;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.GroupMenu;

public class AuthorityManager{

	DataAccessObject dao = new DataAccessObject();
	
	public void saveGroupMenu(GroupMenu groupMenu) {
		dao.saveOrUpdate(groupMenu);
	}

	public GroupMenu getGroupMenuByID(Integer nGroupID) {
		return (GroupMenu) dao.getEntityByID(GroupMenu.class, nGroupID);
	}
	
	private List<Dict> getAllMenu(){
		return DictManager.getDicts(CDictCategory.ClothingCategory.getID());
	}
	
	public String getTreeData(int nGroupID) {
		Dict dictGroup=DictManager.getDictByID(nGroupID);		
		String strSelectedMenu= dictGroup.getExtension();
		StringBuffer treeData=new StringBuffer();
		treeData.append("[");
		List<Dict> allMenu=getAllMenu();
		for (Dict menu :allMenu) {
			String ecode = "";
			if(menu.getEcode() != null&& !"".equals(menu.getEcode())){
				ecode = "[" + menu.getEcode() + "]";
			}
			if(Utility.contains(strSelectedMenu, Utility.toSafeString(menu.getID()))){
				treeData.append("{\"id\":"+menu.getID()+",\"pId\":"+menu.getParentID()+",\"name\":\""+menu.getName() + ecode + "\",\"checked\":\"true\", \"open\":\"true\"},");
			}else{
				treeData.append("{\"id\":"+menu.getID()+",\"pId\":"+menu.getParentID()+",\"name\":\""+menu.getName() + ecode + "\", \"open\":\"true\"},");
			}
		}
		String strTreeData=treeData.toString();
		return strTreeData.substring(0, strTreeData.length()-1)+"]";
	}
}