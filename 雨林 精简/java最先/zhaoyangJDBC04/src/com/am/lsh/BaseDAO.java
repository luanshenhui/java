package com.am.lsh;

import java.sql.Connection;

import com.lsh.util.DBFactory;
//����DAOImpl�Ļ���
public abstract class BaseDAO {
	protected  Connection conn=DBFactory.openConnection();

}
