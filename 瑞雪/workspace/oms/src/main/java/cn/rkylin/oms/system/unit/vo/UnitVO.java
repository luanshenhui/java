package cn.rkylin.oms.system.unit.vo;

import cn.rkylin.oms.system.unit.domain.WF_ORG_UNIT;

public class UnitVO extends WF_ORG_UNIT {

	private static final long serialVersionUID = 1581489626820590196L;
	
	private String userAccountLocked;

	public String getUserAccountLocked() {
		return userAccountLocked;
	}

	public void setUserAccountLocked(String userAccountLocked) {
		this.userAccountLocked = userAccountLocked;
	}
	
	

}
