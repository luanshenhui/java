package cn.rkylin.apollo.system.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import cn.rkylin.apollo.system.domain.UserInfo;
import cn.rkylin.core.ApolloMap;

/**
 * Copyright (C), 2016-2020, cn.rkylin.apollo FileName: ISystemUserService.java
 * 
 * @Description: 系统用户相关功能接口类
 * @author zhangXinyuan
 * @Date 2016-7-12 下午 15:30
 * @version 1.00
 */

@Service
public interface ISystemUserService {
	/**
	 * 【用户登录】
	 * 
	 * @param userInfo
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> Login(UserInfo userInfo) throws Exception;

	/**
	 * 【加密登录密码】
	 * 
	 * @param userInfo
	 * @return
	 * @throws Exception
	 */
	public String getUserPwd(UserInfo userInfo) throws Exception;

	/**
	 * 【根据用户类型和平台获取全站用户信息】
	 * 
	 * @param userInfo
	 * @return
	 * @throws Exception
	 */
	public String getAllUserInfo(UserInfo userInfo) throws Exception;

	/**
	 * 
	 * 【根据用户ID、用户类型、平台ID 获取用户信息】
	 * 
	 * @param userInfo
	 * @return
	 * @throws Exception
	 */
	public String getUserInfo(UserInfo userInfo) throws Exception;

	/**
	 * 【根据条件分页查询用户信息】
	 * 
	 * @param userInfo
	 * @return
	 * @throws Exception
	 */
	public String findbyWhereUserInfo(UserInfo userInfo) throws Exception;

	/**
	 * 【增加修改用户信息，不用区分接口自行判别】
	 * 
	 * @param userInfo
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> addUserInfo(UserInfo userInfo) throws Exception;

	/**
	 * 【查询所有的项目】
	 * 
	 * @return
	 * @throws Exception
	 */
	public String findProject(ApolloMap<String, Object> params) throws Exception;

	/**
	 * 【根据用户ID查询已有的项目】
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public String findUserProject(ApolloMap<String, Object> params) throws Exception;

	/**
	 * 【根据用户ID查询已有的项目】
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> findUserProjectByWhere(ApolloMap<String, Object> params) throws Exception;

	/**
	 * 【根据用户ID和项目ID修改人员底下项目的状态】
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int updateUserProjectByWhere(ApolloMap<String, Object> params) throws Exception;

	/**
	 * 【增加用户项目关联关系】
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int insertUserProject(ApolloMap<String, Object> params) throws Exception;

	/**
	 * 【验证用户合法性】
	 * 
	 * @param userId
	 * @param cookies
	 * @return
	 */
	public UserInfo validityUser(String cookies) throws Exception;
}
