package cn.rkylin.apollo.system.web;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import cn.rkylin.apollo.common.util.CookiesUtil;
import cn.rkylin.apollo.common.util.HttpUtils;
import cn.rkylin.apollo.service.ProjectUserService;
import cn.rkylin.apollo.system.domain.PrivilegeMenu;
import cn.rkylin.apollo.system.domain.RoleInfo;
import cn.rkylin.apollo.system.domain.UserInfo;
import cn.rkylin.apollo.system.service.IPrivilegeMenuService;
import cn.rkylin.apollo.system.service.ISystemRoleService;
import cn.rkylin.apollo.system.service.ISystemUserService;
import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.controller.AbstractController;

/**
 * Copyright (C), 2016-2020, cn.rkylin.apollo FileName: SysUserController.java
 * 
 * @Description: 系统用户相关功能
 * @author zhangXinyuan
 * @Date 2016-7-13 上午 11:49
 * @version 1.00
 */

@Controller
@RequestMapping("/sysUser")
public class SysUserController extends AbstractController {
	private Log log = LogFactory.getLog(SysUserController.class);
	// 系统主页面
	private static final String TO_PAGE_INDEXPAGE = "redirect:/index.html";// /system/user/indexPage";
	// 登录页面
	private static final String TO_PAGE_INDEX = "redirect:/login.html";
	// 账户管理列表
	private static final String TO_USER_LIST = "/system/user/searchUserList";

	@Autowired
	private ISystemUserService systemUserService;
	@Autowired
	private IPrivilegeMenuService privilegeMenuService;
	@Autowired
	private ISystemRoleService systemRoleService;
	@Autowired
	public ProjectUserService projectUserService;
	@Value("#{api_properties}")
	private Properties apiProperties;

	/**
	 * 登录成功跳转到系统主页 如果直接跳过登录页，访问主页面则进入登录页面
	 * 
	 * @return
	 */
	@RequestMapping("/userPage")
	public ModelAndView userPage(HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> model = new HashMap<String, Object>();
		/*
		 * HttpSession session = request.getSession(); UserInfo user =
		 * (UserInfo) session.getAttribute("_userInfo");
		 */
		String url = null;
		String menusJson = null;
		UserInfo user = CookiesUtil.getUserCookies(request);
		if (user == null || StringUtils.isEmpty(user.getUserid())) {
			url = TO_PAGE_INDEX;//TO_PAGE_INDEXPAGE; // wxy 2016年12月21日
		} else {
			String cookies = CookiesUtil.setCookies(request);
			PrivilegeMenu menu = new PrivilegeMenu();
			menu.setUserId(user.getUserid());
			menu.setCookies(cookies);
			try {
				menusJson = privilegeMenuService.searchUserLeftMenus(menu);
			} catch (Exception e) {
				log.error("根据用户ID查询左侧权限列表异常", e);
			}
			url = TO_PAGE_INDEXPAGE;
			model.put("userName", user.getUserid());
			model.put("menusJson", menusJson);
		}
		return new ModelAndView(url, model);
	}

	/**
	 * 退出系统登录
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/loginOut")
	public String loginOut(HttpServletRequest request, HttpServletResponse response) {
		UserInfo userCookie = CookiesUtil.getUserCookies(request);
		if (null != userCookie && StringUtils.isNotBlank(userCookie.getUserid())) {
			String domainName = String.valueOf(apiProperties.get("domainName"));
			Cookie userIdCookie = new Cookie("user_id", null);
			Cookie userNameCookie = new Cookie("user_name", null);
			Cookie userProjectCookie = new Cookie("projectId", null);
			Cookie tokenCookie = new Cookie("tokenId", null);
			userIdCookie.setMaxAge(0);
			userIdCookie.setPath("/");
			//userIdCookie.setDomain(domainName);
			response.addCookie(userIdCookie);

			userNameCookie.setMaxAge(0);
			userNameCookie.setPath("/");
			//userNameCookie.setDomain(domainName);
			response.addCookie(userNameCookie);

			userProjectCookie.setMaxAge(0);
			userProjectCookie.setPath("/");
			//userProjectCookie.setDomain(domainName);
			response.addCookie(userProjectCookie);

			tokenCookie.setMaxAge(0);
			tokenCookie.setPath("/");
			//tokenCookie.setDomain(domainName);
			response.addCookie(tokenCookie);
		}
		return TO_PAGE_INDEX;
	}

	/**
	 * 异步登录
	 * 
	 * @param request
	 * @param response
	 * @param userInfo
	 * @throws Exception
	 */
	@RequestMapping("/ajaxUserLogin")
	public void ajaxUserLogin(HttpServletRequest request, HttpServletResponse response, UserInfo userInfo) {
		JSONObject json = new JSONObject();
		if (userInfo == null) {
			userInfo = new UserInfo();
		}
		try {
			Map<String, Object> userMap = systemUserService.Login(userInfo);
			if (null == userMap) {
				json.put("success", false);
				json.put("message", "登录失败，用户名或密码不正确！");
				return;
			}
			if (null != userMap.get("userInfo")) {
				String cookies = CookiesUtil.setCookies(userInfo.getUserid(), userInfo.getUserName());
				userInfo.setCookies(cookies);
				
				UserInfo resultUserInfo = (UserInfo) userMap.get("userInfo");
				String projectId = getProject(resultUserInfo.getUserid());
				/*
				 * // 在整个会话中都可以获取到用户对象 HttpSession session =
				 * request.getSession(); session.setAttribute("_userInfo",
				 * resultUserInfo);
				 */
				String domainName = String.valueOf(apiProperties.get("domainName"));
				String userName = URLEncoder.encode(resultUserInfo.getUserName(), "utf-8");
				Cookie userIdCookie = new Cookie("user_id", resultUserInfo.getUserid());
				Cookie userNameCookie = new Cookie("user_name", userName);
				Cookie userProjectCookie = new Cookie("project_id", projectId);
				Cookie tokenCookie = new Cookie("token_id", resultUserInfo.getTokenId());
				// userIdCookie.setMaxAge(24*60);
				userIdCookie.setPath("/");
				//userIdCookie.setDomain(domainName);
				response.addCookie(userIdCookie);

				// userNameCookie.setMaxAge(24*60);
				userNameCookie.setPath("/");
				//userNameCookie.setDomain(domainName);
				response.addCookie(userNameCookie);

				// userNameCookie.setMaxAge(24*60);
				userProjectCookie.setPath("/");
				//userProjectCookie.setDomain(domainName);
				response.addCookie(userProjectCookie);

				// tokenCookie.setMaxAge(24*60);
				tokenCookie.setPath("/");
				//tokenCookie.setDomain(domainName);
				response.addCookie(tokenCookie);

				json.put("success", true);
			} else if (null != userMap.get("busMessage")) {
				json.put("success", false);
				json.put("message", String.valueOf(userMap.get("busMessage")));
			} else {
				json.put("success", false);
				json.put("message", "登录失败，请联系管理员！");
			}
		} catch (Exception e) {
			log.error("登录异常！", e);
		} finally {
			try {
				HttpUtils.writeString(response, json.toString());
			} catch (IOException e) {
				log.error("异步登录输出流IO异常", e);
			}
		}
	}

	/**
	 * 根据登录用户ID查询项目
	 * 
	 * @param userId
	 * @return
	 */
	private String getProject(String userId) {
		ApolloMap<String, Object> params = new ApolloMap<String, Object>();
		StringBuffer strProject = new StringBuffer();
		params.put("userId", userId);
		try {
			List<Map<String, Object>> userProjectList = systemUserService.findUserProjectByWhere(params);
			if (null != userProjectList && userProjectList.size() > 0) {
				for (int i = 0; i < userProjectList.size(); i++) {
					Map<String, Object> projectMap = userProjectList.get(i);
					if (null != projectMap.get("ID")) {
						strProject.append(String.valueOf(projectMap.get("ID")));
						strProject.append(i < userProjectList.size() - 1 ? "," : "");
					}
				}
			}
		} catch (Exception e) {
			log.error("根据用户ID查询项目异常！", e);
		}
		return strProject.toString();
	}

	/**
	 * 异步获取系统主界面左侧菜单列表
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("/ajaxQryLeftMenus")
	public void ajaxQryLeftMenus(HttpServletRequest request, HttpServletResponse response) {
		UserInfo user = CookiesUtil.getUserCookies(request);
		String cookies = CookiesUtil.setCookies(request);
		PrivilegeMenu menu = new PrivilegeMenu();
		menu.setUserId(user.getUserid());
		menu.setCookies(cookies);
		try {
			String menusJson = privilegeMenuService.searchUserLeftMenus(menu);
			if (StringUtils.isNotBlank(menusJson)) {
				HttpUtils.writeString(response, menusJson);
			}
		} catch (Exception e) {
			log.error("异步获取系统左侧菜单列表异常！", e);
		}
	}

	/**
	 * 跳转到账户管理列表
	 * 
	 * @return
	 */
	@RequestMapping("/userList")
	public String userList() {
		return TO_USER_LIST;
	}

	/**
	 * 异步查询账户管理列表
	 * 
	 * @param request
	 * @param response
	 * @param userInfo
	 */
	@RequestMapping("/ajaxQryUserList")
	public void ajaxQryUserList(HttpServletRequest request, HttpServletResponse response, UserInfo userInfo) {
		String cookies = CookiesUtil.setCookies(request);
		String resultUserListJson = null;
		if (userInfo == null) {
			userInfo = new UserInfo();
		}
		userInfo.setCookies(cookies);
		try {
			resultUserListJson = systemUserService.findbyWhereUserInfo(userInfo);
			if (resultUserListJson == null) {
				resultUserListJson = findDataGrid();
			}
		} catch (Exception e) {
			log.error("异步查询账户列表异常", e);
		} finally {
			try {
				HttpUtils.writeString(response, resultUserListJson);
			} catch (IOException e) {
				log.error("IO输出流异常。", e);
			}
		}
	}

	/**
	 * 根据用户ID获取用户基本信息
	 * 
	 * @param request
	 * @param response
	 * @param userInfo
	 */
	@RequestMapping("/ajaxQryUserInfo")
	public void ajaxQryUserInfo(HttpServletRequest request, HttpServletResponse response, UserInfo userInfo) {
		String cookies = CookiesUtil.setCookies(request);
		if (userInfo == null) {
			userInfo = new UserInfo();
		}
		userInfo.setCookies(cookies);
		try {
			String resultUserJson = systemUserService.getUserInfo(userInfo);
			if (StringUtils.isNotBlank(resultUserJson)) {
				HttpUtils.writeString(response, resultUserJson);
			}
		} catch (Exception e) {
			log.error("异步查询账户信息异常", e);
		}
	}

	/**
	 * 查询全部角色
	 * 
	 * @param request
	 * @param response
	 * @param role
	 */
	@RequestMapping("/ajaxQryRoleList")
	public void ajaxQryRoleList(HttpServletRequest request, HttpServletResponse response, RoleInfo role) {
		String cookies = CookiesUtil.setCookies(request);
		if (role == null) {
			role = new RoleInfo();
		}
		role.setCookies(cookies);
		try {
			String resultRoleJson = systemRoleService.searchRole(role);
			HttpUtils.writeString(response, resultRoleJson);
		} catch (Exception e) {
			log.error("查询全部用户角色异常", e);
		}
	}

	/**
	 * 查询OA全部用户信息
	 * 
	 * @param request
	 * @param response
	 * @param userInfo
	 */
	@RequestMapping("/ajaxQryUserAllList")
	public void ajaxQryUserAllList(HttpServletRequest request, HttpServletResponse response, UserInfo userInfo) {
		String cookies = CookiesUtil.setCookies(request);
		String resultUserJson = null;
		if (userInfo == null) {
			userInfo = new UserInfo();
		}
		userInfo.setType(1);
		userInfo.setCookies(cookies);
		try {
			resultUserJson = systemUserService.getAllUserInfo(userInfo);
			if (resultUserJson == null) {
				resultUserJson = findDataGrid();
			}
		} catch (Exception e) {
			log.error("异步查询账户信息异常", e);
		}finally {
			try {
				HttpUtils.writeString(response, resultUserJson);
			} catch (IOException e) {
				log.error("IO输出流异常。", e);
			}
		}
	}

	/**
	 * 查询全部项目
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("/ajaxQryAllProject")
	public void ajaxQryAllProject(HttpServletRequest request, HttpServletResponse response) {
		ApolloMap<String, Object> params = getParams(request);
		try {
			String resultAllProjectJson = systemUserService.findProject(params);
			if (StringUtils.isNotBlank(resultAllProjectJson)) {
				HttpUtils.writeString(response, resultAllProjectJson);
			}
		} catch (Exception e) {
			log.error("异步查询全部项目异常", e);
		}
	}

	/**
	 * 根据用户ID查询项目
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("/ajaxQryUserProject")
	public void ajaxQryUserProject(HttpServletRequest request, HttpServletResponse response) {
		ApolloMap<String, Object> params = getParams(request);
		try {
			String resultUserPorjectJson = systemUserService.findUserProject(params);
			if (StringUtils.isNotBlank(resultUserPorjectJson)) {
				HttpUtils.writeString(response, resultUserPorjectJson);
			}
		} catch (Exception e) {
			log.error("异步查询用户项目异常", e);
		}
	}

	/**
	 * 【根据人员ID，项目ID修改人员底下的项目状态】
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("/ajaxModifyUserProject")
	public void ajaxModifyUserProject(HttpServletRequest request, HttpServletResponse response) {
		ApolloMap<String, Object> params = getParams(request);
		JSONObject json = new JSONObject();
		boolean success = false;
		try {
			int resultSts = systemUserService.updateUserProjectByWhere(params);
			if (resultSts > 0) {
				success = true;
			}
			json.put("success", success);
		} catch (Exception e) {
			log.error("根据人员ID，项目ID修改人员底下的项目状态异常", e);
			json.put("success", success);
		} finally {
			try {
				HttpUtils.writeString(response, json.toString());
			} catch (IOException e) {
				log.error("IO输出流异常", e);
			}
		}
	}

	/**
	 * 增加项目和用户的关系 直接在增加修改项目接口方法中调用
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	public int insertProjectUser(HttpServletRequest request, UserInfo userInfo) {
		ApolloMap<String, Object> params = new ApolloMap<String, Object>();
		params.put("userName", userInfo.getComaccountName());
		params.put("userId", userInfo.getUserid());
		params.put("position", userInfo.getPosition());
		params.put("deptId", userInfo.getDeptId());
		params.put("deptName", userInfo.getDeptName());
		if (StringUtils.isNotBlank(userInfo.getUserStatus())) {
			params.put("status", Integer.parseInt(userInfo.getUserStatus()));
		}

		List<Map<String, Object>> userProjectList = null;
		String[] projectArray = null;
		int result = 0;
		boolean same = true;
		try {
			// projectUserService.deleteProjUser(params);
			List<String> newUserProjectList = new ArrayList<String>();
			// 用户本次新增的项目
			String projectId = userInfo.getProjectId();
			if (StringUtils.isNotBlank(projectId)) {
				projectArray = projectId.split(",");
			}
			// 用户已经存在的项目
			userProjectList = systemUserService.findUserProjectByWhere(params);
			if (null != userProjectList && userProjectList.size() > 0) {
				for (String selectProjectId : projectArray) {
					same = true;
					for (int i = 0; i < userProjectList.size(); i++) {
						Map<String, Object> userMap = userProjectList.get(i);
						if (selectProjectId.equals(null != userMap.get("ID") ? userMap.get("ID").toString() : "")) {
							same = false;
							break;
						}
					}
					if (same) {
						newUserProjectList.add(selectProjectId);
					}
				}
			}
			// 插入用户和项目关系表
			if (null != userProjectList && userProjectList.size() > 0) {
				if (null != newUserProjectList && newUserProjectList.size() > 0) {
					for (String selectProjectId : newUserProjectList) {
						params.put("projectId", selectProjectId);
						result = systemUserService.insertUserProject(params);
					}
				}
			} else {
				if (null != projectArray && projectArray.length > 0) {
					for (String selectProjectId : projectArray) {
						params.put("projectId", selectProjectId);
						result = systemUserService.insertUserProject(params);
					}
				}
			}
		} catch (Exception e) {
			log.error("异步查询用户项目异常", e);
		}
		return result;
	}

	/**
	 * 增加&修改-账户
	 * 
	 * @param request
	 * @param response
	 * @param userInfo
	 */
	@RequestMapping("/ajaxAddModifyUser")
	public void ajaxAddModifyUser(HttpServletRequest request, HttpServletResponse response, UserInfo userInfo) {
		String cookies = CookiesUtil.setCookies(request);
		JSONObject json = new JSONObject();
		StringBuffer paramStr = new StringBuffer();
		if (userInfo == null) {
			userInfo = new UserInfo();
		}
		try {
			paramStr.append("[");
			if (StringUtils.isNotBlank(userInfo.getRoleId())) {
				paramStr.append("{");
				paramStr.append("\"type\":\"").append("1").append("\",");
				paramStr.append("\"relations\":\"").append(userInfo.getRoleId()).append("\"");
				paramStr.append("}");
			}
			if (StringUtils.isNotBlank(userInfo.getProjectCode())) {
				paramStr.append(",");
				String[] projectArray = userInfo.getProjectCode().split(",");
				if (projectArray.length > 0) {
					for (int i = 0; i < projectArray.length; i++) {
						paramStr.append("{");
						paramStr.append("\"type\":\"").append("2").append("\",");
						paramStr.append("\"relations\":\"").append(projectArray[i]).append("\"");
						paramStr.append("}");
						paramStr.append(i < projectArray.length - 1 ? "," : "");
					}
				}
			}
			paramStr.append("]");
			userInfo.setProjectCode(paramStr.toString());
			userInfo.setCookies(cookies);
			Map<String, Object> resultMap = systemUserService.addUserInfo(userInfo);
			if (null != resultMap.get("success") && (Boolean) resultMap.get("success")) {
				insertProjectUser(request, userInfo);
			}
			json.put("success", null != resultMap.get("success") ? (Boolean) resultMap.get("success") : false);
			json.put("resulStatus", String.valueOf(resultMap.get("resulStatus")));
			HttpUtils.writeString(response, json.toString());
		} catch (Exception e) {
			log.error("增加或修改账户异常！", e);
		}
	}

	/**
	 * 查询用户功能按钮权限
	 * 
	 * @param request
	 * @param response
	 * @param menu
	 */
	@RequestMapping("/ajaxQryUserAction")
	public void ajaxQryUserAction(HttpServletRequest request, HttpServletResponse response, PrivilegeMenu menu) {
		if (menu == null) {
			menu = new PrivilegeMenu();
		}
		String cookies = CookiesUtil.setCookies(request);
		JSONObject json = new JSONObject();
		StringBuffer module = new StringBuffer();
		if (StringUtils.isNotEmpty(menu.getMenuId())) {
			String[] strMenuId = menu.getMenuId().split(",");
			if (null != strMenuId && strMenuId.length > 0) {
				module.append("[");
				for (int i = 0; i < strMenuId.length; i++) {
					module.append("{");
					module.append("\"moduleId\":\"").append(strMenuId[i]).append("\"");
					module.append("}");
					module.append(i < strMenuId.length - 1 ? "," : "");
				}
				module.append("]");
			}
		}
		menu.setMenuId(module.toString());
		menu.setCookies(cookies);
		try {
			String userModuleJson = privilegeMenuService.searchUserPrivilege(menu);
			if (StringUtils.isNotEmpty(userModuleJson)) {
				json.put("success", true);
				json.put("userModuleJson", userModuleJson);
			} else {
				json.put("success", false);
			}
		} catch (Exception e) {
			log.error("查询用户按钮功能权限异常！", e);
			json.put("success", false);
		} finally {
			try {
				HttpUtils.writeString(response, json.toString());
			} catch (IOException e) {
				log.error("IO输出流异常", e);
			}
		}
	}
	
	/**
	 * 查询为空返回dataGrid需要的格式
	 * @return
	 */
	private String findDataGrid() {
		StringBuffer resultDataGrid = new StringBuffer();
		resultDataGrid.append("{");
		resultDataGrid.append("\"total\":\"").append("0").append("\",");
		resultDataGrid.append("\"page\":\"").append("0").append("\",");
		resultDataGrid.append("\"pageNo\":\"").append("0").append("\",");
		resultDataGrid.append("\"rows\":");
		resultDataGrid.append("[");
		resultDataGrid.append("{}");
		resultDataGrid.append("]");
		resultDataGrid.append("}");
		return resultDataGrid.toString();
	}
}
