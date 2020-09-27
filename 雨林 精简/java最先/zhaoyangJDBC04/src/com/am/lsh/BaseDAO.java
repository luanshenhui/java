package com.am.lsh;

import java.sql.Connection;

import com.lsh.util.DBFactory;
//所有DAOImpl的基类
public abstract class BaseDAO {
	protected  Connection conn=DBFactory.openConnection();

}
