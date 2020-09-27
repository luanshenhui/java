package cn.rkylin.apollo.notice.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import cn.rkylin.core.ApolloMap;

/**
 * Copyright (C), 2016-2020, cn.rkylin.apollo FileName:
 * BacklogNoticeContorller.java
 * 
 * @Description: 通知配置操作
 * @author zhangXinyuan
 * @Date 2016-8-24 下午 14:22
 * @version 1.00
 */
public interface INoticeConfigureService {

	/**
	 * 查询通知配置
	 * 
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> findByWhere(ApolloMap<String, Object> params) throws Exception;

	/**
	 * 查询oa待办事项
	 * 
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> findWaitManageByWhere(ApolloMap<String, Object> params) throws Exception;

	/**
	 * 修改通知配置
	 * 
	 * @return
	 * @throws Exception
	 */
	public int update(ApolloMap<String, Object> params) throws Exception;

	/**
	 * 新增通知配置
	 * 
	 * @return
	 * @throws Exception
	 */
	public int insert(ApolloMap<String, Object> params) throws Exception;

	/**
	 * 删除通知配置
	 * 
	 * @return
	 * @throws Exception
	 */
	public int delete(ApolloMap<String, Object> params) throws Exception;

}
