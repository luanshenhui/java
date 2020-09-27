/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.kpi.web;

import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import org.apache.commons.collections.CollectionUtils;
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

import com.fasterxml.jackson.databind.JavaType;
import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.kpi.entity.DcaKpi;
import com.hepowdhc.dcapp.modules.kpi.entity.DcaKpiIdx;
import com.hepowdhc.dcapp.modules.kpi.entity.DcaKpiResult;
import com.hepowdhc.dcapp.modules.kpi.service.DcaKpiIdxService;
import com.hepowdhc.dcapp.modules.kpi.service.DcaKpiService;
import com.hepowdhc.dcapp.modules.system.entity.SysDictCustom;
import com.hepowdhc.dcapp.modules.system.service.SysDictCustomService;
import com.thinkgem.jeesite.common.beanvalidator.BeanValidators;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.utils.IdGen;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.utils.excel.ImportExcel;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 企业绩效管理Controller
 * 
 * @author dhc
 * @version 2017-01-09
 */
@Controller
@RequestMapping(value = "${adminPath}/kpi/dcaKpi")
public class DcaKpiController extends BaseController {

	@Autowired
	private DcaKpiService dcaKpiService;
	@Autowired
	private DcaKpiIdxService dcaKpiIdxService;
	@Autowired
	private SysDictCustomService sysDictCustomService;

	@ModelAttribute
	public DcaKpi get(@RequestParam(required = false) String id) {
		DcaKpi entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = dcaKpiService.get(id);
		}
		if (entity == null) {
			entity = new DcaKpi();
		}
		return entity;
	}

	@RequiresPermissions("kpi:dcaKpi:view")
	@RequestMapping(value = { "list", "" })
	public String list(DcaKpi dcaKpi, Model model) {

		List<DcaKpiResult> dcaKpiResult = getKPIColName(dcaKpi);

		model.addAttribute("allresult", dcaKpiResult);

		return "modules/kpi/dcaKpiList";
	}

	@RequiresPermissions("kpi:dcaKpi:view")
	@RequestMapping(value = "form")
	public String form(DcaKpi dcaKpi, Model model) {

		List<DcaKpi> dcaKpiResult = getKPICheckResult(dcaKpi);

		model.addAttribute("result", dcaKpiResult);

		return "modules/kpi/dcaKpiForm";
	}

	@RequiresPermissions("kpi:dcaKpi:edit")
	@RequestMapping(value = "save")
	public String save(DcaKpi dcaKpi, Model model, RedirectAttributes redirectAttributes) {

		if (!beanValidator(model, dcaKpi)) {
			return form(dcaKpi, model);
		}

		dcaKpiService.save(dcaKpi);
		addMessage(redirectAttributes, "保存企业绩效成功");
		return "redirect:" + Global.getAdminPath() + "/kpi/dcaKpi/?repage";
	}

	@RequiresPermissions("kpi:dcaKpi:edit")
	@RequestMapping(value = "delete")
	public String delete(DcaKpi dcaKpi, RedirectAttributes redirectAttributes) {
		dcaKpiService.delete(dcaKpi);
		addMessage(redirectAttributes, "删除企业绩效成功");
		return "redirect:" + Global.getAdminPath() + "/kpi/dcaKpi/?repage";
	}

	/**
	 * 获取绩效考核结果数据
	 * 
	 * @return geshuo 20170109
	 */
	// @RequiresPermissions("kpi:dcaKpi:view")
	// @RequestMapping(value = "getKPICheckResult")
	// @ResponseBody
	public List<DcaKpi> getKPICheckResult(DcaKpi dcaKpi) {
		Map<String, List<DcaKpi>> resultMap = new HashMap<>();
		List<DcaKpi> kpiResultList = dcaKpiService.getKPICheckResult(dcaKpi);
		for (DcaKpi resultItem : kpiResultList) {
			// 按照类型进行区分，类型idxType作为key
			String idxType = resultItem.getIdxType();
			if (null == resultMap.get(idxType)) {
				// map 中该类型不存在
				List<DcaKpi> kpiList = new ArrayList<>();
				kpiList.add(resultItem);
				resultMap.put(idxType, kpiList);
			} else {
				// map中已存在
				resultMap.get(idxType).add(resultItem);
			}
		}

		List<DcaKpi> dcaKpiResult = new ArrayList<DcaKpi>();
		for (String key : resultMap.keySet()) {
			DcaKpi kpiItem = new DcaKpi();

			// 指标类型
			kpiItem.setIdxType(key);
			// 指标类型名称
			String typeName = resultMap.get(key).get(0).getIdxTypeName();
			kpiItem.setIdxTypeName(typeName);

			List<DcaKpi> dataList = resultMap.get(key);
			kpiItem.setDataList(dataList);
			dcaKpiResult.add(kpiItem);
		}

		return dcaKpiResult;
	}

	@RequestMapping(value = "getKPIcolName")
	@ResponseBody
	public List<DcaKpiResult> getKPIColName(DcaKpi dcaKpi) {
		Map<String, List<DcaKpiIdx>> mapResult = new HashMap<>();
		List<DcaKpiIdx> nameList = dcaKpiIdxService.findNameList(dcaKpi);

		List<DcaKpiResult> dcaKpiResult = new ArrayList<>();
		for (DcaKpiIdx result : nameList) {
			// 按照绩效指标类型分类
			String typeId = result.getIdxType();
			if (null == mapResult.get(typeId)) {
				// map中该类型不存在
				List<DcaKpiIdx> nameValue = new ArrayList<>();
				nameValue.add(result);
				mapResult.put(typeId, nameValue);
			} else {
				mapResult.get(typeId).add(result);
			}
		}

		for (String key : mapResult.keySet()) {
			DcaKpiResult allResult = new DcaKpiResult();

			allResult.setIdType(key);
			String typeName = mapResult.get(key).get(0).getColName();
			allResult.setIdTypeName(typeName);

			List<DcaKpiIdx> index = mapResult.get(key);
			// 指标名称存入到list中
			allResult.setResultList(index);

			dcaKpiResult.add(allResult);
		}
		return dcaKpiResult;
	}

	/**
	 * 保存提交
	 * 
	 * @param result
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value = "savaKPIResult")
	public String savaKPIResult(String result, RedirectAttributes redirectAttributes) {

		// 将前台传来的json专为对象
		JavaType javaType = JsonMapper.getInstance().createCollectionType(ArrayList.class, DcaKpi.class);
		List<DcaKpi> dataCollection = (List<DcaKpi>) JsonMapper.getInstance().fromJson(result, javaType);

		// 校验绩效值格式
		if (checkData(dataCollection)) {
			return "false";
		}

		dcaKpiService.savaResult(dataCollection);

		return "success";
	}

	/**
	 * 校验绩效值格式
	 * 
	 * @param list
	 * @return
	 */
	private boolean checkData(List<DcaKpi> list) {

		boolean res = false;
		// double类型数据校验-格式：9999.99(正负)
		Pattern pattern = Pattern.compile("^[-+]?[0-9]{1,4}+(.[0-9]{1,2})?$");
		for (DcaKpi item : list) {

			String value = item.getKpiResult().toString();

			if (!pattern.matcher(value).matches()) {
				res = true;
				break;
			}
		}

		return res;
	}

	/**
	 * 下载模板
	 * 
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("kpi:dcaKpi:edit")
	@RequestMapping(value = "import/template")
	public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String path = System.getProperty("user.dir");
			// 文件的存放路径（本地开发测试使用）
			InputStream inStream = new FileInputStream(path + "/src/main/resources/template/kpi_import_template.xls");
			// 文件的存放路径（生产环境服务器使用）
			// InputStream inStream = new FileInputStream(
			// path + "/webapps/ROOT/WEB-INF/classes/template/kpi_import_template.xlsx");

			// 设置输出的格式
			response.reset();
			response.setContentType("bin");
			response.addHeader("Content-Disposition",
					"attachment;filename=" + URLEncoder.encode("绩效考核导入模板.xls", "UTF-8"));
			// 循环取出流中的数据
			byte[] b = new byte[100];
			int len;
			while ((len = inStream.read(b)) > 0)
				response.getOutputStream().write(b, 0, len);
			inStream.close();
			return null;

		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/kpi/dcaKpi/list?repage";
	}

	/**
	 * 导入绩效考核数据
	 * 
	 * @param file
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("kpi:dcaKpi:edit")
	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 4, 0);
			List<DcaKpi> list = ei.getDataList(DcaKpi.class);
			List<DcaKpi> saveList = new ArrayList<>();

			for (DcaKpi dcaKpi : list) {
				try {
					if (dcaKpi.getKpiResult() == null && dcaKpi.getIdxName().isEmpty()
							&& dcaKpi.getIdxTypeName().isEmpty()) {
						continue;
					} else if (dcaKpi.getKpiResult() == null || dcaKpi.getIdxName().isEmpty()
							|| dcaKpi.getIdxTypeName().isEmpty()) {
						failureMsg.append("<br/>第" + dcaKpi.getKpiId() + "条数据导入失败：数据项不可为空！");
						failureNum++;
					} else {
						// 将绩效指标类型有名称转为type
						String idxType = idxTypeNameToIdxType(dcaKpi.getIdxTypeName());
						dcaKpi.setIdxType(idxType);
						dcaKpi.setIdxName(dcaKpi.getIdxName().trim());
						// 从考核指标表中查询考核指标信息
						DcaKpiIdx dcaKpiIdx = new DcaKpiIdx();
						dcaKpiIdx.setIdxName(dcaKpi.getIdxName());
						dcaKpiIdx.setIdxType(dcaKpi.getIdxType());
						List<DcaKpiIdx> dcaKpiIdxList = dcaKpiIdxService.findByIdxTypeAndIdxName(dcaKpiIdx);

						if (CollectionUtils.isEmpty(dcaKpiIdxList)) {
							failureMsg.append("<br/>第" + dcaKpi.getKpiId() + "条数据导入失败：【" + dcaKpi.getIdxTypeName()
									+ "】中的【" + dcaKpi.getIdxName() + "】在考核指标表中不存在！");
							failureNum++;
						} else {
							BeanValidators.validateWithException(validator, dcaKpi);
							dcaKpi.setKpiId(IdGen.uuid());
							// 考核指标ID(从考核指标表中取得)
							dcaKpi.setIdxId(dcaKpiIdxList.get(0).getIdxId());
							dcaKpi.setCreatePerson(UserUtils.getUser().getId());
							dcaKpi.setUpdatePerson(UserUtils.getUser().getId());
							saveList.add(dcaKpi);
							successNum++;
						}
					}
				} catch (ConstraintViolationException ex) {
					failureMsg.append("<br/>第" + dcaKpi.getKpiId() + "条数据导入失败：");
					List<String> messageList = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>第" + dcaKpi.getKpiId() + "条数据导入失败:" + ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条数据，导入信息如下：");
				addMessage(redirectAttributes, "已成功导入0条数据" + failureMsg);
			} else {
				// 保存list
				dcaKpiService.savaResult(saveList);
				addMessage(redirectAttributes, "已成功导入 " + successNum + " 条数据");
			}

		} catch (Exception e) {
			addMessage(redirectAttributes, "导入数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/kpi/dcaKpi/list?repage";
	}

	/**
	 * 将绩效指标类型有名称转为type
	 * 
	 * @param idxTypeName
	 * @return
	 */
	private String idxTypeNameToIdxType(String idxTypeName) {
		SysDictCustom sysDictCustom = new SysDictCustom();
		sysDictCustom.setLabel(idxTypeName);
		sysDictCustom.setType(Constant.DICT_CUSTOM_TYPE_KPI_IDX_TYPE);
		List<SysDictCustom> dictList = sysDictCustomService.findByLableAndType(sysDictCustom);
		String IdxType = ""; // 字典表中的value
		if (CollectionUtils.isNotEmpty(dictList)) {
			IdxType = dictList.get(0).getValue();
		}
		return IdxType;
	}
}