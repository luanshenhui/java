package com.cost.admin;

import com.cost.action.BaseAction;
import com.cost.entity.Cost_Admin;

public class FindAdminAction extends BaseAction {
	private Cost_Admin admin;
	private String password;

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Cost_Admin getAdmin() {
		return admin;
	}

	public void setAdmin(Cost_Admin admin) {
		this.admin = admin;
	}

	public String execute(){
		admin = (Cost_Admin) session.get("admin");
//		System.out.println(admin);
//		System.out.println(password);
//		String pwdOld = admin.getPassword();
//		if(pwdOld.equals(password)){
//			System.out.println("重复");
//		}else{
//			System.out.println("Ok");
//			System.out.println("pwdOld" + password);
//		}
		return "success";
	}
//	public static void main(String[] args) {
//		Cost_Admin admin = (Cost_Admin) session.get("admin");
//		password = admin.getPassword();
//		System.out.println(admin);
//		System.out.println(password);
//	}
}
