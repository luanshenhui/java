package com.dpn.ciqqlc.http;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.dpn.ciqqlc.common.util.CommonUtil;
import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.common.util.FileUtil;
import com.dpn.ciqqlc.http.form.HlthcheckForm;
import com.dpn.ciqqlc.http.form.MailSteamerSampForm;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdDTO;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.model.CodeLibraryDTO;
import com.dpn.ciqqlc.standard.model.DeclarationDTO;
import com.dpn.ciqqlc.standard.model.HlthCheckDTO;
import com.dpn.ciqqlc.standard.model.MailSteamerChkDealDTO;
import com.dpn.ciqqlc.standard.model.MailSteamerChkDealModel;
import com.dpn.ciqqlc.standard.model.MailSteamerDTO;
import com.dpn.ciqqlc.standard.model.MailSteamerRmkDTO;
import com.dpn.ciqqlc.standard.model.MailSteamerSampDTO;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.model.VideoFileEventModel;
import com.dpn.ciqqlc.standard.service.CommonService;
import com.dpn.ciqqlc.standard.service.MailSteamerService;
import com.dpn.ciqqlc.standard.service.UserManageDbService;

/**
 * mailSteamerConvryController.
 * 
 * @author
 * @since 1.0.0
 * @version 1.0.0
 */
/**************************************************************************
 * 进出境运输工具检疫（邮轮）
 **************************************************************************/
@Controller
@RequestMapping(value = "/mailSteamer")
public class MailSteamerController {
	/**
	 * logger.
	 * 
	 * @since 1.0.0
	 */
	private final Logger logger_ = LoggerFactory.getLogger(this.getClass());
	/**
	 * DbServ.
	 * 
	 * @since 1.0.0
	 */
	/**
	 * DbServ.
	 * 
	 * @since 1.0.0
	 */
	@Autowired
	@Qualifier("mailSteamerDbServ")
	private MailSteamerService mailSteamerDbServ = null;

	/**
	 * DbServ.
	 * 
	 * @since 1.0.0
	 */
	@Autowired
	@Qualifier("userManageDbServ")
	private UserManageDbService dbServ = null;

	@Autowired
	private CommonService commonServer;

	/**
	 * 获取当前登录用户
	 * 
	 * @param request
	 * @return
	 */
	UserInfoDTO getUser(HttpServletRequest request) {
		Object userObj = request.getSession().getAttribute(Constants.USER_KEY);
		if (null != userObj) {
			return (UserInfoDTO) userObj;
		}
		return new UserInfoDTO();
	}

	/*********************************************************************************************************************
	 * 进出境运输工具检疫（邮轮）执法全过程记录查询
	 * 
	 * @param request
	 * @return
	 *********************************************************************************************************************/
	@SuppressWarnings("unchecked")
	@RequestMapping("/showenforcementprocess")
	public String findProcesslist(HttpServletRequest request) {
		Map<String, String> map = CommonUtil.getParamsToMap(request
				.getParameterMap());
		try {
			// 分页处理
			if (map.size() == 0) {
				map.put("page", "1");
			}
			int pages = Integer.parseInt(map.get("page"));
			int counts = mailSteamerDbServ.findEnforcementprocessCount(map);
			map.put("firstRcd",
					String.valueOf((pages - 1) * Constants.PAGE_NUM + 1)); // 数据定位
			map.put("lastRcd", String.valueOf(pages * Constants.PAGE_NUM));
			List<MailSteamerDTO> list = mailSteamerDbServ
					.findEnforcementprocessList(map);
			// List<OrganizesDTO> orglist = dbServ.getAllOrgList();
			// List<DeptmentsDTO> depyList = dbServ.getAllDeptList();
			List<CodeLibraryDTO> organizes = CommonUtil.queryCodeLibrary(
					Constants.QLCORGANIZES, request); // 直属局下拉列表
			List<CodeLibraryDTO> deptments = CommonUtil.queryCodeLibrary(
					Constants.QLCDEPTMENTS, request);
			Map<String, String> tempMap = new HashMap<String, String>();
			tempMap.put("type", "QLC_MAIL_STEAMER_CHK_NOTIFY");
			List<CodeLibraryDTO> libraryList = commonServer
					.getCodeLibrary(tempMap);
			request.setAttribute("orglist", organizes);
			request.setAttribute("depyList", deptments);
			request.setAttribute("libraryList", libraryList);
			request.setAttribute("list", list);
			request.setAttribute("map", map);// 查询条件
			request.setAttribute("itemInPage", Constants.PAGE_NUM);// 每页几条数据
			request.setAttribute("pages", pages);
			request.setAttribute(
					"allPage",
					counts % Constants.PAGE_NUM == 0 ? (counts / Constants.PAGE_NUM)
							: (counts / Constants.PAGE_NUM) + 1);// 总共多少页
			request.setAttribute("counts", counts);// 总共多少条数据
		} catch (Exception e) {
			logger_.error(
					"***********/mailSteamer/showenforcementprocess************",
					e);
		} finally {
			map = null;
		}
		return "mailSteamer/enforcement/processList";
	}

	/*********************************************************************************************************************
	 * 进出境运输工具检疫（邮轮）邮轮入境检疫申报查询
	 * 
	 * @param request
	 * @return
	 *********************************************************************************************************************/
	@SuppressWarnings("unchecked")
	@RequestMapping("/showdeclarationlist")
	public String findDeclaratiionlist(HttpServletRequest request) {
		Map<String, String> map = CommonUtil.getParamsToMap(request
				.getParameterMap());
		try {
			// 分页处理
			if (map.size() == 0) {
				map.put("page", "1");
			}
			int pages = Integer.parseInt(map.get("page"));
			int counts = mailSteamerDbServ.findDeclarationCount(map);
			map.put("firstRcd",
					String.valueOf((pages - 1) * Constants.PAGE_NUM + 1)); // 数据定位
			map.put("lastRcd", String.valueOf(pages * Constants.PAGE_NUM + 1));
			List<DeclarationDTO> list = mailSteamerDbServ
					.findDeclarationlist(map);
			if (list != null && list.size() > 0) {
				for (DeclarationDTO declar : list) {
					if (declar != null) {
						if (declar.getCiq_resault() != null
								&& !declar.getCiq_resault().equals("")) {
							if (declar.getCiq_resault().equals("通过")) {
								declar.setMail_dec("<a href=\"javascript:jumpPage('/ciqs/mailSteamer/editDeclaration?decMasterId="
										+ declar.getDec_master_id()
										+ "');\">入境检疫申报</a>");
							}
							if (StringUtils.isNotEmpty(declar.getFile_name())) {
								declar.setFile_name("<input  type='button' value='附件下载' style='width: 70px' onclick='download(\""
										+ declar.getFile_name() + "\")'/>");
							}
						}

					}
				}
			}
			List<CodeLibraryDTO> levels = CommonUtil.queryCodeLibrary(
					"QLC_MAIL_STEAMER_CENT_WAR_LEVEL", request);
			request.setAttribute("levels", levels);
			List<CodeLibraryDTO> inspTypes = CommonUtil.queryCodeLibrary(
					"QLC_MAIL_STEAMER_CHK_NOTIFY", request);
			request.setAttribute("inspTypes", inspTypes);
			request.setAttribute("list", list);
			request.setAttribute("map", map);// 查询条件
			request.setAttribute("itemInPage", Constants.PAGE_NUM);// 每页几条数据
			request.setAttribute("pages", pages);
			request.setAttribute(
					"allPage",
					counts % Constants.PAGE_NUM == 0 ? (counts / Constants.PAGE_NUM)
							: (counts / Constants.PAGE_NUM) + 1);// 总共多少页
			request.setAttribute("counts", counts);// 总共多少条数据
		} catch (Exception e) {
			logger_.error(
					"***********/mailSteamer/showdeclaratiionlist************",
					e);
		} finally {
			map = null;
		}
		return "mailSteamer/declaration/declarationlist";
	}

	/*********************************************************************************************************************
	 * 页面跳转详情页面
	 *********************************************************************************************************************/
	@RequestMapping("/showtoprocessInfo_jsp")
	public String showToprocessInfo_jsp(HttpServletRequest request,
			String processId) {
		Map<String, Object> resultData = new HashMap<String, Object>();
		try {
			if (null == processId || "".equals(processId)) {
				resultData.put("status", "FAIL");
				resultData.put("results", "输入数据不能为空");
			} else {
				Map<String, String> paramMap = new HashMap<String, String>(); // 存放照片，视频和doc的查询参数
				Map<String, String> results = mailSteamerDbServ
						.findEnforcementprocessById(processId);// 获得进出境运输工具检疫（邮轮）基本信息
				paramMap.put("dec_master_id", results.get("DEC_MASTER_ID"));
				paramMap.put("proj_code", "JC_T_Y");
				paramMap.put("port_org_code", "");
				paramMap.put("port_dept_code", "");
				List<Map<String, String>> processFiles = mailSteamerDbServ
						.getfileList(paramMap); // 查询该详情页面所涉及的所有照片和视频
				List<Map<String, String>> processDocs = mailSteamerDbServ
						.getDocList(paramMap);// 查询该详情页面所涉及的所有doc
				Map<String, String> tempMap = new HashMap<String, String>();
				tempMap.put("dec_master_id", results.get("DEC_MASTER_ID"));
				String type = "0";
				String typeName = "";
				String hlthcheckType = "";
				List<HlthCheckDTO> list = mailSteamerDbServ
						.getHlthcheckList(tempMap);
				if (list != null && list.size() > 0) {
					for (HlthCheckDTO hcl : list) {
						if (hcl != null) {
							if (hcl.getHlth_check_type() != null
									&& !hcl.getHlth_check_type().equals("")) {
								if (hcl.getHlth_check_type().equals("1")) {
									type = hcl.getHlth_check_type();
									typeName = "一般卫生监督表";
									hlthcheckType = hcl.getHlth_check_type();
								} else {
									if (type.equals("1")) {
										type = "3";
										typeName = "一般卫生监督表,专项卫生监督表";
										hlthcheckType += ","
												+ hcl.getHlth_check_type();
										break;
									} else {
										type = hcl.getHlth_check_type();
										typeName = "专项卫生监督表";
										hlthcheckType = hcl
												.getHlth_check_type();
									}
								}
							}
						}
					}
				}
				// 专项卫生监督 - 证据报告表 - 照片列表
				request.setAttribute("V_MS_E_R", CommonUtil
						.queryVideoFileEvent(results.get("DEC_MASTER_ID"),
								"V_MS_E_R", null, request));
				// 登轮检疫 - 文件审核 - 违反事项
				request.setAttribute("V_JC_T_Y_2", CommonUtil
						.queryVideoFileEvent(results.get("DEC_MASTER_ID"),
								"V_JC_T_Y_2", null, request));
					

				// 登轮检疫 - 文件审核 - 有无可以病例
				request.setAttribute("D_OC_PAGE_2", CommonUtil.queryDoc(
						results.get("DEC_MASTER_ID"), "D_OC_PAGE_2", request));
				// 登轮检疫 - 文件审核 - 申报无异常事项
				// request.setAttribute("D_JC_T_Y_7",
				// CommonUtil.queryDoc(results.get("DEC_MASTER_ID"),
				// "D_JC_T_Y_7", request));
				request.setAttribute("D_OC_PAGE_1", CommonUtil.queryDoc(
						results.get("DEC_MASTER_ID"), "D_OC_PAGE_1", request));
				// 登轮检疫 - 文件审核 - 检查结果表
				// request.setAttribute("D_JC_T_Y_2",
				// CommonUtil.queryDoc(results.get("DEC_MASTER_ID"),
				// "D_JC_T_Y_2", request));
				request.setAttribute("D_OC_REGISTER", CommonUtil.queryDoc(
						results.get("DEC_MASTER_ID"), "D_OC_REGISTER", request));
				// 船舶卫生监督评分表
				request.setAttribute("D_MS_SP_GD", CommonUtil.queryDoc(
						results.get("DEC_MASTER_ID"), "D_MS_SP_GD", request));

				// 监督结果
				HlthCheckDTO hlthChk = mailSteamerDbServ.getLatestCheck(results.get("DEC_MASTER_ID"));
				request.setAttribute("hlthChk",hlthChk );
				// 采样记录
				MailSteamerSampDTO samp = mailSteamerDbServ.getLatestSamp(results.get("DEC_MASTER_ID"));
				request.setAttribute("samp", samp);
				// 检疫处理
				MailSteamerChkDealDTO chkDeal =  mailSteamerDbServ.getLatestDeal(results.get("DEC_MASTER_ID"));
				request.setAttribute("chkDeal",chkDeal);
				// 结果判定
				List<Map<String, String>> res = mailSteamerDbServ.getLastResult(results.get("DEC_MASTER_ID"));
				if(res.size()>0){
					request.setAttribute("resultCheck", res.get(0));
				}

				tempMap.put("name", "监督结果");
				tempMap.put("type", type);
				tempMap.put("hlthcheckType", hlthcheckType);
				tempMap.put("typeName", typeName);
				resultData.put("tempMap", tempMap);
				resultData.put("status", "OK");
				request.setAttribute("results", results);
				resultData.put("processFiles", processFiles);
				resultData.put("processDocs", processDocs);

				VideoFileEventModel proc1 = new VideoFileEventModel();
				proc1.setCreate_date(DateUtil.formatDateTime(results.get("DEC_DATE")));
				if(proc1.getCreate_date() != null){
					proc1.setCreate_date_str(DateUtil.DateToString(proc1.getCreate_date(), "yyyy-MM-dd HH:mm"));
				}
				proc1.setCreate_user(results.get("DEC_ORG"));
				String[] dljyFile = new String[] { "V_MS_E_R",
						"V_JC_T_Y_D_9",
						"V_JC_T_Y_D_10",
						"V_JC_T_Y_D_5",
						"V_JC_T_Y_D_1",
						"V_JC_T_Y_D_2",
						"V_MS_OP_ZS_QF",
						"V_JC_T_Y_D_6"};
				String[] dljyDocs = new String[] {
						"D_JC_T_Y_6", "D_JC_T_Y_7",
						"D_JC_T_Y_2", "D_MS_SP_GD",
						"D_OC_PAGE_1","D_OC_PAGE_2","V_MS_E_R",
						"D_JC_T_Y_4","D_OC_REGISTER"};
				VideoFileEventModel[] procArray = new VideoFileEventModel[] {
						proc1,
						CommonUtil.getMaxDateFileInProcTypes(request,
								results.get("DEC_MASTER_ID"), new String[] { "V_JC_T_Y_D_8" },
								new String[] { "D_JC_T_Y_8" }),
						CommonUtil.getMaxDateFileInProcTypes(request,
								results.get("DEC_MASTER_ID"),dljyFile, dljyDocs),
						new VideoFileEventModel(),
						new VideoFileEventModel(),
						CommonUtil.getMaxDateFileInProcTypes(request,
								results.get("DEC_MASTER_ID"), null,
								new String[] { "D_JC_T_Y_5" }) };
				
				//整合登轮环节详情页面小圆圈问题
				if(procArray[2] == null && (res.size() > 0 || hlthChk.getCheck_date() != null 
						|| samp.getSamp_date() != null || chkDeal.getCheck_deal_date() != null)){
					procArray[2] = new VideoFileEventModel();
				}
				if(res.size()>0){
					if(procArray[2].getCreate_date_str().compareTo(res.get(0).get("CREATE_DATE")) < 0){
						
						procArray[2].setCreate_date_str(res.get(0).get("CREATE_DATE"));
						procArray[2].setCreate_user(res.get(0).get("CHECK_DEAL_PSN"));
					}
				}
				if(hlthChk.getCheck_date() != null){
					String str = DateUtil.DateToString(hlthChk.getCheck_date(),DateUtil.DATETIME_DEFAULT_FORMAT);
					if((StringUtils.isNotEmpty(procArray[2].getCreate_date_str()) &&
							procArray[2].getCreate_date_str().compareTo(str) < 0)
							|| StringUtils.isEmpty(procArray[2].getCreate_date_str())){
						procArray[2].setCreate_date_str(str);
						procArray[2].setCreate_user(hlthChk.getCheck_psn());
					}
				}
				
				if(samp.getSamp_date() != null){
					String str = DateUtil.DateToString(samp.getSamp_date(),DateUtil.DATETIME_DEFAULT_FORMAT);
					if((StringUtils.isNotEmpty(procArray[2].getCreate_date_str()) &&
							procArray[2].getCreate_date_str().compareTo(str) < 0)
							|| StringUtils.isEmpty(procArray[2].getCreate_date_str())){
						procArray[2].setCreate_date_str(str);
						procArray[2].setCreate_user(samp.getSamp_psn());
					}					
				}
				
				if(chkDeal.getCheck_deal_date() != null){
					String str = DateUtil.DateToString(chkDeal.getCheck_deal_date(),DateUtil.DATETIME_DEFAULT_FORMAT);
					if((StringUtils.isNotEmpty(procArray[2].getCreate_date_str()) &&
							procArray[2].getCreate_date_str().compareTo(str) < 0)
							|| StringUtils.isEmpty(procArray[2].getCreate_date_str())){
						procArray[2].setCreate_date_str(str);
						procArray[2].setCreate_user(chkDeal.getCheck_deal_psn());
					}					
				}
				
				
				request.setAttribute("DENG_LUN_JIAN_YI", procArray[2] != null ? procArray[2].getCreate_date_str():null);
				request.setAttribute("procArray", new ObjectMapper()
						.writeValueAsString(procArray).replace("null", "\"\"")
						.replace("\"", "\'"));
				
				// dingJY start------------------------------------------------------------
				// 登轮前注意事项列表
				List<VideoFileEventModel> haha = CommonUtil.queryVideoFileEvent(results.get("DEC_MASTER_ID"),
							"V_JC_T_Y_D_9", null, request);
				List<VideoFileEventModel> re = new ArrayList<VideoFileEventModel>();
				if(haha != null){
					for(int i=haha.size()-1;i>=0;i--){
						re.add(haha.get(i));
					}
				}
				request.setAttribute("V_JC_T_Y_D_9",re);
				
				// 船舶文件检查清单
				request.setAttribute("V_JC_T_Y_D_2", CommonUtil
						.queryVideoFileEvent(results.get("DEC_MASTER_ID"),
								"V_JC_T_Y_D_2", null, request));
				
				// 证书签发 Free Pratique
				request.setAttribute("V_MS_OP_ZS_QF", CommonUtil
						.queryVideoFileEvent(results.get("DEC_MASTER_ID"),
								"V_MS_OP_ZS_QF", null, request));
				// 证书签发 Pratique
				request.setAttribute("V_JC_T_Y_D_6", CommonUtil
						.queryVideoFileEvent(results.get("DEC_MASTER_ID"),
								"V_JC_T_Y_D_6", null, request));
				// 仪器领用
				request.setAttribute("V_JC_T_Y_D_8", CommonUtil
						.queryVideoFileEvent(results.get("DEC_MASTER_ID"),
								"V_JC_T_Y_D_8", null, request));
				// 突发公共卫生事件 D_JC_T_Y_3 V_JC_T_Y_D_10
				request.setAttribute("V_JC_T_Y_D_10", CommonUtil
						.queryVideoFileEvent(results.get("DEC_MASTER_ID"),
								"V_JC_T_Y_D_10", null, request));
				
				Map<String, String> paramMap1 = new HashMap<String, String>();
				paramMap1.put("doc_type", "D_JC_T_Y_3");
				paramMap1.put("proc_main_id", results.get("DEC_MASTER_ID"));
				CheckDocsRcdDTO docDTO1 = mailSteamerDbServ.findDocByTypeNMainId(paramMap1);
				request.setAttribute("D_JC_T_Y_3", docDTO1);
				
				
				paramMap1.put("doc_type", "D_MS_SP_SC_FI");
				paramMap1.put("proc_main_id", results.get("DEC_MASTER_ID"));
				CheckDocsRcdDTO d = mailSteamerDbServ.findDocByTypeNMainId(paramMap1);
/*				CheckDocsRcdDTO d = CommonUtil.queryDoc(results.get("DEC_MASTER_ID"),
						 "D_MS_SP_SC_FI", request);*/
				 request.setAttribute("V_JC_T_Y_D_2_DOC",d.getProc_main_id() == null ? null : d);
				 
				// 其他事项
				paramMap1.put("doc_type", "D_JC_T_Y_4");
				paramMap1.put("proc_main_id", results.get("DEC_MASTER_ID"));
				CheckDocsRcdDTO docDTO2 = mailSteamerDbServ.findDocByTypeNMainId(paramMap1);
				request.setAttribute("D_JC_T_Y_4", docDTO2);
				
				//要求船方预先准备的清单
				paramMap1.put("doc_type", "D_JC_T_Y_8");
				paramMap1.put("proc_main_id", results.get("DEC_MASTER_ID"));
				CheckDocsRcdDTO docDTO3 = mailSteamerDbServ.findDocByTypeNMainId(paramMap1);
				request.setAttribute("D_JC_T_Y_8", docDTO3);
				
				// 结果登记下的拍照记录
				request.setAttribute("V_JC_T_Y_D_5", CommonUtil
						.queryVideoFileEvent(results.get("DEC_MASTER_ID"),
								"V_JC_T_Y_D_5", null, request));
				
				// 归档
				paramMap1.put("doc_type", "D_JC_T_Y_5");
				paramMap1.put("proc_main_id", results.get("DEC_MASTER_ID"));
				CheckDocsRcdDTO docDTO4 = mailSteamerDbServ.findDocByTypeNMainId(paramMap1);
				request.setAttribute("D_JC_T_Y_5", docDTO4);
				
				// 船舶卫生监督评分表拍照录像V_JC_T_Y_D_1
				request.setAttribute("V_JC_T_Y_D_1", CommonUtil
						.queryVideoFileEvent(results.get("DEC_MASTER_ID"),
								"V_JC_T_Y_D_1", null, request));
			}
		} catch (Exception e) {
			logger_.error(
					"***********/mailSteamer/findProcessInfo************",
					e.getMessage());
			e.printStackTrace();
		}
		return "mailSteamer/enforcement/processInfo";
	}

	@ResponseBody
	@RequestMapping("/findProcessInfo")
	public Map<String, Object> findProcessInfo(String processId) {
		Map<String, Object> resultData = new HashMap<String, Object>();
		try {
			if (null == processId || "".equals(processId)) {
				resultData.put("status", "FAIL");
				resultData.put("results", "输入数据不能为空");
			} else {
				Map<String, String> paramMap = new HashMap<String, String>(); // 存放照片，视频和doc的查询参数
				Map<String, String> results = mailSteamerDbServ.findEnforcementprocessById(processId);// 获得进出境运输工具检疫（邮轮）基本信息
				paramMap.put("dec_master_id", results.get("DEC_MASTER_ID"));
				paramMap.put("proj_code", "JC_T_Y");
				paramMap.put("port_org_code", "");
				paramMap.put("port_dept_code", "");
				List<Map<String, String>> processFiles = mailSteamerDbServ
						.getfileList(paramMap); // 查询该详情页面所涉及的所有照片和视频
				List<Map<String, String>> processDocs = mailSteamerDbServ
						.getDocList(paramMap);// 查询该详情页面所涉及的所有doc
				Map<String, String> tempMap = new HashMap<String, String>();
				tempMap.put("dec_master_id", results.get("DEC_MASTER_ID"));
				String type = "0";
				String typeName = "";
				String hlthcheckType = "";
				List<HlthCheckDTO> list = mailSteamerDbServ
						.getHlthcheckList(tempMap);
				if (list != null && list.size() > 0) {
					for (HlthCheckDTO hcl : list) {
						if (hcl != null) {
							if (hcl.getHlth_check_type() != null
									&& !hcl.getHlth_check_type().equals("")) {
								if (hcl.getHlth_check_type().equals("1")) {
									type = hcl.getHlth_check_type();
									typeName = "一般卫生监督表";
									hlthcheckType = hcl.getHlth_check_type();
								} else {
									if (type.equals("1")) {
										type = "3";
										typeName = "一般卫生监督表,专项卫生监督表";
										hlthcheckType += ","
												+ hcl.getHlth_check_type();
										break;
									} else {
										type = hcl.getHlth_check_type();
										typeName = "专项卫生监督表";
										hlthcheckType = hcl
												.getHlth_check_type();
									}
								}
							}
						}
					}
				}
				tempMap.put("name", "监督结果");
				tempMap.put("type", type);
				tempMap.put("hlthcheckType", hlthcheckType);
				tempMap.put("typeName", typeName);
				resultData.put("tempMap", tempMap);
				resultData.put("status", "OK");
				resultData.put("results", results);
				resultData.put("processFiles", processFiles);
				resultData.put("processDocs", processDocs);
			}
		} catch (Exception e) {
			logger_.error(
					"***********/mailSteamer/findProcessInfo************",
					e.getMessage());
		}
		return resultData;
	}

	/**
	 * doc详情
	 * 
	 * @param request
	 * @param id
	 * @param step
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/toDocPage")
	public String toDocPage(
			HttpServletRequest request,
			@RequestParam(value = "proc_main_id", required = true) String proc_main_id,
			@RequestParam(value = "page", required = true) String page,
			@RequestParam(value = "update", required = false) String update,
			@RequestParam(value = "doc_groupid", required = false) String doc_groupid
			) {
		String doc_type = "";// 文档类型
		String top_proc_type = "";// 顶层环节代码
		List<Map<String, String>> CLYJ = mailSteamerDbServ.findClyj();
		request.setAttribute("FY", CLYJ);
		try {
			if (null != page) {
				if (page.startsWith("ms_shenbaowuyichangshixiang")) {// 申报无异常事项
					doc_type = "D_OC_PAGE_1";
					// top_proc_type = "PAGE1";
				} else if (page.startsWith("ms_youwukeyibingli")) {// 有无可以病例
					doc_type = "D_OC_PAGE_2";
					page+='2';
//					top_proc_type = "PAGE2";
				} else if (page.startsWith("ms_rujingchuanbojianyichayanjilubiao")) {// 入境船舶检疫查验记录表
					MailSteamerDTO paramDTO = new MailSteamerDTO();
					paramDTO.setDec_master_id(proc_main_id);
					// 自动提取部分的信息
					request.setAttribute("ms",mailSteamerDbServ.findMailSteamerOne(paramDTO));
					doc_type = "D_OC_REGISTER";
				} else if (page.startsWith("ms_zxwsjd_wenjianqingdan")) {// 专项卫生监督-船舶卫生监督检查记录表-船舶检查文件清单
					doc_type = "D_MS_SP_SC_FI";
				} else if (page.startsWith("ms_chuanboweishengjiandupengfenbiao")) {// 专项卫生监督-邮轮卫生监督专项检查-船舶卫生监督评分表
					MailSteamerDTO paramDTO = new MailSteamerDTO();
					paramDTO.setDec_master_id(proc_main_id);
					// 自动提取部分的信息
					request.setAttribute("ms",mailSteamerDbServ.findMailSteamerOne(paramDTO));
					doc_type = "D_MS_SP_GD";
				} else if (page.startsWith("ms_guidangxiangxiliebiao")) {// 归档
					doc_type = "D_JC_T_Y_5";
				} else if (page.startsWith("ms_hanghaijiankangshengbao")) { // 航海健康申報
					doc_type = "D_JC_T_Y_6";
				} else if (page.startsWith("ms_yuxianzhunbeiqingdan")) { // 船方预先准备清单
					doc_type = "D_JC_T_Y_7";
				} else if (page.startsWith("ms_2yuxianzhunbeiqingdan")) { // 船方预先准备清单
					doc_type = "D_JC_T_Y_8";
				}
			}
			Map<String, String> paramMap = new HashMap<String, String>();
			paramMap.put("doc_type", doc_type);
			paramMap.put("proc_main_id", proc_main_id);
			paramMap.put("doc_groupid", doc_groupid);
			CheckDocsRcdDTO docDTO = mailSteamerDbServ.findDocByTypeNMainId(paramMap);
			if (null == docDTO) {
				docDTO = new CheckDocsRcdDTO();
				docDTO.setDoc_type(doc_type);
				docDTO.setProc_main_id(proc_main_id);
			}
			List<VideoFileEventModel> vList = CommonUtil.queryVideoFileEventByGroupId(
					proc_main_id, null, top_proc_type, doc_groupid, request);
			
			List<VideoFileEventModel> imgs = new ArrayList<VideoFileEventModel>();
			if(StringUtils.isBlank(doc_groupid)){
				for(VideoFileEventModel ve:vList){
					if(StringUtils.isBlank(ve.getName())){
						imgs.add(ve);
					}
				}
				vList = imgs;
			}
			
			CommonUtil.setFileEventToReqByProcType(vList, request);
			
			if (page.startsWith("ms_shenbaowuyichangshixiang")) {// 申报无异常事项
				// TODO 处理多个采样 封存 等
				String str = docDTO.getOption_33();
				JSONArray json = JSONObject.parseArray(str);
				request.setAttribute("caiyang", json);
				str = docDTO.getOption_34();
				json = JSONObject.parseArray(str);
				request.setAttribute("cunfeng", json);
				// TODO 获取消毒信息
				Map<String, String> paramMap1 = new HashMap<String, String>();
				paramMap1.put("proc_type", "PAGE1-V_JC_T_Y_D_45");
				paramMap1.put("proc_main_id", proc_main_id);
				MailSteamerChkDealModel mscdm = mailSteamerDbServ.findMailDeal(paramMap1);
				request.setAttribute("mscdm1", mscdm);
				if(mscdm != null){
					String xdPic = mscdm.getCheck_deal_pic();
					String xdNoticeStr = mscdm.getCheck_deal_notice();
					if(StringUtils.isNotBlank(xdPic)){
						List<Map<String, String>> xdPicList = new ArrayList<Map<String,String>>();	
						for(VideoFileEventModel v:vList){
							String[] xdPicArr = xdPic.split(",");
							for(String xdstr:xdPicArr){
								if(v.getFile_name().contains(xdstr)){
									Map<String, String> res = new HashMap<String, String>();
									res.put("file_name", v.getFile_name());
									res.put("file_type", v.getFile_type());
									xdPicList.add(res);
								}
							}
						}
						request.setAttribute("xdPic", xdPicList);
					}
					if(StringUtils.isNotBlank(xdNoticeStr)){
						List<Map<String, String>> xdNoticeList = new ArrayList<Map<String,String>>();
						for(VideoFileEventModel v:vList){
							String[] xdPicArr = xdNoticeStr.split(",");
							for(String xdstr:xdPicArr){
								if(v.getFile_name().contains(xdstr)){
									Map<String, String> res = new HashMap<String, String>();
									res.put("file_name", v.getFile_name());
									res.put("file_type", v.getFile_type());
									xdNoticeList.add(res);
								}
							}
						}
						request.setAttribute("xdNotice", xdNoticeList);
					}
					
					String xdPicVideo = mscdm.getCheck_deal_video();
					String xdNoticeVideoStr = mscdm.getCheck_deal_notice_video();
					if(StringUtils.isNotBlank(xdPicVideo)){
						List<Map<String, String>> xdPicList = new ArrayList<Map<String,String>>();	
						for(VideoFileEventModel v:vList){
							String[] xdPicArr = xdPicVideo.split(",");
							for(String xdstr:xdPicArr){
								if(v.getFile_name().contains(xdstr)){
									Map<String, String> res = new HashMap<String, String>();
									res.put("file_name", v.getFile_name());
									res.put("file_type", v.getFile_type());
									xdPicList.add(res);
								}
							}
						}
						request.setAttribute("xdPicVideo", xdPicList);
					}
					if(StringUtils.isNotBlank(xdNoticeVideoStr)){
						List<Map<String, String>> xdNoticeList = new ArrayList<Map<String,String>>();
						for(VideoFileEventModel v:vList){
							String[] xdPicArr = xdNoticeVideoStr.split(",");
							for(String xdstr:xdPicArr){
								if(v.getFile_name().contains(xdstr)){
									Map<String, String> res = new HashMap<String, String>();
									res.put("file_name", v.getFile_name());
									res.put("file_type", v.getFile_type());
									xdNoticeList.add(res);
								}
							}
						}
						request.setAttribute("xdNoticeVideo", xdNoticeList);
					}
				}
			}
			if (page.startsWith("ms_hanghaijiankangshengbao")) {// 航海健康申报书
				// TODO 突发公共卫生事件
				Map<String, String> paramMap1 = new HashMap<String, String>();
				paramMap1.put("doc_type", "D_JC_T_Y_3");
				paramMap1.put("proc_main_id", proc_main_id);
//				CheckDocsRcdDTO docDTO1 = mailSteamerDbServ.findDocByTypeNMainId(paramMap1);
//				request.setAttribute("D_JC_T_Y_3", docDTO1);
				// TODO 3.消毒
				paramMap1.put("proc_type", "V_JC_T_Y_D_42");
				MailSteamerChkDealModel mscdm = mailSteamerDbServ.findMailDeal(paramMap1);
				request.setAttribute("mscdm1", mscdm);
				if(mscdm != null){
					String xdPic = mscdm.getCheck_deal_pic();
					String xdNoticeStr = mscdm.getCheck_deal_notice();
					if(StringUtils.isNotBlank(xdPic)){
						String res = "";
						for(VideoFileEventModel v:vList){
							String[] xdPicArr = xdPic.split(",");
							for(String str:xdPicArr){
								if(v.getFile_name().contains(str)){
									res += v.getFile_name() + ",";
								}
							}
						}
						request.setAttribute("xdPic", StringUtils.isNotBlank(res)?res.split(","):null);
					}
					if(StringUtils.isNotBlank(xdNoticeStr)){
						String res = "";
						for(VideoFileEventModel v:vList){
							String[] xdPicArr = xdNoticeStr.split(",");
							for(String str:xdPicArr){
								if(v.getFile_name().contains(str)){
									res += v.getFile_name() + ",";
								}
							}
						}
						request.setAttribute("xdNotice", StringUtils.isNotBlank(res)?res.split(","):null);
					}
					
					String xdPicVideo = mscdm.getCheck_deal_video();
					String xdNoticeVideoStr = mscdm.getCheck_deal_notice_video();
					if(StringUtils.isNotBlank(xdPicVideo)){
						String res = "";
						for(VideoFileEventModel v:vList){
							String[] xdPicArr = xdPicVideo.split(",");
							for(String str:xdPicArr){
								if(v.getFile_name().contains(str)){
									res += v.getFile_name() + ",";
								}
							}
						}
						request.setAttribute("xdPicVideo", StringUtils.isNotBlank(res)?res.split(","):null);
					}
					if(StringUtils.isNotBlank(xdNoticeVideoStr)){
						String res = "";
						for(VideoFileEventModel v:vList){
							String[] xdPicArr = xdNoticeVideoStr.split(",");
							for(String str:xdPicArr){
								if(v.getFile_name().contains(str)){
									res += v.getFile_name() + ",";
								}
							}
						}
						request.setAttribute("xdNoticeVideo", StringUtils.isNotBlank(res)?res.split(","):null);
					}
				}
				// TODO 检疫处理
				paramMap1.put("proc_type", "V_JC_T_Y_D_44");
				mscdm = mailSteamerDbServ.findMailDeal(paramMap1);
				request.setAttribute("mscdm2", mscdm);
				// TODO 翻译
				request.setAttribute("jyclfy", mailSteamerDbServ.findClyj());
				if(mscdm != null){
					String jyPicStr = mscdm.getCheck_deal_pic();
					String jyNoticeStr = mscdm.getCheck_deal_notice();
					if(StringUtils.isNotBlank(jyPicStr)){
						String res = "";
						for(VideoFileEventModel v:vList){
							String[] xdPicArr = jyPicStr.split(",");
							for(String str:xdPicArr){
								if(v.getFile_name().contains(str)){
									res += v.getFile_name() + ",";
								}
							}
						}
						request.setAttribute("jyPic", StringUtils.isNotBlank(res)?res.split(","):null);
					}
					if(StringUtils.isNotBlank(jyNoticeStr)){
						String res = "";
						for(VideoFileEventModel v:vList){
							String[] xdPicArr = jyNoticeStr.split(",");
							for(String str:xdPicArr){
								if(v.getFile_name().contains(str)){
									res += v.getFile_name() + ",";
								}
							}
						}
						request.setAttribute("jyNotice", StringUtils.isNotBlank(res)?res.split(","):null);
					}
					
					String jyPicVideoStr = mscdm.getCheck_deal_video();
					String jyNoticeVideoStr = mscdm.getCheck_deal_notice_video();
					if(StringUtils.isNotBlank(jyPicVideoStr)){
						String res = "";
						for(VideoFileEventModel v:vList){
							String[] xdPicArr = jyPicVideoStr.split(",");
							for(String str:xdPicArr){
								if(v.getFile_name().contains(str)){
									res += v.getFile_name() + ",";
								}
							}
						}
						request.setAttribute("jyPicVideo", StringUtils.isNotBlank(res)?res.split(","):null);
					}
					if(StringUtils.isNotBlank(jyNoticeVideoStr)){
						String res = "";
						for(VideoFileEventModel v:vList){
							String[] xdPicArr = jyNoticeVideoStr.split(",");
							for(String str:xdPicArr){
								if(v.getFile_name().contains(str)){
									res += v.getFile_name() + ",";
								}
							}
						}
						request.setAttribute("jyNoticeVideo", StringUtils.isNotBlank(res)?res.split(","):null);
					}
				}
			}
			
			if(page.startsWith("ms_youwukeyibingli2")){ //有无可疑病例
				vList = CommonUtil.queryVideoFileEventByGroupId(
						proc_main_id, null, top_proc_type, null, request);
				Map<String, String> paramMap1 = new HashMap<String, String>();
				String proc_type_str = "PAGE2-V_D_OC_PAGE_2_4";
				if(StringUtils.isNotBlank(doc_groupid)){
					proc_type_str= "PAGE2-V_D_OC_PAGE_2_4" + "-" + doc_groupid;
				}
				paramMap1.put("proc_type", proc_type_str);
				paramMap1.put("proc_main_id", proc_main_id);
				// TODO 检疫处理
				MailSteamerChkDealModel mscdm = mailSteamerDbServ.findMailDeal(paramMap1);
				request.setAttribute("mscdm2", mscdm);
				if(mscdm != null){
					String jyPicStr = mscdm.getCheck_deal_pic();
					String jyNoticeStr = mscdm.getCheck_deal_notice();
					if(StringUtils.isNotBlank(jyPicStr)){
						String res = "";
						for(VideoFileEventModel v:vList){
							String[] xdPicArr = jyPicStr.split(",");
							for(String str:xdPicArr){
								if(v.getFile_name().contains(str)){
									res += v.getFile_name() + ",";
								}
							}
						}
						request.setAttribute("jyPic", StringUtils.isNotBlank(res)?res.split(","):null);
					}
					if(StringUtils.isNotBlank(jyNoticeStr)){
						String res = "";
						for(VideoFileEventModel v:vList){
							String[] xdPicArr = jyNoticeStr.split(",");
							for(String str:xdPicArr){
								if(v.getFile_name().contains(str)){
									res += v.getFile_name() + ",";
								}
							}
						}
						request.setAttribute("jyNotice", StringUtils.isNotBlank(res)?res.split(","):null);
					}
					
					String jyPicVideoStr = mscdm.getCheck_deal_video();
					if(StringUtils.isNotBlank(jyPicVideoStr)){
						String res = "";
						for(VideoFileEventModel v:vList){
							String[] xdPicArr = jyPicVideoStr.split(",");
							for(String str:xdPicArr){
								if(v.getFile_name().contains(str)){
									res += v.getFile_name() + ",";
								}
							}
						}
						request.setAttribute("jyPicVideo", StringUtils.isNotBlank(res)?res.split(","):null);
					}
					String jyNoticeVideoStr = mscdm.getCheck_deal_notice_video();
					if(StringUtils.isNotBlank(jyNoticeVideoStr)){
						String res = "";
						for(VideoFileEventModel v:vList){
							String[] xdPicArr = jyNoticeVideoStr.split(",");
							for(String str:xdPicArr){
								if(v.getFile_name().contains(str)){
									res += v.getFile_name() + ",";
								}
							}
						}
						request.setAttribute("jyNoticeVideo", StringUtils.isNotBlank(res)?res.split(","):null);
					}
				}
				
				// 流行病学调查（表）结果
				Map<String, String> paramMap2 = new HashMap<String, String>();
				paramMap2.put("doc_type", "D_JC_T_Y_2");
				paramMap2.put("proc_main_id", proc_main_id);
				paramMap2.put("doc_groupid", doc_groupid);
				CheckDocsRcdDTO docDTO2 = mailSteamerDbServ.findDocByTypeNMainId(paramMap2);
				System.out.println(docDTO2);
				request.setAttribute("D_JC_T_Y_2", docDTO2);
			}
			
			if(page.startsWith("ms_yuxianzhunbeiqingdan")){ // 船方预先准备清单自定义部分
				
				String option141 = docDTO.getOption_141();//{}
				String option142 = docDTO.getOption_142();
				String option143 = docDTO.getOption_143();
				List<Map<String, String>> cfResult = new ArrayList<Map<String,String>>();
				if(StringUtils.isNotBlank(option141)){
					String[] optionArr1 = option141.split(",");
					List<Map<String, String>> optionList2 = (List<Map<String, String>>) JSONObject.parse(option142);
					List<Map<String, String>> optionList3 = (List<Map<String, String>>) JSONObject.parse(option143);
					for(int i=0; i<optionArr1.length;i++){
						Map<String, String> map = new HashMap<String, String>();
						map.put("name", optionList3.get(i).get("name"));
						map.put("code", optionList2.get(i).get("code"));
						map.put("status", optionArr1[i]);
						cfResult.add(map);
					}
				}
				request.setAttribute("cfResult", cfResult);
			}
			
			if(page.startsWith("ms_guidangxiangxiliebiao")){ // 归档
				// TODO 登轮前注意事项
				List<VideoFileEventModel> haha = CommonUtil.queryVideoFileEvent(proc_main_id,
						"V_JC_T_Y_D_9", null, request);
				List<VideoFileEventModel> re = new ArrayList<VideoFileEventModel>();
				if(haha != null){
					for(int i=haha.size()-1;i>=0;i--){
						re.add(haha.get(i));
					}
				}
				request.setAttribute("dlFile",re);
				
				// 采样列表
				List<Map<String, String>> sampRes = mailSteamerDbServ.findSampById(proc_main_id);
				request.setAttribute("sampRes",sampRes);
			}
			
			if (page.startsWith("ms_2yuxianzhunbeiqingdan")) { // 船方预先准备清单2
				String option71 = docDTO.getOption_71();
				if(StringUtils.isNotBlank(option71)){
					request.setAttribute("shoudong", option71.split(","));
				}
			}
			
			if (page.startsWith("ms_pandingjieguo")){ // 结果判定
				// 结果判定
				List<Map<String, String>> res = mailSteamerDbServ.getLastResult(proc_main_id);
				if(res.size()>0){
					request.setAttribute("resultCheck", res.get(0));
				}
			}
			
			request.setAttribute("doc", docDTO);
			request.setAttribute("page", page);
		} catch (Exception e) {
			logger_.error("***********/mailSteamer/toDocPage************", e);
		}
		return "template/" + page + ("update".equals(update) ? "_input" : "");
	}

	// 归档接口
	@RequestMapping(value = "/docs", method = RequestMethod.POST)
	public String docs(HttpServletRequest request,CheckDocsRcdModel checkDocsRcdModel) {
		checkDocsRcdModel.setDocType("D_JC_T_Y_5");
		checkDocsRcdModel.setDecUser(getUser(request).getName());
		checkDocsRcdModel.setDecDate(new Date());
		if (null != checkDocsRcdModel) {
			commonServer.deleteDocsByDocTypeNProcMainId(checkDocsRcdModel);
		}
		try {
			commonServer.insertDocs(checkDocsRcdModel);
		} catch (Exception e) {
			logger_.error("***********/mailSteamer/docs************", e);
		}
		return "redirect:toDocPage?proc_main_id="+checkDocsRcdModel.getProcMainId()+"&page=ms_guidangxiangxiliebiao";
	}
	
	// 跳转到采样
	@RequestMapping("/toCaiYang")
	public String toCaiYang(
			HttpServletRequest request,
			@RequestParam(value = "proc_main_id", required = true) String proc_main_id,
			@RequestParam(value = "doc_type", required = true) String doc_type) {
		// 查询采样信息
		List<MailSteamerSampDTO> sampDtos = mailSteamerDbServ.findSamp(
				proc_main_id, doc_type);
		request.setAttribute("sampDtos", sampDtos.size()>0?sampDtos.get(0):null);
		// 查询所有图片
		List<VideoFileEventModel> vList = null;
		try {
			vList = CommonUtil.queryVideoFileEvent(proc_main_id, null, null,
					request);
		} catch (IOException e) {
			e.printStackTrace();
		}
		CommonUtil.setFileEventToReqByProcType(vList, request);
		// 拿出所有图片变成集合去比对
		this.fromatImg(request,vList,sampDtos);

		return "template/ms_caiyang";
	}
	
	private void fromatImg(HttpServletRequest request,List<VideoFileEventModel> vList,List<MailSteamerSampDTO> sampDtos){
		String sampFileStr = sampDtos.size()>0?sampDtos.get(0).getSamp_file():"";
		if (StringUtils.isNotBlank(sampFileStr)) {
			String[] sampFileList = sampFileStr.split(",");
			String samp = "";
			for (VideoFileEventModel m : vList) {
				for (String str : sampFileList) {
					if (m.getFile_name().contains(str)) {
						samp += m.getFile_name() + ',';
					}
				}
			}
			request.setAttribute("sampFileList", samp.split(","));
		}

		String sampVideoStr = sampDtos.size()>0?sampDtos.get(0).getSamp_video():"";
		if (StringUtils.isNotBlank(sampVideoStr)) {
			String[] sampVideoList = sampVideoStr.split(",");
			String samp = "";
			for (VideoFileEventModel m : vList) {
				for (String str : sampVideoList) {
					if (m.getFile_name().contains(str)) {
						samp += m.getFile_name() + ',';
					}
				}
			}
			request.setAttribute("sampVideoList", samp.split(","));
		}

		String sampNoticeStr = sampDtos.size()>0?sampDtos.get(0).getSamp_notice():"";
		if (StringUtils.isNotBlank(sampNoticeStr)) {
			String[] sampNoticeList = sampNoticeStr.split(",");
			String samp = "";
			for (VideoFileEventModel m : vList) {
				for (String str : sampNoticeList) {
					if (m.getFile_name().contains(str)) {
						samp += m.getFile_name() + ',';
					}
				}
			}
			request.setAttribute("sampNoticeList", samp.split(","));
		}

		String sampNoticeVideoStr = sampDtos.size()>0?sampDtos.get(0).getSamp_notice_video():"";
		if (StringUtils.isNotBlank(sampNoticeVideoStr)) {
			String[] sampNoticeVideoList = sampNoticeVideoStr.split(",");
			String samp = "";
			for (VideoFileEventModel m : vList) {
				for (String str : sampNoticeVideoList) {
					if (m.getFile_name().contains(str)) {
						samp += m.getFile_name() + ',';
					}
				}
			}
			request.setAttribute("sampNoticeVideoList", samp.split(","));
		}

		String resultPaperStr = sampDtos.size()>0?sampDtos.get(0).getResult_cmd_paper():"";
		if (StringUtils.isNotBlank(resultPaperStr)) {
			String[] resultPaperList = resultPaperStr.split(",");
			String samp = "";
			for (VideoFileEventModel m : vList) {
				for (String str : resultPaperList) {
					if (m.getFile_name().contains(str)) {
						samp += m.getFile_name() + ',';
					}
				}
			}
			request.setAttribute("resultPaperList", samp.split(","));
		}

		String resultPaperVideoStr = sampDtos.size()>0?sampDtos.get(0).getResult_cmd_paper_video():"";
		if (StringUtils.isNotBlank(resultPaperVideoStr)) {
			String[] resultPaperVideoList = resultPaperVideoStr.split(",");
			String samp = "";
			for (VideoFileEventModel m : vList) {
				for (String str : resultPaperVideoList) {
					if (m.getFile_name().contains(str)) {
						samp += m.getFile_name() + ',';
					}
				}
			}
			request.setAttribute("resultPaperVideoList", samp.split(","));
		}
	}

	/*********************************************************************************************************************
	 * 进出境运输工具检疫（邮轮）
	 * 
	 * @param request
	 * @return
	 *********************************************************************************************************************/
	@RequestMapping("/processtemplate")
	public String processtemplate(HttpServletRequest request, String doc_id,
			String doc_type) {
		Map<String, String> results = null;
		try {
			if (null == doc_id || "".equals(doc_id)) {
				return "/error";
			} else {
				results = mailSteamerDbServ.processtemplate(doc_id);
			}

			request.setAttribute("results", results);
			String docType = results.get("DOC_TYPE");
			if ("D_JC_T_Y_1".equals(docType)) {
				return "template/zfjlysydjtz";// 执法记录仪使用登记台账
			} else if ("D_JC_T_Y_2".equals(docType)) {
				return "template/rujingchuanbojianyichayanjilubiao";// 入境船舶检疫查验记录表
			} else if ("D_JC_T_Y_3".equals(docType)) {
				return "template/chuanboweishengjiandudengjibiao";// 船舶卫生监督登记表
			} else if ("V_JC_T_Y_D_1".equals(docType)) {
				return "template/chuanboweishengjiandupengfenbiao";// 船舶卫生监督评分表
			} else if ("D_JC_T_Y_5".equals(docType)) {
				return "template/guidangxiangxiliebiao";// 归档详细列表
			} else if ("D_JC_T_Y_6".equals(docType)) {
				// return "template/chuanboweishengjiandujianchajilubiao2";
				return "template/ms_youwukeyibingli";// 有无可疑病例
			} else if ("D_JC_T_Y_7".equals(docType)) {
				// "PAGE1":【申报无异常事项】（页面1）顶层环节类型
				List<VideoFileEventModel> vList = CommonUtil
						.queryVideoFileEvent(results.get("PROC_MAIN_ID"), null,
								"PAGE1", request);
				CommonUtil.setFileEventToReqByProcType(vList, request);
				return "template/ms_shenbaowuyichangshixiang";// 申报无异常事项
			}/*
			 * else if("D_JC_T_Y_8".equals(docType)){ //两种 return
			 * "template/chuanboweishengjiandujianchajilubiao";//船舶卫生监督检查记录表 }
			 */else if ("D_JC_T_Y_9".equals(docType)) {
				return "template/caiyangjilu";// 采样记录
			} else if ("D_JC_T_Y10".equals(docType)) {
				// return "template/zhengjubaogaobiao";//证据报告表
				return "template/pandijieguo"; // 判定结果
			}
		} catch (Exception e) {
			logger_.error(
					"***********/mailSteamer/processtemplate************", e);
		}
		return "/error";
	}

	/*********************************************************************************************************************
	 * 进出境运输工具检疫（邮轮）邮轮业务卫生监督表查询
	 * 
	 * @param request
	 *            QLC_MAIL_STEAMER_HLTH_CHECK
	 * @return
	 *********************************************************************************************************************/
	@RequestMapping("/showhlthchecklist")
	public String showhlthchecklist(HttpServletRequest request,
			HlthcheckForm hlthForm) {
		Map<String, String> map = new HashMap<String, String>();
		try {
			// 分页处理
			if (map.size() == 0) {
				map.put("page", "1");
			}
			int pages = Integer.parseInt(map.get("page"));
			if (hlthForm.getPage() != null && !hlthForm.getPage().equals("")) {
				pages = Integer.parseInt(hlthForm.getPage());
			}
			// 查询条件
			map.put("dec_master_id", hlthForm.getDec_master_id());
			map.put("hlth_check_type", hlthForm.getHlth_check_type());
			map.put("table_type", hlthForm.getTable_type());
			map.put("hun_name", hlthForm.getHun_name());
			int counts = mailSteamerDbServ.findHlthcheckCount(map);
			map.put("firstRcd",
					String.valueOf((pages - 1) * Constants.PAGE_NUM + 1)); // 数据定位
			map.put("lastRcd", String.valueOf(pages * Constants.PAGE_NUM + 1));
			List<HlthCheckDTO> list = mailSteamerDbServ.findHlthchecklist(map);
			List<CodeLibraryDTO> tableTypeList = CommonUtil.queryCodeLibrary(
					"QLC_MAIL_STEAMER_HLTH_TABLE_TYPE", request);
			request.setAttribute("tableTypeList", tableTypeList);
			List<CodeLibraryDTO> checkTypeList = CommonUtil.queryCodeLibrary(
					"QLC_MAIL_STEAMER_HLTH_CHECK_TYPE", request);
			request.setAttribute("checkTypeList", checkTypeList);
			request.setAttribute("list", list);
			request.setAttribute("map", map);// 查询条件
			request.setAttribute("itemInPage", Constants.PAGE_NUM);// 每页几条数据
			request.setAttribute("pages", pages);
			request.setAttribute(
					"allPage",
					counts % Constants.PAGE_NUM == 0 ? (counts / Constants.PAGE_NUM)
							: (counts / Constants.PAGE_NUM) + 1);// 总共多少页
			request.setAttribute("counts", counts);// 总共多少条数据
		} catch (Exception e) {
			logger_.error(
					"***********/mailSteamer/showhlthchecklist************", e);
		} finally {
			map = null;
		}
		return "mailSteamer/enforcement/hlthchecklist";
	}

	/*********************************************************************************************************************
	 * 进出境运输工具检疫（邮轮）卫生监督表详情
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 *********************************************************************************************************************/
	@RequestMapping("/hlthcheckdetail")
	public String Hlthcheckdetail(HttpServletRequest request,
			String dec_master_id, String hun_name, String hlth_check_type,
			String tableType) throws Exception {
		List<HlthCheckDTO> result = null;
		try {
			if (null == dec_master_id || "".equals(dec_master_id)) {
				return "/error";
			} else {
				Map<String, String> tempMap = new HashMap<String, String>();
				tempMap.put("dec_master_id", dec_master_id);
				tempMap.put("tableType", tableType);
				tempMap.put("hlth_check_type", hlth_check_type);
				result = mailSteamerDbServ.getHlthcheckdetail(tempMap);
				request.setAttribute("result", result);
			}

			request.setAttribute("hun_name", hun_name);

			if (hlth_check_type.equals("1")) {// 一般卫生监督
				if (result != null && result.size() > 0) {
					for (HlthCheckDTO dto : result) {
						request.setAttribute(
								"check_result".concat(dto.getCheck_impo()),
								dto.getCheck_result());
						request.setAttribute(
								"dec".concat(dto.getCheck_impo()),
								dto.getViwe_discription());
						// 获取检疫处理数据
						if(StringUtils.isNotBlank(dto.getCheck_deal())){
							List<Map<String, String>> jys = mailSteamerDbServ.findChekDetail(dec_master_id, dto.getCheck_deal());
							if(jys.size()>0){
								request.setAttribute(
										"jy_result".concat(dto.getCheck_impo()),jys.get(0));
							}
						}
					}
				}
				if (StringUtils.isNotEmpty(tableType)) {

					List<VideoFileEventModel> vList = CommonUtil
							.queryVideoFileEvent(dec_master_id, null, null,
									request);
					request.setAttribute("vList", vList);
					CommonUtil.setFileEventToReqByProcType(vList, request);

					if (tableType.equals("1")) {
						return "template/ms_chuanboweishengjiandujianchajilusuchangbiao";
					} else if (tableType.equals("2")) {
						return "template/ms_chuanboweishengjiandujianchajiluchufangbiao";
					} else if (tableType.equals("3")) {
						return "template/ms_chuanboweishengjiandujianchajilucangkubiao";
					} else if (tableType.equals("4")) {
						return "template/ms_chuanboweishengjiandujianchajiluyiliaobiao";
					} else if (tableType.equals("5")) {
						return "template/ms_chuanboweishengjiandujianchajilulajizhanbiao";
					} else if (tableType.equals("6")) {
						return "template/ms_chuanboweishengjiandujianchajilulunjicangbiao";
					} else {
						return "error";
					}
				}
			} else if (hlth_check_type.equals("2")) {// 专项卫生监督
				if (result != null && result.size() > 0) {
					for (HlthCheckDTO dto : result) {
						request.setAttribute(
								"check_result".concat(dto.getCheck_impo()),
								dto.getCheck_result());
						request.setAttribute(
								"dec".concat(dto.getCheck_impo()),
								dto.getViwe_discription());
						// 获取检疫处理数据
						if(StringUtils.isNotBlank(dto.getCheck_deal())){
							List<Map<String, String>> jys = mailSteamerDbServ.findChekDetail(dec_master_id, dto.getCheck_deal());
							if(jys.size()>0){
								request.setAttribute(
										"jy_result".concat(dto.getCheck_impo()),jys.get(0));
							}
						}
					}
				}
				if (StringUtils.isNotEmpty(tableType)) {
					List<VideoFileEventModel> vList = CommonUtil
							.queryVideoFileEvent(dec_master_id, null, null,
									request);
					CommonUtil.setFileEventToReqByProcType(vList, request);
					if (tableType.equals("1")) {
						return "template/ms_zxwsjd_sucang";
					} else if (tableType.equals("2")) {
						return "template/ms_zxwsjd_chufang";
					} else if (tableType.equals("3")) {
						return "template/ms_zxwsjd_cangku";
					} else if (tableType.equals("4")) {
						return "template/ms_zxwsjd_yiliao";
					} else if (tableType.equals("5")) {
						return "template/ms_zxwsjd_lajizhan";
					} else if (tableType.equals("6")) {
						return "template/ms_zxwsjd_lunjicang";
					} else if (tableType.equals("7")) {
						return "template/ms_zxwsjd_xiyifang";
					} else {
						return "error";
					}
				}
			}
		} catch (Exception e) {
			logger_.error(
					"***********/mailSteamer/hlthcheckdetail************", e);
		}
		return "error";
	}

	@RequestMapping("/showhlthcheckdetail_jsp")
	public String showHlthcheckdetail_jsp(String dec_master_id,
			String hlth_check_type, String tableType) {
		if (StringUtils.isNotEmpty(hlth_check_type)) {
			if (hlth_check_type.equals("1")) {
				if (StringUtils.isNotEmpty(tableType)) {
					if (tableType.equals("1")) {
						return "template/chuanboweishengjiandujianchajilusuchangbiao1";
					} else if (tableType.equals("2")) {
						return "template/chuanboweishengjiandujianchajiluchufangbiao";
					} else if (tableType.equals("3")) {
						return "template/chuanboweishengjiandujianchajilucangkubiao";
					} else if (tableType.equals("4")) {
						return "template/chuanboweishengjiandujianchajiluyiliaobiao";
					} else if (tableType.equals("5")) {
						return "template/chuanboweishengjiandujianchajilulajizhanbiao";
					} else if (tableType.equals("6")) {
						return "template/chuanboweishengjiandujianchajilulunjicangbiao";
					} else {
						return "error";
					}
				}
			} else {
				if (StringUtils.isNotEmpty(tableType)) {
					if (tableType.equals("1")) {
						return "template/chuanboweishengjiandujianchajilubiao2";
					} else if (tableType.equals("2")) {
						return "template/";
					} else if (tableType.equals("3")) {
						return "template/";
					} else if (tableType.equals("4")) {
						return "template/";
					} else if (tableType.equals("5")) {
						return "template/";
					} else if (tableType.equals("6")) {
						return "template/";
					} else if (tableType.equals("7")) {
						return "template/chuanboweishengjiandujianchajilubiao2";
					} else {
						return "error";
					}
				}
			}
		}
		return "error";
	}

	@SuppressWarnings("rawtypes")
	@ResponseBody
	@RequestMapping("/findHlthcheckdetail")
	public Map<String, Object> findHlthcheckdetail(String dec_master_id,
			String hlth_check_type, String tableType) {
		Map<String, Object> resultData = new HashMap<String, Object>();
		try {
			if (null == dec_master_id || "".equals(dec_master_id)) {
				resultData.put("status", "FAIL");
				resultData.put("results", "输入数据不能为空");
			} else {
				Map<String, String> tempMap = new HashMap<String, String>();
				tempMap.put("dec_master_id", dec_master_id);
				tempMap.put("tableType", tableType);
				List<String> hunNameList = new ArrayList<String>();
				List<Map<String, String>> results = mailSteamerDbServ
						.findHlthcheckdetail(tempMap);
				resultData.put("status", "OK");
				for (Map map : results) {
					if (map != null) {
						if (StringUtils.isNotEmpty(map.get("HUN_NAME")
								.toString())) {
							if (!hunNameList.contains(map.get("HUN_NAME")
									.toString())) {
								hunNameList.add(map.get("HUN_NAME").toString());
							}
						}
					}
				}
				Map<String, String> paramMap = new HashMap<String, String>();
				paramMap.put("dec_master_id", dec_master_id);
				List<Map<String, String>> processFiles = mailSteamerDbServ
						.getfileList(paramMap); // 查询该详情页面所涉及的所有照片和视频
				resultData.put("hunNameList", hunNameList);
				resultData.put("processFiles", processFiles);
				resultData.put("results", results);
			}
		} catch (Exception e) {
			logger_.error(
					"***********/mailSteamer/findHlthcheckdetail************",
					e);
		}
		return resultData;
	}

	// 附件下载方法
	@RequestMapping(value = "/download", method = RequestMethod.GET)
	public void download(HttpServletRequest request,
			HttpServletResponse response, String fileName) {
		try {
			FileUtil.downloadFile(fileName, response, true);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 调转至检疫申报提交页面
	 */
	@RequestMapping("/editDeclaration")
	public String editDeclaration(HttpServletRequest request, String decMasterId) {
		try {
			MailSteamerRmkDTO dto = mailSteamerDbServ
					.findMailSteamerRmkByDecMasterId(decMasterId);
			if (dto == null) {
				dto = new MailSteamerRmkDTO();
				dto.setDec_master_id(decMasterId);
			}
			request.setAttribute("model", dto);

			List<CodeLibraryDTO> levels = CommonUtil.queryCodeLibrary(
					"QLC_MAIL_STEAMER_CENT_WAR_LEVEL", request);
			request.setAttribute("levels", levels);

			List<CodeLibraryDTO> inspTypes = CommonUtil.queryCodeLibrary(
					"QLC_MAIL_STEAMER_CHK_NOTIFY", request);
			request.setAttribute("inspTypes", inspTypes);
		} catch (Exception e) {
			logger_.error(
					"***********/mailSteamer/editDeclaration************", e);
		}
		return "mailSteamer/declaration/updatedeclaration";
	}

	/**
	 * 保存检疫申报信息至业务表（新增/修改）
	 */
	@RequestMapping(value = "/saveDeclaration", method = RequestMethod.POST)
	public String saveDeclaration(HttpServletRequest request,
			MailSteamerRmkDTO dto) {
		try {
			if (null == dto.getId() || "".equals(dto.getId())) {
				dto.setDecl_insp_date(new GregorianCalendar().getTime());
				dto.setDecl_insp_psn(getUser(request).getName());
				mailSteamerDbServ.insertMailSteamerRmk(dto);
			} else {
				mailSteamerDbServ.updateMailSteamerRmkById(dto);
			}
		} catch (Exception e) {
			logger_.error(
					"***********/mailSteamer/saveDeclaration************", e);
		}
		return "redirect:showdeclarationlist";
	}

	/*********************************************************************************************************************
	 * 进出境运输工具检疫（邮轮）采样
	 * 
	 * @param request
	 *            QLC_MAIL_STEAMER_SAMP
	 * @return
	 *********************************************************************************************************************/
	@RequestMapping("/showSampList")
	public String showSampList(HttpServletRequest request,
			MailSteamerSampForm form) {
		Map<String, String> map = new HashMap<String, String>();
		try {
			// 分页处理
			if (map.size() == 0) {
				map.put("page", "1");
			}
			int pages = Integer.parseInt(map.get("page"));
			if (form.getPage() != null && !form.getPage().equals("")) {
				pages = Integer.parseInt(form.getPage());
			}
			// 查询条件
			map.put("dec_master_id", form.getDec_master_id());
			int counts = mailSteamerDbServ.findSampCount(map);
			map.put("firstRcd",
					String.valueOf((pages - 1) * Constants.PAGE_NUM + 1)); // 数据定位
			map.put("lastRcd", String.valueOf(pages * Constants.PAGE_NUM + 1));
			List<MailSteamerSampDTO> list = mailSteamerDbServ.findSampList(map);
			// 处理图片问题
			List<VideoFileEventModel> vlist = CommonUtil.queryVideoFileEvent(form.getDec_master_id(),null, null, request);
			
			List<MailSteamerSampDTO> result = new ArrayList<MailSteamerSampDTO>();
			for(MailSteamerSampDTO md:list){
				String[] noticeArr = StringUtils.isNotBlank(md.getSamp_notice())?md.getSamp_notice().split(","):null;
				String noticeStr = "";
				if(noticeArr != null){
					for(String str:noticeArr){
						for(VideoFileEventModel vm:vlist){
							if(vm.getFile_name().contains(str)){
								noticeStr += vm.getFile_name() + ",";
								break;
							}
						}
						
					}
				}
				
				String[] picArr = StringUtils.isNotBlank(md.getSamp_file())?md.getSamp_file().split(","):null;
				String picStr = "";
				if(picArr != null){
					for(String str:picArr){
						for(VideoFileEventModel vm:vlist){
							if(vm.getFile_name().contains(str)){
								picStr += vm.getFile_name() + ",";
								break;
							}
						}
						
					}
				}
				
				String[] cmdPaperArr = StringUtils.isNotBlank(md.getResult_cmd_paper())?md.getResult_cmd_paper().split(","):null;
				String cmdPaperStr = "";
				if(cmdPaperArr != null){
					for(String str:cmdPaperArr){
						for(VideoFileEventModel vm:vlist){
							if(vm.getFile_name().contains(str)){
								cmdPaperStr += vm.getFile_name() + ",";
								break;
							}
						}
						
					}
				}
				
				md.setResult_cmd_paper(cmdPaperStr);
				md.setSamp_file(picStr);
				md.setSamp_notice(noticeStr);
				
				//_------------------------------视频处理
				
				String[] noticeVideoArr = StringUtils.isNotBlank(md.getSamp_notice_video())?md.getSamp_notice_video().split(","):null;
				String noticeVideoStr = "";
				if(noticeVideoArr != null){
					for(String str:noticeVideoArr){
						for(VideoFileEventModel vm:vlist){
							if(vm.getFile_name().contains(str)){
								noticeVideoStr += vm.getFile_name() + ",";
								break;
							}
						}
						
					}
				}
				
				String[] picVideoArr = StringUtils.isNotBlank(md.getSamp_video())?md.getSamp_video().split(","):null;
				String picVideoStr = "";
				if(picVideoArr != null){
					for(String str:picVideoArr){
						for(VideoFileEventModel vm:vlist){
							if(vm.getFile_name().contains(str)){
								picVideoStr += vm.getFile_name() + ",";
								break;
							}
						}
						
					}
				}
				
				String[] cmdPaperVideoArr = StringUtils.isNotBlank(md.getResult_cmd_paper_video())?md.getResult_cmd_paper_video().split(","):null;
				String cmdPaperVideoStr = "";
				if(cmdPaperVideoArr != null){
					for(String str:cmdPaperVideoArr){
						for(VideoFileEventModel vm:vlist){
							if(vm.getFile_name().contains(str)){
								cmdPaperVideoStr += vm.getFile_name() + ",";
								break;
							}
						}
						
					}
				}
				
				md.setResult_cmd_paper_video(cmdPaperVideoStr);
				md.setSamp_video(picVideoStr);
				md.setSamp_notice_video(noticeVideoStr);
				
				
				result.add(md);
			}
			
			request.setAttribute("list", result);
			request.setAttribute("map", map);// 查询条件
			request.setAttribute("itemInPage", Constants.PAGE_NUM);// 每页几条数据
			request.setAttribute("pages", pages);
			request.setAttribute(
					"allPage",
					counts % Constants.PAGE_NUM == 0 ? (counts / Constants.PAGE_NUM)
							: (counts / Constants.PAGE_NUM) + 1);// 总共多少页
			request.setAttribute("counts", counts);// 总共多少条数据
		} catch (Exception e) {
			logger_.error("***********/mailSteamer/showSampleList************",
					e);
		} finally {
			map = null;
		}
		return "mailSteamer/enforcement/sampList";
	}

	/*********************************************************************************************************************
	 * 进出境运输工具检疫（邮轮）邮轮业务卫生监督表查询
	 * 
	 * @param request
	 *            QLC_MAIL_STEAMER_HLTH_CHECK
	 * @return
	 *********************************************************************************************************************/
	@RequestMapping("/showChkDealList")
	public String showChkDealList(HttpServletRequest request,
			HlthcheckForm hlthForm) {
		Map<String, String> map = new HashMap<String, String>();
		try {
			// 分页处理
			if (map.size() == 0) {
				map.put("page", "1");
			}
			int pages = Integer.parseInt(map.get("page"));
			if (hlthForm.getPage() != null && !hlthForm.getPage().equals("")) {
				pages = Integer.parseInt(hlthForm.getPage());
			}
			// 查询条件
			map.put("dec_master_id", hlthForm.getDec_master_id());
			int counts = mailSteamerDbServ.findChkDealCount(map);
			map.put("firstRcd",
					String.valueOf((pages - 1) * Constants.PAGE_NUM + 1)); // 数据定位
			map.put("lastRcd", String.valueOf(pages * Constants.PAGE_NUM + 1));
			List<MailSteamerChkDealDTO> list = mailSteamerDbServ
					.findChkDealList(map);
			List<VideoFileEventModel> vlist = CommonUtil.queryVideoFileEvent(hlthForm.getDec_master_id(),null, null, request);
			
			List<MailSteamerChkDealDTO> result = new ArrayList<MailSteamerChkDealDTO>();
			for(MailSteamerChkDealDTO md:list){
				String[] noticeArr = StringUtils.isNotBlank(md.getCheck_deal_notice())?md.getCheck_deal_notice().split(","):null;
				String noticeStr = "";
				if(noticeArr != null){
					for(String str:noticeArr){
						for(VideoFileEventModel vm:vlist){
							if(vm.getFile_name().contains(str)){
								noticeStr += vm.getFile_name() + ",";
								break;
							}
						}
						
					}
				}
				
				String[] picArr = StringUtils.isNotBlank(md.getCheck_deal_pic())?md.getCheck_deal_pic().split(","):null;
				String picStr = "";
				if(picArr != null){
					for(String str:picArr){
						for(VideoFileEventModel vm:vlist){
							if(vm.getFile_name().contains(str)){
								picStr += vm.getFile_name() + ",";
								break;
							}
						}
						
					}
				}
				
				String[] noticeVideoArr = StringUtils.isNotBlank(md.getCheck_deal_notice_video())?md.getCheck_deal_notice_video().split(","):null;
				String noticeVideoStr = "";
				if(noticeVideoArr != null){
					for(String str:noticeVideoArr){
						for(VideoFileEventModel vm:vlist){
							if(vm.getFile_name().contains(str)){
								noticeVideoStr += vm.getFile_name() + ",";
								break;
							}
						}
						
					}
				}
				
				String[] picVideoArr = StringUtils.isNotBlank(md.getCheck_deal_video())?md.getCheck_deal_video().split(","):null;
				String picVideoStr = "";
				if(picVideoArr != null){
					for(String str:picVideoArr){
						for(VideoFileEventModel vm:vlist){
							if(vm.getFile_name().contains(str)){
								picVideoStr += vm.getFile_name() + ",";
								break;
							}
						}
						
					}
				}
				
				md.setCheck_deal_pic(picStr);
				md.setCheck_deal_notice(noticeStr);
				md.setCheck_deal_video(picVideoStr);
				md.setCheck_deal_notice_video(noticeVideoStr);
				result.add(md);
			}
			request.setAttribute("list", result);
			request.setAttribute("map", map);// 查询条件
			request.setAttribute("itemInPage", Constants.PAGE_NUM);// 每页几条数据
			request.setAttribute("pages", pages);
			request.setAttribute(
					"allPage",
					counts % Constants.PAGE_NUM == 0 ? (counts / Constants.PAGE_NUM)
							: (counts / Constants.PAGE_NUM) + 1);// 总共多少页
			request.setAttribute("counts", counts);// 总共多少条数据
		} catch (Exception e) {
			logger_.error(
					"***********/mailSteamer/showChkDealList************", e);
		} finally {
			map = null;
		}
		return "mailSteamer/enforcement/chkDealList";
	}
}
