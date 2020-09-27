/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.sys.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.entity.DcaTraceUserRole;
import com.thinkgem.jeesite.modules.sys.service.DcaTraceUserRoleService;

/**
 * 岗位管理Controller
 * 
 * @author zhengwei.cui
 * @version 2016-12-15
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/dcaTraceUserRole")
public class DcaTraceUserRoleController extends BaseController {

	@Autowired
	private DcaTraceUserRoleService dcaTraceUserRoleService;

	/**
	 * 获取岗位列表数据
	 * 
	 * @param dcaTraceUserRole
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "list", "" })
	public String list(DcaTraceUserRole dcaTraceUserRole, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		model.addAttribute("list", dcaTraceUserRoleService.findTreeList(dcaTraceUserRole));
		return "modules/dca/dcaTraceUserRoleList";
	}

	/**
	 * 获取岗位JSON数据
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(HttpServletRequest request, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		// 查出全部岗位
		List<DcaTraceUserRole> list = dcaTraceUserRoleService.findAllList();
		// 循环组成map集合
		for (int i = 0; i < list.size(); i++) {
			DcaTraceUserRole e = list.get(i);
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", e.getRoleId());
			map.put("pId", e.getRoleParentId());
			map.put("pIds", e.getParentIds());
			map.put("name", e.getRoleName());
			mapList.add(map);
		}
		return mapList;
	}

}