/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.kpi.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.kpi.entity.DcaKpiIdx;
import com.hepowdhc.dcapp.modules.kpi.entity.DcaKpiIdxDataResult;
import com.hepowdhc.dcapp.modules.kpi.service.DcaKpiIdxService;
import com.hepowdhc.dcapp.modules.system.entity.SysDictCustom;
import com.hepowdhc.dcapp.modules.system.service.SysDictCustomService;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;

/**
 * 企业绩效管理Controller
 * 
 * @author dhc
 * @version 2017-01-09
 */
@Controller
@RequestMapping(value = "${adminPath}/kpi/dcaKpiIdx")
public class DcaKpiIdxController extends BaseController {

	@Autowired
	private DcaKpiIdxService dcaKpiIdxService;

	@Autowired
	private SysDictCustomService sysDictCustomService;

	@ModelAttribute
	public DcaKpiIdx get(@RequestParam(required = false) String id) {
		DcaKpiIdx entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = dcaKpiIdxService.get(id);
		}
		if (entity == null) {
			entity = new DcaKpiIdx();
		}
		return entity;
	}

	@RequiresPermissions("kpi:dcaKpiIdx:view")
	@RequestMapping(value = { "list", "" })
	public String list(DcaKpiIdx dcaKpiIdx, HttpServletRequest request, HttpServletResponse response, Model model) {

		SysDictCustom sysDictCustom = new SysDictCustom();
		sysDictCustom.setType(Constant.DICT_CUSTOM_TYPE_IDX_RESULT);
		List<SysDictCustom> dictList = sysDictCustomService.findListByType(sysDictCustom);
		model.addAttribute("dictList", dictList);

		List<DcaKpiIdxDataResult> result = dcaKpiIdxService.getData(dcaKpiIdx);
		model.addAttribute("result", result);

		return "modules/kpi/dcaKpiIdxList";
	}

	/**
	 * 新建/编辑
	 * 
	 * @param dcaKpiIdx
	 * @param model
	 * @return
	 */
	@RequiresPermissions("kpi:dcaKpiIdx:view")
	@RequestMapping(value = "form")
	public String form(DcaKpiIdx dcaKpiIdx, Model model) {

		SysDictCustom sysDictCustom = new SysDictCustom();
		// 绩效指标类型
		sysDictCustom.setType(Constant.DICT_CUSTOM_TYPE_KPI_IDX_TYPE);
		List<SysDictCustom> dictList = sysDictCustomService.findListByType(sysDictCustom);
		model.addAttribute("dictList", dictList);

		// 指标结果类型
		SysDictCustom sysDictCustomResult = new SysDictCustom();
		sysDictCustomResult.setType(Constant.DICT_CUSTOM_TYPE_IDX_RESULT);
		List<SysDictCustom> dictListResult = sysDictCustomService.findListByType(sysDictCustomResult);
		model.addAttribute("dictListResult", dictListResult);

		if (StringUtils.isNotBlank(dcaKpiIdx.getIdxId())) {
			// 根据idxId查询
			List<DcaKpiIdx> dcaKpiIdxList = dcaKpiIdxService.getByIdxId(dcaKpiIdx);
			if (CollectionUtils.isNotEmpty(dcaKpiIdxList)) {
				dcaKpiIdx = dcaKpiIdxList.get(0);
			}
			model.addAttribute("dcaKpiIdx", dcaKpiIdx);
			model.addAttribute("dcaKpiIdxList", dcaKpiIdxList);
		}

		return "modules/kpi/dcaKpiIdxForm";
	}

	/**
	 * 保存数据
	 * 
	 * @param dcaKpiIdx
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("kpi:dcaKpiIdx:edit")
	@RequestMapping(value = "save")
	public String save(DcaKpiIdx dcaKpiIdx, Model model, RedirectAttributes redirectAttributes) {
		// 页面输入的项目名称非空判断
		String idxName = dcaKpiIdx.getIdxName();
		if (StringUtils.isBlank(idxName)) {
			addMessage(redirectAttributes, "指标名称不能为空");
			return "redirect:" + Global.getAdminPath() + "/kpi/dcaKpiIdx/form";
		}
		// 页面选择的类型非空判断
		String idxType = dcaKpiIdx.getIdxType();
		if (StringUtils.isBlank(idxType)) {
			addMessage(redirectAttributes, "绩效指标类型不能为空");
			return "redirect:" + Global.getAdminPath() + "/kpi/dcaKpiIdx/form";
		} else {
			idxName = idxName.trim();
			idxType = idxType.trim();
			// 项目名称在此类型中的重复校验
			String checkFlag = checkName(idxName, idxType);
			if (checkFlag == "false") {
				addMessage(redirectAttributes, "项目名称在此类型中已存在");
				return "redirect:" + Global.getAdminPath() + "/kpi/dcaKpiIdx/form";
			}
		}
		// 绩效临界值判断
		Map<String, String> dataMap = (Map<String, String>) JsonMapper.fromJsonString(dcaKpiIdx.getDataMap(),
				Map.class);
		for (String key : dataMap.keySet()) {
			String criticalityValue = dataMap.get(key);
			// 绩效临界值非空判断
			if (StringUtils.isBlank(criticalityValue)) {
				addMessage(redirectAttributes, "绩效临界值不能为空");
				return "redirect:" + Global.getAdminPath() + "/kpi/dcaKpiIdx/form";
			} else {
				// 绩效临界值格式判断
				boolean checkFlag = checkData(criticalityValue);
				if (checkFlag) {
					addMessage(redirectAttributes, "绩效临界值大小不在-xxxx.xx到xxxx.xx格式范围内！");
					return "redirect:" + Global.getAdminPath() + "/kpi/dcaKpiIdx/form";
				}
			}
		}
		// 绩效临界值大小顺序判断
		if (Double.valueOf(dataMap.get("05")) - Double.valueOf(dataMap.get("04")) > 0
				&& Double.valueOf(dataMap.get("04")) - Double.valueOf(dataMap.get("03")) > 0
				&& Double.valueOf(dataMap.get("03")) - Double.valueOf(dataMap.get("02")) > 0
				&& Double.valueOf(dataMap.get("02")) - Double.valueOf(dataMap.get("01")) > 0) {
			dcaKpiIdx.setIdxName(idxName);
			dcaKpiIdx.setIdxType(idxType);
			// 企业绩效保存
			dcaKpiIdxService.saveData(dcaKpiIdx);
			addMessage(redirectAttributes, "保存企业绩效成功");
			return "redirect:" + Global.getAdminPath() + "/kpi/dcaKpiIdx/?repage";
		} else {
			addMessage(redirectAttributes, "绩效临界值由高到低且不能相等！");
			return "redirect:" + Global.getAdminPath() + "/kpi/dcaKpiIdx/form";
		}
	}

	/**
	 * 删除
	 * 
	 * @param dcaKpiIdx
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("kpi:dcaKpiIdx:edit")
	@RequestMapping(value = "delete")
	public String delete(DcaKpiIdx dcaKpiIdx, RedirectAttributes redirectAttributes) {
		dcaKpiIdxService.deleteByIdxId(dcaKpiIdx);
		addMessage(redirectAttributes, "删除企业绩效成功");
		return "redirect:" + Global.getAdminPath() + "/kpi/dcaKpiIdx/?repage";
	}

	@ResponseBody
	@RequestMapping(value = "getData")
	public String getData(DcaKpiIdx dcaKpiIdx) {
		List<DcaKpiIdxDataResult> result = dcaKpiIdxService.getData(dcaKpiIdx);
		return JsonMapper.nonDefaultMapper().toJson(result);
	}

	/**
	 * 校验绩效临界值大小和格式是否正确
	 * 
	 * @param value
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "checkNum")
	public boolean checkData(String value) {
		value = value.replace("-", "").trim();
		// 正则表达式^\d{1,4}(?:\.\d{1,2})?$
		String reg = "^\\d{1,4}(?:\\.\\d{1,2})?$";
		boolean numResult = value.matches(reg);
		// 正则表达式判断结果numResult为false则不满足格式
		if (numResult) {
			return false;
		}
		return true;
	}

	/**
	 * 校验[指标名称]是否存在
	 * 
	 * @param idxName
	 * @param idxType
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "checkName")
	public String checkName(String idxName, String idxType) {
		if (StringUtils.isNotEmpty(idxName) && StringUtils.isNotEmpty(idxType)) {
			// 参数整合
			DcaKpiIdx entity = new DcaKpiIdx();
			entity.setIdxName(idxName);
			entity.setIdxType(idxType);
			// 根据指标类型和指标名称查询数据
			List<DcaKpiIdx> dcaKpiIdxList = dcaKpiIdxService.findByIdxTypeAndIdxName(entity);
			if (dcaKpiIdxList == null || dcaKpiIdxList.size() == 0) {
				// 不存在重复名称
				return "true";
			}
		}
		return "false";
	}
}