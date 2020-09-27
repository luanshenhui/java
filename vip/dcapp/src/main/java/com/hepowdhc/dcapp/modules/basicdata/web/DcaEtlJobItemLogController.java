/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.basicdata.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.hepowdhc.dcapp.modules.basicdata.entity.DcaEtlJobItemLog;
import com.hepowdhc.dcapp.modules.basicdata.service.DcaEtlJobItemLogService;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;

/**
 * 数据版本Controller
 * @author dhc
 * @version 2017-01-18
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaEtlJobItemLog")
public class DcaEtlJobItemLogController extends BaseController {

	@Autowired
	private DcaEtlJobItemLogService dcaEtlJobItemLogService;
	
	/**
	 * 获取数据列表
	 * @param dcaEtlJobItemLog
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("dca:dcaEtlJobItemLog:view")
	@RequestMapping(value = {"list", ""})
	public String list(DcaEtlJobItemLog dcaEtlJobItemLog, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<DcaEtlJobItemLog> page = dcaEtlJobItemLogService.findPage(new Page<DcaEtlJobItemLog>(request, response), dcaEtlJobItemLog); 
		model.addAttribute("page", page);
		return "modules/dca/dcaEtlJobItemLogList";
	}

	/**
	 * 获取物理表更新履历
	 * @param dcaEtlJobItemLog
	 * @param model
	 * @return
	 */
	@RequiresPermissions("dca:dcaEtlJobItemLog:view")
	@RequestMapping(value = "findDetailByStepname")
	public String findDetailByStepname(DcaEtlJobItemLog dcaEtlJobItemLog, Model model) {
		
		List<DcaEtlJobItemLog> detailList = dcaEtlJobItemLogService.findDetailByStepname(dcaEtlJobItemLog);
		
		model.addAttribute("detailList", detailList);
		return "modules/dca/dcaEtlJobItemLogDetail";
	}

}