package com.zhaoyang.dao;


import org.apache.ibatis.session.SqlSession;

import com.zhaoyang.domain.Company;
import com.zhaoyang.util.DBUtil;

public class Main {

	public static void main(String[] args) {
		
		SqlSession session = DBUtil.getSqlSession();
		
		Company com = (Company)session.selectOne("com.zhaoyang.domain.Company.getCompany", 1);
		System.out.println(com);
		
		session.close();

	}

}
