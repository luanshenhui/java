package cn.com.cgbchina.common.aspect;

import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;

/**
 * 获取数据源
 * 
 */
public class ChooseDataSource extends AbstractRoutingDataSource {

	// 获取数据源名称
	protected Object determineCurrentLookupKey() {
		return HandleDataSource.getDataSource();
	}
}
