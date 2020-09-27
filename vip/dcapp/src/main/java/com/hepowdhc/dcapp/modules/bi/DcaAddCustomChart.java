package com.hepowdhc.dcapp.modules.bi;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.thinkgem.jeesite.common.web.BaseController;

@Controller
@RequestMapping(value = "${adminPath}/dca/dcaAddcustomchart")
public class DcaAddCustomChart extends BaseController {

	@RequiresPermissions("addcustomchart:dcaAddcustomchart:view")
	@RequestMapping(value = { "addName", "" })
	public String addName(HttpServletRequest request, HttpServletResponse response) {
		return "modules/dca/addCustomChart";
	}

}
