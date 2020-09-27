/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.metadata.web;

import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.metadata.entity.DcaTopicLib;
import com.hepowdhc.dcapp.modules.metadata.entity.DcaTopicPhysics;
import com.hepowdhc.dcapp.modules.metadata.service.DcaTopicLibService;
import com.hepowdhc.dcapp.modules.metadata.service.DcaTopicPhysicsService;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 基础数据管理Controller
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaBasicDataManage")
public class DcaBasicDataManageController extends BaseController {

	@Autowired
	private DcaTopicPhysicsService dcaTopicPhysicsService;

	@Autowired
	private DcaTopicLibService dcaTopicLibService;

	@ModelAttribute
	public DcaTopicPhysics get(@RequestParam(required = false) String tableName) {

		DcaTopicPhysics entity = null;

		if (StringUtils.isNotBlank(tableName)) {
			entity = dcaTopicPhysicsService.get(tableName);
		}
		if (entity == null) {
			entity = new DcaTopicPhysics();
			entity.getCurrentFiled().initDefaultInfo();
		}

		return entity;
	}

	/**
	 * list查询页面
	 * 
	 * @param dcaTopicPhysics 查询参数
	 * @return 页面路径
	 */
	@RequiresPermissions("dca:dcaBasicDataManage:view")
	@RequestMapping(value = { "list", "" })
	public String list(DcaTopicPhysics dcaTopicPhysics, HttpServletRequest request, HttpServletResponse response,
			Model model) {

		//列表分页数据
		Page<DcaTopicPhysics> page = dcaTopicPhysicsService.findBasicDataByPage(new Page<DcaTopicPhysics>(request, response),
				dcaTopicPhysics);

		//主题库下拉列表数据
		List<DcaTopicLib> topicList = dcaTopicLibService.findList(new DcaTopicLib());

		model.addAttribute("page", page);
		model.addAttribute("topicList", topicList);

		return "modules/dca/dcaBasicDataManageList";
	}

	/**
	 * 查询物理表详细数据
	 *
	 * @return 页面路径
	 */
	@RequiresPermissions("dca:dcaBasicDataManage:view")
	@RequestMapping(value = { "getBasicDataDetail", "" })
	public String toBasicDataDetail(HttpServletRequest request, HttpServletResponse response,
									RedirectAttributes redirectAttributes, Model model) {

		String id = request.getParameter("id");

		// 校验表名是否是DCA_PHY_开头
		if (!id.toUpperCase().startsWith(Constant.TABLE_START)) {
			addMessage(redirectAttributes,"查询失败:物理表英文名必须以'DCA_PHY_'开头！");
			//返回列表页面
			return "modules/dca/dcaBasicDataManageList";
		}


		int pageNo = StringUtils.isEmpty(request.getParameter("pageNo")) ? 1 : Integer.parseInt(request.getParameter("pageNo"));
		int pageSize = StringUtils.isEmpty(request.getParameter("pageSize")) ? 10 : Integer.parseInt(request.getParameter("pageSize"));

		int start = pageSize*(pageNo-1) + 1;
		int end = pageSize*pageNo;

		//查询表信息
		DcaTopicPhysics dataEntity = dcaTopicPhysicsService.findDcaTopicPhysics(id);

		//查询所有列
		List<String> columnList = dcaTopicPhysicsService.findBasicDataColumns(id);


		Map<String,Object> paramMap = new HashMap<>();
		paramMap.put("tableName",id);
		paramMap.put("start",start);
		paramMap.put("end",end);

		Page<Object> page =new Page<>(request, response);
		page.setPageNo(pageNo);
		page.setPageSize(pageSize);
		//查询分页数据
		Page<Object> pageResult = dcaTopicPhysicsService.findBasicDataDetailByPage(page,paramMap);

		model.addAttribute("columnList", columnList);//列名
		model.addAttribute("page", pageResult);//数据
		model.addAttribute("dataEntity", dataEntity);//表信息

		return "modules/dca/dcaBasicDataDetail";
	}

}