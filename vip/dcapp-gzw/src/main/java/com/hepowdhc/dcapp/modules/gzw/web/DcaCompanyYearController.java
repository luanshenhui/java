/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.gzw.web;

import java.net.URLEncoder;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCompany;
import com.hepowdhc.dcapp.modules.gzw.entity.DcaCompanyReport;
import com.hepowdhc.dcapp.modules.gzw.service.DcaCompanyYearService;
import com.hepowdhc.dcapp.modules.gzw.utils.GUID;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.utils.excel.ImportExcel;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;

/**
 * 单表生成Controller
 * @author ThinkGem
 * @version 2017-01-02
 */
@Controller
@RequestMapping(value = "${adminPath}/dca/dcaCompanyYear")
public class DcaCompanyYearController extends BaseController {

	@Autowired
	private DcaCompanyYearService dcaCompanyService;
	
	@ModelAttribute
	public DcaCompany get(@RequestParam(required=false) String id) {
		DcaCompany entity =null;
		if (StringUtils.isNotBlank(id)){
			entity = dcaCompanyService.get(id);
		}
		if (entity == null){
			entity = new DcaCompany();
		}
		return entity;
	}
	
	@RequiresPermissions("dca:dcaCompanyYear:view")
	@RequestMapping(value = {"list", ""})
	public String list(DcaCompany dcaCompany, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<DcaCompany> page = dcaCompanyService.findPage(new Page<DcaCompany>(request, response), dcaCompany); 
		model.addAttribute("page", page);
		return "modules/gzw/dcaCompanyYearList";
	}

	@RequiresPermissions("dca:dcaCompanyYear:view")
	@RequestMapping(value = "form")
	public String form(DcaCompany dcaCompany, Model model) {
		model.addAttribute("dcaCompany", dcaCompany);
		return "modules/gzw/dcaCompanyYearForm";
	}

	@RequiresPermissions("dca:dcaCompanyYear:edit")
	@RequestMapping(value = "save")
	public String save(DcaCompany dcaCompany, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, dcaCompany)){
			return form(dcaCompany, model);
		}
		dcaCompanyService.save(dcaCompany);
		addMessage(redirectAttributes, "保存DacCompany成功");
		return "redirect:"+Global.getAdminPath()+"/dca/dcaCompanyYear/?repage";
	}
	
	@RequiresPermissions("dca:dcaCompanyYear:edit")
	@RequestMapping(value = "delete")
	public String delete(DcaCompany dcaCompany, RedirectAttributes redirectAttributes) {
		dcaCompanyService.delete(dcaCompany);
		addMessage(redirectAttributes, "删除DacCompany成功");
		return "redirect:"+Global.getAdminPath()+"/dca/dcaCompanyYear/?repage";
	}
	
	/**
	 * 导入用户数据
	 * 
	 * @param file
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("dca:dcaCompanyYear:edit")
	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file, RedirectAttributes redirectAttributes, HttpServletRequest request) {
		try {
			String company = request.getParameter("company");
			String companyY = request.getParameter("companyY");

			if ("".equals(company)) {
				addMessage(redirectAttributes, "企业名称，必须选择！");
				return "redirect:" + adminPath + "/dca/dcaCompanyYear/list?repage";
			}

			if ("".equals(companyY)){
				addMessage(redirectAttributes, "年度，必须输入！");
				return "redirect:" + adminPath + "/dca/dcaCompanyYear/list?repage";
			}

			try {  
		        int year = Integer.parseInt(companyY.substring(0, 4));  
		        if (year <= 0) {
					addMessage(redirectAttributes, "请输入正确年度！例如(2017)");
					return "redirect:" + adminPath + "/dca/dcaCompany/list?repage";
				}  
		    } catch (Exception e) {  
				addMessage(redirectAttributes, "请输入正确年度！例如(2017)");
				return "redirect:" + adminPath + "/dca/dcaCompany/list?repage";
		    }
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<DcaCompany> list = ei.getDataList(DcaCompany.class);
			list.remove(0);
			Collections.sort(list, new Comparator<DcaCompany>() {
				public int compare(DcaCompany arg0, DcaCompany arg1) {
					return arg0.getReviewType().compareTo(arg1.getReviewType());
				}
			});

			String errinfo = "";
			String reviewType = "";
			Integer sumErr = 0;
			Map<String, Integer> map = new HashMap<String, Integer>();

			for (DcaCompany dcaCompany : list) {
				if (!"".equals(dcaCompany.getReviewType())) {
					if (map.containsKey(dcaCompany.getReviewType())) {
						map.put(dcaCompany.getReviewType(), map.get(dcaCompany.getReviewType()).intValue() + 1);
					} else {
						map.put(dcaCompany.getReviewType(), 1);
					}
				}
			}

			for (String key : map.keySet()) {
				errinfo = errinfo + key + "," + map.get(key)+",";
				reviewType = reviewType + key + ",";
				sumErr = sumErr + map.get(key);
			}

			DcaCompany companyp = new DcaCompany();
			companyp.setUid(new GUID().toString());
			companyp.setCompanyId(company);
			companyp.setCompanyY(companyY);
			companyp.setReviewType(reviewType);
			companyp.setReviewTypeCount(errinfo);
			companyp.setFileName(file.getOriginalFilename());
			companyp.setCompanyFile(file.getBytes());
			companyp.setSumErr(String.valueOf(sumErr));

			List<DcaCompany> companylist = dcaCompanyService.findList(companyp);

			if (companylist.size() == 0) {
				// 插入
				dcaCompanyService.save(companyp);
			}else{
				// 更新
				dcaCompanyService.update(companyp);
			}
			// 履历插入
			dcaCompanyService.backup(companyp);

			addMessage(redirectAttributes, "已成功导入 ");
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入用户失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/dca/dcaCompanyYear/list?repage";
	}

	/**
	 * 下载导入用户数据
	 * 
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("dca:dcaCompanyYear:view")
	@RequestMapping(value = "import/template")
	public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes,
			HttpServletRequest request) {
		try {

			String company = request.getParameter("company");
			String companyY = request.getParameter("companyY");

			DcaCompany companyp = new DcaCompany();
			companyp.setCompanyId(company);
			companyp.setCompanyY(companyY);

			List<DcaCompany> companylist = dcaCompanyService.findList(companyp);

			// 设置输出的格式
			response.reset();
			response.setContentType("bin");
			response.addHeader("Content-Disposition",
					"attachment;filename=" + URLEncoder.encode(companylist.get(0).getFileName(), "UTF-8"));
			response.getOutputStream().write(companylist.get(0).getCompanyFile());

			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/dca/dcaCompanyYear/list?repage";

	}
	
	/**
	 * 审核结果总
	 * 
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("dca:dcaCompanyYear:view")
	@RequestMapping(value = "reportAll")
	public String reportAll(HttpServletRequest request,HttpServletResponse response, RedirectAttributes redirectAttributes) {
		return "modules/gzw/dcaCompanyYearReportAll";

	}
	
	/**
	 * 审核结果月
	 * 
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("dca:dcaCompanyYear:view")
	@RequestMapping(value = "reportY")
	public String reportYM(DcaCompany dcaCompany, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		request.getSession().setAttribute("year_companyId", dcaCompany.getCompanyId());
		request.getSession().setAttribute("year_companyY", dcaCompany.getCompanyY());
		
		String company = dcaCompany.getCompanyId();
		String companyY = dcaCompany.getCompanyY();
		if ("".equals(company)) {
			addMessage(redirectAttributes, "企业名称，必须选择！");
			return "redirect:" + adminPath + "/dca/dcaCompanyYear/list?repage";
		}

		if ("".equals(companyY)){
			addMessage(redirectAttributes, "年度，必须输入！");
			return "redirect:" + adminPath + "/dca/dcaCompanyYear/list?repage";
		}

		try {  
	        int year = Integer.parseInt(companyY.substring(0, 4));  
	        if (year <= 0) {
				addMessage(redirectAttributes, "请输入正确年度！例如(2017)");
				return "redirect:" + adminPath + "/dca/dcaCompany/list?repage";
			}  
	    } catch (Exception e) {  
			addMessage(redirectAttributes, "请输入正确年度！例如(2017)");
			return "redirect:" + adminPath + "/dca/dcaCompany/list?repage";
	    }
		return "modules/gzw/dcaCompanyYearReportY";

	}

	/**
	 * 审核结果总
	 * 
	 * @return
	 * @author lip
	 * @date 2016年12月5日
	 */
	@RequestMapping(value = "reportAllData")
	@ResponseBody
	public String reportAllData() {

        DcaCompany companyp = new DcaCompany();

		List<DcaCompany> companylistAll = dcaCompanyService.findList(companyp);
		DcaCompanyReport companyReport = new DcaCompanyReport();
		TreeMap<String, Integer> mapReviewType = new TreeMap<String, Integer>();
		TreeMap<String, Integer> mapCompany = new TreeMap<String, Integer>();

		List<String> reviewTypelist = Lists.newArrayList();
		List<String> companylist = Lists.newArrayList();
		List<String> sumlist = Lists.newArrayList();
		for(DcaCompany company:companylistAll){
			String reviewType[]=company.getReviewType().split(",");
			
			for(String tempteype:reviewType){
				if (!mapReviewType.containsKey(tempteype)) {
					mapReviewType.put(tempteype, 1);
				} 
			}

			if (!mapCompany.containsKey(company.getCompanyId())) {
					mapCompany.put(company.getCompanyId(), 1);
					String comanyName = DictUtils.getDictLabel(company.getCompanyId(), "company_name", "");
					companylist.add(comanyName);
					String errSum = this.dcaCompanyService.findSum(company.getCompanyId());
					sumlist.add(errSum);
			} 
		}
		
		List<List<String>> typelist = Lists.newArrayList();
		for (String typekey : mapReviewType.keySet()) {
			List<String> typeCountlist = Lists.newArrayList();
			for (String companykey : mapCompany.keySet()) {
				DcaCompany companypCount = new DcaCompany();
				companypCount.setCompanyId(companykey);
				companypCount.setReviewType(typekey+",");
				String typeCount =dcaCompanyService.findCount(companypCount);
				typeCountlist.add(typeCount);
			}
			reviewTypelist.add(typekey);
			typelist.add(typeCountlist);
		}

		companyReport.setCompanylist(companylist);
		companyReport.setReviewTypelist(reviewTypelist);
		companyReport.setTypelist(typelist);
		companyReport.setSumlist(sumlist);
		// 查询平台告警统计数据
		return JsonMapper.nonDefaultMapper().toJson(companyReport);
	}
	
	/**
	 * 审核结果月
	 * 
	 * @return
	 * @author lip
	 * @date 2016年12月5日
	 */
	@RequestMapping(value = "reportYmView")
	@ResponseBody
	public String reportYmView(HttpServletRequest request,HttpServletResponse response, RedirectAttributes redirectAttributes) {
		return "modules/gzw/dcaCompanyYearReportYM";
	}

	/**
	 * 审核结果月
	 * 
	 * @return
	 * @author lip
	 * @date 2016年12月5日
	 */
	@RequestMapping(value = "reportYmData")
	@ResponseBody
	public String reportYmData(HttpServletRequest request, RedirectAttributes redirectAttributes) {

		String companyId = String.valueOf(request.getSession().getAttribute("year_companyId"));
		String companyY = String.valueOf(request.getSession().getAttribute("year_companyY"));
		
		DcaCompany dcompanyp = new DcaCompany();
		dcompanyp.setCompanyId(companyId);
		dcompanyp.setCompanyY(companyY);
		
		List<DcaCompany> companylistAll = dcaCompanyService.findListY(dcompanyp);
		DcaCompanyReport companyReport = new DcaCompanyReport();
		TreeMap<String, Integer> mapReviewType = new TreeMap<String, Integer>();

		List<String> reviewTypelist = Lists.newArrayList();
		List<String> sumlist = Lists.newArrayList();
		for(DcaCompany company:companylistAll){
			String reviewType[]=company.getReviewType().split(",");
			
			for(String tempteype:reviewType){
				if (!mapReviewType.containsKey(tempteype)) {
					mapReviewType.put(tempteype, 1);
				} 
			}
		}
		
		List<List<String>> typelist = Lists.newArrayList();
		List<String> typeCountlist = Lists.newArrayList();
		for (String typekey : mapReviewType.keySet()) {
				DcaCompany companypCount = new DcaCompany();
				companypCount.setCompanyId(dcompanyp.getCompanyId());
				companypCount.setCompanyY(dcompanyp.getCompanyY());
				companypCount.setReviewType(typekey+",");
				
				String typeCount =dcaCompanyService.findCountYM(companypCount);
				typeCountlist.add(typeCount);
				List<DcaCompany> companylistsum = this.dcaCompanyService.findList(companypCount);
				if(companylistsum .size() ==0){
					sumlist.add("0");
				}else{
				    sumlist.add(companylistsum.get(0).getSumErr());
				}
			reviewTypelist.add(typekey);
		}
		typelist.add(typeCountlist);

		DcaCompany outDcaCompany = new DcaCompany();
		if ( dcompanyp.getCompanyY() == "null"){
			outDcaCompany.setCompanyName("");
			outDcaCompany.setCompanyY("");
		}else{
			outDcaCompany.setCompanyName(DictUtils.getDictLabel(dcompanyp.getCompanyId(), "company_name", ""));
			outDcaCompany.setCompanyY(dcompanyp.getCompanyY());
		}
		
		companyReport.setDcaCompany(outDcaCompany);
		companyReport.setCompanylist(reviewTypelist);
		companyReport.setReviewTypelist(reviewTypelist);
		companyReport.setTypelist(typelist);
		companyReport.setSumlist(typeCountlist);
		// 查询平台告警统计数据
		return JsonMapper.nonDefaultMapper().toJson(companyReport);
	}
}