package com.cost.admin;

import com.cost.Dao.Admin_hibernate;
import com.cost.Dao.Cost_AdminDao;
import com.cost.Factory.Factory;
import com.cost.action.BaseAction;
import com.cost.entity.Cost_Admin;

public class AdminAction extends BaseAction {
	private String admin_code;
	private String password;
	private String imageCode;
	
//    Cost_AdminDao dao = (Cost_AdminDao) Factory.getInstance("Cost_AdminDao");
	
	public String getImageCode() {
		return imageCode;
	}
	public void setImageCode(String imageCode) {
		this.imageCode = imageCode;
	}
	public String getAdmin_code() {
		return admin_code;
	}
	public void setAdmin_code(String adminCode) {
		admin_code = adminCode;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}

	public String execute() {
		String code = (String)session.get("imageCode");
//		System.out.println(code);
		if(imageCode != null && imageCode.equalsIgnoreCase(code)){
			Admin_hibernate dao = new Admin_hibernate();
			Cost_Admin admin = new Cost_Admin();
			admin.setAdmin_code(admin_code);
			admin.setPassword(password);
//			System.out.println(admin);
			if(dao.login(admin)){
				System.out.println(admin);
				session.put("admin", admin);
				return "success";
			}else{
				return "fail";
			}
		}else{
			return "fail";
		}
	}

}
