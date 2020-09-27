/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.system.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hepowdhc.dcapp.modules.system.entity.DcaPageConfig;
import com.hepowdhc.dcapp.modules.system.entity.DcaPageConfigDetail;
import com.hepowdhc.dcapp.modules.system.service.DcaPageConfigService;
import com.hepowdhc.dcapp.modules.workflow.service.DcaWorkflowService;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.entity.Dict;
import com.thinkgem.jeesite.modules.sys.entity.Office;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;

/**
 * 页面设置Controller
 * 
 * @author zhengwei.cui
 * @version 2016-12-26
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaPageConfig")
public class DcaPageConfigController extends BaseController {

	@Autowired
	private DcaPageConfigService dcaPageConfigService;
	@Autowired
	private DcaWorkflowService dcaWorkflowService;

	@ModelAttribute
	public DcaPageConfig get(@RequestParam(required = false) String id) {
		DcaPageConfig entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = dcaPageConfigService.get(id);
		}
		if (entity == null) {
			entity = new DcaPageConfig();
		}
		return entity;
	}

	/**
	 * 初始化页面
	 * 
	 * @param dcaPageConfig
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "list", "" })
	public String list(DcaPageConfig dcaPageConfig, HttpServletRequest request, HttpServletResponse response,
			Model model) {

		DcaPageConfigDetail allData = dcaPageConfigService.getAllData();

		// 查询部门列表
		List<Office> list = dcaPageConfigService.getOfficeList();
		// 查询效能列表
		List<Dict> dictList = DictUtils.getDictList("risk_type_detail");

		model.addAttribute("overallDataList", allData.getOverallDataList());
		model.addAttribute("timeDimensionList", allData.getTimeDimensionList());
		model.addAttribute("involveDeptList", allData.getInvolveDeptList());
		model.addAttribute("efficacyAnalysisList", allData.getEfficacyAnalysisList());

		model.addAttribute("workflowCount", dcaWorkflowService.findEnabledWorkflowCount());
		model.addAttribute("list", list);
		model.addAttribute("dictList", dictList);

		return "modules/dca/dcaPageConfigList";
	}

	@RequestMapping(value = "save")
	public String save(DcaPageConfig dcaPageConfig, Model model, RedirectAttributes redirectAttributes) {

		dcaPageConfigService.save(dcaPageConfig);
		addMessage(redirectAttributes, "保存页面设置成功");
		return "redirect:" + Global.getAdminPath() + "/dca/dcaPageConfigList/?repage";
	}

	/**
	 * 保存页面数据
	 * 
	 * @param dataList
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "saveData")
	public String saveData(String dataList) {

		DcaPageConfigDetail detail = (DcaPageConfigDetail) JsonMapper.fromJsonString(dataList,
				DcaPageConfigDetail.class);

		dcaPageConfigService.saveSubmit(detail);

		return "true";
	}

}