package cn.rkylin.apollo.system.service.impl;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONObject;

import cn.rkylin.apollo.common.util.HttpUtil;
import cn.rkylin.apollo.common.util.PropertiesUtils;
import cn.rkylin.apollo.enums.BusinessExceptionEnum;
import cn.rkylin.apollo.system.domain.UserInfo;
import cn.rkylin.apollo.system.service.ISystemUserService;
import cn.rkylin.apollo.system.web.util.SystemApiUtil;
import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.core.exception.BusinessException;

/**
 * Copyright (C), 2016-2020, cn.rkylin.apollo FileName:SystemUserServiceImpl
 * SystemUserServiceImpl.java
 * 
 * @Description: 系统用户相关功能业务类
 * @author zhangXinyuan
 * @Date 2016-7-12 上午 15:30
 * @version 1.00
 */

@Service("systemUserService")
public class SystemUserServiceImpl implements ISystemUserService {
	private Log log = LogFactory.getLog(SystemUserServiceImpl.class);
	private static final String serverPath = PropertiesUtils.getVal("sysServiceAddress");
	@Autowired
	private IDataBaseFactory dao;

	@Override
	public Map<String, Object> Login(UserInfo userInfo) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String url = serverPath + SystemApiUtil.USER_LOGIN_URL;
		StringBuffer params = new StringBuffer("");
		UserInfo userInfoDomain = null;
		String resultBusiness = null;
		String businessCode = null;
		String tokenId = null;
		try {
			String userPassword = getUserPwd(userInfo);
			params.append("userId=").append(userInfo.getUserid());
			params.append("&password=").append(userPassword);
			params.append("&type=").append(userInfo.getType());
			params.append("&platformId=").append(SystemApiUtil.PLATFORMID);
			String jsonStr = HttpUtil.sendByGet(url, params.toString(), userInfo.getCookies());
			JSONObject jsonObject = JSONObject.parseObject(jsonStr);
			String resulStatus = jsonObject.getString("status");
			if ("0".equals(resulStatus)) { // 请求成功
				JSONObject resultObj = jsonObject.getJSONObject("result");
				if (resultObj.containsKey("businessCode")) {
					businessCode = resultObj.getString("businessCode");
				}
				if (resultObj.containsKey("tokenId")) {
					tokenId = resultObj.getString("tokenId");
				}
				if ("0".equals(businessCode)) { // 业务成功
					JSONObject userJson = resultObj.getJSONObject("user");
					if (null != userJson) {
						userInfoDomain = JSONObject.parseObject(userJson.toString(), UserInfo.class);
						userInfoDomain.setTokenId(tokenId);
					}
				} else if ("-103".equals(businessCode) || "-101".equals(businessCode)) {
					resultBusiness = resultObj.getString("businessMessage");
				}
			}
			resultMap.put("userInfo", userInfoDomain);
			resultMap.put("busMessage", resultBusiness);
		} catch (Exception e) {
			log.error("用户登录异常", e);
		}
		return resultMap;
	}

	@Override
	public String getUserPwd(UserInfo userInfo) throws Exception {
		String url = serverPath + SystemApiUtil.USER_PWD_ENCRYPTION_URL;
		StringBuffer params = new StringBuffer("");
		String encryptedPwd = null;
		try {
			params.append("type=").append(userInfo.getType());
			params.append("&platformId=").append(SystemApiUtil.PLATFORMID);
			String password = URLEncoder.encode(userInfo.getPassword(), "utf-8");
			params.append("&password=").append(password);
			String jsonStr = HttpUtil.sendByGet(url, params.toString(), userInfo.getCookies());
			JSONObject jsonObject = JSONObject.parseObject(jsonStr);
			String resulStatus = jsonObject.getString("status");
			if ("0".equals(resulStatus)) {
				JSONObject resultJsonObj = jsonObject.getJSONObject("result");
				encryptedPwd = resultJsonObj.getString("encryptpw");
			}
		} catch (Exception e) {
			log.error("加密登录密码异常", e);
		}
		return encryptedPwd;
	}

	@Override
	public String getAllUserInfo(UserInfo userInfo) throws Exception {
		String url = serverPath + SystemApiUtil.SEARCH_ALL_USERIINFO_URL;
		StringBuffer params = new StringBuffer("");
		String userAllStrJson = null;
		try {
			if (StringUtils.isNotEmpty(userInfo.getUserName())) {
				params.append("&userName=").append(URLEncoder.encode(userInfo.getUserName().trim(), "utf-8"));
			}
			if (StringUtils.isNotEmpty(userInfo.getUserid())) {
				params.append("&userId=").append(URLEncoder.encode(userInfo.getUserid().trim(), "utf-8"));
			}
			params.append("&type=").append(userInfo.getType());
			params.append("&platformId=").append(SystemApiUtil.PLATFORMID);
			params.append("&limit=").append(userInfo.getRows());
			params.append("&page=").append(userInfo.getPage());
			String jsonStr = HttpUtil.sendByGet(url, params.toString(), userInfo.getCookies());
			JSONObject jsonObject = JSONObject.parseObject(jsonStr);
			String resulStatus = jsonObject.getString("status");
			if ("0".equals(resulStatus)) {
				JSONObject resultJsonObj = jsonObject.getJSONObject("result");
				// JSONArray userAllList =
				// resultJsonObj.getJSONArray("userList");
				userAllStrJson = resultJsonObj.toString();
			}
		} catch (Exception e) {
			log.error("获取全站用户信息异常", e);
		}
		return userAllStrJson;
	}

	@Override
	public String getUserInfo(UserInfo userInfo) throws Exception {
		String url = serverPath + SystemApiUtil.SEARCH_USERINFO_URL;
		StringBuffer params = new StringBuffer("");
		String userInfoJson = null;
		try {
			params.append("userId=").append(userInfo.getUserid());
			params.append("&type=").append(userInfo.getType());
			params.append("&tag=").append(userInfo.getTag());
			params.append("&platformId=").append(SystemApiUtil.PLATFORMID);
			String jsonStr = HttpUtil.sendByGet(url, params.toString(), userInfo.getCookies());
			JSONObject jsonObject = JSONObject.parseObject(jsonStr);
			String resulStatus = jsonObject.getString("status");
			if ("0".equals(resulStatus)) {
				JSONObject resultJsonObj = jsonObject.getJSONObject("result");
				// userinfo = JSONObject.parseObject(resultJsonObj.toString(),
				// UserInfo.class);
				userInfoJson = resultJsonObj.toString();
			}
		} catch (Exception e) {
			log.error("根据用户ID查询用户信息异常", e);
		}
		return userInfoJson;
	}

	@Override
	public String findbyWhereUserInfo(UserInfo userInfo) throws Exception {
		String url = serverPath + SystemApiUtil.SEARCH_USER_LIST_URL;
		StringBuffer params = new StringBuffer("");
		String resultJson = null;
		try {
			if (StringUtils.isNotEmpty(userInfo.getUserid())) {
				params.append("userId=").append(URLEncoder.encode(userInfo.getUserid().trim(), "utf-8"));
			}
			if (StringUtils.isNotEmpty(userInfo.getComaccountName())) {
				params.append("&userName=").append(URLEncoder.encode(userInfo.getComaccountName().trim(), "utf-8"));
			}
			if (StringUtils.isNotEmpty(userInfo.getDeptName())) {
				params.append("&deptName=").append(URLEncoder.encode(userInfo.getDeptName().trim(), "utf-8"));
			}
			if (StringUtils.isNotEmpty(userInfo.getUserStatus())) {
				params.append("&userStatus=").append(userInfo.getUserStatus());
			}
			if (StringUtils.isNotEmpty(userInfo.getRoleId())) {
				params.append("&roleId=").append(userInfo.getRoleId());
			}
			params.append("&limit=").append(userInfo.getRows());
			params.append("&page=").append(userInfo.getPage());
			params.append("&platformId=").append(SystemApiUtil.PLATFORMID);
			String jsonStr = HttpUtil.sendByGet(url, params.toString(), userInfo.getCookies());
			JSONObject jsonObject = JSONObject.parseObject(jsonStr);
			String resulStatus = jsonObject.getString("status");
			if ("0".equals(resulStatus)) {
				JSONObject resultUserListJson = jsonObject.getJSONObject("result");
				resultJson = resultUserListJson.toString();
			}
		} catch (Exception e) {
			log.error("查询用户列表信息异常", e);
		}
		return resultJson;
	}

	@Override
	public Map<String, Object> addUserInfo(UserInfo userInfo) throws Exception {
		String url = serverPath + SystemApiUtil.ADD_MODIFY_USERINFO_URL;
		Map<String, Object> resultMap = new HashMap<String, Object>();
		StringBuffer params = new StringBuffer("");
		boolean success = false;
		try {
			params.append("userId=").append(userInfo.getUserid());
			params.append("&userStatus=").append(userInfo.getUserStatus());
			params.append("&str=").append(userInfo.getProjectCode());
			params.append("&flag=").append(userInfo.getTag());
			params.append("&platformId=").append(SystemApiUtil.PLATFORMID);
			String jsonStr = HttpUtil.sendByGet(url, params.toString(), userInfo.getCookies());
			JSONObject jsonObject = JSONObject.parseObject(jsonStr);
			String resulStatus = jsonObject.getString("status");
			if ("0".equals(resulStatus)) {
				success = true;
			}
			resultMap.put("resulStatus", resulStatus);
			resultMap.put("success", success);
		} catch (Exception e) {
			log.error("增加或修改用户异常", e);
		}
		return resultMap;
	}

	/**
	 * 【查询所有的项目】
	 * 
	 * @return
	 * @throws Exception
	 */
	public String findProject(ApolloMap<String, Object> params) throws Exception {
		List<Map<String, Object>> projectList = dao.findForList("findProject", params);
		String projectJson = JSONObject.toJSONString(projectList);
		return projectJson;
	}

	/**
	 * 【根据用户ID查询已有的项目】
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public String findUserProject(ApolloMap<String, Object> params) throws Exception {
		List<Map<String, Object>> userProjectList = dao.findForList("findUserProject", params);
		String userProjectJson = JSONObject.toJSONString(userProjectList);
		return userProjectJson;
	}

	/**
	 * 【根据用户ID查询已有的项目】
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> findUserProjectByWhere(ApolloMap<String, Object> params) throws Exception {
		List<Map<String, Object>> userProjectList = dao.findForList("findUserProject", params);
		return userProjectList;
	}

	/**
	 * 【根据用户ID和项目ID修改人员底下项目的状态】
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int updateUserProjectByWhere(ApolloMap<String, Object> params) throws Exception {
		return dao.update("updateProjectUserByWhere", params);
	}

	/**
	 * 【增加用户项目关联关系】
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int insertUserProject(ApolloMap<String, Object> params) throws Exception {
		int result = dao.insert("inserUserProjectRelated", params);
		if (result != 1) {
			throw new BusinessException(BusinessExceptionEnum.ADD_DATA.getC(), "添加用户与项目关联关系异常！");
		}
		return result;
	}

	/**
	 * 【验证用户合法性】
	 * 
	 * @param userId
	 * @param cookies
	 * @return
	 */
	public UserInfo validityUser(String cookies) throws Exception {
		String url = serverPath + SystemApiUtil.SEARCH_USER_VALIDITY_URL;
		StringBuffer params = new StringBuffer("");
		UserInfo userInfo = null;
		try {
			//params.append("userId=").append(userId);
			params.append("&platformId=").append(SystemApiUtil.PLATFORMID);
			String jsonStr = HttpUtil.sendByGet(url, params.toString(), cookies);
			JSONObject jsonObject = JSONObject.parseObject(jsonStr);
			String resulStatus = jsonObject.getString("status");
			if ("0".equals(resulStatus)) {
				JSONObject resultUserObj = jsonObject.getJSONObject("result");
				JSONObject userValidity = resultUserObj.getJSONObject("userSession");
				userInfo = JSONObject.parseObject(userValidity.toString(), UserInfo.class);
			}
		} catch (Exception e) {
			log.error("验证用户合法性异常！", e);
		}
		return userInfo;
	}

}
