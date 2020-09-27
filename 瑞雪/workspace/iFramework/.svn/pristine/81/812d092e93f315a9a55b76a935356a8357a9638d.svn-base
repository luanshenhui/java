package com.dhc.base.cache.util;

import java.sql.SQLException;

import com.dhc.base.common.util.SpringContextUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class FlushDataUtil {
	SqlMapClient sqlMapClient = (SqlMapClient) SpringContextUtil.getBean("sqlMapClient");

	public int flushDataCacheByName(String sqlName) {
		try {

			sqlMapClient.flushDataCache(sqlName);
			return 0;
		} catch (Exception e) {
			return 1;
		}
	}

	public void getData() {
		try {
			sqlMapClient.getDataSource().getConnection().prepareStatement("select * from dual");
		} catch (SQLException e) {

		}

	}

}
