package com.cost.Dao;

import java.util.List;

import com.cost.entity.Cost_Admin;

public interface Cost_AdminDao {
	//登录
	Cost_Admin login(String admin,String password) throws Exception;
	//查找用户的密码
	
	//修改密码
	void UpAdminPwd(int id, String password) throws Exception;
}
