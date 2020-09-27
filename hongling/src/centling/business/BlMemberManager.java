package centling.business;

import chinsoft.business.CDict;
import chinsoft.core.DataAccessObject;

public class BlMemberManager {

	DataAccessObject dao = new DataAccessObject();

	// 构造
	public BlMemberManager() {
	}

	/**
	 * 是不是大B用户
	 * @param memberId
	 * @return
	 *   0:是大B用户
	 *   1:不是大B用户
	 *   2:异常
	 */
	public static Integer isDaBUser(Integer groupId, Integer parentGroupId){
		Integer isdaBUser = null;
		// 该用户的角色是--B级用户(MTM管理用户\瑞璞管理用户\凯妙管理用户\总管理用户\专卖店管理用户)
		if (isBUser(groupId)){
			if (CDict.MTM_MANAGEMENTACCOUNT.getID().equals(parentGroupId) || CDict.KM_MANAGEMENTACCOUNT.getID().equals(parentGroupId) 
					|| CDict.RP_MANAGEMENTACCOUNT.getID().equals(parentGroupId) || CDict.ADMIN_MANAGERMENTACCOUNT.getID().equals(parentGroupId)
					|| CDict.ZMD_MANAGEMENTACCOUNT.getID().equals(parentGroupId)){
				isdaBUser = 0;
			} else if (isBUser(parentGroupId)){
				isdaBUser = 1;
			} else {
				isdaBUser = 2;
			}
		} else {
			isdaBUser = 2;
		}
		return isdaBUser;
	}
	
	/**
	 * 是不是B级用户
	 * @param groupId 角色ID
	 * @return 
	 *         true  ：     是B级用户
	 *         false ：不是B级用户
	 */
	public static Boolean isBUser(Integer groupId){
		Boolean isBUser = false;
		// 该用户的角色是--AA级客户或A级客户或B级客户或C级客户
		if (CDict.AA_CUSTOMERACCOUNT.getID().equals(groupId)
				|| CDict.A_CUSTOMERACCOUNT.getID().equals(groupId)
				|| CDict.B_CUSTOMERACCOUNT.getID().equals(groupId)
				|| CDict.C_CUSTOMERACCOUNT.getID().equals(groupId)){
			isBUser = true;
		} 
		return isBUser;
	}
}