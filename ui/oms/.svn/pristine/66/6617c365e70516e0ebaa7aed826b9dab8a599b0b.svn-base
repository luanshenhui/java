package cn.rkylin.apollo.system.web;

import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONObject;

import cn.rkylin.apollo.common.util.CookiesUtil;
import cn.rkylin.apollo.common.util.HttpUtils;
import cn.rkylin.apollo.system.domain.PrivilegeMenu;
import cn.rkylin.apollo.system.domain.RoleInfo;
import cn.rkylin.apollo.system.service.IPrivilegeMenuService;
import cn.rkylin.apollo.system.service.ISystemRoleService;
import cn.rkylin.core.controller.AbstractController;

/**
 * Copyright (C), 2016-2020, cn.rkylin.apollo FileName: SysRoleController.java
 * 
 * @Description: 系统角色相关功能
 * @author zhangXinyuan
 * @Date 2016-7-14 下午 19:02
 * @version 1.00
 */
@Controller
@RequestMapping("/sysRole")
public class SysRoleController extends AbstractController {
	private Log log = LogFactory.getLog(SysRoleController.class);
	// 角色管理列表
	private static final String TO_ROLE_LIST = "/system/user/searchRoleList";
	@Autowired
	private IPrivilegeMenuService privilegeMenuService;
	@Autowired
	private ISystemRoleService systemRoleService;

	/**
	 * 跳转到角色管理列表
	 * 
	 * @return
	 */
	@RequestMapping("/roleList")
	public String roleList() {
		return TO_ROLE_LIST;
	}

	/**
	 * 异步查询角色管理列表
	 * 
	 * @param request
	 * @param response
	 * @param userInfo
	 */
	@RequestMapping("/ajaxQryRoleList")
	public void ajaxQryRoleList(HttpServletRequest request, HttpServletResponse response, RoleInfo role) {
		String cookies = CookiesUtil.setCookies(request);
		if (role == null) {
			role = new RoleInfo();
		}
		role.setCookies(cookies);
		try {
			String resultRoleListJson = systemRoleService.searchRole(role);
			if (StringUtils.isNotBlank(resultRoleListJson)) {
				HttpUtils.writeString(response, resultRoleListJson);
			}
		} catch (Exception e) {
			log.error("异步查询角色列表异常", e);
		}
	}

	/**
	 * 异步增加或修改角色
	 * 
	 * @param request
	 * @param response
	 * @param userInfo
	 */
	@RequestMapping("/ajaxAddRole")
	public void ajaxAddRole(HttpServletRequest request, HttpServletResponse response, RoleInfo role) {
		String cookies = CookiesUtil.setCookies(request);
		JSONObject json = new JSONObject();
		if (role == null) {
			role = new RoleInfo();
		}
		role.setCookies(cookies);
		try {
			Map<String,Object> resultMap = systemRoleService.addRole(role);
			json.put("success", resultMap.get("success"));
			json.put("message", resultMap.get("message"));
			HttpUtils.writeString(response, json.toString());
		} catch (Exception e) {
			log.error("异步增加角色异常", e);
		}
	}

	/**
	 * 根据角色ID查询角色拥有的功能权限菜单
	 * 
	 * @param request
	 * @param response
	 * @param menu
	 */
	@RequestMapping("/ajaxQryRolePrivilege")
	public void ajaxQryRolePrivilege(HttpServletRequest request, HttpServletResponse response, PrivilegeMenu menu) {
		String cookies = CookiesUtil.setCookies(request);
		StringBuffer successResult = new StringBuffer();
		String roleMenusJson = null;
		if (menu == null) {
			menu = new PrivilegeMenu();
		}
		menu.setCookies(cookies);
		try {
			roleMenusJson = privilegeMenuService.searchRoleMenus(menu);
			if(StringUtils.isEmpty(roleMenusJson)){
				successResult.append("{");
				successResult.append("\"success\":\"").append("false").append("\"");
				successResult.append("}");
				roleMenusJson = successResult.toString();
			}
		} catch (Exception e) {
			log.error("根据角色查询权限菜单异常", e);
			successResult.append("{");
			successResult.append("\"success\":\"").append("false").append("\"");
			successResult.append("}");
			roleMenusJson = successResult.toString();
		}finally{
			try{
				HttpUtils.writeString(response, roleMenusJson);
			}catch(IOException e){
				log.error("IO输出流异常",e);
			}
		}
	}

	/**
	 * 为角色授权功能菜单
	 * 
	 * @param request
	 * @param response
	 * @param menu
	 */
	@RequestMapping("/ajaxAuthRolePrivilege")
	public void ajaxAuthRolePrivilege(HttpServletRequest request, HttpServletResponse response, PrivilegeMenu menu) {
		String cookies = CookiesUtil.setCookies(request);
		JSONObject json = new JSONObject();
		if (menu == null) {
			menu = new PrivilegeMenu();
		}
		if (StringUtils.isNotBlank(menu.getMenuId())) {
			StringBuffer module = new StringBuffer();
			String[] menuArray = menu.getMenuId().split(",");
			if (menuArray.length > 0) {
				module.append("[");
				for (int i = 0; i < menuArray.length; i++) {
					module.append("{");
					module.append("\"moduleId\":\"").append(menuArray[i]).append("\"");
					module.append("}");
					module.append(i < menuArray.length - 1 ? "," : "");
				}
				module.append("]");
			}
			menu.setMenuId(module.toString());
		}
		menu.setCookies(cookies);
		try {
			boolean resultAuthRole = privilegeMenuService.roleAuthorize(menu);
			json.put("success", resultAuthRole);
			HttpUtils.writeString(response, json.toString());
		} catch (Exception e) {
			log.error("为角色分配权限异常", e);
		}

	}

}
