package com.hepowdhc.dcapp.modules.risklist.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.hepowdhc.dcapp.modules.risklist.entity.RiskTypeDetail;
import com.hepowdhc.dcapp.modules.risklist.service.RiskTypeDetailService;
import com.hepowdhc.dcapp.modules.system.entity.SysDict;
import com.thinkgem.jeesite.common.mapper.JsonMapper;

@Controller
@RequestMapping(value = "${adminPath}/dca/risktypedetail")
public class RiskTypeDetailController {
	
	@Autowired
	private RiskTypeDetailService riskTypeDetailService;
	
	/**
	 * 风险矩阵列表横向纵向标示
	 * 
	 * @param sysDict
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("dca:risktypedetail:view")
	@RequestMapping(value = { "list", "" })
	public String list(SysDict sysDict , HttpServletRequest request, HttpServletResponse response, Model model) {

		sysDict = new SysDict();
		List<SysDict> titleList= riskTypeDetailService.findriskListByType(sysDict);
		model.addAttribute("titleList", titleList);
		List<List<String>> dictList = riskTypeDetailService.findTableListByType(sysDict);
		model.addAttribute("dictList", dictList);
		return "modules/dca/risktypedetailList";
	}

	/**
	 * 风险矩阵列实际获取数值
	 * 
	 * @param riskTypeDetail
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "getData")
	public String getData(RiskTypeDetail riskTypeDetail) {
		List<RiskTypeDetail> result = riskTypeDetailService.getData(riskTypeDetail);
		return JsonMapper.nonDefaultMapper().toJson(result);
	}
	
	/**
	 * 风险矩阵列修改实际是删除后从新插入
	 * 
	 * @param riskTypeDetail
	 * @return
	 */
	
	@RequiresPermissions("dca:risktypedetail:save")
	@ResponseBody
	@RequestMapping(value = "save")
	public String save(String list, Model model, RedirectAttributes redirectAttributes) {
		try {
			List<RiskTypeDetail> detlist = JsonMapper.toJsonCollections(list,ArrayList.class,RiskTypeDetail.class);
			riskTypeDetailService.saveRiskTypeDetail(detlist);
			return "success";
		} catch (JsonParseException e) {
			e.printStackTrace();
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return "error";
	}

}
