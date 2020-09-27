package com.netctoss.login.action;

import com.netctoss.exception.DAOException;
import com.netctoss.login.dao.IAdminInfoDAO;
import com.netctoss.login.entity.AdminInfo;
import com.netctoss.util.BaseAction;
import com.netctoss.util.DAOFactory;

public class LoginAction extends BaseAction{
	private String adminCode;
	private String password;
	private String code;
	private String msg;
	
	
	public String getAdminCode() {
		return adminCode;
	}

	public void setAdminCode(String adminCode) {
		this.adminCode = adminCode;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	
	public String execute(){
		//System.out.println("adminCode:"+admin.getAdminCode());
		//System.out.println("password:"+admin.getPassword());
		IAdminInfoDAO dao=(IAdminInfoDAO)
		DAOFactory.getInstance("IAdminInfoDAO");	
		try {
			String oldCode=(String)session.get("code");
			if(!oldCode.equalsIgnoreCase(code)){
				msg="验证码错误";
				return "fail";
			}
			AdminInfo admin=dao.findByCodeAndPwd(adminCode, password);
			if(admin!=null){	
				session.put("admin", admin);
				return "success";
			}else{
				msg="用户名或者密码错误，请重试";
				return "fail";
			}
		} catch (DAOException e) {	
			e.printStackTrace();
			return "error";
		}
	}
	public static void main(String[] args) {
		IAdminInfoDAO dao=(IAdminInfoDAO)
		DAOFactory.getInstance("IAdminInfoDAO");
		try {
			AdminInfo admin=	dao.findByCodeAndPwd("admin", "111111");
			System.out.println(admin);
		} catch (DAOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
