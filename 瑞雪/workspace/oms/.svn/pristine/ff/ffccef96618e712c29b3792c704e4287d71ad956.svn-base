package cn.rkylin.core;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;

/**
 * 多数据源切换
 * 
 * @author Administrator
 *
 */
public class SessionFactory {
	private String defaultDataSource;
	private Map<String, SqlSession> sessionMap;

	public SqlSession getSessionFactory(String dataSource) throws Exception {
		if (dataSource == null || "".equals(dataSource))
			dataSource = defaultDataSource;
		if (!sessionMap.containsKey(dataSource))
			throw new Exception("不存在此数据源:" + dataSource);
		return sessionMap.get(dataSource);
	}

	public String getDefaultDataSource() {
		return defaultDataSource;
	}

	public void setDefaultDataSource(String defaultDataSource) {
		this.defaultDataSource = defaultDataSource;
	}

	public Map<String, SqlSession> getSessionMap() {
		return sessionMap;
	}

	public void setSessionMap(Map<String, SqlSession> sessionMap) {
		this.sessionMap = sessionMap;
	}

}
