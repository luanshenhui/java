package chinsoft.business;

import java.util.ArrayList;
import java.util.List;

import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.Member;

public class CurrentInfo {
	public static void setCurrentMember(Member member) {
	
		HttpContext.setSessionValue(Utility.SessionKey_CurrentMember, member);
	}

	public static Member getCurrentMember() {
		try {
			return (Member)HttpContext.getSessionValue(Utility.SessionKey_CurrentMember);
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug(e.getMessage());
		}
		return null;
	}
	
	public static String getERPUserName(){
		return CDict.ERP_USER_PRE + getCurrentMember().getUsername();
		
	}
	
	public static boolean isInRole(Integer nMenuID)
    {
		String menus = getCurrentMember().getMenuIDs();
        if(Utility.contains(menus, Utility.toSafeString(nMenuID))){
        	return true;
        }
        return false;
    }
	
	public static List<Dict> getAuthorityFunction(List<Dict> dicts){
		List<Dict> authorityFunction = new ArrayList<Dict>();
		for(Dict dict : dicts){
			if(CurrentInfo.isInRole(dict.getID())){
				authorityFunction.add(dict);
			}
		}
		
		return authorityFunction;
	}
	
	public static boolean isAdmin(){
		boolean bFlag = false;
		Member currentMember = getCurrentMember();
		if(currentMember != null && currentMember.getGroupID() != null){
			Dict group = DictManager.getDictByID(currentMember.getGroupID());
			if(group != null && CDict.GroupStatusManagerUser.getID().equals(group.getStatusID())){
				bFlag = true;
			}
		}
		return bFlag;
	}
	
	public static boolean checkAccess() {
		boolean isAccess = true;
		try {
			Member member = (Member) HttpContext.getSessionValue(Utility.SessionKey_CurrentMember);
			if (member == null) {
				isAccess = false;
			}
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
		return isAccess;
	}
	
	public static boolean isPubMember(String strMemberID) {
		return CurrentInfo.getCurrentMember().getID().equals(strMemberID);
	}
}
