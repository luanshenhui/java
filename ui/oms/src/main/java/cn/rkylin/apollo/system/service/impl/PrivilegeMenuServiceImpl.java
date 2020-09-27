package cn.rkylin.apollo.system.service.impl;



import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import cn.rkylin.apollo.common.util.HttpUtil;
import cn.rkylin.apollo.common.util.PropertiesUtils;
import cn.rkylin.apollo.system.domain.PrivilegeMenu;
import cn.rkylin.apollo.system.service.IPrivilegeMenuService;
import cn.rkylin.apollo.system.web.util.SystemApiUtil;

/**
 * Copyright (C), 2016-2020, cn.rkylin.apollo FileName: PrivilegeMenuServiceImpl.java
 * 
 * @Description: 系统用户权限相关功能业务类
 * @author zhangXinyuan
 * @Date 2016-7-12 下午 17:15
 * @version 1.00
 */

@Service("privilegeMenuService")
public class PrivilegeMenuServiceImpl implements IPrivilegeMenuService {
	private Log log = LogFactory.getLog(PrivilegeMenuServiceImpl.class);
	private static final String serverPath = PropertiesUtils.getVal("sysServiceAddress");
	
	@Override
	public String searchUserLeftMenus(PrivilegeMenu menu) throws Exception {
		String url = serverPath + SystemApiUtil.SEARCH_USER_LEFT_MENU_URL;
		StringBuffer params = new StringBuffer("");
		String menusLeftJson = null;
		try {
			params.append("&userId=").append(menu.getUserId());
			params.append("&platformId=").append(SystemApiUtil.PLATFORMID);
			//String jsonStr = HttpUtils.sendByGet(url, params.toString());
			String jsonStr = HttpUtil.sendByGet(url, params.toString(),menu.getCookies());
			JSONObject jsonObject = JSONObject.parseObject(jsonStr);
			String resulStatus = jsonObject.getString("status");
			if ("0".equals(resulStatus)) {
				JSONObject resultObjJson = jsonObject.getJSONObject("result");
				menusLeftJson = resultObjJson.toString();
			}
		} catch (Exception e) {
			log.error("查询用户左侧菜单信息异常", e);
		}
		return menusLeftJson;
	}

	@Override
	public String searchRoleMenus(PrivilegeMenu menu) throws Exception {
		String url = serverPath + SystemApiUtil.SEARCH_PRIVILEGE_URL;
		StringBuffer params = new StringBuffer("");
		String rolePrivilegeJson = null;
		try {
			params.append("&roleId=").append(menu.getRoleId());
			params.append("&platformId=").append(SystemApiUtil.PLATFORMID);
			//String jsonStr = HttpUtils.sendByGet(url, params.toString());
			String jsonStr = HttpUtil.sendByGet(url, params.toString(),menu.getCookies());
			JSONObject jsonObject = JSONObject.parseObject(jsonStr);
			String resulStatus = jsonObject.getString("status");
			if ("0".equals(resulStatus)) {
				JSONObject resultObjJson = jsonObject.getJSONObject("result");
				if(null != resultObjJson){
				JSONArray rolePrivilegeArray = resultObjJson.getJSONArray("sysmodule");
				rolePrivilegeJson = rolePrivilegeArray.toString();
				}
			}
		} catch (Exception e) {
			log.error("根据角色ID查询权限菜单信息异常", e);
		}
		return rolePrivilegeJson;
	}

	@Override
	public boolean roleAuthorize(PrivilegeMenu menu) throws Exception {
		String url = serverPath + SystemApiUtil.ROLE_AUTHORIZE_URL;
		StringBuffer params = new StringBuffer("");
		boolean success = false;
		try {
			params.append("roleId=").append(menu.getRoleId());
			params.append("&str=").append(menu.getMenuId());
			params.append("&platformId=").append(SystemApiUtil.PLATFORMID);
			//String jsonStr = HttpUtils.sendByGet(url, params.toString());
			String jsonStr = HttpUtil.sendByGet(url, params.toString(),menu.getCookies());
			JSONObject jsonObject = JSONObject.parseObject(jsonStr);
			String resulStatus = jsonObject.getString("status");
			if ("0".equals(resulStatus)) {
				success = true;
			}
		} catch (Exception e) {
			log.error("为角色分配权限异常", e);
		}
		return success;
	}
	
	/**
	 * 根据用户查询按钮功能权限
	 */
	public String searchUserPrivilege(PrivilegeMenu menu) throws Exception {
		String url = serverPath + SystemApiUtil.SEARCH_ACTION_PRIVILEGE_URL;
		StringBuffer params = new StringBuffer("");
		String resultJson = null;
		try {
			params.append("userId=").append(menu.getUserId());
			params.append("&moduleIds=").append(menu.getMenuId());
			params.append("&platformId=").append(SystemApiUtil.PLATFORMID);
			String jsonStr = HttpUtil.sendByGet(url, params.toString(), menu.getCookies());
			JSONObject jsonObject = JSONObject.parseObject(jsonStr);
			String resulStatus = jsonObject.getString("status");
			if ("0".equals(resulStatus)) {
				JSONObject resultObj = jsonObject.getJSONObject("result");
				if(resultObj.containsKey("modulePermisionList")){
					JSONArray resultModuleObj = resultObj.getJSONArray("modulePermisionList");
					resultJson = resultModuleObj.toString();
				}
				
			}
		} catch (Exception e) {
			log.error("根据用户查询按钮功能权限异常", e);
		}
		return resultJson;
	}

}
