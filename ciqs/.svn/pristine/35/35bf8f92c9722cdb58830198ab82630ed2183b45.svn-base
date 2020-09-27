package com.dpn.ciqqlc.webservice.common;

import java.util.HashMap;
import java.util.Map;

import org.springframework.util.StringUtils;
import org.springframework.web.context.ContextLoader;
import org.springframework.web.context.WebApplicationContext;

import com.dpn.ciqqlc.common.util.BaseUtils;
import com.dpn.ciqqlc.service.UserManageDb;
import com.dpn.ciqqlc.standard.model.UsersDTO;
import com.dpn.ciqqlc.webservice.vo.ServiceResult;

public class WebLogin {

	private static UserManageDb dbServ = null;
	static{
		WebApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext();
		dbServ = (UserManageDb)ctx.getBean("userManageDbServ");
	}

	public static boolean login(String usName,String pwd,ServiceResult sr){
	    
		if(StringUtils.isEmpty(usName)){
			sr.setStatus("1");
			sr.setResult("请填写userName");
			return false;
		}
		
		if(StringUtils.isEmpty(usName)){
			sr.setStatus("1");
			sr.setResult("请填写passWord");
			return false;
		}
		
		try {
			pwd = BaseUtils.decode(pwd);
			usName = BaseUtils.decode(usName);
			
			Map<String,String> map = new HashMap<String,String>();
			map.put("pwd", pwd.substring(0, pwd.lastIndexOf("_ciq")));
			map.put("userid", usName.substring(0, usName.lastIndexOf("_ciq")));
			
			UsersDTO userInfo = dbServ.userLogin(map);
			if(userInfo == null){
				sr.setStatus("1");
				sr.setResult("登录验证错误请检查用户名与密码");
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
			sr.setStatus("1");
			sr.setResult("系统错误");
			return false;
		}

		return true;
	}
}
