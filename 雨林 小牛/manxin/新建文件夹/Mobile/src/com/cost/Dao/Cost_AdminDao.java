package com.cost.Dao;

import java.util.List;

import com.cost.entity.Cost_Admin;

public interface Cost_AdminDao {
	//登录
	Cost_Admin login(Cost_Admin admin) throws Exception;
	
}
