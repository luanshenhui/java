package cn.rkylin.apollo.notice.dao;

import java.util.List;
import java.util.Map;

import cn.rkylin.core.ApolloMap;

/**
 * Copyright (C), 2016-2020, cn.rkylin.apollo FileName: INoticeStrategyDao.java
 * 
 * @Description: 通知配置操作
 * @author zhangXinyuan
 * @Date 2016-9-6 下午 10:56
 * @version 1.00
 */
public interface INoticeStrategyDao {

	/**
	 * 查询通知策略
	 * 
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> findByWhere(ApolloMap<String, Object> params) throws Exception;

	/**
	 * 修改通知策略
	 * 
	 * @return
	 * @throws Exception
	 */
	public int update(ApolloMap<String, Object> params) throws Exception;

	/**
	 * 新增通知策略
	 * 
	 * @return
	 * @throws Exception
	 */
	public int insert(ApolloMap<String, Object> params) throws Exception;

	/**
	 * 删除通知策略
	 * 
	 * @return
	 * @throws Exception
	 */
	public int delete(ApolloMap<String, Object> params) throws Exception;

}
