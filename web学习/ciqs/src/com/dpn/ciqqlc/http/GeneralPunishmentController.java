package com.dpn.ciqqlc.http;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.dpn.ciqqlc.common.util.CommonUtil;
import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.common.util.FileUtil;
import com.dpn.ciqqlc.http.form.GeneralPunishmentForm;
import com.dpn.ciqqlc.http.form.QueryBaseIo;
import com.dpn.ciqqlc.http.form.YbcfQueryIo;
import com.dpn.ciqqlc.http.result.AjaxResult;
import com.dpn.ciqqlc.service.GeneralPunishmentDb;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdDTO;
import com.dpn.ciqqlc.standard.model.CodeLibraryDTO;
import com.dpn.ciqqlc.standard.model.FileInfoDto;
import com.dpn.ciqqlc.standard.model.GeneralPunishmentDTO;
import com.dpn.ciqqlc.standard.model.GeneralPunishmentHistoryDTO;
import com.dpn.ciqqlc.standard.model.LocalePunishDTO;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.service.GeneralPunishmentService;

/**
 * 行政处罚/一般处罚
 * 
 * 处罚流程：
 * 
 * 1.线索申报
 * 
 * 2.线索预审核
 * 
 * 3.稽查受理
 * 
 * 4.稽查审批
 * 
 * 5.法制受理
 * 
 * 6.法制审批
 * 
 * 7.局领导审批
 * 
 * 9.调查取证
 * 
 * 10.审理决定 - 初审
 * 
 * 11.审理决定 - 复审
 * 
 * 12.审理决定 - 终审
 * 
 * 13.送达执行
 * 
 * 14.结案归档
 * 
 * @author xwj
 *
 */
@Controller
@RequestMapping(value = "/generalPunishment")
public class GeneralPunishmentController {
	
    private final Logger logger_ = LoggerFactory.getLogger(this.getClass());
    
    @Autowired
    @Qualifier("generalPunishmentDb")
    private GeneralPunishmentService dbServ = null;
    @InitBinder
     
	public void InitBinder(WebDataBinder binder) {
		try {
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");  
			dateFormat.setLenient(false);  
			binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
    
    @RequestMapping("/pnIndex")
	public String pnIndex(HttpServletRequest request){
    	
		return "generalPunishment/index";
	}
    
    /**
     * 获取当前登录用户
     * @param request
     * @return
     */
    UserInfoDTO getUser(HttpServletRequest request){
    	Object userObj = request.getSession().getAttribute(Constants.USER_KEY);
    	if(null != userObj){
    		return (UserInfoDTO)userObj;
    	}
    	return new UserInfoDTO();
    }
    
    @RequestMapping("/toList")
    public String toList(HttpServletRequest request, GeneralPunishmentForm form){
    	return "generalPunishment/"+form.getStep();
    }
    
    /**
     * 根据当前登录用户的所属机构，获取允许作为查询条件的【业务处/办事处】
     * @param request
     * @return
     */
    public List<CodeLibraryDTO> getOrgsByCurrUser(HttpServletRequest request){
    	List<CodeLibraryDTO> organizes = new ArrayList<CodeLibraryDTO>();
    	try {
    		organizes = CommonUtil.queryCodeLibrary(Constants.QLCORGANIZES, request);
			UserInfoDTO user = getUser(request);
			if(user.getManage_sign().equals("Y")){
				organizes.add(0, new CodeLibraryDTO());
			}else if(CommonUtil.OrganizesContains(organizes, user.getOrg_code())){
				organizes.clear();
				CodeLibraryDTO org = new CodeLibraryDTO();
				org.setCode(user.getOrg_code());
				org.setName(user.getOrg_name());
	    	    organizes.add(org);
			}else{
				organizes.clear();
				organizes.add(new CodeLibraryDTO());
				CodeLibraryDTO org = new CodeLibraryDTO();
				org.setCode(Constants.DEFAULT_ORG_CODE);
				org.setName(Constants.DEFAULT_ORG_NAME);
	    	    organizes.add(org);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
    	return organizes;
    }

    /**
	 * 列表
	 */
	@RequestMapping("/listNew")
	public String listNew(HttpServletRequest request, YbcfQueryIo form){
		
		String step = Constants.AUDIT_STEP_1;
 		if(StringUtils.isNotEmpty(form.getwListStr())){
			List<QueryBaseIo> list =  JSONArray.parseArray(form.getwListStr(), QueryBaseIo.class);
			form.setwList(list);
		}
		try{
			int pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
	        
			UserInfoDTO user = getUser(request);
			
			if(null !=form.getStep()){
				step = form.getStep();
			}
			if(Constants.AUDIT_STEP_1.equals(step)){
				form.setStep_psn(user.getName());
			}
			form.setStep_org(user.getOrg_code());
			form.setFirstRcd(String.valueOf((pages-1)*Constants.PAGE_NUM+1));
			form.setLastRcd(String.valueOf(pages*Constants.PAGE_NUM+1));
			
			//搜索条件-提交状态 的默认值-未提交
			if(null == form.getSubmit_status()){
				form.setSubmit_status("1");
			}
			if(StringUtils.isEmpty(form.getOrg_code()) && Constants.AUDIT_STEP_15.equals(step)){
				form.setOrg_code(user.getOrg_code());
			}
			List<Map<String,Object>> list = dbServ.findNewList(form);
			request.setAttribute("list", list);
			request.setAttribute("listJson", JSONObject.toJSON(list));
			request.setAttribute("counts", dbServ.findNewListCount(form));
			
			request.setAttribute("form", form);
			request.setAttribute("itemInPage", Constants.PAGE_NUM);                                               //每页显示条数
			request.setAttribute("pages",  pages); 
			
			if(form.getwList() != null){
				for (QueryBaseIo io : form.getwList()) {
					String name = io.getwName();
					if(name.indexOf(".") >-1){
						if(StringUtils.isNotEmpty(io.getKey())){
							name = io.getKey().substring(io.getKey().indexOf(".")+1, io.getKey().length());
						}else{
							name = name.substring(name.indexOf(".")+1, name.length());
						}
					}
					request.setAttribute(name, io.getwValue());
				}
			}
			request.setAttribute("step", step);
			//request.setAttribute("orgs", getOrgsByCurrUser(request));
        } catch (Exception e) {
			logger_.error("***********/generalPunishment/list************",e);
		}
//		return  "generalPunishment/list"+step;
//		request.setAttribute("orgList", dbServ.findOrgList());
		if("15".equals(step)){
			request.setAttribute("orgList", dbServ.findSBOrgList());
			return  "generalPunishment/list15";			
		}else{
			return  "generalPunishment/list";
		}
	}
    /**
	 * 列表
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, GeneralPunishmentForm form){
		String step = Constants.AUDIT_STEP_1;
		try{
			int pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
	        
			UserInfoDTO user = getUser(request);
			
			if(null !=form.getStep()){
				step = form.getStep();
			}
			if(Constants.AUDIT_STEP_1.equals(step)){
				form.setStep_1_psn(user.getName());
				form.setStep_1_org(user.getOrg_code());
			}else if(Constants.AUDIT_STEP_2.equals(step)){
				//form.setStep_2_psn(user.getName());
				form.setStep_2_org(user.getOrg_code());//领导角色，使用orgcode过滤
			}else if(Constants.AUDIT_STEP_3.equals(step)){
				form.setStep_3_org(user.getOrg_code());
			}else if(Constants.AUDIT_STEP_4.equals(step)){
				form.setStep_4_org(user.getOrg_code());
			}else if(Constants.AUDIT_STEP_5.equals(step)){
				form.setStep_5_org(user.getOrg_code());
			}else if(Constants.AUDIT_STEP_6.equals(step)){
				form.setStep_6_org(user.getOrg_code());
			}else if(Constants.AUDIT_STEP_7.equals(step)){
				form.setStep_7_org(user.getOrg_code());
			}else if(Constants.AUDIT_STEP_8.equals(step)){
				form.setStep_8_org(user.getOrg_code());
			}else if(Constants.AUDIT_STEP_9.equals(step)){
				form.setStep_9_org(user.getOrg_code());
			}else if(Constants.AUDIT_STEP_10.equals(step)){
				form.setStep_10_org(user.getOrg_code());
			}else if(Constants.AUDIT_STEP_11.equals(step)){
				form.setStep_11_org(user.getOrg_code());
			}else if(Constants.AUDIT_STEP_12.equals(step)){
				form.setStep_12_org(user.getOrg_code());
			}else if(Constants.AUDIT_STEP_13.equals(step)){
				form.setStep_13_org(user.getOrg_code());
			}else if(Constants.AUDIT_STEP_14.equals(step)){
				form.setStep_14_org(user.getOrg_code());
			}else if(Constants.AUDIT_STEP_16.equals(step)){
				form.setStep_16_org(user.getOrg_code());
			}else if(Constants.AUDIT_STEP_17.equals(step)){
				form.setStep_17_org(user.getOrg_code());
			}else if(Constants.AUDIT_STEP_20.equals(step)){
				form.setStep_20_org(user.getOrg_code());
			}
			form.setFirstRcd(String.valueOf((pages-1)*Constants.PAGE_NUM+1));
			form.setLastRcd(String.valueOf(pages*Constants.PAGE_NUM+1));
			//默认只有大连局
			//form.setStep_1_org("CIQDL");
			
			//搜索条件-提交状态 的默认值-未提交
			if(null == form.getSubmit_status()){
				if(Constants.AUDIT_STEP_14.equals(step)){
					form.setSubmit_status("0");
				}else{
					form.setSubmit_status("1");
				}
			}
			request.setAttribute("list", dbServ.findList(form));
			request.setAttribute("counts", dbServ.findListCount(form));
			
			request.setAttribute("form", form);
			request.setAttribute("itemInPage", Constants.PAGE_NUM);                                               //每页显示条数
			request.setAttribute("pages",  pages); 
			//request.setAttribute("orgs", getOrgsByCurrUser(request));
        } catch (Exception e) {
			logger_.error("***********/generalPunishment/list************",e);
		}
		return  "generalPunishment/list"+step;
	}
	
	/**
	 * 详情
	 */
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request, @RequestParam(value="id", required=true)String id, 
			@RequestParam(value="step", required=true)String step,
			@RequestParam(value="main_id", required=false)String main_id){
		try {
			if(Constants.AUDIT_STEP_14.equals(step)){
				Map<String,String> map = new HashMap<String,String>();
				map.put("main_id", main_id);
				request.setAttribute("videoList", dbServ.videoFileEventList(map));
			}
			
			
			GeneralPunishmentDTO gp = null;
			
//			gp = dbServ.findNewById(id);
			
			if(Constants.AUDIT_STEP_1.equals(step)){
				gp = dbServ.findNewById(id);
			}else{
				gp = dbServ.findById(id);
			}
			FileInfoDto param = new FileInfoDto();
			param.setMain_id(gp.getMain_id());
			param.setKey_name("gp_file_fj");
			request.setAttribute("gp_file_fj", dbServ.findFile(param));//附件
			
			//if(Constants.AUDIT_STEP_9.equals(step) || Constants.AUDIT_STEP_15.equals(step)){//step9：调查取证，获取相关附件
				param.setMain_id(gp.getMain_id());
				param.setKey_name("gp_file_fj");
				request.setAttribute("gp_file_fj", dbServ.findFile(param));//附件
				param.setKey_name("gp_file_dcxw");
				request.setAttribute("gp_file_dcxw", dbServ.findFile(param));//调查询问
				param.setKey_name("gp_file_xcky");
				request.setAttribute("gp_file_xcky", dbServ.findFile(param));//现场勘验
				param.setKey_name("gp_file_cfky");
				request.setAttribute("gp_file_cfky", dbServ.findFile(param));//查封扣押
				param.setKey_name("gp_file_qt");
				request.setAttribute("gp_file_qt", dbServ.findFile(param));//其他
			//}else if(Constants.AUDIT_STEP_10.equals(step) || Constants.AUDIT_STEP_11.equals(step) || Constants.AUDIT_STEP_12.equals(step) || Constants.AUDIT_STEP_15.equals(step)){//step10,11,12：审理决定，获取相关附件
				param.setMain_id(gp.getMain_id());
				param.setKey_name("gp_file_ajjzsl");
				request.setAttribute("gp_file_ajjzsl", dbServ.findFile(param));//案件集中审理
				param.setKey_name("gp_file_sdhz");
				request.setAttribute("gp_file_sdhz", dbServ.findFile(param));//送达回证
				param.setKey_name("gp_file_tzcx");
				request.setAttribute("gp_file_tzcx", dbServ.findFile(param));//听证程序
				
				param.setKey_name("gp_file_jfsj_sdzx");//缴费收据
				request.setAttribute("gp_file_jfsj_sdzx", dbServ.findFile(param));//听证程序
			//}else if(Constants.AUDIT_STEP_13.equals(step) || Constants.AUDIT_STEP_15.equals(step)){//step13：送达执行，获取相关附件
				param.setMain_id(gp.getMain_id());
				param.setKey_name("gp_file_sdhz_sdzx");
				request.setAttribute("gp_file_sdhz_sdzx", dbServ.findFile(param));//送达回证 - 送达执行
				param.setKey_name("gp_file_qt_sdzx");
				request.setAttribute("gp_file_qt_sdzx", dbServ.findFile(param));//其他 - 送达执行
				
				GeneralPunishmentHistoryDTO dto = new GeneralPunishmentHistoryDTO();
				dto.setPre_report_no(gp.getPre_report_no());
				dto.setAudit_step(Constants.AUDIT_STEP_9);
				dto.setAudit_status(Constants.GNRL_PNSMT_SHH_STATUS_39);
				request.setAttribute("step9s", dbServ.findHistoryByStatus(dto));
			//}
//				GeneralPunishmentDTO d = dbServ.findById(id);
				Map<String, Object> paramMap = new HashMap<String, Object>();
				CheckDocsRcdDTO yshDoc = null;
//				if(Constants.AUDIT_STEP_15.equals(step)){
					paramMap.put("proc_main_id", gp.getMain_id());
					paramMap.put("doc_type", "D_GP_A_Y_1");
					 yshDoc = dbServ.findDocByTypeNMainId(paramMap);
					request.setAttribute("D_GP_A_Y_1", yshDoc);
					
					paramMap.put("doc_type", "GP_AJ_SBD");
					yshDoc = dbServ.findDocByTypeNMainId(paramMap);
					request.setAttribute("GP_AJ_SBD", yshDoc);
					
					paramMap.put("doc_type", "D_GP_L_S_1");
					yshDoc = dbServ.findDocByTypeNMainId(paramMap);
					request.setAttribute("D_GP_L_S_1", yshDoc);
					
					if(StringUtils.isNotEmpty(gp.getStep_9_doc_id())){
						
						paramMap.put("doc_type", "D_GP_DCBG");
						paramMap.put("doc_id", gp.getStep_9_doc_id());
						yshDoc = dbServ.findDocByTypeNMainId(paramMap);
						request.setAttribute("D_GP_DCBG", yshDoc);
						
						paramMap.put("doc_type", "D_GP_DCBG_Y_S_1");
						paramMap.put("doc_id", gp.getStep_9_doc_id());
						yshDoc = dbServ.findDocByTypeNMainId(paramMap);
						request.setAttribute("D_GP_DCBG_Y_S_1", yshDoc);
						
						paramMap.put("doc_type", "D_GP_DCBG_XZCFAJ_SPB");
						paramMap.put("doc_id", gp.getStep_9_doc_id());
						yshDoc = dbServ.findDocByTypeNMainId(paramMap);
						request.setAttribute("D_GP_DCBG_XZCFAJ_SPB", yshDoc);
					}
					paramMap.put("doc_id", null);
					
					paramMap.put("doc_type", "D_GP_XZCF_GZS");
					yshDoc = dbServ.findDocByTypeNMainId(paramMap);
					request.setAttribute("D_GP_XZCF_GZS", yshDoc);
					
					
//				}
				
				paramMap.put("doc_type", "D_GP_XZCFAJ_SPB");
				yshDoc = dbServ.findDocByTypeNMainId(paramMap);
				request.setAttribute("D_GP_XZCFAJ_SPB", yshDoc);
				
				paramMap.put("doc_type", "D_GP_XZCF_GZS");
				yshDoc = dbServ.findDocByTypeNMainId(paramMap);
				request.setAttribute("D_GP_XZCF_GZS", yshDoc);
				
				paramMap.put("doc_type", "D_GP_XZCF_AJFKB");
				yshDoc = dbServ.findDocByTypeNMainId(paramMap);
				request.setAttribute("D_GP_XZCF_AJFKB", yshDoc);
				
//				paramMap.put("doc_type", "D_GP_DCBG_Y_S_1");
//				yshDoc = dbServ.findDocByTypeNMainId(paramMap);
//				request.setAttribute("D_GP_DCBG_Y_S_1", yshDoc);
				
				paramMap.put("doc_type", "D_GP_XZCF_JDS");
				yshDoc = dbServ.findDocByTypeNMainId(paramMap);
				request.setAttribute("D_GP_XZCF_JDS", yshDoc);
				
				paramMap.put("doc_type", "D_GP_XZCF_JABG");
				yshDoc = dbServ.findDocByTypeNMainId(paramMap);
				request.setAttribute("D_GP_XZCF_JABG", yshDoc);
				request.setAttribute("model", gp);
		} catch (Exception e) {
			logger_.error("***********/generalPunishment/toDetail_1************",e);
		}
		request.setAttribute("step", step);
		if("15".equals(step)){
			return "generalPunishment/detail"+step;
		}
		if(!("1".equals(step) || "2".equals(step))){
			return "generalPunishment/detailNew";
		}
		return "generalPunishment/detail"+step;
	}
	
    @RequestMapping("/delete")
    public String delete_1(HttpServletRequest request, @RequestParam(value="pre_report_no", required=true)String pre_report_no, 
    		@RequestParam(value="step", required=true)String step){
		try {
			GeneralPunishmentHistoryDTO paramDto = new GeneralPunishmentHistoryDTO();
			paramDto.setPre_report_no(pre_report_no);
			paramDto.setAudit_step(step);
			dbServ.deleteHistory(paramDto);
			
			paramDto.setAudit_step(String.valueOf(Integer.parseInt(step)+1));
			dbServ.deleteHistory(paramDto);
			
			dbServ.delete(pre_report_no);
		} catch (Exception e) {
			logger_.error("***********/generalPunishment/delete************",e);
		}
    	return "redirect:list?step="+step;
    }
    
    /**
	 * 新增
	 */
	@RequestMapping("/toAdd")
	public String toAdd(HttpServletRequest request,@RequestParam(value="step", required=true)String step){
		request.setAttribute("orgList", dbServ.findOrgList());
		return "generalPunishment/add"+step;
	}
	
	/**
	 * 新增保存线索申报
	 */
	@RequestMapping("/add")
	public String add(HttpServletRequest request, GeneralPunishmentForm form){
		String step = Constants.AUDIT_STEP_1;
		try{
			if(null !=form.getStep()){
				step = form.getStep();
			}
			
			UserInfoDTO user = getUser(request);
			
			Date currDate = new GregorianCalendar().getTime();
			String dateStr = new SimpleDateFormat("yyyyMMddHHmmsssss").format(currDate);
			String pre_report_no = "QLC-I-" + dateStr;
			
			GeneralPunishmentDTO gPDto = new GeneralPunishmentDTO();
			gPDto.setPre_report_no(pre_report_no);
			gPDto.setComp_name(form.getComp_name());
			gPDto.setPsn_name(form.getPsn_name());
			gPDto.setGender(form.getGender());
			gPDto.setBirth(form.getBirth());
			gPDto.setNation(form.getNation());
			gPDto.setCorporate_psn(form.getCorporate_psn());
			gPDto.setAddr(form.getAddr());
			gPDto.setTel(form.getTel());
			
			gPDto.setAudit_step(step);
			gPDto.setAudit_status(Constants.GNRL_PNSMT_SHH_STATUS_0);
			gPDto.setAudit_date(currDate);
			gPDto.setAudit_psn(user.getName());
			gPDto.setPer_addr(form.getPer_addr());
			gPDto.setAge(form.getAge());
			gPDto.setContacts_name(form.getContacts_name());
			gPDto.setForward_step(Constants.AUDIT_STEP_1);
			gPDto.setBelong_org(form.getBelong_org());//直属局
			gPDto.setDeclare_org(user.getOrg_code());//申报局
			gPDto.setAudit_org(user.getOrg_code());//审批局
			gPDto.setAccept_org(form.getAccept_org());//受理局
			
			dbServ.add(gPDto);
			
			//查询刚保存的gp
//			GeneralPunishmentForm paramForm = new GeneralPunishmentForm();
//			paramForm.setPre_report_no(pre_report_no);
//			paramForm.setFirstRcd("0");
//			paramForm.setLastRcd("2");
//			String main_id = dbServ.findList(paramForm).get(0).getMain_id();
			
			String main_id = gPDto.getMain_id();
			
			//保存附件
			List<Map<String, String>> fileList = FileUtil.uploadFile(request, true);
			if(null != fileList && fileList.size() > 0){
				Map<String, String> fileMap = fileList.get(0);
				if(null != fileMap){
					FileInfoDto f = new FileInfoDto();
					f.setMain_id(main_id);
					f.setFile_name(fileMap.get("fileName"));
					f.setFile_location(fileMap.get("filePath"));
					f.setCreate_user(user.getId());
					f.setCreate_date(currDate);
					f.setKey_name("gp_file_fj");
					dbServ.saveFile(f);
				}
			}
			
			GeneralPunishmentHistoryDTO gPHDto = new GeneralPunishmentHistoryDTO();
			gPHDto.setPre_report_no(pre_report_no);
			gPHDto.setAudit_step(step);
			gPHDto.setAudit_status(Constants.GNRL_PNSMT_SHH_STATUS_0);
			gPHDto.setAudit_date(currDate);
			gPHDto.setAudit_psn(user.getName());
			gPHDto.setAudit_org(user.getOrg_code());
			gPHDto.setBelong_org(form.getBelong_org());
			dbServ.addHistory(gPHDto);
			
        } catch (Exception e) {
			logger_.error("***********/generalPunishment/add************",e);
		}
		return "redirect:listNew?step="+step;
	}

//	/**
//	 * 报单查询
//	 */
//	@RequestMapping("/checkForm")
//	@ResponseBody
//	public String checkForm(HttpServletRequest request, GeneralPunishmentForm form){
//		Map<String, String> paramMap = new HashMap<String, String>();
//		paramMap.put("proc_main_id", form.getMain_id());
//		paramMap.put("doc_type", form.getd);
//		CheckDocsRcdDTO yshDoc = dbServ.findDocByTypeNMainId(paramMap);
//	}
	/**
	 * 提交线索申报到线索预审批这一步需要转换审批局
	 */
	@RequestMapping("/next")
	@ResponseBody
	public String next(HttpServletRequest request,@RequestBody GeneralPunishmentForm form){
		String step = Constants.AUDIT_STEP_1;
		try{
			if(!StringUtils.isEmpty(form.getStep())){
				step = form.getStep();
			}
			
			UserInfoDTO user = getUser(request);
			
			for (GeneralPunishmentForm f : form.getForms()) {
				//查询刚保存的gp
				GeneralPunishmentForm paramForm = new GeneralPunishmentForm();
				paramForm.setId(f.getId());
				GeneralPunishmentDTO dto = dbServ.findNewById(f.getId());
				
				//下一个环节
				String nextStep = GeneralPunishmentDb.getAboutStep(step,null,f.getStatus())[1];
				
				dto.setForward_step(nextStep);
				dbServ.update(dto);
				
				//得到当前环节
				GeneralPunishmentHistoryDTO paramDto3 = new GeneralPunishmentHistoryDTO();
				paramDto3.setPre_report_no(f.getPre_report_no());
				paramDto3.setAudit_step(step);
				GeneralPunishmentHistoryDTO dto3 = dbServ.findStepByReportNo(paramDto3);
				
				dto3.setAudit_status(Constants.GNRL_PNSMT_SHH_STATUS_1);
				dto3.setAudit_date(new Date());
				dbServ.updateHistory(dto3);
				
				GeneralPunishmentHistoryDTO paramDto = new GeneralPunishmentHistoryDTO();
				paramDto.setPre_report_no(dto.getPre_report_no());
				paramDto.setAudit_step(nextStep);
				List<GeneralPunishmentHistoryDTO> hList = dbServ.findListHistory(paramDto);
				
				if(hList.size() == 0){//未到step next
					GeneralPunishmentHistoryDTO gPHDto = new GeneralPunishmentHistoryDTO();
					gPHDto.setPre_report_no(dto.getPre_report_no());
					gPHDto.setAudit_date(DateUtil.newDate());
					gPHDto.setAudit_psn(user.getName());
					gPHDto.setAudit_org(dto.getAudit_org());
					
					gPHDto.setAudit_date(null);
					gPHDto.setAudit_org(user.getOrg_code());
//					gPHDto.setAudit_org(dto.getAccept_org());
					gPHDto.setAudit_psn(null);
					gPHDto.setAudit_step(nextStep);
					gPHDto.setAudit_status(Constants.GNRL_PNSMT_SHH_STATUS_0);
					dbServ.addHistory(gPHDto);
				}else{//已到step next，未通过，更新为未审批
						GeneralPunishmentHistoryDTO gPHDto = new GeneralPunishmentHistoryDTO();
						gPHDto.setPre_report_no(dto.getPre_report_no());
						gPHDto.setAudit_date(DateUtil.newDate());
						gPHDto.setAudit_psn(user.getName());
						gPHDto.setAudit_org(user.getOrg_code());
						gPHDto.setAudit_date(new Date());
						gPHDto.setAudit_org(user.getOrg_code());
//						gPHDto.setAudit_org(dto.getAccept_org());
						gPHDto.setAudit_psn(null);
						gPHDto.setAudit_step(nextStep);
						gPHDto.setAudit_status(Constants.GNRL_PNSMT_SHH_STATUS_0);
						dbServ.addHistory(gPHDto);
				}
			}
        } catch (Exception e) {
			logger_.error("***********/generalPunishment/next************",e);
		}
		return step;
	}
	
	@RequestMapping("/toUpdate")
    public String toUpdate(HttpServletRequest request, @RequestParam(value="id", required=true)String id,
    		@RequestParam(value="step", required=true)String step){
		GeneralPunishmentDTO dto = dbServ.findNewById(id);
		request.setAttribute("model", dto);
		
		GeneralPunishmentDTO gp = dbServ.findById(id);
		FileInfoDto param = new FileInfoDto();
		param.setMain_id(gp.getMain_id());
		param.setKey_name("gp_file_fj");
		request.setAttribute("gp_file_fj", dbServ.findFile(param));//附件
		
		if(Constants.AUDIT_STEP_9.equals(step)||Constants.AUDIT_STEP_18.equals(step)||Constants.AUDIT_STEP_19.equals(step)){//step9：调查取证，获取相关附件
			param.setMain_id(gp.getMain_id());
			param.setKey_name("gp_file_fj");
			request.setAttribute("gp_file_fj", dbServ.findFile(param));//附件
			param.setKey_name("gp_file_dcxw");
			request.setAttribute("gp_file_dcxw", dbServ.findFile(param));//调查询问
			param.setKey_name("gp_file_xcky");
			request.setAttribute("gp_file_xcky", dbServ.findFile(param));//现场勘验
			param.setKey_name("gp_file_cfky");
			request.setAttribute("gp_file_cfky", dbServ.findFile(param));//查封扣押
			param.setKey_name("gp_file_qt");
			request.setAttribute("gp_file_qt", dbServ.findFile(param));//其他
		}
		
		request.setAttribute("orgList", dbServ.findOrgList());
    	return "generalPunishment/add"+step;
    }
	
	/**
	 * 下载附件
	 */
	@RequestMapping("/downloadFile")
	public void downloadFile(HttpServletResponse response, HttpServletRequest request){
		try {
			String fileName = request.getParameter("fileName");
			fileName = new String(fileName.getBytes("ISO-8859-1"),"utf-8");
			if(null != fileName){
				FileUtil.downloadFile(Constants.UP_LOAD_P + fileName, response, true);
			}
		} catch (Exception e) {
			logger_.error("***********/generalPunishment/downloadFile************",e);
		}
	}
	
	/**
	 * 修改
	 */
	@SuppressWarnings("unused")
	@RequestMapping("/update")
	public String update(HttpServletRequest request, GeneralPunishmentForm form){
		String step = Constants.AUDIT_STEP_1;
		try{
			if(null !=form.getStep()){
				step = form.getStep();
			}
			
			Date currDate = new GregorianCalendar().getTime();
			GeneralPunishmentDTO gPDto = new GeneralPunishmentDTO();
			gPDto.setId(form.getId());
			gPDto.setPre_report_no(form.getPre_report_no());
			gPDto.setComp_name(form.getComp_name());
			gPDto.setPsn_name(form.getPsn_name());
			gPDto.setGender(form.getGender());
			gPDto.setBirth(form.getBirth());
			gPDto.setNation(form.getNation());
			gPDto.setCorporate_psn(form.getCorporate_psn());
			gPDto.setAddr(form.getAddr());
			gPDto.setTel(form.getTel());
			gPDto.setAudit_step(step);
			if(StringUtils.isNotEmpty(form.getStatus())){
				gPDto.setAudit_status(Constants.GNRL_PNSMT_SHH_STATUS_1);
			}
			gPDto.setAudit_date(currDate);
			gPDto.setPer_addr(form.getPer_addr());
			gPDto.setAge(form.getAge());
			gPDto.setContacts_name(form.getContacts_name());
			gPDto.setAccept_org(form.getAccept_org());//受理局
			dbServ.update(gPDto);
			
			//查询刚保存的gp
			GeneralPunishmentForm paramForm = new GeneralPunishmentForm();
			paramForm.setPre_report_no(form.getPre_report_no());
			paramForm.setFirstRcd("0");
			paramForm.setLastRcd("2");
			String main_id = dbServ.findList(paramForm).get(0).getMain_id();
			
			GeneralPunishmentHistoryDTO paramDto = new GeneralPunishmentHistoryDTO();
			paramDto.setPre_report_no(gPDto.getPre_report_no());
			paramDto.setAudit_step(step);
			
			GeneralPunishmentHistoryDTO ht = dbServ.findHistory(paramDto);
			
			List<Map<String, String>> fileList = FileUtil.uploadFile(request, true);
			for(Map<String, String> map : fileList){
				String proc_type = map.get("name");
				String fileName = map.get("fileName");
				String path = map.get("filePath");
				if(!"".equals(fileName) && !"".equals(proc_type)){
					FileInfoDto paramDTO = new FileInfoDto();
					paramDTO.setMain_id(main_id);
					paramDTO.setKey_name(proc_type);
					
					FileInfoDto f = new FileInfoDto();
					f.setMain_id(main_id);
					f.setFile_name(map.get("fileName"));
					f.setFile_location(map.get("filePath"));
					f.setCreate_user(getUser(request).getId());
					f.setCreate_date(currDate);
					f.setKey_name(proc_type);
					
					FileInfoDto fd = dbServ.findFile(paramDTO);
					if(null == fd){
						dbServ.saveFile(f);
					}else{
						dbServ.updateFile(f);
					}
					ht.setFile_id(
							StringUtils.isEmpty(ht.getFile_id()) 
							? f.getId()
									:(!ht.getFile_id().contains(f.getId()) ?(ht.getFile_id()+","+f.getId()):ht.getFile_id()));
					
					dbServ.updateHistory(ht);
				}
			}
			
			//判断是否修改时在线填写了申报单doc
			Object tempDocIdObj = request.getSession().getAttribute("tempDocId");
			if(null != tempDocIdObj){
				CheckDocsRcdDTO doc = new CheckDocsRcdDTO();
				doc.setDoc_id(tempDocIdObj.toString());
				String proc_main_id = dbServ.findById(form.getId()).getMain_id();
				doc.setProc_main_id(proc_main_id);
				dbServ.updateDoc(doc);
				request.getSession().removeAttribute("tempDocId");
			}
        } catch (Exception e) {
			logger_.error("***********/generalPunishment/update************",e);
		}
		return "redirect:listNew?step="+step;
	}
	
	/**
	 * 新的审批接口
	 * @param request
	 * @param f
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/auditRef",method=RequestMethod.POST)
	public AjaxResult auditRef(HttpServletRequest request, @RequestBody GeneralPunishmentForm f){
	
		String step = Constants.AUDIT_STEP_1;
		
		if(null == f.getForms()){
			return AjaxResult.error("参数错误");
		}
		UserInfoDTO user = getUser(request);
		
		for(GeneralPunishmentForm form : f.getForms()){

			String status = "";//审核状态
			step = form.getStep();
			
			//得到申报立案数据
			GeneralPunishmentDTO currGp = dbServ.findNewById(form.getId());
			
			//得到当前环节
			GeneralPunishmentHistoryDTO paramDto = new GeneralPunishmentHistoryDTO();
			paramDto.setPre_report_no(form.getPre_report_no());
			paramDto.setAudit_step(step);
			GeneralPunishmentHistoryDTO dto = dbServ.findStepByReportNo(paramDto);
			
			/*审理决定环节直接设置通过*/
			Date currDate = new GregorianCalendar().getTime();			
			
			status = StringUtils.isNotEmpty(form.getStatus())?form.getStatus():status;
			
			if(StringUtils.isEmpty(status)){
				return AjaxResult.error("请选择状态");
			}
			
			String docType = "";
			//调查报告环节逻辑处理
			if(Constants.AUDIT_STEP_9.equals(step) || Constants.AUDIT_STEP_19.equals(step)){
				Map<String,Object> map = new HashMap<String,Object>();
				if(StringUtils.isNotEmpty(currGp.getStep_9_doc_id())){
					map.put("docIds", Arrays.asList(currGp.getStep_9_doc_id().split(",")));
				}else{
					return AjaxResult.biz("from.isEmpty", "请您填写报单", null);
				}
				List<String> docTypes = new ArrayList<String>(){{
					add(Constants.DOC_YBCF_D_GP_DCBG);
					add(Constants.DOC_YBCF_D_GP_DCBG_XZCFAJ_SPB);
					add(Constants.DOC_YBCF_D_GP_DCBG_Y_S_1);
				}};
				map.put("docTypes", docTypes);
				CheckDocsRcdDTO  docd =  dbServ.findDocByTypeNMainId(map);
				
				if(docd == null){
					return AjaxResult.biz("from.isEmpty", "您尚未填写报单", null);
				}
				docType = docd.getDoc_type(); 
				if(Constants.DOC_YBCF_D_GP_DCBG_Y_S_1.equals(docType)){
					status = Constants.GNRL_PNSMT_SHH_STATUS_39;
				}else if(Constants.DOC_YBCF_D_GP_DCBG.equals(docType)){
					status = Constants.GNRL_PNSMT_SHH_STATUS_10;
				}else   if(Constants.DOC_YBCF_D_GP_DCBG_XZCFAJ_SPB.equals(docType)){
					status = Constants.GNRL_PNSMT_SHH_STATUS_14;
				}
			}
			
			if(Constants.AUDIT_STEP_5.equals(step) && Constants.GNRL_PNSMT_SHH_STATUS_15.equals(status)){
				Map<String,Object> map = new HashMap<String,Object>();
				if(StringUtils.isNotEmpty(dto.getDoc_id())){
					map.put("docIds", Arrays.asList(dto.getDoc_id().split(",")));
				}
				List<String> docTypes = new ArrayList<String>(){{
					add(Constants.DOC_YBCF_D_GP_A_Y_1);
				}};
				map.put("docTypes", docTypes);
				CheckDocsRcdDTO  docd =  dbServ.findDocByTypeNMainId(map);
				
				if(docd == null){
					return AjaxResult.biz("from.isEmpty", "请填写案件移送函", null);
				}
//				docType = docd.getDoc_type(); 
			}
			
			if(Constants.AUDIT_STEP_3.equals(step) || Constants.AUDIT_STEP_17.equals(step) || Constants.AUDIT_STEP_4.equals(step) 
					|| Constants.AUDIT_STEP_5.equals(step) || Constants.AUDIT_STEP_17.equals(step)|| Constants.AUDIT_STEP_6.equals(step)){
				docType = "";
			}
			
			String forWardStep = GeneralPunishmentDb.getAboutStep(step,docType,status)[1];
			
			if(dto != null){
				
				dto.setAudit_status(status);
				dto.setAudit_date(currDate);
				dto.setAudit_org(user.getOrg_code());
				dto.setAudit_psn(user.getName());
				
				if(Constants.AUDIT_STEP_18.equals(dto.getAudit_step()) || Constants.AUDIT_STEP_19.equals(dto.getAudit_step())){
					dto.setDoc_id(currGp.getStep_9_doc_id());
				}
				dbServ.updateHistory(dto);
			}
			
			//通过往下一个流程走
			if((!Constants.GNRL_PNSMT_SHH_STATUS_2.equals(status) && !Constants.GNRL_PNSMT_SHH_STATUS_0.equals(status))
				||(Constants.AUDIT_STEP_3.equals(step) || Constants.AUDIT_STEP_16.equals(step) || Constants.AUDIT_STEP_4.equals(step) 
						|| Constants.AUDIT_STEP_5.equals(step) || Constants.AUDIT_STEP_17.equals(step)|| Constants.AUDIT_STEP_6.equals(step)) 	
					){
				dbServ.adoptStep(dto,currGp, forWardStep);
			}else{//不通过
				
				if(!(Constants.AUDIT_STEP_4.equals(step))){
					forWardStep = GeneralPunishmentDb.getAboutStep(step,docType,status)[0];
					paramDto.setAudit_step(forWardStep);
					paramDto.setAudit_status(null);
					List<GeneralPunishmentHistoryDTO> hNextList = dbServ.findListHistory(paramDto);
					if(hNextList.size() > 0){//如果存在上一审批步骤，将其审批状态重置
						GeneralPunishmentHistoryDTO dto1 = hNextList.get(0);
						dto1.setAudit_status(status);
//						dto1.setAudit_date(currDate);
						
						dbServ.updateHistory(dto1);
						dto1.setAudit_status(Constants.GNRL_PNSMT_SHH_STATUS_0);
						dto1.setAudit_date(new Date());
						dbServ.addHistory(dto1);
					}
				}
			}
			
			GeneralPunishmentDTO gPDto = new GeneralPunishmentDTO();
			gPDto.setId(form.getId());
			gPDto.setPre_report_no(form.getPre_report_no());
			
			if(Constants.AUDIT_STEP_7.equals(step)){//step7立案审批，1.生成立案号 2.直接审批通过原来step8延期审批表审批
				
				//如果立案审批，直接审批通过原来step8延期审批表审批
				if(Constants.GNRL_PNSMT_SHH_STATUS_1.equals(form.getStatus())){
					String newCaseNo = "";
					String latestCaseNo = dbServ.getLatestCaseNo(String.valueOf(currDate.getYear() + 1900));
					newCaseNo = StringUtils.isNotEmpty(latestCaseNo) ? 
							String.valueOf(Integer.parseInt(latestCaseNo) + 1) :
								String.valueOf((currDate.getYear() + 1900) * 100000 + 1);
							gPDto.setCase_no(newCaseNo);
					form.setStep(Constants.AUDIT_STEP_8);
					GeneralPunishmentForm fN = new GeneralPunishmentForm();
					List<GeneralPunishmentForm> formNs = new ArrayList<GeneralPunishmentForm>();
					formNs.add(form);
					fN.setForms(formNs);
					audit(request, fN);
				}
			}
			
			gPDto.setAudit_step(step);
			gPDto.setAudit_status(status);
			gPDto.setAudit_date(currDate);
			gPDto.setAudit_psn(user.getName());
			gPDto.setAudit_org(user.getOrg_code());
			gPDto.setForward_step(forWardStep);
			dbServ.update(gPDto);
		}
		return AjaxResult.suc("审批成功");
	}
	/**
	 * 审批
	 * param: id, pre_report_no, step, status
	 * TODO 此方法后续废弃
	 */
	@SuppressWarnings("deprecation")
	@ResponseBody
	@RequestMapping(value="/audit",method=RequestMethod.POST)
	public String audit(HttpServletRequest request, @RequestBody GeneralPunishmentForm f){
		String step = Constants.AUDIT_STEP_1;
		String status = Constants.GNRL_PNSMT_SHH_STATUS_0;
		try{
			if(null != f.getForms()){
				for(GeneralPunishmentForm form : f.getForms()){
					//当前主表记录
					GeneralPunishmentDTO currGp = dbServ.findById(form.getId());
					
					if(!StringUtils.isEmpty(form.getStep())) step = form.getStep();
//					if(StringUtils.isEmpty(form.getStatus())){ 
//						/*审理决定环节直接设置通过*/
//						status = Constants.AUDIT_STEP_10.equals(step) || Constants.AUDIT_STEP_11.equals(step) || Constants.AUDIT_STEP_12.equals(step)
//								? Constants.GNRL_PNSMT_SHH_STATUS_1:form.getStatus();
//						status = form.getStatus();
//					}else{
//						status = form.getStatus();
//					}
					
					//更新状态
					status = StringUtils.isNotEmpty(form.getStatus())?form.getStatus():status;
					
					UserInfoDTO user = getUser(request);
					
					/*
					 *更新该环节的审批状态 根据 step 与  审批状态 
					 *
					 */
					GeneralPunishmentHistoryDTO paramDto = new GeneralPunishmentHistoryDTO();
					paramDto.setPre_report_no(form.getPre_report_no());
					paramDto.setAudit_step(step);
					List<GeneralPunishmentHistoryDTO> hList = dbServ.findListHistory(paramDto);
					
					/*更新当前环节状态*/
					Date currDate = new GregorianCalendar().getTime();
					if(hList.size() > 0){
						GeneralPunishmentHistoryDTO dto = hList.get(0);
						dto.setAudit_status(status);
						dto.setAudit_date(currDate);
						dto.setAudit_org(user.getOrg_code());
						dto.setAudit_psn(user.getName());
						dbServ.updateHistory(dto);
					}
					
					if(!Constants.GNRL_PNSMT_SHH_STATUS_2.equals(status)
							&& !Constants.GNRL_PNSMT_SHH_STATUS_3.equals(status)
							&& !Constants.GNRL_PNSMT_SHH_STATUS_4.equals(status)
							&& !Constants.GNRL_PNSMT_SHH_STATUS_0.equals(status)){//通过
						
						String next_step = GeneralPunishmentDb.getAboutStep(step,null,status)[1];
						paramDto.setAudit_step(next_step);
						List<GeneralPunishmentHistoryDTO> hNextList = dbServ.findListHistory(paramDto);
						
						if(hNextList.size() > 0){//如果存在step_next, 更新
							GeneralPunishmentHistoryDTO dto = hNextList.get(0);
							dto.setAudit_status(Constants.GNRL_PNSMT_SHH_STATUS_0);
							dto.setAudit_date(currDate);
							dto.setAudit_org(user.getOrg_code());
							dbServ.updateHistory(dto);
						}else{//不存在step_next，新增
							GeneralPunishmentHistoryDTO dto = new GeneralPunishmentHistoryDTO();
							dto.setPre_report_no(form.getPre_report_no());
							
							//判断是否在【审理决定-终审】通过了不连续的next_step，如果有，按照不连续的step更新
							if(Constants.AUDIT_STEP_12.equals(step)){//如果是【审理决定-终审】
								if(null != currGp){
									if(!Constants.AUDIT_STEP_13.equals(currGp.getForward_step())){//终审通过的next_step不是step_13
										next_step = currGp.getForward_step();
									}
								}
							}
							
							dto.setAudit_step(next_step);
							dto.setAudit_status(Constants.GNRL_PNSMT_SHH_STATUS_0);
							dto.setAudit_org(user.getOrg_code());
							dbServ.addHistory(dto);
						}
						
						//判断
						//1. step5
						//2. step6
						//3. step12并且【处理建议】=【移送】
						//提交时是否已经填写了【案件移送函】，如果已经填写，此条记录后续环节不可见
						if(Constants.AUDIT_STEP_5.equals(step) || Constants.AUDIT_STEP_6.equals(step) || (Constants.AUDIT_STEP_12.equals(step) && "15".equals(currGp.getForward_step()))){
							Map<String, Object> paramMap = new HashMap<String, Object>();
							paramMap.put("proc_main_id", currGp.getMain_id());
							paramMap.put("doc_type", "D_GP_A_Y_1");
							CheckDocsRcdDTO yshDoc = dbServ.findDocByTypeNMainId(paramMap);
							if(null != yshDoc){//已经填写【案件移送函】
								GeneralPunishmentHistoryDTO dto = new GeneralPunishmentHistoryDTO();
								dto.setPre_report_no(currGp.getPre_report_no());
								dto.setAudit_step(step);
								dbServ.deleteHistoryWhenFinished(dto);
							}
						}
					}else{//不通过
						paramDto.setAudit_step(GeneralPunishmentDb.getAboutStep(step,null,status)[0]);
						List<GeneralPunishmentHistoryDTO> hNextList = dbServ.findListHistory(paramDto);
						if(hNextList.size() > 0){//如果存在上一审批步骤，将其审批状态重置
							GeneralPunishmentHistoryDTO dto = hNextList.get(0);
							dto.setAudit_status(Constants.GNRL_PNSMT_SHH_STATUS_0);
//							dbServ.updateHistory(dto);
							dto.setAudit_date(currDate);
							dbServ.addHistory(dto);
						}
					}
					
					GeneralPunishmentDTO gPDto = new GeneralPunishmentDTO();
					gPDto.setId(form.getId());
					gPDto.setPre_report_no(form.getPre_report_no());
					
					if(Constants.AUDIT_STEP_7.equals(step)){//step7立案审批，1.生成立案号 2.直接审批通过原来step8延期审批表审批
						String newCaseNo = "";
						String latestCaseNo = dbServ.getLatestCaseNo(String.valueOf(currDate.getYear() + 1900));
						if(null != latestCaseNo){
							newCaseNo = String.valueOf(Integer.parseInt(latestCaseNo) + 1);
						}else{
							newCaseNo = String.valueOf((currDate.getYear() + 1900) * 100000 + 1);
						}
						gPDto.setCase_no(newCaseNo);
						
						//如果立案审批，直接审批通过原来step8延期审批表审批
						if(Constants.GNRL_PNSMT_SHH_STATUS_1.equals(form.getStatus())){
							form.setStep(Constants.AUDIT_STEP_8);
							GeneralPunishmentForm fN = new GeneralPunishmentForm();
							List<GeneralPunishmentForm> formNs = new ArrayList<GeneralPunishmentForm>();
							formNs.add(form);
							fN.setForms(formNs);
							audit(request, fN);
						}
					}
					
					gPDto.setAudit_step(step);
					gPDto.setAudit_status(status);
					gPDto.setAudit_date(currDate);
					gPDto.setAudit_psn(user.getName());
					gPDto.setAudit_org(user.getOrg_code());
					gPDto.setForward_step(form.getForward_step());
					dbServ.update(gPDto);
				}
			}
        } catch (Exception e) {
			logger_.error("***********/generalPunishment/audit************",e);
			e.printStackTrace();
		}
		
		step = GeneralPunishmentDb.getAboutStep(step,null,status)[2];
		
		//合并审批步骤之后
		if("4".equals(step)){
			step = "3";
		}else if("6".equals(step)){
			step = "5";
		}else if("11".equals(step)){
			step = "10";
		}
		return step;
	}
	
	/**
	 * 案件移送函
	 * @param request
	 * @param id
	 * @param step     请求来源步骤index
	 * @param page     请求表格页面
	 * @param update   是否为编辑操作
	 * @param subStep  子步骤（针对包含多级审批的页面）
	 * @return
	 */
	@RequestMapping("/toPage")
    public String toPage(HttpServletRequest request, @RequestParam(value="id", required=true)String id,
    		@RequestParam(value="step", required=true)String step, @RequestParam(value="page", required=true)String page,
    		@RequestParam(value="update", required=false)String update,
    		@RequestParam(value="subStep", required=false)String subStep){
		String main_id = "";//业务主键
		String doc_type = "";//文档类型
		String modelType = request.getParameter("docType");
		try {
			if(null != page){
				doc_type = GeneralPunishmentDb.getDocTypeByStr(page, modelType);
			}
			
			GeneralPunishmentDTO gpDTO = dbServ.findById(id);//除第一步【线索申报】以外，都不会为null
			String doc_id = request.getParameter("doc_id");
			if(null != gpDTO){
				main_id = gpDTO.getMain_id();
				if(StringUtils.isEmpty(doc_id)){
					if("18".equals(step)||"9".equals(step)||"19".equals(step)){
						doc_id=gpDTO.getStep_9_doc_id();
					}
				}else{
					doc_type = null;
				}
			}
			
			CheckDocsRcdDTO docDTO = null;
			if(!StringUtils.isEmpty(main_id)){
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("doc_type", doc_type);
				paramMap.put("proc_main_id", main_id);
				if(StringUtils.isNotEmpty(doc_id)){
					paramMap.put("doc_id", doc_id);
					docDTO = dbServ.findDocByTypeNMainId(paramMap);
				}else{
					docDTO = dbServ.findDocByTypeNMainId(paramMap);
					if("18".equals(step)||"9".equals(step)||"19".equals(step)){
						docDTO = null;
					}
				}
				if(null == docDTO){
//					if(page.startsWith("gp_anjian_fkb")){//行政处罚案件反馈表
//						if(Constants.AUDIT_STEP_1.equals(step) || Constants.AUDIT_STEP_2.equals(step)){//【线索移送】环节
//							request.setAttribute("operation", "close");
//							request.setAttribute("message", "该记录尚未在【结案归档】环节进行反馈，暂时无法查看！");
//						}
//					}
					docDTO = new CheckDocsRcdDTO();
					docDTO.setDoc_type(doc_type);
					docDTO.setProc_main_id(main_id);
					if("D_GP_L_S_1".equals(doc_type)){//如果是立案审批表，将案件基本信息带入
						docDTO.setOption_3(gpDTO.getPsn_name());
						String gender = "";
						if("0".equals(gpDTO.getGender())){
							gender = "不详";
						}else if("1".equals(gpDTO.getGender())){
							gender = "男";
						}else if("2".equals(gpDTO.getGender())){
							gender = "女";
						}
						docDTO.setOption_4(gender);
						docDTO.setOption_5(gpDTO.getBirth());
						docDTO.setOption_6(gpDTO.getNation());
						docDTO.setOption_7(gpDTO.getComp_name());
						docDTO.setOption_8(gpDTO.getCorporate_psn());
						docDTO.setOption_9(gpDTO.getAddr());
						docDTO.setOption_10(gpDTO.getTel());
					}else if("D_GP_DCBG".equals(doc_type)){//如果是调查报告，将案件基本信息带入
						docDTO.setOption_3(gpDTO.getPsn_name());
						String gender = "";
						if("0".equals(gpDTO.getGender())){
							gender = "不详";
						}else if("1".equals(gpDTO.getGender())){
							gender = "男";
						}else if("2".equals(gpDTO.getGender())){
							gender = "女";
						}
						docDTO.setOption_4(gender);
						docDTO.setOption_5(gpDTO.getBirth());
						docDTO.setOption_6(gpDTO.getNation());
						docDTO.setOption_7(gpDTO.getComp_name());
						docDTO.setOption_8(gpDTO.getCorporate_psn());
						docDTO.setOption_9(gpDTO.getAddr());
					}
				}
			}else{
				docDTO = new CheckDocsRcdDTO();
				docDTO.setDoc_type(doc_type);
				if("D_GP_L_S_1".equals(doc_type)){//如果是立案审批表，将案件基本信息带入
					docDTO.setOption_3(gpDTO.getPsn_name());
					String gender = "";
					if("0".equals(gpDTO.getGender())){
						gender = "不详";
					}else if("1".equals(gpDTO.getGender())){
						gender = "男";
					}else if("2".equals(gpDTO.getGender())){
						gender = "女";
					}
					docDTO.setOption_4(gender);
					docDTO.setOption_5(gpDTO.getBirth());
					docDTO.setOption_6(gpDTO.getNation());
					docDTO.setOption_7(gpDTO.getComp_name());
					docDTO.setOption_8(gpDTO.getCorporate_psn());
					docDTO.setOption_9(gpDTO.getAddr());
					docDTO.setOption_10(gpDTO.getTel());
				}else if("D_GP_DCBG".equals(doc_type)){//如果是调查报告，将案件基本信息带入
					docDTO.setOption_3(gpDTO.getPsn_name());
					String gender = "";
					if("0".equals(gpDTO.getGender())){
						gender = "不详";
					}else if("1".equals(gpDTO.getGender())){
						gender = "男";
					}else if("2".equals(gpDTO.getGender())){
						gender = "女";
					}
					docDTO.setOption_4(gender);
					docDTO.setOption_5(gpDTO.getBirth());
					docDTO.setOption_6(gpDTO.getNation());
					docDTO.setOption_7(gpDTO.getComp_name());
					docDTO.setOption_8(gpDTO.getCorporate_psn());
					docDTO.setOption_9(gpDTO.getAddr());
				}
			}
			
			request.setAttribute("gpDTO", gpDTO);
			request.setAttribute("doc", docDTO);
			request.setAttribute("id", id);
			request.setAttribute("step", step);
			request.setAttribute("page", page);
			request.setAttribute("subStep", subStep);
			
//			if("gp_xzcf_jds".equals(page)){
				LocalePunishDTO d = new LocalePunishDTO();
				request.setAttribute("tiaoList", dbServ.findPunishList(d));
//			}
			
		} catch (Exception e) {
			logger_.error("***********/generalPunishment/toPage************",e);
		}
    	return "template/"+page+("update".equals(update) ? "_input" : "");
    }
	
	@RequestMapping("/updateDoc")
    public String updateDoc(HttpServletRequest request, CheckDocsRcdDTO docDTO, @RequestParam(value="id", required=true)String id,
    		@RequestParam(value="step", required=true)String step, @RequestParam(value="page", required=true)String page){
		try {
			//预申报号ID
			String pre_report_no = request.getParameter("pre_report_no");

			if(StringUtils.isEmpty(pre_report_no)) throw new Exception("请填写预申报号ID");
				
			GeneralPunishmentHistoryDTO paramDto = new GeneralPunishmentHistoryDTO();
			paramDto.setPre_report_no(pre_report_no);
			paramDto.setAudit_step(step);
			GeneralPunishmentHistoryDTO ht = dbServ.findHistory(paramDto);

			if(Constants.AUDIT_STEP_9.equals(step)){
				List<GeneralPunishmentHistoryDTO> ls = dbServ.findListHistory(paramDto);
				if(ls.size() > 1&& "0".equals(ht.getAudit_status())){
					ht.setDoc_id(null);
//					docDTO.setDoc_id(null);
				}
			}
			
			if(null != docDTO){
				
				if(StringUtils.isEmpty(docDTO.getDoc_id())){//新增
					
					
					if(Constants.AUDIT_STEP_9.equals(step) && ht.getDoc_id() != null){
						
						Map<String,Object> map = new HashMap<String,Object>();
						List<String> docTypes = new ArrayList<String>(){{
							add(Constants.DOC_YBCF_D_GP_DCBG);
							add(Constants.DOC_YBCF_D_GP_XZCFAJ_SPB);
							add(Constants.DOC_YBCF_D_GP_DCBG_Y_S_1);
						}};
						docTypes.remove(docDTO.getDoc_type());
						map.put("docIds", Arrays.asList(ht.getDoc_id().split(",")));
						map.put("docTypes", docTypes);
						int count = dbServ.findDocByHisoryDocId(map);
//						int count = dbServ.findDocCountByTypeMainId(map);
						
						if(count > 0 ){
							request.setAttribute("doc", docDTO);
							request.setAttribute("id", id);
							request.setAttribute("step", step);
							request.setAttribute("page", page);
							request.setAttribute("operation", "close");
							request.setAttribute("bizError", "调查报告、行政处罚案件办理审批表、延期办理审批表只能提交一种");
							return "template/"+page;
						}
					}
					dbServ.addDoc(docDTO);
					
					/*
					if(page.startsWith("gp_anjian_ysh")){//如果填写案件移送函，完结
						GeneralPunishmentDTO gp = dbServ.findById(id);
						GeneralPunishmentHistoryDTO dto = new GeneralPunishmentHistoryDTO();
						dto.setPre_report_no(gp.getPre_report_no());
						dto.setAudit_step(step);
						dbServ.deleteHistoryWhenFinished(dto);
					}
					*/
					request.getSession().setAttribute("tempDocId", docDTO.getDoc_id());
				}else{//修改
					dbServ.updateDoc(docDTO);
				}
			}
			
			if(ht != null){
				if(StringUtils.isNotEmpty(ht.getDoc_id())){
					if("18".equals(step)||"19".equals(step)){
						ht.setDoc_id(docDTO.getDoc_id());
					}else{
						ht.setDoc_id(!ht.getDoc_id().contains(docDTO.getDoc_id()) ?(ht.getDoc_id()+","+docDTO.getDoc_id()):docDTO.getDoc_id());	
					}
				}else{
					ht.setDoc_id(docDTO.getDoc_id());
				}
				
				dbServ.updateHistory(ht);
			}
			
			request.setAttribute("doc", docDTO);
			request.setAttribute("id", id);
			request.setAttribute("step", step);
			request.setAttribute("page", page);
			request.setAttribute("operation", "close");
		} catch (Exception e) {
			logger_.error("***********/generalPunishment/updateDoc************",e);
		}
		return "template/"+page;
    }
	
	@RequestMapping("/fk")
	@ResponseBody
    public String fk(HttpServletRequest request, @RequestParam(value="id", required=true)String id){
		try {
			if(null != id){
				GeneralPunishmentDTO gp = dbServ.findById(id);
				if(null != gp){
					Map<String, Object> paramMap = new HashMap<String, Object>();
					paramMap.put("doc_type", "D_GP_XZCF_AJFKB");
					paramMap.put("group_id", gp.getMain_id());
					CheckDocsRcdDTO doc = dbServ.findDocByTypeNMainId(paramMap);
					if(null != doc){
						return "1";
					}else{
						paramMap.remove("group_id");
						paramMap.put("proc_main_id", gp.getMain_id());
						doc = dbServ.findDocByTypeNMainId(paramMap);
						if(null != doc){
							doc.setGroup_id(gp.getMain_id());
							dbServ.updateDoc(doc);
						}else{
							return "2";
						}
					}
				}
			}
		} catch (Exception e) {
			logger_.error("***********/generalPunishment/fk************",e);
			e.printStackTrace();
		}
		return "0";
    }
	
}
