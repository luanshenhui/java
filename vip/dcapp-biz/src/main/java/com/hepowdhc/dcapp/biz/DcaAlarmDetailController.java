/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.biz;

import com.hepowdhc.dcapp.modules.alarm.entity.DcaAlarmDetail;
import com.hepowdhc.dcapp.modules.alarm.service.DcaAlarmDetailService;
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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 告警查询Controller
 * 
 * @author huibin.dong
 * @version 2016-11-15
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaAlarmDetail")
public class DcaAlarmDetailController extends BaseController {

	@Autowired
	private DcaAlarmDetailService dcaAlarmDetailService;

	@ModelAttribute
	public DcaAlarmDetail get(@RequestParam(required = false) String id) {
		DcaAlarmDetail entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = dcaAlarmDetailService.get(id);
		}
		if (entity == null) {
			entity = new DcaAlarmDetail();
		}
		return entity;
	}

	/**
	 * 告警分页查询
	 * 
	 * @param dcaAlarmDetail
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("alarm:dcaAlarmDetail:view")
	@RequestMapping(value = { "list", "" })
	public String list(DcaAlarmDetail dcaAlarmDetail, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		String tabType = request.getParameter("tabType");
		if (StringUtils.isNoneEmpty(tabType)){
			request.getSession().setAttribute("tabType",tabType);
		}
		String idxDataType = (String) request.getSession().getAttribute("tabType");

		String operPerson = dcaAlarmDetail.getBizOperPerson();
		if( operPerson!= null ){
			String operPer = operPerson.replace(" ", ""); 
			dcaAlarmDetail.setBizOperPerson(operPer);
		}
		// 设置查询的业务类型
        dcaAlarmDetail.setIdxDataType(idxDataType);
		Page<DcaAlarmDetail> page = dcaAlarmDetailService.findPage(new Page<DcaAlarmDetail>(request, response),
				dcaAlarmDetail);
		
		model.addAttribute("page", page);
		return "modules/dca/dcaAlarmDetailList";
	}
}