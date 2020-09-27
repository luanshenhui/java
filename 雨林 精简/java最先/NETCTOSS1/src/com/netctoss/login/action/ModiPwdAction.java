package com.netctoss.login.action;


import com.netctoss.exception.DAOException;
import com.netctoss.login.dao.IAdminInfoDAO;
import com.netctoss.login.entity.AdminInfo;
import com.netctoss.util.BaseAction;
import com.netctoss.util.DAOFactory;

public class ModiPwdAction extends BaseAction{
	private String oldPwd;
	private String newPwd;
	private boolean ok;
	
	public String getNewPwd() {
		return newPwd;
	}
	public void setNewPwd(String newPwd) {
		this.newPwd = newPwd;
	}
	
	
	public boolean isOk() {
		return ok;
	}
	public void setOk(boolean ok) {
		this.ok = ok;
	}
	public String getOldPwd() {
		return oldPwd;
	}
	public void setOldPwd(String oldPwd) {
		this.oldPwd = oldPwd;
	}

	public String execute(){
		IAdminInfoDAO dao=(IAdminInfoDAO) 
		DAOFactory.getInstance("IAdminInfoDAO");
		AdminInfo	admin=(AdminInfo) session.get("admin");
		try {
			String oldPassword=admin.getPassword();
			if(oldPwd!=null&&oldPassword.equals(oldPwd)){
				admin.setPassword(newPwd);
				dao.modify(admin);
				ok=true;
			}else{
				ok=false;
			}
			System.out.println(oldPassword+","+ok);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
