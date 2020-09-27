package cn.rkylin.apollo.controller;

import cn.rkylin.apollo.service.ProjectUserService;
import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.controller.AbstractController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Admin on 2016/7/7.
 */

@Controller
@RequestMapping("/project/user")
public class ProjectUserController extends AbstractController {
	@Autowired
	public ProjectUserService projectUserService;

	@RequestMapping("/updateProjectUser")
	@ResponseBody
	public Map<String, Object> updateProjectUser(HttpServletRequest request) throws Exception {
		Map<String, Object> retMap = new HashMap<String, Object>();
		ApolloMap<String, Object> params = getParams(request);
		projectUserService.updateProjectUser(params);
		retMap.put("resultId", 1);
		retMap.put("resultDescription", "修改成功！");
		return retMap;
	}

	/**
	 * 根据项目增加人员
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/addProjectUser")
	@ResponseBody
	public Map<String, Object> addProjectUser(HttpServletRequest request) throws Exception {
		Map<String, Object> retMap = new HashMap<String, Object>();
		ApolloMap<String, Object> params = getParams(request);
		projectUserService.addProjectUser(params);
		retMap.put("resultId", 1);
		retMap.put("resultDescription", "新增成功！");
		return retMap;
	}

	/**
	 * 获取人员列表信息
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/queryOAUser")
	@ResponseBody
	public Map<String, Object> queryOAUser(HttpServletRequest request) throws Exception {
		Map<String, Object> retMap = new HashMap<String, Object>();
		ApolloMap<String, Object> params = getParams(request);
		ApolloMap<String, Object> queryMap = new ApolloMap<String, Object>();
		queryMap.put("page", params.get("page") + ""); // 必传
		queryMap.put("limit", params.get("rows") + ""); // 必传
		queryMap.put("platformId", params.get("platformId") == null ? "" : String.valueOf(params.get("platformId"))); // 必传
		queryMap.put("userName", params.get("projectUserForm_userName") == null ? "" : String.valueOf(params.get("projectUserForm_userName")));
		queryMap.put("deptName", params.get("projectUserForm_deptName") == null ? "" : String.valueOf(params.get("projectUserForm_deptName")));
		queryMap.put("index", params.get("index") == null ? "" : String.valueOf(params.get("index")));
		retMap = projectUserService.queryOAUser(queryMap);
		retMap.put("resultId", 1);
		retMap.put("resultDescription", "新增成功！");
		return retMap;
	}

	@RequestMapping("/updateProjectUserStatus")
	@ResponseBody
	public Map<String, Object> updateProjectUserStatus(HttpServletRequest request) throws Exception {
		Map<String, Object> retMap = new HashMap<String, Object>();
		ApolloMap<String, Object> params = getParams(request);
		projectUserService.updateProjectUserStatus(params);
		retMap.put("resultId", 1);
		retMap.put("resultDescription", "删除成功！");
		return retMap;
	}
}
