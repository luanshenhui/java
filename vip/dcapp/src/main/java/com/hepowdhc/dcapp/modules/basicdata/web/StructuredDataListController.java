/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.basicdata.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.thinkgem.jeesite.common.web.BaseController;

/**
 * 结构型数据Controller
 * 
 * @author hanxin'an
 * @version 2016-11-08
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/structuredData")
public class StructuredDataListController extends BaseController {

	@RequiresPermissions("dca:structuredData:view")
	@RequestMapping(value = { "list", "" })
	public String list(HttpServletRequest request, HttpServletResponse response, Model model) {

		return "modules/dca/structuredDataList";
	}

}