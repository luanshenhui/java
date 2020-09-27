package com.dpn.ciqqlc.http;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.ParseException;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.FormBodyPart;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.common.util.ElectronicSealUtil;
import com.dpn.ciqqlc.common.util.FileUtil;
import com.dpn.ciqqlc.common.util.PageBean;
import com.dpn.ciqqlc.http.form.LicenseDecForm;
import com.dpn.ciqqlc.http.result.FormPdf;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.model.ExpFoodProdPsnRdmDTO;
import com.dpn.ciqqlc.standard.model.HygieneLicenseEventDto;
import com.dpn.ciqqlc.standard.model.LicenseDecDTO;
import com.dpn.ciqqlc.standard.model.SealFileDTO;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.model.VideoEventModel;
import com.dpn.ciqqlc.standard.service.CommonService;
import com.dpn.ciqqlc.standard.service.CompleteProcessDbService;
import com.dpn.ciqqlc.standard.service.DeclareService;
import com.dpn.ciqqlc.standard.service.ExpFoodProdService;
import com.dpn.ciqqlc.standard.service.LicenseDecDbService;
import com.dpn.ciqqlc.standard.service.LicenseWorkService;
import com.dpn.ciqqlc.standard.service.MailObjCheckDbService;
import com.dpn.ciqqlc.standard.service.OrigPlaceFlowService;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.pdf.AcroFields;
import com.itextpdf.text.pdf.PdfStamper;


/**
 * LicenseDecController.
 * 
 * @author wangzhy
 * @since 1.0.0
 * @version 1.0.0
 */
@SuppressWarnings("rawtypes")
/* *****************************************************************************
* 备忘记录
* -> 以"/xk"作为URL前缀的action，口岸卫生许可证核发。
********************************************************************************
* 变更履历
* -> 
***************************************************************************** */
@Controller
@RequestMapping(value = "/xk")
public class LicenseDecController extends FormPdf{

   /**
    * logger.
    * 
    * @since 1.0.0
    */
    private final Logger logger_ = LoggerFactory.getLogger(this.getClass());
    
	@Autowired
	@Qualifier("licenseDecDbService")
	private LicenseDecDbService licenseDecDbService = null;
	@Autowired
	private DeclareService declareService = null;
	@Autowired
	@Qualifier("mailObjCheckServ")
	private MailObjCheckDbService mailObjCheckServ = null;
	
	@Autowired
    @Qualifier("expFoodProdDb")
    private ExpFoodProdService dbServ = null;
	@Autowired
	private OrigPlaceFlowService origPlaceFlowService;
	@Autowired
	private CommonService commonServer = null; 
	@Autowired
	@Qualifier("completeProcessDbService")
	private CompleteProcessDbService completeProcessDbService = null;
	@Autowired
    @Qualifier("licenseWorkService")
    private LicenseWorkService licenseWorkService = null;
	
	@RequestMapping("/xkIndex")
	public String xkIndex(HttpServletRequest request){
    	
		return "xk/index";
	}
	
	
	
   /**
    * 口岸卫生许可证受理列表查询
    * @param request
    * @return
    */
    @RequestMapping("/findLicenseDecs")
	public String findLicenseDecs(HttpServletRequest request,LicenseDecForm licenseDecForm,@ModelAttribute("msg")String msg){
    	Map<String,String> map = new HashMap<String,String>();
		try{
			/***************************** 分页列表查询部分  ***********************************/
	        int pages = 1;
	        if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
	            pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
	        }
	        PageBean page_bean = new PageBean(pages, String.valueOf(Constants.PAGE_NUM));
	        if(!StringUtils.isEmpty(licenseDecForm.getComp_name())){
	        	map.put("comp_name", licenseDecForm.getComp_name());
	        }
	        if(!StringUtils.isEmpty(licenseDecForm.getStartDeclare_date())){
	        	map.put("startDeclare_date", licenseDecForm.getStartDeclare_date());
	        }
			if(!StringUtils.isEmpty(licenseDecForm.getEndDeclare_date())){
				map.put("endDeclare_date", licenseDecForm.getEndDeclare_date());
			}
			if(!StringUtils.isEmpty(licenseDecForm.getApproval_result())){
				map.put("approval_result", licenseDecForm.getApproval_result());
			}
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			if(!commonServer.isDirectyUnderOrg(request)){
				map.put("admissible_org_code", commonServer.getOrg_code(request));
			}
			List<LicenseDecDTO> list = licenseDecDbService.findLicenseDecs(map);
			int counts = licenseDecDbService.findLicenseDecsCount(map);
			
			/***************************** 页面el表达式传递数据部分  ***********************************/
			request.setAttribute("msg", msg);
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
	        request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
            request.setAttribute("counts",counts);
	        request.setAttribute("allPage", counts % page_bean.getPageSize()==0 ? (counts/page_bean.getPageSize()) : (counts/page_bean.getPageSize())+1);
	        request.setAttribute("comp_name",licenseDecForm.getComp_name());
	        request.setAttribute("approval_result",licenseDecForm.getApproval_result());
	        request.setAttribute("startDeclare_date", licenseDecForm.getStartDeclare_date());
	        request.setAttribute("endDeclare_date", licenseDecForm.getEndDeclare_date());
		} catch (Exception e) {
			
			logger_.error("***********/xk/findLicenseDecs************",e);
		}finally{
			map =  null;
		}
		return "xk/licenseDecsList";
	}
    
   /**
    * 卫生许可证受理详情页面
    * @param request
    * @return
    */
    @RequestMapping("/doDetail")
 	public String doDetail(HttpServletRequest request,
 			@RequestParam("license_dno") String license_dno){
    	Map<String,String> map = new HashMap<String,String>();
    	try{
    		map.put("license_dno", license_dno);
    		LicenseDecDTO dto = licenseDecDbService.getLicenseDec(map);
    		String filePath = licenseDecDbService.selectfilePath(map);// 文件附件
    		String filePath2 = licenseDecDbService.selectZgfilePath(map);// 整改书
    		if(filePath != null && !filePath.equals("")){
    			filePath = filePath.replace("/", "\\");
    			dto.setFilePath(filePath);
    		}
    		if(filePath2 != null && !filePath2.equals("")){
    			filePath2 = filePath2.replace("/", "\\");
    			dto.setFilePath2(filePath2);
    		}
    		request.setAttribute("dto", dto);
    		// 现场审查表
    		Map<String,String> map2 = new HashMap<String,String>();
    		map2.put("license_dno", license_dno);
    		request.setAttribute("scbList", completeProcessDbService.getScbList(map2));
        } catch (Exception e) {
			logger_.error("***********/xk/doDetail************",e);
		}finally{
			map =  null;
		}
    	return "/xk/detail";
    }
     
    /**
     * 口岸卫生许可证审查列表查询（初审）
     * @param request
     * @return
     */
     @RequestMapping("/findScs1")
 	public String findScs1(HttpServletRequest request,LicenseDecForm licenseDecForm,
 			@ModelAttribute("msg")String msg){
     	Map<String,String> map = new HashMap<String,String>();
 		try{
 			/***************************** 分页列表查询部分  ***********************************/
 	        int pages = 1;
 	        if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
 	            pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
 	        }
 	        PageBean page_bean = new PageBean(pages, String.valueOf(Constants.PAGE_NUM));
 	        if(!StringUtils.isEmpty(licenseDecForm.getComp_name())){
 	        	map.put("comp_name", licenseDecForm.getComp_name());
 	        }
 	        if(!StringUtils.isEmpty(licenseDecForm.getStartDeclare_date())){
 	        	map.put("startDeclare_date", licenseDecForm.getStartDeclare_date());
 	        }
 			if(!StringUtils.isEmpty(licenseDecForm.getEndDeclare_date())){
 				map.put("endDeclare_date", licenseDecForm.getEndDeclare_date());
 			}
 			if(!StringUtils.isEmpty(licenseDecForm.getApproval_result())){
 				map.put("approval_result", licenseDecForm.getApproval_result());
 			}
 			map.put("firstRcd", page_bean.getLow());
 			map.put("lastRcd", page_bean.getHigh());
 			if(!commonServer.isDirectyUnderOrg(request)){
				map.put("admissible_org_code", commonServer.getOrg_code(request));
			}
 			List<LicenseDecDTO> list = licenseDecDbService.findScs1(map);
 			int counts = licenseDecDbService.findScs1Count(map);
 			
 			/***************************** 页面el表达式传递数据部分  ***********************************/
 			request.setAttribute("msg", msg);
 			request.setAttribute("list", list);
 			request.setAttribute("pages", Integer.toString(pages));// 当前页码
 	        request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
             request.setAttribute("counts",counts);
 	        request.setAttribute("allPage", counts % page_bean.getPageSize()==0 ? (counts/page_bean.getPageSize()) : (counts/page_bean.getPageSize())+1);
 	        request.setAttribute("comp_name",licenseDecForm.getComp_name());
 	        request.setAttribute("approval_result",licenseDecForm.getApproval_result());
 	        request.setAttribute("startDeclare_date", licenseDecForm.getStartDeclare_date());
 	        request.setAttribute("endDeclare_date", licenseDecForm.getEndDeclare_date());
 		} catch (Exception e) {
 			
 			logger_.error("***********/xk/findScs************",e);
 		}finally{
 			map =  null;
 		}
 		return "xk/scList1";
 	}
     
    /**
     * 口岸卫生许可证审查列表查询
     * @param request
     * @return
     */
     @RequestMapping("/findScs")
 	public String findScs(HttpServletRequest request,LicenseDecForm licenseDecForm,
 			@ModelAttribute("msg")String msg){
     	Map<String,String> map = new HashMap<String,String>();
 		try{
 			/***************************** 分页列表查询部分  ***********************************/
 	        int pages = 1;
 	        if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
 	            pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
 	        }
 	        PageBean page_bean = new PageBean(pages, String.valueOf(Constants.PAGE_NUM));
 	        if(!StringUtils.isEmpty(licenseDecForm.getComp_name())){
 	        	map.put("comp_name", licenseDecForm.getComp_name());
 	        }
 	        if(!StringUtils.isEmpty(licenseDecForm.getStartDeclare_date())){
 	        	map.put("startDeclare_date", licenseDecForm.getStartDeclare_date());
 	        }
 			if(!StringUtils.isEmpty(licenseDecForm.getEndDeclare_date())){
 				map.put("endDeclare_date", licenseDecForm.getEndDeclare_date());
 			}
 			if(!StringUtils.isEmpty(licenseDecForm.getApproval_result())){
 				map.put("approval_result", licenseDecForm.getApproval_result());
 			}
 			map.put("firstRcd", page_bean.getLow());
 			map.put("lastRcd", page_bean.getHigh());
 			if(!commonServer.isDirectyUnderOrg(request)){
				map.put("admissible_org_code", commonServer.getOrg_code(request));
			}
 			List<LicenseDecDTO> list = licenseDecDbService.findScs(map);
 			int counts = licenseDecDbService.findScsCount(map);
 			
 			/***************************** 页面el表达式传递数据部分  ***********************************/
 			request.setAttribute("msg", msg);
 			request.setAttribute("list", list);
 			request.setAttribute("pages", Integer.toString(pages));// 当前页码
 	        request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
             request.setAttribute("counts",counts);
 	        request.setAttribute("allPage", counts % page_bean.getPageSize()==0 ? (counts/page_bean.getPageSize()) : (counts/page_bean.getPageSize())+1);
 	        request.setAttribute("comp_name",licenseDecForm.getComp_name());
 	        request.setAttribute("approval_result",licenseDecForm.getApproval_result());
 	        request.setAttribute("startDeclare_date", licenseDecForm.getStartDeclare_date());
 	        request.setAttribute("endDeclare_date", licenseDecForm.getEndDeclare_date());
 		} catch (Exception e) {
 			
 			logger_.error("***********/xk/findScs************",e);
 		}finally{
 			map =  null;
 		}
 		return "xk/scList";
 	}
     
	/**
	 * 审查组同意
	 * @param request
	 * @return
	 */
    @RequestMapping("/setTy")
  	public String setTy(HttpServletRequest request){
     	Map<String,Object> map = new HashMap<String,Object>();
     	map.put("license_dno", request.getParameter("license_dno"));

     	map.put("approval_users_name", request.getParameter("approval_users_name"));	
     	try{
     		licenseDecDbService.setTy(map);
     		licenseDecDbService.updateApprovalUsersName(map);
     		String approval_users_name =request.getParameter("approval_users_name");
		    if(approval_users_name != null && approval_users_name != ""){
			    String[] arr = approval_users_name.split(",");
			    String str = "";
			    for (int i = 1; i < arr.length; i++) {
					if(i!=1){
						str+=","+arr[i];	
					}else{
						str+=arr[i];
					}
				}
			    map.put("option_21", arr[0]);
			    map.put("option_22", str);
			   
			}
     		licenseDecDbService.updateDocApprovalUsersName(map);
     	     // 更新event表
    		UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
    				Constants.USER_KEY);
    		Map<String, String> eventmap = new HashMap<String, String>();
    		eventmap.put("licence_id", request.getParameter("license_dno"));
    		eventmap.put("status", "4");
    		eventmap.put("opr_psn", user.getId());
    		licenseDecDbService.insertEvent(eventmap);
    		
    		licenseDecDbService.updateDStatus(request.getParameter("license_dno"), 4);
        } catch (Exception e) {
 			logger_.error("***********/xk/setTy************",e);
 		}finally{
 			map =  null;
 		}
     	 return "redirect:/xk/findAddpesons2";
     }
     
    /**
     * 审批
     * @param request
     * @return
     */
     @RequestMapping("/doApproval")
 	public String doApproval(HttpServletRequest request,
 			@RequestParam("id") String id,
 			@RequestParam("do_approval_result") String do_approval_result){
    	Map<String,String> map = new HashMap<String,String>();
    	UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
				Constants.USER_KEY);
    	map.put("id", id);
    	map.put("approval_result", do_approval_result);
    	map.put("approval_user", user.getId());
    	// 受理局
    	/*Map<String, Object> orgMap = new HashMap<String, Object>();
		orgMap.put("org_code", user.getOrg_code());
		if(!StringUtils.isEmpty(user.getOrg_code())){
			map.put("admissible_org_code", user.getOrg_code());
		}else{
			map.put("admissible_org_code", "211900");
		}*/
    	try{
    		licenseDecDbService.doApproval(map);
    		// 更新event表
    		Map<String, String> eventmap = new HashMap<String, String>();
    		eventmap.put("licence_id", request.getParameter("license_dno"));
    		eventmap.put("status", "1");
    		eventmap.put("opr_psn", user.getId());
    		licenseDecDbService.insertEvent(eventmap);
    		if(do_approval_result.equals("1")){
    			Map<String, String> map2 = new HashMap<String, String>();
        		map2.put("licence_id", request.getParameter("license_dno"));
        		map2.put("status", "18");
        		map2.put("opr_psn", user.getId());
        		licenseDecDbService.insertEvent(map2);
    		}
    		licenseDecDbService.updateDStatus(request.getParameter("license_dno"), 1);
        } catch (Exception e) {
			logger_.error("***********/xk/findLicenseDecs************",e);
		}finally{
			map =  null;
		}
    	 return "redirect:/xk/findLicenseDecs";
    }
     
     /**
      * 终止撤销与注销审批
      * @param request
      * @return
      */
    @RequestMapping("/doSubmit")
  	public String doSubmit(HttpServletRequest request){
    	String license_dno = request.getParameter("license_dno");
    	String status = request.getParameter("status");
    	String result = request.getParameter("result");
		UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
				Constants.USER_KEY);
    	Map<String,String> map = new HashMap<String,String>();
    	map.put("license_dno", license_dno);
    	// 终止审批
    	if(status !=null && status.equals("8")){
    		map.put("zz_result", result);
    		/*if(result.equals("1") || result.equals("2") || result.equals("3") || result.equals("5")){
    			map.put("approval_result", "2");
    		}*/
    		// 更新event表
    		Map<String, String> eventmap = new HashMap<String, String>();
    		eventmap.put("licence_id", license_dno);
    		eventmap.put("status", "8");
    		eventmap.put("opr_psn", user.getId());
    		licenseDecDbService.insertEvent(eventmap);
    		this.licenseDecDbService.updateDStatus(license_dno, 8);
    	// 撤销审批
    	}else if(status !=null && status.equals("15")){
    		map.put("cx_result", result);
    		// 更新event表
    		Map<String, String> eventmap = new HashMap<String, String>();
    		eventmap.put("licence_id", license_dno);
    		eventmap.put("status", "15");
    		eventmap.put("opr_psn", user.getId());
    		licenseDecDbService.insertEvent(eventmap);
    		this.licenseDecDbService.updateDStatus(license_dno, 15);
    	// 注销审批
    	}else if(status !=null && status.equals("16")){
    		map.put("zx_result", result);
    		// 更新event表
    		Map<String, String> eventmap = new HashMap<String, String>();
    		eventmap.put("licence_id", license_dno);
    		eventmap.put("status", "16");
    		eventmap.put("opr_psn", user.getId());
    		licenseDecDbService.insertEvent(eventmap);
    		this.licenseDecDbService.updateDStatus(license_dno, 16);
    	}
    	try{
    		licenseDecDbService.doSubmit(map);
    		
        } catch (Exception e) {
			logger_.error("***********/xk/doSubmit************",e);
		}finally{
			map =  null;
		}
    	
    	if(status !=null && status.equals("8")){
    		return "redirect:/xk/zzList"; 
    	}else if(status !=null && status.equals("15")){
    		return "redirect:/xk/cxList"; 
    	}else{
    		return "redirect:/xk/zxList";
    	}
    }
  			
    /**
     * 审查(初审)
     * @param request
     * @return
     */
    @RequestMapping("/doExamination1")
   	public String doExamination1(HttpServletRequest request,
   			@RequestParam("id") String id,
   			@RequestParam("exam_result") String exam_result){
      	Map<String,String> map = new HashMap<String,String>();
      	UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
  				Constants.USER_KEY);
      	map.put("id", id);
      	map.put("first_exam_result", exam_result);
      	map.put("exam_user", user.getId());
      	try{
      		licenseDecDbService.doExamination1(map);
      	    // 更新event表
     		Map<String, String> eventmap = new HashMap<String, String>();
     		eventmap.put("licence_id", request.getParameter("license_dno"));
     		eventmap.put("status", "20");
     		eventmap.put("opr_psn", user.getId());
     		licenseDecDbService.insertEvent(eventmap);
     		licenseDecDbService.updateDStatus(String.valueOf(request.getParameter("license_dno")), 20);
          } catch (Exception e) {
  			logger_.error("***********/xk/doExamination************",e);
  		}finally{
  			map =  null;
  		}
      	return "redirect:/xk/findScs1";
    }
     
   /**
    * 审查
    * @param request
    * @return
    */
    @RequestMapping("/doExamination")
  	public String doExamination(HttpServletRequest request,
  			@RequestParam("id") String id,
  			@RequestParam("exam_result") String exam_result){
     	Map<String,String> map = new HashMap<String,String>();
     	UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
 				Constants.USER_KEY);
     	map.put("id", id);
     	map.put("exam_result", exam_result);
     	map.put("exam_user", user.getId());
     	try{
     		licenseDecDbService.doExamination(map);
     	    // 更新event表
    		Map<String, String> eventmap = new HashMap<String, String>();
    		eventmap.put("licence_id", request.getParameter("license_dno"));
    		eventmap.put("status", "2");
    		eventmap.put("opr_psn", user.getId());
    		licenseDecDbService.insertEvent(eventmap);
    		licenseDecDbService.updateDStatus(String.valueOf(request.getParameter("license_dno")), 2);
         } catch (Exception e) {
 			logger_.error("***********/xk/doExamination************",e);
 		}finally{
 			map =  null;
 		}
     	 return "redirect:/xk/findScs";
     }
     
     
	/**
	 * 跳转至不予受理告知书页面 pdf
	 * @param declare_date 
	 * @return
	 */
    @SuppressWarnings("unchecked")
	@RequestMapping("/toBysls")
  	public String toBysls(Model model,HttpServletRequest  request, HttpServletResponse response,
  			String declare_date,
  			String comp_name,
			@RequestParam("license_dno") String license_dno){
//    	model.addAttribute("declare_date",declare_date);
    	CheckDocsRcdModel dto=new CheckDocsRcdModel();
		dto.setProcMainId(license_dno);
		dto.setDocType("D_BY_GZ");
		String TemplatePDF = Constants.D_BY_GZ;
		this.toPrintPlanNote(request,response,dto,TemplatePDF,dto.getDocType(),false);
		//TODO 不予受理告知
     	return "/xk/bysls";
    }
    
    /**
	 * 跳转至不予受理告知书页面(终止) pdf
	 * @param declare_date 
	 * @return
	 */
    @SuppressWarnings("unchecked")
	@RequestMapping("/toBysls2")
  	public String toBysls2(Model model,HttpServletRequest  request, HttpServletResponse response,
  			String declare_date,
  			String comp_name,
			@RequestParam("license_dno") String license_dno){
//    	model.addAttribute("declare_date",declare_date);
    	CheckDocsRcdModel dto=new CheckDocsRcdModel();
		dto.setProcMainId(license_dno);
		dto.setDocType("D_BY_GZ2");
		String TemplatePDF = Constants.D_BY_GZ;
		this.toPrintPlanNote(request,response,dto,TemplatePDF,dto.getDocType(),false);
		//TODO 不予受理告知
     	return "/xk/bysls";
    }
    
	/**
	 * 跳转至送达回证页面 pdf(新)
	 * @return
	 */
    @SuppressWarnings("unchecked")
	@RequestMapping("/toSdhzShowDpf")
  	public String toSdhzShowDpf(Model model,HttpServletRequest  request, HttpServletResponse response,
			@RequestParam("license_dno") String license_dno,
			@RequestParam("doc_type") String doc_type){
//    	
    	CheckDocsRcdModel dto=new CheckDocsRcdModel();
		dto.setProcMainId(license_dno);
		dto.setDocType(doc_type);
		String TemplatePDF = "/message/ciqqlc/pdfModel/sdhz.pdf";
		this.toPrintPlanNote(request,response,dto,TemplatePDF,dto.getDocType(),false);
		//TODO 不予受理告知
     	return "/xk/bysls";
    }
    
 	/**
 	 * 跳转至不予受理告知书页面 pdf
 	 * @param declare_date 
 	 * @return
 	 */
     @SuppressWarnings("unchecked")
 	@RequestMapping("/toByslsGz")
   	public String toByslsGz(Model model,HttpServletRequest  request, HttpServletResponse response,
   			String declare_date,
   			String comp_name,
 			@RequestParam("license_dno") String license_dno){
     	CheckDocsRcdModel dto=new CheckDocsRcdModel();
 		dto.setProcMainId(license_dno);
 		dto.setDocType("D_BY_GZ");
 		String TemplatePDF = Constants.D_BY_GZ;
 		String fileName = this.printPlanNoteGz(request,response,dto,TemplatePDF,dto.getDocType());
		try{
			String orgtype = commonServer.getOrgType(request, Constants.SEAL_PDF_TYPE[0]);
			Boolean bo=ElectronicSealUtil.getElectronicSealPDF(fileName, orgtype);
			if(bo){
				this.toPrintPlanNote(request,response,null,fileName,"",true);
				// 调用局端上传接口
    			Map queryMap = new HashMap();
    			queryMap.put("type", "XKZFILEOUT");
    			String ciqsip = commonServer.getCiqsIp(queryMap);
    			sendPost("http://"+ciqsip+"/ciqs-dec/apps/saveUpload?type=2", new File(fileName));
			}else{
				response.setHeader("Content-type","text/html;charset=UTF-8");//向浏览器发送一个响应头，设置浏览器的解码方式为UTF-8  
				String data = "<script language='javascript'>alert('电子盖章失败');</script>";  
				OutputStream stream = response.getOutputStream();  
				stream.write(data.getBytes("UTF-8")); 
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
 		//TODO 不予受理告知
      	return "/xk/bysls";
     }
    
	/**
	 * 跳转至不予受理告知书页面   旧样式
	 * @param declare_date 
	 * @return
	 */
    @RequestMapping("/toByslsOld")
  	public String toByslsOld(Model model,
  			String declare_date,
  			String comp_name,
			@RequestParam("license_dno") String license_dno){
    	model.addAttribute("declare_date",declare_date);
    	CheckDocsRcdModel dto=new CheckDocsRcdModel();
		dto.setProcMainId(license_dno);
		dto.setDocType("D_BY_GZ");
		List<CheckDocsRcdModel> list = origPlaceFlowService.getOptionList(dto);
		if(!list.isEmpty()){
			model.addAttribute("doc",list.get(0)); 
		}
     	return "/xk/byslsEdit";
    }
    
    /**
	 * 跳转至不予受理告知书页面  (终止不予受理)
	 * @param declare_date 
	 * @return
	 */
    @RequestMapping("/toByslsOld2")
  	public String toByslsOld2(Model model,
  			String declare_date,
  			String comp_name,
			@RequestParam("license_dno") String license_dno){
    	model.addAttribute("declare_date",declare_date);
    	CheckDocsRcdModel dto=new CheckDocsRcdModel();
		dto.setProcMainId(license_dno);
		dto.setDocType("D_BY_GZ2");
		List<CheckDocsRcdModel> list = origPlaceFlowService.getOptionList(dto);
		if(!list.isEmpty()){
			model.addAttribute("doc",list.get(0)); 
		}
     	return "/xk/byslsEdit2";
    }
    
    
    /**
 	 * 打开企业端pdf
 	 * @return
 	 */
    @SuppressWarnings("unchecked")
 	@RequestMapping("/openPdf")
   	public String openPdf(Model model,HttpServletRequest  request, 
   			HttpServletResponse response,
 			@RequestParam("license_dno") String license_dno,
 			@RequestParam("doc_type") String doc_type){
     	CheckDocsRcdModel dto=new CheckDocsRcdModel();
 		dto.setProcMainId(license_dno);
 		dto.setDocType(doc_type);
 		String templatePDF = "";
 		if(doc_type !=null){
			if(doc_type.equals("D_SDHZ") || doc_type.equals("D_SDHZ2") || 
					doc_type.equals("D_SDHZ3") || doc_type.equals("D_SDHZ4")
					|| doc_type.equals("D_SDHZ5") || doc_type.equals("D_PT_H_L_13")){
				templatePDF="/message/ciqqlc/pdfModel/sdhz.pdf";
			}else if(doc_type.equals("D_BY_GZ")){
				templatePDF="/message/ciqqlc/pdfModel/byxzxkslgzs.pdf";//不予行政许可受理告知书 模板
			}else if(doc_type.equals("D_SQ_SL")){
				templatePDF="/message/ciqqlc/pdfModel/zysljds.pdf";//准予行政许可告知书 模板
			}else if(doc_type.equals("D_BU_SL")){
				templatePDF="/message/ciqqlc/pdfModel/byxzxkjds.pdf";//不予行政许可决定书 模板
			}else if(doc_type.equals("D_SL_GZ")){
				templatePDF="/message/ciqqlc/pdfModel/zyxzxkgzs.pdf";//准予受理决定书 模板
			}else if(doc_type.equals("D_SQ_BZ")){
				templatePDF="/message/ciqqlc/pdfModel/clbq.pdf";//行政许可申请材料补正告知书 模板
			}else if(doc_type.equals("D_SQ_SHRY")){
				templatePDF="/message/ciqqlc/pdfModel/spry.pdf";//审派人员 模板
			}else if(doc_type.equals("D_QD")){
				templatePDF="/message/ciqqlc/pdfModel/jsqd.pdf";//审派人员 模板
			}
		}else{
			if(doc_type.equals("D_SQS")){
				templatePDF="/message/ciqqlc/pdfModel/sqs.pdf";//审派人员 模板
			}
		}
 		Map<String,String> map = new HashMap<String,String>();
		map.put("licence_id", license_dno);
		map.put("doc_type", doc_type);
		String fileName ="";
		List seallist = licenseDecDbService.getSealList(map);
		if(seallist !=null && seallist.size() > 0){
			SealFileDTO sealfiledto= (SealFileDTO) seallist.get(0);
			fileName =sealfiledto.getDoc_file_path();
		}
 		//String fileName = this.printPlanNoteGz(request,response,dto,templatePDF,dto.getDocType());
		try{
			//Boolean bo=ElectronicSealUtil.getElectronicSealPDF(fileName, "3");
			if(true){
				this.toPrintPlanNote(request,response,dto,fileName,dto.getDocType(),false);
			}else{
				response.setHeader("Content-type","text/html;charset=UTF-8");//向浏览器发送一个响应头，设置浏览器的解码方式为UTF-8  
				String data = "<script language='javascript'>alert('电子盖章失败');</script>";  
				OutputStream stream = response.getOutputStream();  
				stream.write(data.getBytes("UTF-8")); 
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
      	return "/xk/bysls";
    }
     
    /**
	 * 局端pdf盖章
	 * @param declare_date 
	 * @return
	 */
    @SuppressWarnings("unchecked")
	@RequestMapping("/toDpf")
  	public String toDpf(HttpServletRequest  request, HttpServletResponse response,Model model,
  			@RequestParam("license_dno") String license_dno,
  			@RequestParam("doc_type") String doc_type){
    	CheckDocsRcdModel dto=new CheckDocsRcdModel();
		dto.setProcMainId(license_dno);
		dto.setDocType(doc_type);
		try {
			List<CheckDocsRcdModel> list = origPlaceFlowService.getOptionList(dto);
			String templatePDF="";
			if(doc_type !=null && list.size() > 0){
				if(doc_type.equals("D_SDHZ") || doc_type.equals("D_SDHZ2") || 
						doc_type.equals("D_SDHZ3") || doc_type.equals("D_SDHZ4")
						|| doc_type.equals("D_SDHZ5") || doc_type.equals("D_PT_H_L_13")){
					templatePDF="/message/ciqqlc/pdfModel/sdhz.pdf";
				}else if(doc_type.equals("D_BY_GZ")){
					templatePDF="/message/ciqqlc/pdfModel/byxzxkslgzs.pdf";//不予行政许可受理告知书 模板
				}else if(doc_type.equals("D_SQ_SL")){
					templatePDF="/message/ciqqlc/pdfModel/zysljds.pdf";//准予行政许可告知书 模板
				}else if(doc_type.equals("D_BU_SL")){
					templatePDF="/message/ciqqlc/pdfModel/byxzxkjds.pdf";//不予行政许可决定书 模板
				}else if(doc_type.equals("D_SL_GZ")){
					templatePDF="/message/ciqqlc/pdfModel/zyxzxkgzs.pdf";//准予受理决定书 模板
				}else if(doc_type.equals("D_SQ_BZ")){
					templatePDF="/message/ciqqlc/pdfModel/clbq.pdf";//行政许可申请材料补正告知书 模板
				}else if(doc_type.equals("D_SQ_SHRY")){
					templatePDF="/message/ciqqlc/pdfModel/spry.pdf";//审派人员 模板
				}else if(doc_type.equals("D_ACC_FORM")){
					templatePDF="/message/ciqqlc/pdfModel/jsqd.pdf";//接收清单
				}else if(doc_type.equals("D_SQS")){
					templatePDF="/message/ciqqlc/pdfModel/sqs.pdf";//审派人员 模板
				}
			}else{
				if(doc_type.equals("D_SQS")){
					templatePDF="/message/ciqqlc/pdfModel/sqs.pdf";//审派人员 模板
				}else if(doc_type.equals("D_ACC_FORM")){
					templatePDF="/message/ciqqlc/pdfModel/jsqd.pdf";//接收清单
				}
				
			}
			/*dto.setOption80("1");
			dto.setDocId(list.get(0).getDocId());
			commonServer.updateDocs(dto);*/
			logger_.debug("***********START PDF************");
			String fileName = this.toPrintFile(request,response,dto,templatePDF,dto.getDocType());
			logger_.debug("***********PDF fileName************"+fileName);
			// 保存盖章后的文件
			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
    				Constants.USER_KEY);
			Map<String,String> map = new HashMap<String,String>();
			map.put("licence_id", license_dno);
			map.put("doc_type", doc_type);
			map.put("create_user", user.getId());
			map.put("doc_file_path", fileName);
			List seallist = licenseDecDbService.getSealList(map);
			if(seallist !=null && seallist.size() > 0){
				licenseDecDbService.updateSeal(map);
			}else{
				licenseDecDbService.insertSeal(map);
			}
			String orgtype = commonServer.getOrgType(request, Constants.SEAL_PDF_TYPE[0]);
    		Boolean bo=ElectronicSealUtil.getElectronicSealPDF(fileName, orgtype);// 盖章
    		logger_.debug("***********PDF bo************"+bo);
    		//boolean bo = true;
			if(bo){
    			this.toPrintPlanNote(request,response,dto,fileName,dto.getDocType(),true);
    			// 调用局端上传接口
    			Map queryMap = new HashMap();
    			queryMap.put("type", "XKZFILEOUT");
    			String ciqsip = commonServer.getCiqsIp(queryMap);
    			logger_.debug("***********ciqsip************"+ciqsip);
    			sendPost("http://"+ciqsip+"/ciqs-dec/apps/saveUpload?type=2", new File(fileName));
    			logger_.debug("***********end************");
    		}else{
    			response.setHeader("Content-type","text/html;charset=UTF-8");//向浏览器发送一个响应头，设置浏览器的解码方式为UTF-8  
				String data = "<script0 language='javascript'>alert('电子盖章失败');</script>";  
				OutputStream stream = response.getOutputStream();  
				stream.write(data.getBytes("UTF-8")); 
    		}
		} catch (Exception e) {
			e.printStackTrace();
		}
		//String TemplatePDF = "/message/ciqqlc/pdfModel/sdhz.pdf";
		//this.toPrintPlanNote(request,response,dto,TemplatePDF,dto.getDocType(),false);
    	//TODO 准予受理告知
     	return "/xk/slgzs";
    }
    
    /**
	 * 跳转至准予受理告知书页面
	 * @param declare_date 
	 * @return
	 */
    @SuppressWarnings("unchecked")
	@RequestMapping("/toSlgzs")
  	public String toSlgzs(HttpServletRequest  request, HttpServletResponse response,Model model,
  			@RequestParam("id") String id,
  			@RequestParam("license_dno") String license_dno,
  			String comp_name,
  			String legal_name,
  			String management_addr,
  			String contacts_name,
  			String contacts_phone){
    	model.addAttribute("comp_name",comp_name);
    	model.addAttribute("legal_name",legal_name);
    	model.addAttribute("management_addr",management_addr);
    	model.addAttribute("contacts_name",contacts_name);
    	model.addAttribute("contacts_phone",contacts_phone);
    	CheckDocsRcdModel dto=new CheckDocsRcdModel();
		dto.setProcMainId(license_dno);
		dto.setDocType("D_SL_GZ");
		String TemplatePDF = Constants.D_SL_GZ;
		this.toPrintPlanNote(request,response,dto,TemplatePDF,dto.getDocType(),false);
    	//TODO 准予受理告知
     	return "/xk/slgzs";
    }
    
    /**
	 * 跳转至申请书页面
	 * @param declare_date 
	 * @return
	 */
    @SuppressWarnings("unchecked")
	@RequestMapping("/toSqsPdf")
  	public String toSqsPdf(HttpServletRequest  request, HttpServletResponse response,Model model,
  			@RequestParam("id") String id,
  			@RequestParam("license_dno") String license_dno){
    	CheckDocsRcdModel dto=new CheckDocsRcdModel();
		dto.setProcMainId(license_dno);
		dto.setDocType("D_SQS");
		String templatePDF="/message/ciqqlc/pdfModel/sqs.pdf";
		this.toPrintPlanNote(request,response,dto,templatePDF,dto.getDocType(),false);
    	//TODO 准予受理告知
     	return "/xk/slgzs";
    }
    
    /**
	 * 跳转至准予受理告知书页面
	 * @param declare_date 
	 * @return
	 */
    @SuppressWarnings("unchecked")
	@RequestMapping("/toSlgzsGz")
  	public void toSlgzsGz(HttpServletRequest  request, HttpServletResponse response,Model model,
  			@RequestParam("id") String id,
  			@RequestParam("license_dno") String license_dno,
  			String comp_name,
  			String legal_name,
  			String management_addr,
  			String contacts_name,
  			String contacts_phone){
    	model.addAttribute("comp_name",comp_name);
    	model.addAttribute("legal_name",legal_name);
    	model.addAttribute("management_addr",management_addr);
    	model.addAttribute("contacts_name",contacts_name);
    	model.addAttribute("contacts_phone",contacts_phone);
    	CheckDocsRcdModel dto=new CheckDocsRcdModel();
		dto.setProcMainId(license_dno);
		dto.setDocType("D_SL_GZ");
		String TemplatePDF = Constants.D_SL_GZ;
		String fileName = this.printPlanNoteGz(request,response,dto,TemplatePDF,dto.getDocType());
		try{
			String orgtype = commonServer.getOrgType(request, Constants.SEAL_PDF_TYPE[0]);
			Boolean bo=ElectronicSealUtil.getElectronicSealPDF(fileName, orgtype);
			if(bo){
				this.toPrintPlanNote(request,response,null,fileName,"",true);
				// 调用局端上传接口
    			Map queryMap = new HashMap();
    			queryMap.put("type", "XKZFILEOUT");
    			String ciqsip = commonServer.getCiqsIp(queryMap);
    			sendPost("http://"+ciqsip+"/ciqs-dec/apps/saveUpload?type=2", new File(fileName));
			}else{
				response.setHeader("Content-type","text/html;charset=UTF-8");//向浏览器发送一个响应头，设置浏览器的解码方式为UTF-8  
				String data = "<script language='javascript'>alert('电子盖章失败');</script>";  
				OutputStream stream = response.getOutputStream();  
				stream.write(data.getBytes("UTF-8")); 
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
    }
    
    
    /**
	 * 跳转至准予受理告知书页面  旧样式
	 * @param declare_date 
	 * @return
	 */
    @RequestMapping("/toSlgzsOld")
  	public String toSlgzsOld(
  			@RequestParam("id") String id,
  			String comp_name,
  			String license_dno,
  			String legal_name,
  			String management_addr,
  			String contacts_name,
  			String contacts_phone,
  			Model model,HttpServletRequest  request){
    	Map<String,String> map = new HashMap<String,String>();
    	map.put("id", id);
    	List<LicenseDecDTO> list=licenseDecDbService.findLicenseDecsList(map);
    	if(!list.isEmpty()){
    		model.addAttribute("comp_name",list.get(0).getComp_name());
        	model.addAttribute("legal_name",list.get(0).getLegal_name());
        	model.addAttribute("management_addr",list.get(0).getManagement_addr());
        	model.addAttribute("contacts_name",list.get(0).getContacts_name());
        	model.addAttribute("contacts_phone",list.get(0).getContacts_phone());
        	model.addAttribute("certificate_numver",list.get(0).getCertificate_numver());
        	model.addAttribute("declare_date",list.get(0).getDeclare_date());
    	}else{
    		model.addAttribute("comp_name",comp_name);
    		model.addAttribute("legal_name",legal_name);
    		model.addAttribute("management_addr",management_addr);
    		model.addAttribute("contacts_name",contacts_name);
    		model.addAttribute("contacts_phone",contacts_phone);
    	}
    	CheckDocsRcdModel dto=new CheckDocsRcdModel();
		dto.setProcMainId(license_dno);
		dto.setDocType("D_SL_GZ");
		List<CheckDocsRcdModel> doclist = origPlaceFlowService.getOptionList(dto);
		if(!doclist.isEmpty()){
			model.addAttribute("doc",doclist.get(0)); 
		}
		UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
		model.addAttribute("org_name",user.getOrg_name());
		model.addAttribute("sl_user",user.getName());
		
     	return "/xk/slgzsEdit";
    }

    /**
     * 申请材料补正告知书  旧样式
     * @param declare_date
     * @param model
     * @param request
     * @param response
     * @return
     */
	@RequestMapping("/toBzgzsOld") 
	public String toBzgzsOld(@RequestParam("declare_date") String declare_date,
			@RequestParam("comp_name") String comp_name,
			@RequestParam("license_dno") String license_dno,
			Model model,HttpServletRequest  request, HttpServletResponse response){
		model.addAttribute("declare_date",declare_date); 
		model.addAttribute("license_dno",license_dno); 
		model.addAttribute("comp_name",comp_name); 
		CheckDocsRcdModel dto=new CheckDocsRcdModel();
		dto.setProcMainId(license_dno);
		dto.setDocType("D_SQ_BZ");
		List<CheckDocsRcdModel> list = origPlaceFlowService.getOptionList(dto);
		if(!list.isEmpty()){
			model.addAttribute("doc",list.get(0)); 
		}
		model.addAttribute("sq_status",request.getParameter("sq_status")); 
		return "/xk/bzgzsEdit"; 
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/toBzgzsGz") 
	public void toBzgzsGz(
			@RequestParam("id") String id,
			@RequestParam("license_dno") String license_dno,
			String declare_date,
			String comp_name,
			Model model,HttpServletRequest  request, HttpServletResponse response){
		model.addAttribute("declare_date",declare_date); 
		model.addAttribute("license_dno",license_dno); 
		model.addAttribute("comp_name",comp_name); 
		CheckDocsRcdModel dto=new CheckDocsRcdModel();
		dto.setProcMainId(license_dno);
		dto.setDocType("D_SQ_BZ");
		String TemplatePDF = Constants.CHECK_NOTE_PRT;
		String fileName = this.printPlanNoteGz(request,response,dto,TemplatePDF,dto.getDocType());
		try{
			String orgtype = commonServer.getOrgType(request, Constants.SEAL_PDF_TYPE[0]);
			Boolean bo=ElectronicSealUtil.getElectronicSealPDF(fileName, orgtype);
			if(bo){
				this.toPrintPlanNote(request,response,null,fileName,"",true);
				// 调用局端上传接口
    			Map queryMap = new HashMap();
    			queryMap.put("type", "XKZFILEOUT");
    			String ciqsip = commonServer.getCiqsIp(queryMap);
    			sendPost("http://"+ciqsip+"/ciqs-dec/apps/saveUpload?type=2", new File(fileName));
			}else{
				response.setHeader("Content-type","text/html;charset=UTF-8");//向浏览器发送一个响应头，设置浏览器的解码方式为UTF-8  
				String data = "<script language='javascript'>alert('电子盖章失败');</script>";  
				OutputStream stream = response.getOutputStream();  
				stream.write(data.getBytes("UTF-8")); 
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 申请材料补正告知书  新样式
	 * @param declare_date
	 * @param comp_name
	 * @param license_dno
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/toBzgzs") 
	public String toBzgzs(
			@RequestParam("id") String id,
			@RequestParam("license_dno") String license_dno,
			String declare_date,
			String comp_name,
			Model model,HttpServletRequest  request, HttpServletResponse response){
		model.addAttribute("declare_date",declare_date); 
		model.addAttribute("license_dno",license_dno); 
		model.addAttribute("comp_name",comp_name); 
		CheckDocsRcdModel dto=new CheckDocsRcdModel();
		dto.setProcMainId(license_dno);
		dto.setDocType("D_SQ_BZ");
		String TemplatePDF = Constants.CHECK_NOTE_PRT;
		this.toPrintPlanNote(request,response,dto,TemplatePDF,dto.getDocType(),false);
		// TODO 补正材料
		return "/xk/bzgzs"; 
	}
	

	/**
	 * 跳转至送达回证页面
	 * 
	 * @param declare_date
	 * @return
	 */
	@RequestMapping("/toSdhz")
	public String toSdhz(@RequestParam("comp_name") String comp_name,
			@RequestParam("mailbox") String mailbox,
			@RequestParam("declare_date") String declare_date,
			@RequestParam("approval_users_name") String approval_users_name,
			Model model) {
		//TODO
		model.addAttribute("comp_name", comp_name);
		model.addAttribute("mailbox", mailbox);
		model.addAttribute("declare_date", declare_date);
		model.addAttribute("approval_users_name", approval_users_name);
		return "/xk/bzs";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/toSdhzPDFGz")
	public void toSdhzPDFGz(HttpServletRequest request,HttpServletResponse response,@RequestParam("comp_name") String comp_name,
			@RequestParam("mailbox") String mailbox,
			@RequestParam("declare_date") String declare_date,
			@RequestParam("approval_users_name") String approval_users_name,
			Model model) {
		String fileName = this.printPlanNoteGz(request,response,null,Constants.D_SDHZ,"");
		try{
			String orgtype = commonServer.getOrgType(request, Constants.SEAL_PDF_TYPE[0]);
			Boolean bo=ElectronicSealUtil.getElectronicSealPDF(fileName, orgtype);
			if(bo){
				this.toPrintPlanNote(request,response,null,fileName,"",true);
				// 调用局端上传接口
    			Map queryMap = new HashMap();
    			queryMap.put("type", "XKZFILEOUT");
    			String ciqsip = commonServer.getCiqsIp(queryMap);
    			sendPost("http://"+ciqsip+"/ciqs-dec/apps/saveUpload?type=2", new File(fileName));
			}else{
				response.setHeader("Content-type","text/html;charset=UTF-8");//向浏览器发送一个响应头，设置浏览器的解码方式为UTF-8  
				String data = "<script language='javascript'>alert('电子盖章失败');</script>";  
				OutputStream stream = response.getOutputStream();  
				stream.write(data.getBytes("UTF-8")); 
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	

	/**
	 * 跳转至送达回证PDF
	 * 
	 * @param declare_date
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/toSdhzPDF")
	public String toSdhzPDF(HttpServletRequest request,HttpServletResponse response,@RequestParam("comp_name") String comp_name,
			@RequestParam("mailbox") String mailbox,
			@RequestParam("declare_date") String declare_date,
			@RequestParam("approval_users_name") String approval_users_name,
			Model model) {
		this.toPrintPlanNote(request,response,null,Constants.D_SDHZ,"",false);
		return "/xk/bzs";
	}
	
	
	/**
	 * 审查派员查询
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/findyScs")
	public String findyScs(HttpServletRequest request,
			LicenseDecForm licenseDecForm) {
		Map<String, String> map = new HashMap<String, String>();
		try {
			/***************************** 分页列表查询部分 ***********************************/
			int pages = 1;
			if (request.getParameter("page") != null
					&& !"".equals(request.getParameter("page"))) {
				pages = Integer
						.parseInt(request.getParameter("page") == null ? "1"
								: request.getParameter("page"));
			}
			PageBean page_bean = new PageBean(pages,
					String.valueOf(Constants.PAGE_NUM));
			if (!StringUtils.isEmpty(licenseDecForm.getComp_name())) {
				map.put("comp_name", licenseDecForm.getComp_name());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getStartDeclare_date())) {
				map.put("startDeclare_date",
						licenseDecForm.getStartDeclare_date());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getEndDeclare_date())) {
				map.put("endDeclare_date", licenseDecForm.getEndDeclare_date());
			}
			
			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
					Constants.USER_KEY);
			// 如果是分支局默认查看自己局的
			/*if(user.getOrg_code() !=null 
					&& !user.getOrg_code().equals(Constants.DEFAULT_ORG_CODE)
					&& !user.getManage_sign().equals("Y")){
				map.put("port_org_code", user.getOrg_code());
			}else{
				// 如果是辽宁局或管理员可以查看所有数据
				if (!StringUtils.isEmpty(licenseDecForm.getPort_org_code())) {
					map.put("port_org_code", licenseDecForm.getPort_org_code());
				}
			}*/
			if (!StringUtils.isEmpty(licenseDecForm.getPort_org_code())) {
				map.put("port_org_code", licenseDecForm.getPort_org_code());
			}
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			List<LicenseDecDTO> list = licenseDecDbService.findyScs(map);
			for (int i = 0; i < list.size(); i++) {
				LicenseDecDTO dto = (LicenseDecDTO)list.get(i);
				String[] arr = (dto.getApproval_users_name()).split(",");
				String spproval_users_nameStr = "";
				for (int j = 0; j < arr.length; j++) {
					if(j==0){
						spproval_users_nameStr += "组长:"+arr[j]+" ";
					}else{
						if(j==1){
							spproval_users_nameStr +="组员:"+arr[j];
						}else{
							spproval_users_nameStr +=","+arr[j];
						}
					}
				}
				dto.setApproval_users_name2(spproval_users_nameStr);
			}
			// 获得系统当前用户所属分支机构
			List newList = new ArrayList();
			String org_code = user.getOrg_code();
			Set set = new HashSet();
			for (int i = 0; i < list.size(); i++) {
				LicenseDecDTO dto = (LicenseDecDTO)list.get(i);
				String[] arr = (dto.getApproval_users_name()).split(",");
				for (int j = 0; j < arr.length; j++) {
					String spnname = arr[j];
					// 查询审查组人员所属受理局
					String belScope = String.valueOf(licenseDecDbService.getbelScope(spnname));
					if(org_code.equals(belScope)){
						if(set.add(dto)){
							newList.add(dto);
						}
					}
				}
			}
			int counts = 0;
			//int counts = licenseDecDbService.findyScsCount(map);
			if(newList !=null && newList.size() > 0){
				counts = newList.size();
			}
			List<SelectModel> allorgList = this.declareService.getOrganizeCiq();

			/***************************** 页面el表达式传递数据部分 ***********************************/
			request.setAttribute("list", newList);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
			request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
			request.setAttribute("counts", counts);
			request.setAttribute(
					"allPage",
					counts % page_bean.getPageSize() == 0 ? (counts / page_bean
							.getPageSize())
							: (counts / page_bean.getPageSize()) + 1);
			request.setAttribute("comp_name", licenseDecForm.getComp_name());
			request.setAttribute("approval_result",
					licenseDecForm.getApproval_result());
			request.setAttribute("startDeclare_date",
					licenseDecForm.getStartDeclare_date());
			request.setAttribute("endDeclare_date",
					licenseDecForm.getEndDeclare_date());
			request.setAttribute("allorgList", allorgList);
			request.setAttribute("port_org_code",
					licenseDecForm.getPort_org_code());
		} catch (Exception e) {

			logger_.error("***********/xk/findAddpesons************", e);
		} finally {
			map = null;
		}
		return "xk/scpyList";
	}
	
	/**
	 * 口岸卫生许可证随机人员列表查询（分支局）
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/findAddpesons")
	public String findAddpesons(HttpServletRequest request,
			LicenseDecForm licenseDecForm) {
		Map<String, String> map = new HashMap<String, String>();
		try {
			/***************************** 分页列表查询部分 ***********************************/
			int pages = 1;
			if (request.getParameter("page") != null
					&& !"".equals(request.getParameter("page"))) {
				pages = Integer
						.parseInt(request.getParameter("page") == null ? "1"
								: request.getParameter("page"));
			}
			PageBean page_bean = new PageBean(pages,
					String.valueOf(Constants.PAGE_NUM));
			if (!StringUtils.isEmpty(licenseDecForm.getComp_name())) {
				map.put("comp_name", licenseDecForm.getComp_name());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getStartDeclare_date())) {
				map.put("startDeclare_date",
						licenseDecForm.getStartDeclare_date());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getEndDeclare_date())) {
				map.put("endDeclare_date", licenseDecForm.getEndDeclare_date());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getPort_org_code())) {
				map.put("port_org_code", licenseDecForm.getPort_org_code());
			}
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			if(!commonServer.isDirectyUnderOrg(request)){
				map.put("admissible_org_code", commonServer.getOrg_code(request));
			}
			List<LicenseDecDTO> list = licenseDecDbService.findAddpesons(map);
			List<LicenseDecDTO> newList = new ArrayList<LicenseDecDTO>();
			int counts = 0;
			for (int i = 0; i < list.size(); i++) {
				LicenseDecDTO dto = (LicenseDecDTO) list.get(i);
				CheckDocsRcdModel checkDocsRcd = new CheckDocsRcdModel();
				checkDocsRcd.setDocType("D_SDHZ");
				checkDocsRcd.setProcMainId(dto.getLicense_dno());
				List<CheckDocsRcdModel> checkDocsRcdModelList = origPlaceFlowService.getOptionList(checkDocsRcd);
				if(checkDocsRcdModelList !=null && checkDocsRcdModelList.size() >0){
					String op20 = (checkDocsRcdModelList.get(0)).getOption20();
					if(op20 !=null && op20.equals("2") && dto.getExam_result().equals("1")){
						newList.add(dto);
					}
				}
				
			}
			if(newList !=null && newList.size() > 0){
				counts = newList.size();
			}
			
			//int counts = licenseDecDbService.findAddpesonsCount(map);
			List<SelectModel> allorgList = this.declareService.getOrganizeCiq();

			/***************************** 页面el表达式传递数据部分 ***********************************/
			request.setAttribute("list", newList);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
			request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
			request.setAttribute("counts", counts);
			request.setAttribute(
					"allPage",
					counts % page_bean.getPageSize() == 0 ? (counts / page_bean
							.getPageSize())
							: (counts / page_bean.getPageSize()) + 1);
			request.setAttribute("comp_name", licenseDecForm.getComp_name());
			request.setAttribute("approval_result",
					licenseDecForm.getApproval_result());
			request.setAttribute("startDeclare_date",
					licenseDecForm.getStartDeclare_date());
			request.setAttribute("endDeclare_date",
					licenseDecForm.getEndDeclare_date());
			request.setAttribute("allorgList", allorgList);
			request.setAttribute("port_org_code",
					licenseDecForm.getPort_org_code());
		} catch (Exception e) {

			logger_.error("***********/xk/findAddpesons************", e);
		} finally {
			map = null;
		}
		return "xk/addpesonList";
	}

	/**
	 * 口岸卫生许可证随机人员列表查询（辽宁局）
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/findAddpesons2")
	public String findAddpesons2(HttpServletRequest request,
			LicenseDecForm licenseDecForm) {
		Map<String, String> map = new HashMap<String, String>();
		try {
			/***************************** 分页列表查询部分 ***********************************/
			int pages = 1;
			if (request.getParameter("page") != null
					&& !"".equals(request.getParameter("page"))) {
				pages = Integer
						.parseInt(request.getParameter("page") == null ? "1"
								: request.getParameter("page"));
			}
			PageBean page_bean = new PageBean(pages,
					String.valueOf(Constants.PAGE_NUM));
			if (!StringUtils.isEmpty(licenseDecForm.getComp_name())) {
				map.put("comp_name", licenseDecForm.getComp_name());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getStartDeclare_date())) {
				map.put("startDeclare_date",
						licenseDecForm.getStartDeclare_date());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getEndDeclare_date())) {
				map.put("endDeclare_date", licenseDecForm.getEndDeclare_date());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getPort_org_code())) {
				map.put("port_org_code", licenseDecForm.getPort_org_code());
			}
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			if (!StringUtils.isEmpty(licenseDecForm.getPort_org_code())) {
				map.put("port_org_code", licenseDecForm.getPort_org_code());
			}
			List<LicenseDecDTO> list = licenseDecDbService.findAddpesonsSp(map);
			for (int i = 0; i < list.size(); i++) {
				LicenseDecDTO dto = (LicenseDecDTO)list.get(i);
				String[] arr = (dto.getApproval_users_name()).split(",");
				String spproval_users_nameStr = "";
				for (int j = 0; j < arr.length; j++) {
					if(j==0){
						spproval_users_nameStr += "组长:"+arr[j]+" ";
					}else{
						if(j==1){
							spproval_users_nameStr +="组员:"+arr[j];
						}else{
							spproval_users_nameStr +=","+arr[j];
						}
					}
				}
				dto.setApproval_users_name2(spproval_users_nameStr);
			}
			int counts = licenseDecDbService.findAddpesonsCountSp(map);
			List<SelectModel> allorgList = this.declareService.getOrganizeCiq();

			/***************************** 页面el表达式传递数据部分 ***********************************/
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
			request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
			request.setAttribute("counts", counts);
			request.setAttribute(
					"allPage",
					counts % page_bean.getPageSize() == 0 ? (counts / page_bean
							.getPageSize())
							: (counts / page_bean.getPageSize()) + 1);
			request.setAttribute("comp_name", licenseDecForm.getComp_name());
			request.setAttribute("approval_result",
					licenseDecForm.getApproval_result());
			request.setAttribute("startDeclare_date",
					licenseDecForm.getStartDeclare_date());
			request.setAttribute("endDeclare_date",
					licenseDecForm.getEndDeclare_date());
			request.setAttribute("allorgList", allorgList);
			request.setAttribute("port_org_code",
					licenseDecForm.getPort_org_code());
		} catch (Exception e) {

			logger_.error("***********/xk/findAddpesons************", e);
		} finally {
			map = null;
		}
		return "xk/addpesonList2";
	}

	
	/**
	 * 
	 * 搜索 随机人员列表
	 * 
	 * @param dto
	 *            随机人员对象
	 * @param model
	 *            Model对象
	 * @param no
	 *            企业编号
	 * @return list
	 */
	@RequestMapping("/peson")
	public String searchPeson(ExpFoodProdPsnRdmDTO dto,
			HttpServletRequest request, String apply_time_begin,
			String apply_time_over) {
		int pages = 1;
		if (request.getParameter("page") != null
				&& !"".equals(request.getParameter("page"))) {
			pages = Integer.parseInt(request.getParameter("page") == null ? "1"
					: request.getParameter("page"));
		}
		PageBean page_bean = new PageBean(pages,
				String.valueOf(Constants.PAGE_NUM));
		dto.setFirstRcd(page_bean.getLow());
		dto.setLastRcd(page_bean.getHigh());
		request.setAttribute("list", licenseDecDbService.findByPseon(dto));
		int counts = licenseDecDbService.findPersonCount(dto);
		request.setAttribute("obj", dto);
		request.setAttribute("apply_time_begin", apply_time_begin);
		request.setAttribute("apply_time_over", apply_time_over);
		// 企业申请编号号
		// request.getSession().setAttribute("no", dto.getApply_no());
		request.setAttribute("pages", Integer.toString(pages));// 当前页码
		request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
		request.setAttribute("counts", counts);
		request.setAttribute(
				"allPage",
				counts % page_bean.getPageSize() == 0 ? (counts / page_bean
						.getPageSize())
						: (counts / page_bean.getPageSize()) + 1);
		return "xk/peson";
	}

	/**
	 * 添加随机人员初始化页面
	 * 
	 * @param dto
	 *            随机人员对象
	 * @param model
	 *            Model对象
	 * @return list
	 */
	@RequestMapping("/pesoninit")
	public String pesoninit(HttpServletRequest request,
			ExpFoodProdPsnRdmDTO dto, Model model, String no) {
		request.setAttribute("apply_no", no);
		return "xk/addpeson";
	}

	/**
	 * 随机人员初始化页面
	 * 
	 * @param dto
	 *            随机人员对象
	 * @param model
	 *            Model对象
	 * @return list
	 * @throws Exception
	 */
	@RequestMapping("/addpeson")
	public String addPeson(ExpFoodProdPsnRdmDTO dto, Model model,
			HttpServletRequest request, String personNum) throws Exception {
		ExpFoodProdPsnRdmDTO foodProdPsnRdmDTO = new ExpFoodProdPsnRdmDTO();
		String peson_num = request.getParameter("peson_num");
		String pid = request.getParameter("pid");
		int num = 0;
		if(!StringUtils.isEmpty(peson_num)){
			num = Integer.valueOf(peson_num);
			if(num < 3){
				num = 3;// 最小人数
			}else if(num > 5){
				num = 5;// 最大人数
			}
		}
		String z_psn_name = request.getParameter("z_psn_name");
		String psn_prof = request.getParameter("z_psn_prof");
		String psn_goodat = request.getParameter("z_psn_goodat");
		String z_psn_prof = request.getParameter("z_psn_prof");
		String bel_scope = request.getParameter("z_bel_scope");
		foodProdPsnRdmDTO.setPsn_name(z_psn_name);
		foodProdPsnRdmDTO.setPsn_prof(psn_prof);
		foodProdPsnRdmDTO.setPsn_goodat(psn_goodat); 
		foodProdPsnRdmDTO.setPsn_prof(z_psn_prof);
		foodProdPsnRdmDTO.setBel_scope(bel_scope);
		dto.setOrg_code(request.getParameter("sl_org_code"));
		foodProdPsnRdmDTO.setOrg_code(request.getParameter("sl_org_code"));
		// 选中的组长集合
		List<ExpFoodProdPsnRdmDTO> checkedLaderList = new ArrayList<ExpFoodProdPsnRdmDTO>();
		// 选中的组员集合
		List<ExpFoodProdPsnRdmDTO> checkedMemberList = new ArrayList<ExpFoodProdPsnRdmDTO>();
		// 所有人员选中集合
		List<ExpFoodProdPsnRdmDTO> checkedMemberList2 = new ArrayList<ExpFoodProdPsnRdmDTO>();
        Set<Object> set = new HashSet<Object>(); // 所有人员去重
        Set<Object> set2 = new HashSet<Object>(); // 组员去重
        ExpFoodProdPsnRdmDTO expdto = null;
		// 设置组长随机人员
		if(!StringUtils.isEmpty(peson_num)){
			List lader = this.licenseDecDbService.findByBasePseon(dto);
			if(lader !=null && lader.size() >0){
				Random random = new Random();
		        int sjnum = random.nextInt(lader.size());
				expdto = (ExpFoodProdPsnRdmDTO)lader.get(sjnum);
				expdto.setChecked("1");
				checkedLaderList.add(expdto);
				checkedMemberList2.add(expdto);
				set.add(expdto.getPsn_id());
			}
			// 设置组员随机人员
		
			List member = this.licenseDecDbService.findByBasePseon2(foodProdPsnRdmDTO);
			if(member !=null && member.size() >0){
		        for (int i = 0; i < member.size(); i++) {
		        	ExpFoodProdPsnRdmDTO memberdto = (ExpFoodProdPsnRdmDTO)member.get(i);
		        	if(memberdto.getPsn_name().equals(foodProdPsnRdmDTO.getPsn_name())){
		        		memberdto.setChecked("1");
						checkedMemberList.add(memberdto);
						num =num-1;
		        	}
					if(set.add(memberdto.getPsn_id())){
						checkedMemberList2.add(memberdto);
					}
				}
			}
			if(member !=null && member.size() >0){
				Random memberrandom = new Random();
		        int membernum = memberrandom.nextInt(member.size());
		        ExpFoodProdPsnRdmDTO memberdto =null;
		        for (int i = 1; i <= num-1; i++) {
		        	while (true) {
		        		membernum = memberrandom.nextInt(member.size());
					    memberdto = (ExpFoodProdPsnRdmDTO)member.get(membernum);
						if(!expdto.getPsn_name().equals(memberdto.getPsn_name()) && 
								set2.add(memberdto.getPsn_id())){
						    break;
						}
					}
		        	memberdto.setChecked("1");
					checkedMemberList.add(memberdto);
		        }
			}
			model.addAttribute("member", member);// 组员
			model.addAttribute("lader",lader);// 组长
			model.addAttribute("checkedMemberList2",checkedMemberList2);
		}
		// 获得组织机构list
		List orglist = licenseDecDbService.getOrgList();
		request.setAttribute("org_code", request.getParameter("sl_org_code"));
		request.setAttribute("orglist", orglist);
		request.setAttribute("z_psn_prof", psn_prof);
		request.setAttribute("z_psn_goodat", psn_goodat);
		request.setAttribute("z_psn_name", z_psn_name);
		request.setAttribute("z_psn_prof", z_psn_prof);
		request.setAttribute("z_bel_scope", bel_scope);
		request.setAttribute("personNum", String.valueOf(num));
		request.setAttribute("obj", dto);
		request.setAttribute("apply_no", dto.getApply_no());
		request.setAttribute("pid", pid);
		request.setAttribute("checkedLaderList", checkedLaderList);	
		request.setAttribute("checkedMemberList", checkedMemberList);
		request.setAttribute("checkedMemberList2", checkedMemberList2);
		request.setAttribute("zynum", num-1);
		return "xk/addpeson";
	}

	/**
	 * 随机人员初始化页面(领导)
	 * 
	 * @param dto
	 *            随机人员对象
	 * @param model
	 *            Model对象
	 * @return list
	 * @throws Exception
	 */
	@RequestMapping("/addpeson2")
	public String addPeson2(ExpFoodProdPsnRdmDTO dto, Model model,
			HttpServletRequest request, String personNum) throws Exception {
		ExpFoodProdPsnRdmDTO foodProdPsnRdmDTO = new ExpFoodProdPsnRdmDTO();
		String peson_num = request.getParameter("peson_num");
		String pid = request.getParameter("pid");
		int num = 0;
		if(!StringUtils.isEmpty(peson_num)){
			num = Integer.valueOf(peson_num);
			if(num < 3){
				num = 3;// 最小人数
			}else if(num > 5){
				num = 5;// 最大人数
			}
		}
		String z_psn_name = request.getParameter("z_psn_name");
		String psn_prof = request.getParameter("z_psn_prof");
		String psn_goodat = request.getParameter("z_psn_goodat");
		String z_psn_prof = request.getParameter("z_psn_prof");
		String bel_scope = request.getParameter("z_bel_scope");
		String queryType = request.getParameter("queryType");
		foodProdPsnRdmDTO.setPsn_name(z_psn_name);
		foodProdPsnRdmDTO.setPsn_prof(psn_prof);
		foodProdPsnRdmDTO.setPsn_goodat(psn_goodat); 
		foodProdPsnRdmDTO.setPsn_prof(z_psn_prof);
		foodProdPsnRdmDTO.setBel_scope(bel_scope);
		dto.setOrg_code(request.getParameter("sl_org_code"));
		foodProdPsnRdmDTO.setOrg_code(request.getParameter("sl_org_code"));
		// 选中的组长集合
		List<ExpFoodProdPsnRdmDTO> checkedLaderList = new ArrayList<ExpFoodProdPsnRdmDTO>();
		// 选中的组员集合
		List<ExpFoodProdPsnRdmDTO> checkedMemberList = new ArrayList<ExpFoodProdPsnRdmDTO>();
		// 所有人员选中集合
		List<ExpFoodProdPsnRdmDTO> checkedMemberList2 = new ArrayList<ExpFoodProdPsnRdmDTO>();
        Set<Object> set = new HashSet<Object>(); // 所有人员去重
        Set<Object> set2 = new HashSet<Object>(); // 组员去重
        ExpFoodProdPsnRdmDTO expdto = null;
        
        /*************************** 点击随机 *********************************/
        if(queryType !=null && queryType.equals("query")){
			// 设置组长随机人员
			if(!StringUtils.isEmpty(peson_num)){
				List lader = this.licenseDecDbService.findByBasePseon(dto);
				if(lader !=null && lader.size() >0){
					Random random = new Random();
			        int sjnum = random.nextInt(lader.size());
					expdto = (ExpFoodProdPsnRdmDTO)lader.get(sjnum);
					expdto.setChecked("1");
					checkedLaderList.add(expdto);
					checkedMemberList2.add(expdto);
					set.add(expdto.getPsn_id());
				}
				// 设置组员随机人员
			
				List member = this.licenseDecDbService.findByBasePseon2(foodProdPsnRdmDTO);
				if(member !=null && member.size() >0){
			        for (int i = 0; i < member.size(); i++) {
			        	ExpFoodProdPsnRdmDTO memberdto = (ExpFoodProdPsnRdmDTO)member.get(i);
			        	if(memberdto.getPsn_name().equals(foodProdPsnRdmDTO.getPsn_name())){
			        		memberdto.setChecked("1");
							checkedMemberList.add(memberdto);
							num =num-1;
			        	}
						if(set.add(memberdto.getPsn_id())){
							checkedMemberList2.add(memberdto);
						}
					}
				}
				if(member !=null && member.size() >0){
					Random memberrandom = new Random();
			        int membernum = memberrandom.nextInt(member.size());
			        ExpFoodProdPsnRdmDTO memberdto =null;
			        for (int i = 1; i <= num-1; i++) {
			        	while (true) {
			        		membernum = memberrandom.nextInt(member.size());
						    memberdto = (ExpFoodProdPsnRdmDTO)member.get(membernum);
							if(!expdto.getPsn_name().equals(memberdto.getPsn_name()) && 
									set2.add(memberdto.getPsn_id())){
							    break;
							}
						}
			        	memberdto.setChecked("1");
						checkedMemberList.add(memberdto);
			        }
				}
				model.addAttribute("member", member);// 组员
				model.addAttribute("lader",lader);// 组长
				model.addAttribute("checkedMemberList2",checkedMemberList2);
			}
        }else{
        	// 初始化领导随机人员
        	String approval_users_name = request.getParameter("approval_users_name");
        	if(approval_users_name!=null && !approval_users_name.equals("")){
        		String[] arr = approval_users_name.split(",");
        		// 组长
        		dto.setPsn_name(arr[0]);
        		List lader = this.licenseDecDbService.findByBasePseon(dto);
				if(lader !=null && lader.size() >0){
					expdto = (ExpFoodProdPsnRdmDTO)lader.get(0);
					expdto.setChecked("1");
					dto.setPsn_name("");
				}
				List member = new ArrayList();
				// 组员
				for (int k = 0; k < arr.length; k++) {
					if(k!=0){
						Map<String,Object> map = new HashMap<String,Object>();
						map.put("psn_name", arr[k]);
						ExpFoodProdPsnRdmDTO pseonInfoDto = this.licenseDecDbService.getPseonInfo(map);
						pseonInfoDto.setChecked("1");
						member.add(pseonInfoDto);
					}
				}
				// 所有人员
				checkedMemberList2 = this.licenseDecDbService.findByBasePseon2(foodProdPsnRdmDTO);
				for (int k = 0; k < checkedMemberList2.size(); k++) {
					ExpFoodProdPsnRdmDTO  dto2 = (ExpFoodProdPsnRdmDTO)checkedMemberList2.get(k);
					for (int i = 0; i < arr.length; i++) {
						if(dto2.getPsn_name().equals(arr[i])){
							dto2.setChecked("1");
						}
					}
				}
				checkedLaderList.addAll(lader);// 组员
				checkedMemberList.addAll(member);// 组长
				num = arr.length;
        	}
        }
		
		// 获得组织机构list
		List orglist = licenseDecDbService.getOrgList();
		request.setAttribute("org_code", request.getParameter("sl_org_code"));
		request.setAttribute("orglist", orglist);
		request.setAttribute("z_psn_prof", psn_prof);
		request.setAttribute("z_psn_goodat", psn_goodat);
		request.setAttribute("z_psn_name", z_psn_name);
		request.setAttribute("z_psn_prof", z_psn_prof);
		request.setAttribute("z_bel_scope", bel_scope);
		request.setAttribute("personNum", String.valueOf(num));
		request.setAttribute("obj", dto);
		request.setAttribute("apply_no", dto.getApply_no());
		request.setAttribute("pid", pid);
		request.setAttribute("checkedLaderList", checkedLaderList);	
		request.setAttribute("checkedMemberList", checkedMemberList);
		request.setAttribute("checkedMemberList2", checkedMemberList2);
		request.setAttribute("zynum", num-1);
		request.setAttribute("approval_users_name", request.getParameter("approval_users_name"));		
		return "xk/addpeson2";
	}
	
	/**
	 * 保存随机分配人员到审查组
	 * 
	 * @param dto
	 *            随机人员对象
	 * @param model
	 *            Model对象
	 * @return list
	 * @throws Exception
	 */
	@RequestMapping("/setPeson")
	public String setPeson(HttpServletRequest request) throws Exception {
		// 更新评审组人员
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("license_dno", request.getParameter("license_dno"));
		map.put("approval_users_name", request.getParameter("names"));
		licenseDecDbService.updateApprovalUsers(map);
 		String approval_users_name =request.getParameter("names");
	    if(approval_users_name != null && approval_users_name != ""){
		    String[] arr = approval_users_name.split(",");
		    String str = "";
		    for (int i = 1; i < arr.length; i++) {
				if(i!=1){
					str+=","+arr[i];	
				}else{
					str+=arr[i];
				}
			}
		    map.put("option_21", arr[0]);
		    map.put("option_22", str);
		   
		}
 		licenseDecDbService.updateDocApprovalUsersName(map);
		// 更新event表
		UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
				Constants.USER_KEY);
		Map<String, String> eventmap = new HashMap<String, String>();
		eventmap.put("licence_id", request.getParameter("license_dno"));
		eventmap.put("status", "3");
		eventmap.put("opr_psn", user.getId());
		licenseDecDbService.insertEvent(eventmap);
		// 更新主表状态
		licenseDecDbService.updateDStatus(String.valueOf(request.getParameter("license_dno")),3);
		return "redirect:findAddpesons";
	}
	
	/**
	 * 跳转到审查书页面
	 * @throws Exception
	 */
	@RequestMapping("/toPsyEdit")
	public String toPsyEdit(HttpServletRequest request) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		map.put("license_dno", request.getParameter("license_dno"));
		LicenseDecDTO dto = licenseDecDbService.getLicenseDec(map);
		CheckDocsRcdModel model=new CheckDocsRcdModel();
		model.setProcMainId(request.getParameter("license_dno"));
		model.setDocType("D_SQ_SHRY");
		List<CheckDocsRcdModel> list = origPlaceFlowService.getOptionList(model);
		if(!list.isEmpty()){
			request.setAttribute("doc",list.get(0)); 
		}else{
			//request.setAttribute("doc",null); 
		}
		request.setAttribute("dto", dto);
		UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
				Constants.USER_KEY);
		request.setAttribute("userId", user.getName());
		request.setAttribute("orgname", user.getOrg_name());
		request.setAttribute("orgCode", user.getOrg_code());
		request.setAttribute("sczry", request.getParameter("sczry"));
		String approval_users_name2 = request.getParameter("approval_users_name2");
		request.setAttribute("approval_users_name2", approval_users_name2);
		return "xk/psyEdit";
	}
	
	/**
	 * 跳转到审查书查看页面
	 * @throws Exception
	 */
	@RequestMapping("/toPsyDtail")
	public String toPsyDtail(HttpServletRequest request) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		map.put("license_dno", request.getParameter("license_dno"));
		LicenseDecDTO dto = licenseDecDbService.getLicenseDec(map);
		CheckDocsRcdModel model=new CheckDocsRcdModel();
		model.setProcMainId(request.getParameter("license_dno"));
		model.setDocType("D_SQ_SHRY");
		UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
				Constants.USER_KEY);
		List<CheckDocsRcdModel> list = origPlaceFlowService.getOptionList(model);
		request.setAttribute("userId", user.getName());
		request.setAttribute("orgname", user.getOrg_name());
		request.setAttribute("orgCode", user.getOrg_code());
		if(!list.isEmpty()){
			request.setAttribute("doc",list.get(0)); 
		}else{
			//request.setAttribute("doc",null); 
		}
		request.setAttribute("dto", dto);
		return "xk/psyDtail";
	}
	
	/**
	 * 跳转到整改书页面
	 * @throws Exception
	 */
	@RequestMapping("/toInformDoc")
	public String toInformDoc(HttpServletRequest request) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		map.put("license_dno", request.getParameter("license_dno"));
		LicenseDecDTO dto = licenseDecDbService.getLicenseDec(map);
		CheckDocsRcdModel model=new CheckDocsRcdModel();
		model.setProcMainId(request.getParameter("license_dno"));
		model.setDocType("D_PT_H_L_0");
		List<CheckDocsRcdModel> list = origPlaceFlowService.getOptionList(model);
		if(!list.isEmpty()){
			request.setAttribute("doc",list.get(0)); 
		}else{
			//request.setAttribute("doc",null); 
		}
		request.setAttribute("dto", dto);
		return "xk/informDoc";
	}
	
	/**
	 * 
	 * 保存到本地随机人员库
	 * 
	 * @param learId
	 *            队长选中的id
	 * @param merId
	 *            组员选中的id
	 * @param num
	 *            选中的人数
	 * @param applyNo
	 *            企业申请的号
	 * @param submitType
	 *            提交方式 1是默认提交，0是人为选中的提交
	 * @return ajaxResult
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@ResponseBody
	@RequestMapping("/insert")
	public Map<String, Object> insertPeson(String learId, String merId,
			String num, String applyNo, String submitType,HttpServletRequest request) throws Exception {
		Map<String, Object> ajaxResult = new HashMap<String, Object>();
		String[] lId = learId.split(",");
		String[] mId = merId.split(",");
		int size = Integer.parseInt(num);
		Set<String> set = new HashSet<String>();
		int result = 0;
		
		String allId = learId + merId;
		String[] all = allId.split(",");
		if (all != null && all != null) {
			for (int i = 0; i < all.length; i++) {
				result = this.savePerson(request,all[i], applyNo, submitType);
			}
		}

		if (result != 0) {
			ajaxResult.put("status", "OK");
			ajaxResult.put("results", "成功");
		} else {
			ajaxResult.put("status", "FALL");
			ajaxResult.put("results", "失败");
		}
		return ajaxResult;
	}

	/**
	 * 
	 * 保存到随机人员库
	 * 
	 * @param id
	 *            队长选中的id
	 * @param applyNo
	 *            企业申请的号
	 * @param submitType
	 *            提交方式 1是默认提交，0是人为选中的提交
	 * @return int 插入个数
	 * @throws Exception
	 */
	private int savePerson(HttpServletRequest request,String id, String applyNo, String submitType)
			throws Exception {
		try {
			ExpFoodProdPsnRdmDTO dto = new ExpFoodProdPsnRdmDTO();
			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
					Constants.USER_KEY);
			dto.setId(id);
			// 遍历出随机集合内的所有id
			List<ExpFoodProdPsnRdmDTO> ist = null;
			ist = licenseDecDbService.findByBasePseon(dto);
			
			if (ist != null && ist.size() > 0) {
				dto.setApply_no(applyNo);
				dto.setPsn_id(ist.get(0).getId());
				dto.setPsn_name(ist.get(0).getPsn_name());
				dto.setPsn_prof(ist.get(0).getPsn_prof());
				dto.setPsn_goodat(ist.get(0).getPsn_goodat());
				dto.setPsn_level(ist.get(0).getPsn_level());
				dto.setIn_post(ist.get(0).getIn_post());
				dto.setBel_scope(ist.get(0).getBel_scope());
				dto.setRdm_type(submitType);
				dto.setRdm_user(user.getId());
				dto.setType("1");
				String approval_users_name = ist.get(0).getPsn_name();
				licenseDecDbService.insterPersonRdm(dto);
				// 更新评审组人员
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("license_dno", applyNo);
				map.put("approval_users_name", "," + approval_users_name);
				licenseDecDbService.updateApprovalUsers(map);
			}

		} catch (Exception e) {
			e.getStackTrace();
			return 0;
		}
		return 1;
	}

	/**
	 * 
	 * 下载人员库信息到Excel中
	 * 
	 * @param dto
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/downExcel", method = RequestMethod.GET)
	public void downExcel(ExpFoodProdPsnRdmDTO dto, HttpServletRequest request,
			HttpServletResponse response) {
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		try {
			String columnNames[] = { "随机人员", "专业", "特长", "随机操作时间" };// 列名
			String keys[] = { "psn_name", "psn_prof", "psn_goodat", "rdm_date" };// map中的key
			List<ExpFoodProdPsnRdmDTO> list = licenseDecDbService
					.findAllPseon(dto);
			List<Map<String, Object>> mlist = createListRecord(list);
			FileUtil.createWorkBook(mlist, keys, columnNames).write(os);
			FileUtil.outPutExcel(
					os,
					response,
					"随机人员"
							+ DateUtil.DateToString(new Date(),
									"yyyyMMddHHmmss"));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 把list集合中的数据保存到map中并返回新的list集合
	 * 
	 * @param 需要转换的list集合
	 * @return 转换后的list集合
	 */
	private List<Map<String, Object>> createListRecord(
			List<ExpFoodProdPsnRdmDTO> list) {
		List<Map<String, Object>> listmap = new ArrayList<Map<String, Object>>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("sheetName", "sheet1");
		listmap.add(map);
		ExpFoodProdPsnRdmDTO dto = null;
		for (int j = 0; j < list.size(); j++) {
			dto = list.get(j);
			Map<String, Object> mapValue = new HashMap<String, Object>();
			mapValue.put("psn_name", dto.getPsn_name());
			mapValue.put("psn_prof", dto.getPsn_prof());
			mapValue.put("psn_goodat", dto.getPsn_goodat());
			mapValue.put("rdm_date", DateUtil.DateToString(dto.getRdm_date(),
					DateUtil.DATE_DEFAULT_FORMAT));
			listmap.add(mapValue);
		}
		return listmap;
	}

	/**
	 * 补发审批列表查询
	 * 
	 * @param request
	 * @param licenseDecForm
	 *            查询条件form
	 * @return
	 */
	@RequestMapping("/bfList")
	public String bfList(HttpServletRequest request,
			LicenseDecForm licenseDecForm) {
		Map<String, String> map = new HashMap<String, String>();
		try {
			/***************************** 分页列表查询部分 ***********************************/
			int pages = 1;
			if (request.getParameter("page") != null
					&& !"".equals(request.getParameter("page"))) {
				pages = Integer
						.parseInt(request.getParameter("page") == null ? "1"
								: request.getParameter("page"));
			}
			PageBean page_bean = new PageBean(pages,
					String.valueOf(Constants.PAGE_NUM));
			
			if (!StringUtils.isEmpty(licenseDecForm.getComp_name())) {
				map.put("comp_name", licenseDecForm.getComp_name());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getStartDeclare_date())) {
				map.put("startDeclare_date",
						licenseDecForm.getStartDeclare_date());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getEndDeclare_date())) {
				map.put("endDeclare_date", licenseDecForm.getEndDeclare_date());
			}
			// 受理局
			if (!StringUtils.isEmpty(licenseDecForm.getPort_org_code())) {
				map.put("port_org_code", licenseDecForm.getPort_org_code());
			}
			// 补发审批结果
			if (!StringUtils.isEmpty(licenseDecForm.getStatus())) {
				map.put("status", licenseDecForm.getStatus());
			}else{
				map.put("status", "('9','10','17')");
			}
			if(!commonServer.isDirectyUnderOrg(request)){
				map.put("admissible_org_code", commonServer.getOrg_code(request));
			}
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			map.put("type", "9");
			List<LicenseDecDTO> list = null;
			int counts = 0;
			list = licenseDecDbService.bfList(map);
			counts = licenseDecDbService.bfCounts(map);
			List<SelectModel> allorgList = this.declareService.getOrganizeCiq();
			/***************************** 页面el表达式传递数据部分 ***********************************/
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
			request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
			request.setAttribute("counts", counts);
			request.setAttribute(
					"allPage",
					counts % page_bean.getPageSize() == 0 ? (counts / page_bean
							.getPageSize())
							: (counts / page_bean.getPageSize()) + 1);
			request.setAttribute("comp_name", licenseDecForm.getComp_name());
			request.setAttribute("status",
					licenseDecForm.getStatus());
			request.setAttribute("startDeclare_date",
					licenseDecForm.getStartDeclare_date());
			request.setAttribute("endDeclare_date",
					licenseDecForm.getEndDeclare_date());
			request.setAttribute("allorgList",allorgList);
		} catch (Exception e) {
			logger_.error("***********/xk/bfList************", e);
		} finally {
			map = null;
		}
		return "xk/bfList";
	}
	
	/**
	 * 终止审批列表查询
	 * 
	 * @param request
	 * @param licenseDecForm
	 *            查询条件form
	 * @return
	 */
	@RequestMapping("/zzList")
	public String zzList(HttpServletRequest request,
			LicenseDecForm licenseDecForm) {
		Map<String, String> map = new HashMap<String, String>();
		try {
			/***************************** 分页列表查询部分 ***********************************/
			int pages = 1;
			if (request.getParameter("page") != null
					&& !"".equals(request.getParameter("page"))) {
				pages = Integer
						.parseInt(request.getParameter("page") == null ? "1"
								: request.getParameter("page"));
			}
			PageBean page_bean = new PageBean(pages,
					String.valueOf(Constants.PAGE_NUM));
			
			if (!StringUtils.isEmpty(licenseDecForm.getComp_name())) {
				map.put("comp_name", licenseDecForm.getComp_name());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getStartDeclare_date())) {
				map.put("startDeclare_date",
						licenseDecForm.getStartDeclare_date());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getEndDeclare_date())) {
				map.put("endDeclare_date", licenseDecForm.getEndDeclare_date());
			}
			// 受理局
			if (!StringUtils.isEmpty(licenseDecForm.getPort_org_code())) {
				map.put("port_org_code", licenseDecForm.getPort_org_code());
			}
			// 补发审批结果
			if (!StringUtils.isEmpty(licenseDecForm.getStatus())) {
				map.put("status", licenseDecForm.getStatus());
			}else{
				map.put("status", "('1','2','3','4','5','7')");
			}
			map.put("desc", "desc");
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			map.put("type", "4");
			List<LicenseDecDTO> list = null;
			int counts = 0;
			list = licenseDecDbService.bfList(map);
			counts = licenseDecDbService.bfCounts(map);
			List<SelectModel> allorgList = this.declareService.getOrganizeCiq();
			/***************************** 页面el表达式传递数据部分 ***********************************/
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
			request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
			request.setAttribute("counts", counts);
			request.setAttribute(
					"allPage",
					counts % page_bean.getPageSize() == 0 ? (counts / page_bean
							.getPageSize())
							: (counts / page_bean.getPageSize()) + 1);
			request.setAttribute("comp_name", licenseDecForm.getComp_name());
			request.setAttribute("status",
					licenseDecForm.getStatus());
			request.setAttribute("startDeclare_date",
					licenseDecForm.getStartDeclare_date());
			request.setAttribute("endDeclare_date",
					licenseDecForm.getEndDeclare_date());
			request.setAttribute("allorgList",allorgList);
		} catch (Exception e) {
			logger_.error("***********/xk/bfList************", e);
		} finally {
			map = null;
		}
		return "xk/zzList";
	}
	
	/**
	 * 撤销审批列表查询
	 * 
	 * @param request
	 * @param licenseDecForm
	 *            查询条件form
	 * @return
	 */
	@RequestMapping("/cxList")
	public String cxList(HttpServletRequest request,
			LicenseDecForm licenseDecForm) {
		Map<String, String> map = new HashMap<String, String>();
		try {
			/***************************** 分页列表查询部分 ***********************************/
			int pages = 1;
			if (request.getParameter("page") != null
					&& !"".equals(request.getParameter("page"))) {
				pages = Integer
						.parseInt(request.getParameter("page") == null ? "1"
								: request.getParameter("page"));
			}
			PageBean page_bean = new PageBean(pages,
					String.valueOf(Constants.PAGE_NUM));
			
			if (!StringUtils.isEmpty(licenseDecForm.getComp_name())) {
				map.put("comp_name", licenseDecForm.getComp_name());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getStartDeclare_date())) {
				map.put("startDeclare_date",
						licenseDecForm.getStartDeclare_date());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getEndDeclare_date())) {
				map.put("endDeclare_date", licenseDecForm.getEndDeclare_date());
			}
			// 受理局
			if (!StringUtils.isEmpty(licenseDecForm.getPort_org_code())) {
				map.put("port_org_code", licenseDecForm.getPort_org_code());
			}
			// 撤销审批结果
			if (!StringUtils.isEmpty(licenseDecForm.getStatus())) {
				map.put("status", licenseDecForm.getStatus());
			}else{
				map.put("status", "('6','11')");
			}
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			map.put("type", "4");
			List<LicenseDecDTO> list = null;
			int counts = 0;
			list = licenseDecDbService.bfList(map);
			counts = licenseDecDbService.bfCounts(map);
			List<SelectModel> allorgList = this.declareService.getOrganizeCiq();
			/***************************** 页面el表达式传递数据部分 ***********************************/
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
			request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
			request.setAttribute("counts", counts);
			request.setAttribute(
					"allPage",
					counts % page_bean.getPageSize() == 0 ? (counts / page_bean
							.getPageSize())
							: (counts / page_bean.getPageSize()) + 1);
			request.setAttribute("comp_name", licenseDecForm.getComp_name());
			request.setAttribute("status",
					licenseDecForm.getStatus());
			request.setAttribute("startDeclare_date",
					licenseDecForm.getStartDeclare_date());
			request.setAttribute("endDeclare_date",
					licenseDecForm.getEndDeclare_date());
			request.setAttribute("allorgList",allorgList);
		} catch (Exception e) {
			logger_.error("***********/xk/bfList************", e);
		} finally {
			map = null;
		}
		return "xk/cxList";
	}
	
	/**
	 * 注销审批列表查询
	 * 
	 * @param request
	 * @param licenseDecForm
	 *            查询条件form
	 * @return
	 */
	@RequestMapping("/zxList")
	public String zxList(HttpServletRequest request,
			LicenseDecForm licenseDecForm) {
		Map<String, String> map = new HashMap<String, String>();
		try {
			/***************************** 分页列表查询部分 ***********************************/
			int pages = 1;
			if (request.getParameter("page") != null
					&& !"".equals(request.getParameter("page"))) {
				pages = Integer
						.parseInt(request.getParameter("page") == null ? "1"
								: request.getParameter("page"));
			}
			PageBean page_bean = new PageBean(pages,
					String.valueOf(Constants.PAGE_NUM));
			
			if (!StringUtils.isEmpty(licenseDecForm.getComp_name())) {
				map.put("comp_name", licenseDecForm.getComp_name());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getStartDeclare_date())) {
				map.put("startDeclare_date",
						licenseDecForm.getStartDeclare_date());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getEndDeclare_date())) {
				map.put("endDeclare_date", licenseDecForm.getEndDeclare_date());
			}
			// 受理局
			if (!StringUtils.isEmpty(licenseDecForm.getPort_org_code())) {
				map.put("port_org_code", licenseDecForm.getPort_org_code());
			}
			// 补发审批结果
			if (!StringUtils.isEmpty(licenseDecForm.getStatus())) {
				map.put("status", licenseDecForm.getStatus());
			}else{
				map.put("status", "('6','12')");
			}
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			map.put("type", "4");
			List<LicenseDecDTO> list = null;
			int counts = 0;
			list = licenseDecDbService.bfList(map);
			counts = licenseDecDbService.bfCounts(map);
			List<SelectModel> allorgList = this.declareService.getOrganizeCiq();
			/***************************** 页面el表达式传递数据部分 ***********************************/
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
			request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
			request.setAttribute("counts", counts);
			request.setAttribute(
					"allPage",
					counts % page_bean.getPageSize() == 0 ? (counts / page_bean
							.getPageSize())
							: (counts / page_bean.getPageSize()) + 1);
			request.setAttribute("comp_name", licenseDecForm.getComp_name());
			request.setAttribute("status",
					licenseDecForm.getStatus());
			request.setAttribute("startDeclare_date",
					licenseDecForm.getStartDeclare_date());
			request.setAttribute("endDeclare_date",
					licenseDecForm.getEndDeclare_date());
			request.setAttribute("allorgList",allorgList);
		} catch (Exception e) {
			logger_.error("***********/xk/bfList************", e);
		} finally {
			map = null;
		}
		return "xk/zxList";
	}
	
	/**
	 * 现场评审列表查询
	 * 
	 * @param request
	 * @param licenseDecForm
	 *            查询条件form
	 * @return
	 */
	@RequestMapping("/findReviews")
	public String findReviews(HttpServletRequest request,
			LicenseDecForm licenseDecForm) {
		Map<String, String> map = new HashMap<String, String>();
		try {
			/***************************** 分页列表查询部分 ***********************************/
			int pages = 1;
			if (request.getParameter("page") != null
					&& !"".equals(request.getParameter("page"))) {
				pages = Integer
						.parseInt(request.getParameter("page") == null ? "1"
								: request.getParameter("page"));
			}
			PageBean page_bean = new PageBean(pages,
					String.valueOf(Constants.PAGE_NUM));
			if (!StringUtils.isEmpty(licenseDecForm.getComp_name())) {
				map.put("comp_name", licenseDecForm.getComp_name());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getStartDeclare_date())) {
				map.put("startDeclare_date",
						licenseDecForm.getStartDeclare_date());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getEndDeclare_date())) {
				map.put("endDeclare_date", licenseDecForm.getEndDeclare_date());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getReview_result())) {
				map.put("review_result", licenseDecForm.getReview_result());
			}
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			if(!commonServer.isDirectyUnderOrg(request)){
				map.put("admissible_org_code", commonServer.getOrg_code(request));
			}
			List<LicenseDecDTO> list = null;
			List<LicenseDecDTO> newlist = new ArrayList<LicenseDecDTO>();
			int counts = 0;
			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
					Constants.USER_KEY);
			if(user != null){ 
				// 如果是管理员可以查看全部数据
				//if(!StringUtils.isEmpty(user.getManage_sign()) 
					//&& user.getManage_sign().equals("Y")){
					list = licenseDecDbService.findReviews(map);
					HashSet h = new HashSet(); 
					for (int i = 0; i < list.size(); i++) {
						LicenseDecDTO dto = (LicenseDecDTO)list.get(i);
						String[] arr = (dto.getApproval_users_name()).split(",");
						String spproval_users_nameStr = "";
						for (int j = 0; j < arr.length; j++) {
							if(j==0){
								spproval_users_nameStr += "组长:"+arr[j]+" ";
							}else{
								if(j==1){
									spproval_users_nameStr +="组员:"+arr[j];
								}else{
									spproval_users_nameStr +=","+arr[j];
								}
							}
						}
						dto.setApproval_users_name2(spproval_users_nameStr);
						if(h.add(dto.getId()))  {
							newlist.add(dto); 
						}
					}
					//counts = licenseDecDbService.findReviewsCount(map);
					if(newlist !=null && newlist.size()> 0){
						counts = newlist.size();
					}
				// 根据当前的单号和用户id查询对应的数据
				/*}else{
					 
					
					list = licenseDecDbService.findReviews(map);
					if(list != null && list.size() > 0){
						for (int j = 0; j < list.size(); j++) {
							LicenseDecDTO dto = (LicenseDecDTO)list.get(j);
							String userids = dto.getApproval_users_id();
							if(userids !=null && userids.indexOf(",") !=-1){
								String[] arr = userids.split(",");
								for (int i = 0; i < arr.length; i++) {
									if(arr[i] == user.getId()){
										newlist.add(dto);
									}
								}
							}
						}
						counts = newlist.size();
					}
					//counts = licenseDecDbService.findReviewsCount(map);
					
				}*/
			}
			/***************************** 页面el表达式传递数据部分 ***********************************/
			request.setAttribute("list", newlist);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
			request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
			request.setAttribute("counts", counts);
			request.setAttribute(
					"allPage",
					counts % page_bean.getPageSize() == 0 ? (counts / page_bean
							.getPageSize())
							: (counts / page_bean.getPageSize()) + 1);
			request.setAttribute("comp_name", licenseDecForm.getComp_name());
			request.setAttribute("review_result",
					licenseDecForm.getReview_result());
			request.setAttribute("startDeclare_date",
					licenseDecForm.getStartDeclare_date());
			request.setAttribute("endDeclare_date",
					licenseDecForm.getEndDeclare_date());
		} catch (Exception e) {
			logger_.error("***********/xk/findReviews************", e);
		} finally {
			map = null;
		}
		return "xk/reviewsList";
	}

	/**
	 * 决定审批列表查询
	 * 
	 * @param request
	 * @param licenseDecForm
	 *            查询条件form
	 * @return
	 */
	@RequestMapping("/findReviewsSp")
	public String findReviewsSp(HttpServletRequest request,
			LicenseDecForm licenseDecForm) {
		Map<String, String> map = new HashMap<String, String>();
		try {
			/***************************** 分页列表查询部分 ***********************************/
			int pages = 1;
			if (request.getParameter("page") != null
					&& !"".equals(request.getParameter("page"))) {
				pages = Integer
						.parseInt(request.getParameter("page") == null ? "1"
								: request.getParameter("page"));
			}
			PageBean page_bean = new PageBean(pages,
					String.valueOf(Constants.PAGE_NUM));
			if (!StringUtils.isEmpty(licenseDecForm.getComp_name())) {
				map.put("comp_name", licenseDecForm.getComp_name());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getStartDeclare_date())) {
				map.put("startDeclare_date",
						licenseDecForm.getStartDeclare_date());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getEndDeclare_date())) {
				map.put("endDeclare_date", licenseDecForm.getEndDeclare_date());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getReview_result())) {
				map.put("review_result", licenseDecForm.getReview_result());
			}
			if (!StringUtils.isEmpty(request.getParameter("jd_sp"))) {
				map.put("jd_sp", request.getParameter("jd_sp"));
			}
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			if(!commonServer.isDirectyUnderOrg(request)){
				map.put("admissible_org_code", commonServer.getOrg_code(request));
			}
			List<LicenseDecDTO> list = null;
			List<LicenseDecDTO> newlist = new ArrayList<LicenseDecDTO>();
			int counts = 0;
			/*UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
					Constants.USER_KEY);
			if(user != null){ 
				// 如果是管理员可以查看全部数据
				if(!StringUtils.isEmpty(user.getFlag_op())
					&& user.getManage_sign().equals("Y")){*/
					list = licenseDecDbService.findReviewsSp(map);
					HashSet h = new HashSet(); 
					for (int i = 0; i < list.size(); i++) {
						LicenseDecDTO dto = (LicenseDecDTO)list.get(i);
						if(h.add(dto.getId()))  {
							newlist.add(dto); 
						}
					}     
					//counts = licenseDecDbService.findReviewsSpCount(map);
					if(newlist !=null && newlist.size() > 0){
						counts =newlist.size();
					}
				// 根据当前的单号和用户id查询对应的数据
				/*}else{
					map.put("userId", user.getId());
					list = licenseDecDbService.findReviewsSp(map);
					counts = licenseDecDbService.findReviewsSpCount(map);
				}
			}*/
			/***************************** 页面el表达式传递数据部分 ***********************************/
			request.setAttribute("list", newlist);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
			request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
			request.setAttribute("counts", counts);
			request.setAttribute(
					"allPage",
					counts % page_bean.getPageSize() == 0 ? (counts / page_bean
							.getPageSize())
							: (counts / page_bean.getPageSize()) + 1);
			request.setAttribute("comp_name", licenseDecForm.getComp_name());
			request.setAttribute("review_result",
					licenseDecForm.getReview_result());
			request.setAttribute("startDeclare_date",
					licenseDecForm.getStartDeclare_date());
			request.setAttribute("endDeclare_date",
					licenseDecForm.getEndDeclare_date());
		} catch (Exception e) {
			logger_.error("***********/xk/findReviewsSp************", e);
		} finally {
			map = null;
		}
		return "xk/reviewsSpList";
	}
	
	/**
	 * 许可证状态处理
	 * 
	 * @param request
	 * @param licenseDecForm
	 *            查询条件form
	 * @return
	 */
	@RequestMapping("/xkzDoStatus")
	public String xkzDoStatus(HttpServletRequest request,
			LicenseDecForm licenseDecForm) {
		Map<String, String> map = new HashMap<String, String>();
		try {
			/***************************** 分页列表查询部分 ***********************************/
			int pages = 1;
			if (request.getParameter("page") != null
					&& !"".equals(request.getParameter("page"))) {
				pages = Integer
						.parseInt(request.getParameter("page") == null ? "1"
								: request.getParameter("page"));
			}
			PageBean page_bean = new PageBean(pages,
					String.valueOf(Constants.PAGE_NUM));
			if (!StringUtils.isEmpty(licenseDecForm.getComp_name())) {
				map.put("comp_name", licenseDecForm.getComp_name());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getStartDeclare_date())) {
				map.put("startDeclare_date",
						licenseDecForm.getStartDeclare_date());
			}
			if (!StringUtils.isEmpty(licenseDecForm.getEndDeclare_date())) {
				map.put("endDeclare_date", licenseDecForm.getEndDeclare_date());
			}
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			
			List<LicenseDecDTO> list = null;
			int counts = 0;
			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
					Constants.USER_KEY);
			if(user != null){ 
				// 如果是管理员可以查看全部数据
				if(!StringUtils.isEmpty(user.getFlag_op()) 
					&& user.getManage_sign().equals("Y")){
					list = licenseDecDbService.findDoReviews(map);
					counts = licenseDecDbService.findDoReviewsCount(map);
				// 根据当前的单号和用户id查询对应的数据
				}else{
					map.put("userId", user.getId());
					list = licenseDecDbService.findDoReviews(map);
					counts = licenseDecDbService.findDoReviewsCount(map);
				}
			}
			/***************************** 页面el表达式传递数据部分 ***********************************/
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
			request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
			request.setAttribute("counts", counts);
			request.setAttribute(
					"allPage",
					counts % page_bean.getPageSize() == 0 ? (counts / page_bean
							.getPageSize())
							: (counts / page_bean.getPageSize()) + 1);
			request.setAttribute("comp_name", licenseDecForm.getComp_name());
			request.setAttribute("review_result",
					licenseDecForm.getReview_result());
			request.setAttribute("startDeclare_date",
					licenseDecForm.getStartDeclare_date());
			request.setAttribute("endDeclare_date",
					licenseDecForm.getEndDeclare_date());
		} catch (Exception e) {
			logger_.error("***********/xk/xkzDoStatus************", e);
		} finally {
			map = null;
		}
		return "xk/xkzDoStatusList";
	}
	
	/**
	 * 决定提交
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/doReview")
	public String doReview(HttpServletRequest request,
			@RequestParam("id") String id,
			@RequestParam("reviewResult") String reviewResult) {
		Map<String, String> map = new HashMap<String, String>();
		UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
				Constants.USER_KEY);
		map.put("id", id);
		map.put("jd_result", reviewResult);
		map.put("jd_user", user.getId());
		// 更新event表
		Map<String, String> eventmap = new HashMap<String, String>();
		eventmap.put("licence_id", request.getParameter("license_dno"));
		eventmap.put("status", "5");
		eventmap.put("opr_psn", user.getId());
		licenseDecDbService.insertEvent(eventmap);
		try {
			licenseDecDbService.doReview(map);
			licenseDecDbService.updateDStatus(request.getParameter("license_dno"),5);
		} catch (Exception e) {
			logger_.error("***********/xk/doReview************", e);
		} finally {
			map = null;
		}
		return "redirect:/xk/findReviews";
	}

	/**
	 * 决定审批
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/doReviewSp")
	public String doReviewSp(HttpServletRequest request,
			@RequestParam("id") String id,
			@RequestParam("sp_result") String sp_result) {
		Map<String, String> map = new HashMap<String, String>();
		UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
				Constants.USER_KEY);
		map.put("id", id);
		map.put("jd_sp", sp_result);

		// 更新event表
		Map<String, String> eventmap = new HashMap<String, String>();
		eventmap.put("licence_id", request.getParameter("license_dno"));
		eventmap.put("status", "6");
		eventmap.put("opr_psn", user.getId());
		licenseDecDbService.insertEvent(eventmap);
		try {
			licenseDecDbService.doReviewSp(map);
			licenseDecDbService.updateDStatus(request.getParameter("license_dno"), 6);
		} catch (Exception e) {
			logger_.error("***********/xk/doReviewSp************", e);
		} finally {
			map = null;
		}
		return "redirect:/xk/findReviewsSp";
	}

	/**
	 * 更新event表
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/insertEvent")
	public String insertEvent(HttpServletRequest request) {
		UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
				Constants.USER_KEY);
		Map<String, String> eventmap = new HashMap<String, String>();
		String type = request.getParameter("type");
		try {
		eventmap.put("licence_id", request.getParameter("license_dno"));
		eventmap.put("status", request.getParameter("status"));
		eventmap.put("opr_psn", user.getId());
		licenseDecDbService.insertEvent(eventmap);
        licenseDecDbService.updateDStatus(request.getParameter("license_dno"), Integer.valueOf(request.getParameter("status")));
		} catch (Exception e) {
			logger_.error("***********/xk/insertEvent************", e);
		} finally {
			eventmap = null;
		}
		if(type !=null && type.equals("bf")){
			return "redirect:/xk/bfList";
		}else{
			return "redirect:/dc/getLicenseDecs2";
		}
		
	}
		
	/**
	 * 更新event表
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/insertEvent2")
	public String insertEvent2(HttpServletRequest request) {
		UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
				Constants.USER_KEY);
		Map<String, String> eventmap = new HashMap<String, String>();
		try {
		eventmap.put("licence_id", request.getParameter("license_dno"));
		eventmap.put("status", request.getParameter("status"));
		eventmap.put("opr_psn", user.getId());
		licenseDecDbService.insertEvent(eventmap);
		 licenseDecDbService.updateDStatus(request.getParameter("license_dno"), Integer.valueOf(request.getParameter("status")));
		} catch (Exception e) {
			logger_.error("***********/xk/insertEvent************", e);
		} finally {
			eventmap = null;
		}
		return "redirect:/xk/bfList";
	}
	
	/**
	 * 跳转至准予许可决定书
	 * 
	 * @param comp_name
	 * @param legal_name
	 * @param management_addr
	 * @param declare_date
	 * @param approval_date
	 * @return
	 */
	@RequestMapping("/zyjdsShowOld")
	public String zyjdsShowOld(HttpServletRequest  request, HttpServletResponse response,
			@RequestParam("id") String id,
			@RequestParam("comp_name") String comp_name,
			@RequestParam("legal_name") String legal_name,
			@RequestParam("management_addr") String management_addr,
			@RequestParam("declare_date") String declare_date,
			@RequestParam("approval_date") String approval_date,
			Model model) {
		Map<String,String> map = new HashMap<String,String>();
    	map.put("id", id);
    	List<LicenseDecDTO> list=licenseDecDbService.findLicenseDecsList(map);
    	if(!list.isEmpty()){
    		model.addAttribute("comp_name",list.get(0).getComp_name());
        	model.addAttribute("legal_name",list.get(0).getLegal_name());
        	model.addAttribute("management_addr",list.get(0).getManagement_addr());
        	model.addAttribute("contacts_name",list.get(0).getContacts_name());
        	model.addAttribute("contacts_phone",list.get(0).getContacts_phone());
        	model.addAttribute("certificate_numver",list.get(0).getCertificate_numver());
        	model.addAttribute("declare_date", list.get(0).getDeclare_date());
    		model.addAttribute("approval_date", list.get(0).getApproval_date());
    		model.addAttribute("license_dno",list.get(0).getLicense_dno()); 
    		model.addAttribute("wstdo",list.get(0)); 
    		CheckDocsRcdModel dto=new CheckDocsRcdModel();
    		dto.setProcMainId(list.get(0).getLicense_dno());
    		dto.setDocType("D_SQ_SL");
    		List<CheckDocsRcdModel> doclist = origPlaceFlowService.getOptionList(dto);
    		if(!doclist.isEmpty()){
    			model.addAttribute("doc",doclist.get(0)); 
    		}
    	}else{
    		model.addAttribute("comp_name", comp_name);
    		model.addAttribute("legal_name", legal_name);
    		model.addAttribute("management_addr", management_addr);
    		model.addAttribute("declare_date", declare_date);
    		model.addAttribute("approval_date", approval_date);
    		model.addAttribute("comp_addr", request.getParameter("comp_addr"));
    	}
    	CheckDocsRcdModel dto=new CheckDocsRcdModel();
    	// 查询营业执照记录
    	dto.setProcMainId(list.get(0).getLicense_dno());
		dto.setDocType("D_SL_GZ");
		List<CheckDocsRcdModel> doclist = origPlaceFlowService.getOptionList(dto);
		if(!doclist.isEmpty()){
			dto = (CheckDocsRcdModel) doclist.get(0);
			model.addAttribute("yezz",dto.getOption22()); 
		}
    	String urltype = request.getParameter("urltype");
    	if(urltype !=null && urltype.equals("dc")){
    		return "/dc/zyjdsEdit";
    	}else{
    		return "/xk/zyjdsEdit";
    	}
	}
	
	/**
	 * 跳转至准予许可决定书
	 * 
	 * @param comp_name
	 * @param legal_name
	 * @param management_addr
	 * @param declare_date
	 * @param approval_date
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/zyjdsShow")
	public String zyjdsShow(HttpServletRequest  request, HttpServletResponse response,Model model,
			@RequestParam("id") String id,
			String comp_name,
			String legal_name,
			String management_addr,
			String declare_date,
			String approval_date) {
		Map<String,String> map = new HashMap<String,String>();
    	map.put("id", id);
    	List<LicenseDecDTO> list=licenseDecDbService.findLicenseDecsList(map);
    	if(!list.isEmpty()){
    		CheckDocsRcdModel dto=new CheckDocsRcdModel();
    		dto.setProcMainId(list.get(0).getLicense_dno());
    		dto.setDocType("D_SQ_SL");
    		String TemplatePDF = Constants.D_SQ_SL;
    		this.toPrintPlanNote(request,response,dto,TemplatePDF,dto.getDocType(),false);
    	}
		// TODO 准予许可决定
		return "/xk/zyjds";
	}

	/**
	 * 跳转至不予许可决定书 旧样式
	 * 
	 * @param comp_name
	 * @param legal_name
	 * @param management_addr
	 * @param declare_date
	 * @param approval_date
	 * @return
	 */
	@RequestMapping("/byjdsShowOld")
	public String byjdsShowOld(HttpServletRequest  request, HttpServletResponse response,Model model,
			@RequestParam("id") String id,
			@RequestParam("comp_name") String comp_name,
			@RequestParam("legal_name") String legal_name,
			@RequestParam("management_addr") String management_addr,
			@RequestParam("declare_date") String declare_date,
			@RequestParam("approval_date") String approval_date) {
		Map<String,String> map = new HashMap<String,String>();
    	map.put("id", id);
    	List<LicenseDecDTO> list=licenseDecDbService.findLicenseDecsList(map);
    	if(!list.isEmpty()){
    		model.addAttribute("comp_name",list.get(0).getComp_name());
        	model.addAttribute("legal_name",list.get(0).getLegal_name());
        	model.addAttribute("management_addr",list.get(0).getManagement_addr());
        	model.addAttribute("contacts_name",list.get(0).getContacts_name());
        	model.addAttribute("contacts_phone",list.get(0).getContacts_phone());
        	model.addAttribute("certificate_numver",list.get(0).getCertificate_numver());
        	model.addAttribute("declare_date", list.get(0).getDeclare_date());
    		model.addAttribute("approval_date", list.get(0).getApproval_date());
    		model.addAttribute("license_dno",list.get(0).getLicense_dno()); 
    		model.addAttribute("wstdo",list.get(0)); 
    		CheckDocsRcdModel dto=new CheckDocsRcdModel();
    		dto.setProcMainId(list.get(0).getLicense_dno());
    		dto.setDocType("D_BU_SL");
    		List<CheckDocsRcdModel> doclist = origPlaceFlowService.getOptionList(dto);
    		if(!doclist.isEmpty()){
    			model.addAttribute("doc",doclist.get(0)); 
    		}
    	}else{
    		model.addAttribute("comp_name", comp_name);
    		model.addAttribute("legal_name", legal_name);
    		model.addAttribute("management_addr", management_addr);
    		model.addAttribute("declare_date", declare_date);
    		model.addAttribute("approval_date", approval_date);
    	}
    	CheckDocsRcdModel dto=new CheckDocsRcdModel();
    	// 查询营业执照记录
    	dto.setProcMainId(list.get(0).getLicense_dno());
		dto.setDocType("D_SL_GZ");
		List<CheckDocsRcdModel> doclist = origPlaceFlowService.getOptionList(dto);
		if(!doclist.isEmpty()){
			dto = (CheckDocsRcdModel) doclist.get(0);
			model.addAttribute("yezz",dto.getOption22()); 
		}
    	String urltype = request.getParameter("urltype");
    	if(urltype !=null && urltype.equals("dc")){
    		return "/dc/byjdsEdit";
    	}else{
    		return "/xk/byjdsEdit";
    	}
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/byjdsShow")
	public void byjdsShow(HttpServletRequest  request, HttpServletResponse response,Model model,
			@RequestParam("id") String id) {
		Map<String,String> map = new HashMap<String,String>();
    	map.put("id", id);
    	List<LicenseDecDTO> list=licenseDecDbService.findLicenseDecsList(map);
    	if(!list.isEmpty()){
    		CheckDocsRcdModel dto=new CheckDocsRcdModel();
    		dto.setProcMainId(list.get(0).getLicense_dno());
    		dto.setDocType("D_BU_SL");
    		String TemplatePDF = Constants.D_BU_SL;
    		this.toPrintPlanNote(request,response,dto,TemplatePDF,dto.getDocType(),false);
    	}
	}
	
	/**
	 * 跳转至不予许可决定书盖章
	 * 
	 * @param comp_name
	 * @param legal_name
	 * @param management_addr
	 * @param declare_date
	 * @param approval_date
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/byjdsShowGz")
	public String byjdsShowGz(HttpServletRequest  request, HttpServletResponse response,Model model,
			@RequestParam("id") String id) {
		Map<String,String> map = new HashMap<String,String>();
    	map.put("id", id);
    	List<LicenseDecDTO> list=licenseDecDbService.findLicenseDecsList(map);
    	if(!list.isEmpty()){
    		CheckDocsRcdModel dto=new CheckDocsRcdModel();
    		dto.setProcMainId(list.get(0).getLicense_dno());
    		dto.setDocType("D_BU_SL");
    		String TemplatePDF = Constants.D_BU_SL;
    		String fileName = this.printPlanNoteGz(request,response,dto,TemplatePDF,dto.getDocType());
    		try{
    			String orgtype = commonServer.getOrgType(request, Constants.SEAL_PDF_TYPE[0]);
    			Boolean bo=ElectronicSealUtil.getElectronicSealPDF(fileName, orgtype);
    			if(bo){
    				this.toPrintPlanNote(request,response,null,fileName,"",true);
    				// 调用局端上传接口
        			Map queryMap = new HashMap();
        			queryMap.put("type", "XKZFILEOUT");
        			String ciqsip = commonServer.getCiqsIp(queryMap);
        			sendPost("http://"+ciqsip+"/ciqs-dec/apps/saveUpload?type=2", new File(fileName));
    			}else{
    				response.setHeader("Content-type","text/html;charset=UTF-8");//向浏览器发送一个响应头，设置浏览器的解码方式为UTF-8  
    				String data = "<script language='javascript'>alert('电子盖章失败');</script>";  
    				OutputStream stream = response.getOutputStream();  
    				stream.write(data.getBytes("UTF-8")); 
    			}
    		}catch (Exception e) {
    			e.printStackTrace();
    		}
    	}
		//TODO 不予受理决定
		return "/xk/byjds";
	}

	/**
	 * 验证下载文件是否存在
	 * 
	 * @param request
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/validFile")
	public Map<String, Object> videoFileEventList(
			HttpServletRequest request,
			@RequestParam(value = "license_dno", required = true) String license_dno,
			@RequestParam(value = "file_type", required = true) String file_type) {
		Map<String, String> map = new HashMap<String, String>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			map.put("license_dno", license_dno);
			map.put("file_type", file_type);
			String path = licenseDecDbService.getFilePath(map);
			resultMap.put("path", path);
		} catch (Exception e) {

			logger_.error("***********/mail/toMailObjCheckDetail************",
					e);
		}
		return resultMap;
	}

	/**
	 * 文件下载
	 * 
	 * @param path
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/downloadFile")
	public void downloadFile(String path, HttpServletRequest request,
			HttpServletResponse servletResponse) {
		try {
			FileUtil.downXkloadFile(path, servletResponse);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 评审文件上传
	 * 
	 * @param request
	 * @param id
	 * @return
	 */
	@RequestMapping("/uploadFile")
	public String saveFileVideoOrImg(HttpServletRequest request,
			@RequestParam("license_dno") String license_dno) {
		try {
			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
    				Constants.USER_KEY);
			String filePath = "";
			// 把文件保存到硬盘上
			List<Map<String, String>> filePaths = FileUtil.upXkloadFile(request,false);
			if (filePaths != null && filePaths.size() > 0) {
				Map<String, String> map = (Map) filePaths.get(0);
				filePath = map.get("filePath");
			}
			// 把文件的路径信息保存到数据库中
			VideoEventModel video = new VideoEventModel();
			video.setProcMainId(license_dno);
			video.setFileName(filePath);
			video.setFileType("6");
			video.setProcType("");
			String default_org_code = "DLGWBSC";
			String orgcode = getOrgCode(user,default_org_code);
			video.setPortOrgCode(orgcode);// 分支局
			video.setPortDeptCode(orgcode);// 科室
			video.setCreateDate(DateUtil.newDate());
			video.setCreateUser(user.getId());// 人员
			commonServer.save(video);
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		try {

		} catch (Exception e) {

			logger_.error("***********/mail/saveFileVideoOrImg************", e);
		}
		return "redirect:/xk/findReviews";
	}
	
	public String getOrgCode(UserInfoDTO user,String defaultOrgCode){
		Map<String, Object> orgMap = new HashMap<String, Object>();
		orgMap.put("org_code", user.getOrg_code());
		if(!StringUtils.isEmpty(user.getOrg_code())){
			String fzOrgCode = commonServer.getDzOrgName(orgMap);
			if(!StringUtils.isEmpty(fzOrgCode)){
				return fzOrgCode;
			}
		}
		return defaultOrgCode;
	}
	
	/**
	 * 决定doc提交方法
	 * @param request
	 * @param checkDocsRcd
	 * @return
	 */
	@RequestMapping(value = "/submitDoc" ,method = RequestMethod.POST)
	public String submitDoc(HttpServletRequest request,CheckDocsRcdModel checkDocsRcd,RedirectAttributes attr) {
		try {
			if(com.dpn.ciqqlc.common.util.StringUtils.isEmpty(checkDocsRcd.getDocId())){
				commonServer.insertDocs(checkDocsRcd);
			}else{
				commonServer.updateDocs(checkDocsRcd);
			}
			attr.addFlashAttribute("msg","success");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:findReviews";
	}
	
	/**
	 * 受理doc提交方法
	 * @param request
	 * @param checkDocsRcd
	 * @return
	 */
	@RequestMapping(value = "/submitslDoc" ,method = RequestMethod.POST)
	public String submitslDoc(HttpServletRequest request,CheckDocsRcdModel checkDocsRcd,RedirectAttributes attr) {
		try {
			if(com.dpn.ciqqlc.common.util.StringUtils.isEmpty(checkDocsRcd.getDocId())){
				commonServer.insertDocs(checkDocsRcd);
			}else{
				commonServer.updateDocs(checkDocsRcd);
			}
			attr.addFlashAttribute("msg","success");
		} catch (Exception e) {
			e.printStackTrace();
		}
		String findForwardUrl ="";
		//受理决定书页面
		if(checkDocsRcd.getDocType().equals("D_SL_GZ")){
			findForwardUrl = "xk/slgzsEdit";
		//不予受理决定书页面
		}else if(checkDocsRcd.getDocType().equals("D_BY_GZ")){
			findForwardUrl = "xk/byslsEdit";
		}else if(checkDocsRcd.getDocType().equals("D_BY_GZ2")){
			findForwardUrl = "xk/byslsEdit2";
		}else if(checkDocsRcd.getDocType().equals("D_SQ_BZ")){
			findForwardUrl = "xk/bzgzsEdit";
		}else if(checkDocsRcd.getDocType().equals("D_SQ_SHRY")){
			findForwardUrl = "xk/psyEdit";
		}else if(checkDocsRcd.getDocType().equals("D_BU_SL")){
			findForwardUrl = "xk/byjdsEdit";
		}else if(checkDocsRcd.getDocType().equals("D_SQ_SL")){
			findForwardUrl = "xk/zyjdsEdit";
		}else if(checkDocsRcd.getDocType().equals("D_PT_H_L_12")){
			findForwardUrl = "cp/lookbook";
		}else if(checkDocsRcd.getDocType().equals("D_SQS")){
			findForwardUrl = "xk/printHjkanWs";
		}else{
			findForwardUrl = "xk/bzsEdit";				
		}
		request.setAttribute("doc", checkDocsRcd);
		request.setAttribute("ok", "ok");
		//return "redirect:findReviews";
		return findForwardUrl;
		//return "redirect:findLicenseDecs";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/passResult" ,method = RequestMethod.GET)
	public void passResult(HttpServletRequest request,HttpServletResponse response,CheckDocsRcdModel dto) {
		try {
			List<CheckDocsRcdModel> list = origPlaceFlowService.getOptionList(dto);
			String templatePDF=getTemplatePDF(dto.getDocType());
			dto.setOption80("1");
			dto.setDocId(list.get(0).getDocId());
			commonServer.updateDocs(dto);
			String fileName = this.toPrintFile(request,response,dto,templatePDF,dto.getDocType());
			String orgtype = commonServer.getOrgType(request, Constants.SEAL_PDF_TYPE[0]);
    		Boolean bo=ElectronicSealUtil.getElectronicSealPDF(fileName, orgtype);
    		if(bo){
    			this.toPrintPlanNote(request,response,dto,fileName,dto.getDocType(),true);
    			// 调用局端上传接口
    			Map queryMap = new HashMap();
    			queryMap.put("type", "XKZFILEOUT");
    			String ciqsip = commonServer.getCiqsIp(queryMap);
    			sendPost("http://"+ciqsip+"/ciqs-dec/apps/saveUpload?type=2", new File(fileName));
    		}else{
    			response.setHeader("Content-type","text/html;charset=UTF-8");//向浏览器发送一个响应头，设置浏览器的解码方式为UTF-8  
				String data = "<script language='javascript'>alert('电子盖章失败');</script>";  
				OutputStream stream = response.getOutputStream();  
				stream.write(data.getBytes("UTF-8")); 
    		}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/downFile")
	public void downFile(HttpServletRequest request,HttpServletResponse response,@RequestParam("fileName") String fileName) throws Exception {
		this.toPrintPlanNote(request,response,null,fileName,"",true);
	}
	
	@ResponseBody
	@RequestMapping(value = "/getResult" ,method = RequestMethod.GET)
	public Map<String, Object> getResult(HttpServletRequest request,HttpServletResponse response,CheckDocsRcdModel dto) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			List<CheckDocsRcdModel> list = origPlaceFlowService.getOptionList(dto);
			if(list.isEmpty()){
				map.put("status", "FALL");
				map.put("results", "数据未提交无法处理");
			}else{
				map.put("status", "OK");
				map.put("results", list.get(0));
			}
			return map;
		} catch (Exception e) {
			map.put("status", "FALL");
			map.put("results","失败");
			e.printStackTrace();
		}
		return map;
	}

	@ResponseBody
	@RequestMapping(value = "/getResult2" ,method = RequestMethod.GET)
	public Map<String, Object> getResult2(HttpServletRequest request,HttpServletResponse response,CheckDocsRcdModel dto) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			List<CheckDocsRcdModel> list = origPlaceFlowService.getOptionList(dto);
			if(list.isEmpty()){
				map.put("status", "FALL");
				map.put("results", "0");
			}else{
				map.put("status", "OK");
				map.put("results", (list.get(0)).getOption20());
			}
			return map;
		} catch (Exception e) {
			map.put("status", "FALL");
			map.put("results","失败");
			e.printStackTrace();
		}
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value = "/getResult3" ,method = RequestMethod.GET)
	public Map<String, Object> getResult3(HttpServletRequest request,HttpServletResponse response,CheckDocsRcdModel dto) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			Map<String,String> map2 = new HashMap<String,String>();
			map2.put("licence_id", request.getParameter("ProcMainId"));
			map2.put("doc_type",request.getParameter("DocType"));
			List seallist = licenseDecDbService.getSealList(map2);
			if(seallist.isEmpty()){
				map.put("status", "FALL");
				map.put("results", "数据未提交无法处理");
			}else{
				map.put("status", "OK");
				map.put("results", seallist.get(0));
			}
			return map;
		} catch (Exception e) {
			map.put("status", "FALL");
			map.put("results","失败");
			e.printStackTrace();
		}
		return map;
	}
	
	private String getTemplatePDF(String parameter) {
		if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(parameter) && parameter.equals("D_SQ_BZ")){
			return  Constants.D_SQ_BZ;
		}
		if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(parameter) && parameter.equals("D_BU_SL")){
			return  Constants.D_BU_SL;
		}
		if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(parameter) && parameter.equals("D_SL_GZ")){
			return  Constants.D_SL_GZ;
		}
		if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(parameter) && parameter.equals("D_BY_GZ")){
			return  Constants.D_BY_GZ;
		}
		if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(parameter) && parameter.equals("D_BY_GZ2")){
			return  Constants.D_BY_GZ;
		}
		if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(parameter) && parameter.equals("D_SQ_SL")){
			return  Constants.D_SQ_SL;
		}
		return null;
	}

	@Override
	protected void formSet(HttpServletRequest request,PdfStamper stamper,AcroFields acroform,Object t,String actionType) {
		CheckDocsRcdModel dto=(CheckDocsRcdModel) t;
		if(StringUtils.isNotEmpty(actionType) && actionType.equals("D_SQS")){
			try {
				Map map = new HashMap();
				map.put("license_dno", dto.getProcMainId());
				LicenseDecDTO queryDto = this.declareService.getLicenseDec(map);
				acroform.setField("hygiene_license_number",queryDto.getHygiene_license_number());
				acroform.setField("declare_date",DateUtil.DateToString(queryDto.getDeclare_date(),"yyyy-MM-dd HH:mm:ss"));
				acroform.setField("comp_name",queryDto.getComp_name());
				acroform.setField("apply_type",queryDto.getApply_type());
				acroform.setField("apply_scope",queryDto.getApply_scope());
				if(queryDto.getCertificate_numver().equals("1")){
					acroform.setField("certificate_numver","是");
				}else{
					acroform.setField("certificate_numver","否");
				}
				acroform.setField("comp_addr",queryDto.getComp_addr());
				acroform.setField("comp_code",queryDto.getComp_code());
				acroform.setField("contacts_name",queryDto.getContacts_name());
				acroform.setField("mailbox",queryDto.getMailbox());
				acroform.setField("management_addr",queryDto.getManagement_addr());
				acroform.setField("management_area",queryDto.getManagement_area());
				acroform.setField("legal_name",queryDto.getLegal_name());
				acroform.setField("contacts_phone",queryDto.getContacts_phone());
				acroform.setField("fax",queryDto.getFax());
				acroform.setField("employee_num",queryDto.getEmployee_num());
				Calendar c = Calendar.getInstance();
				c.setTime(queryDto.getDeclare_date());
				int yyyy = c.get(Calendar.YEAR);
				int MM = c.get(Calendar.MONTH)+1;
				int dd = c.get(Calendar.DATE);
				acroform.setField("yyyy",String.valueOf(yyyy));
				acroform.setField("mm",String.valueOf(MM));
				acroform.setField("dd",String.valueOf(dd));
				if(queryDto.getManagement_type() != null ){ 
					if(queryDto.getManagement_type().indexOf(",") !=-1){
							String[] arr = queryDto.getManagement_type().split(",");
							for (int j = 0; j < arr.length; j++) {
								if (queryDto.getManagement_type() != null && arr[j].equals("1")) {
									acroform.setField("box1","1");
				                }else if(queryDto.getManagement_type()!=null && arr[j].equals("2")){
				                	acroform.setField("box2","2");
				                }else if(queryDto.getManagement_type()!=null && arr[j].equals("3")){
				                	acroform.setField("box3","3");
				                }else if(queryDto.getManagement_type()!=null && arr[j].equals("4")){
				                	acroform.setField("box4","4");
				                }else {
				                	acroform.setField("box5","5");
				                }
							}
						
					}else{
						
						if (queryDto.getManagement_type().equals("1")) {
							acroform.setField("box1","1");
		                }else if(queryDto.getManagement_type().equals("2")){
		                	acroform.setField("box2","2");
		                }else if(queryDto.getManagement_type().equals("3")){
		                	acroform.setField("box3","3");
		                }else if(queryDto.getManagement_type().equals("4")){
		                	acroform.setField("box4","4");
		                }else {
		                	acroform.setField("box5","5");
		                }
					}					
				}
			} catch (IOException | DocumentException e) {
				e.printStackTrace();
			}
		}
		List<CheckDocsRcdModel> list = origPlaceFlowService.getOptionList(dto);
		if(!(StringUtils.isEmpty(actionType) || list.isEmpty())){
			try {
				acroform.setField("Option1", list.get(0).getOption1()==null?"":list.get(0).getOption1());
				acroform.setField("Option2", list.get(0).getOption2()==null?"":list.get(0).getOption2());
				acroform.setField("Option3", list.get(0).getOption3()==null?"":list.get(0).getOption3());
				acroform.setField("Option4", list.get(0).getOption4()==null?"":list.get(0).getOption4());
				acroform.setField("Option5", list.get(0).getOption5()==null?"":list.get(0).getOption5());
				acroform.setField("Option6", list.get(0).getOption6()==null?"":list.get(0).getOption6());
				acroform.setField("Option7", list.get(0).getOption7()==null?"":list.get(0).getOption7());
				acroform.setField("Option8", list.get(0).getOption8()==null?"":list.get(0).getOption8());
				acroform.setField("Option9", list.get(0).getOption9()==null?"":list.get(0).getOption9());
				acroform.setField("Option10", list.get(0).getOption10()==null?"":list.get(0).getOption10());
				acroform.setField("Option11", list.get(0).getOption11()==null?"":list.get(0).getOption11());
				acroform.setField("Option12", list.get(0).getOption12()==null?"":list.get(0).getOption12());
				acroform.setField("Option13", list.get(0).getOption13()==null?"":list.get(0).getOption13());
				acroform.setField("Option14", list.get(0).getOption14()==null?"":list.get(0).getOption14());
				acroform.setField("Option15", list.get(0).getOption15()==null?"":list.get(0).getOption15());
				acroform.setField("Option16", list.get(0).getOption16()==null?"":list.get(0).getOption16());
				acroform.setField("Option17", list.get(0).getOption17()==null?"":list.get(0).getOption17());
				acroform.setField("Option18", list.get(0).getOption18()==null?"":list.get(0).getOption18());
				acroform.setField("Option19", list.get(0).getOption19()==null?"":list.get(0).getOption19());
				acroform.setField("Option20", list.get(0).getOption20()==null?"":list.get(0).getOption20());
				acroform.setField("Option21", list.get(0).getOption21()==null?"":list.get(0).getOption21());
				acroform.setField("Option22", list.get(0).getOption22()==null?"":list.get(0).getOption22());
				acroform.setField("Option23", list.get(0).getOption23()==null?"":list.get(0).getOption23());
				acroform.setField("Option24", list.get(0).getOption24()==null?"":list.get(0).getOption24());
				acroform.setField("Option25", list.get(0).getOption25()==null?"":list.get(0).getOption25());
				acroform.setField("Option26", list.get(0).getOption26()==null?"":list.get(0).getOption26());
				acroform.setField("Option27", list.get(0).getOption27()==null?"":list.get(0).getOption27());
				acroform.setField("Option28", list.get(0).getOption28()==null?"":list.get(0).getOption28());
				acroform.setField("Option29", list.get(0).getOption29()==null?"":list.get(0).getOption29());
				acroform.setField("Option30", list.get(0).getOption30()==null?"":list.get(0).getOption30());
				acroform.setField("Option31", list.get(0).getOption31()==null?"":list.get(0).getOption31());
				acroform.setField("Option32", list.get(0).getOption32()==null?"":list.get(0).getOption32());
				acroform.setField("Option33", list.get(0).getOption33()==null?"":list.get(0).getOption33());
				acroform.setField("Option34", list.get(0).getOption34()==null?"":list.get(0).getOption34());
				acroform.setField("Option35", list.get(0).getOption35()==null?"":list.get(0).getOption35());
				acroform.setField("Option36", list.get(0).getOption36()==null?"":list.get(0).getOption36());
				acroform.setField("Option37", list.get(0).getOption37()==null?"":list.get(0).getOption37());
				acroform.setField("Option38", list.get(0).getOption38()==null?"":list.get(0).getOption38());
				acroform.setField("Option39", list.get(0).getOption39()==null?"":list.get(0).getOption39());
				acroform.setField("Option40", list.get(0).getOption40()==null?"":list.get(0).getOption40());
				acroform.setField("Option41", list.get(0).getOption41()==null?"":list.get(0).getOption41());
				acroform.setField("Option42", list.get(0).getOption42()==null?"":list.get(0).getOption42());
				acroform.setField("Option43", list.get(0).getOption43()==null?"":list.get(0).getOption43());
				acroform.setField("Option44", list.get(0).getOption44()==null?"":list.get(0).getOption44());
				acroform.setField("Option45", list.get(0).getOption45()==null?"":list.get(0).getOption45());
				acroform.setField("Option46", list.get(0).getOption46()==null?"":list.get(0).getOption46());
				acroform.setField("Option47", list.get(0).getOption47()==null?"":list.get(0).getOption47());
				acroform.setField("Option48", list.get(0).getOption48()==null?"":list.get(0).getOption48());
				acroform.setField("Option49", list.get(0).getOption49()==null?"":list.get(0).getOption49());
				acroform.setField("Option50", list.get(0).getOption50()==null?"":list.get(0).getOption50());
				acroform.setField("Option51", list.get(0).getOption51()==null?"":list.get(0).getOption51());
				acroform.setField("Option52", list.get(0).getOption52()==null?"":list.get(0).getOption52());
				acroform.setField("Option53", list.get(0).getOption53()==null?"":list.get(0).getOption53());
				acroform.setField("Option54", list.get(0).getOption54()==null?"":list.get(0).getOption54());
				acroform.setField("Option55", list.get(0).getOption55()==null?"":list.get(0).getOption55());
				acroform.setField("Option56", list.get(0).getOption56()==null?"":list.get(0).getOption56());
				acroform.setField("Option57", list.get(0).getOption57()==null?"":list.get(0).getOption57());
				acroform.setField("Option58", list.get(0).getOption58()==null?"":list.get(0).getOption58());
				acroform.setField("Option59", list.get(0).getOption59()==null?"":list.get(0).getOption59());
				acroform.setField("Option60", list.get(0).getOption60()==null?"":list.get(0).getOption60());
				acroform.setField("Option80", list.get(0).getOption80()==null?"":list.get(0).getOption80());
				/*if(actionType.equals("D_SQ_BZ")){//申请材料补正告知书
					acroform.setField("Option1", list.get(0).getOption1());
					acroform.setField("Option2", list.get(0).getOption2());
					acroform.setField("Option3", list.get(0).getOption3());
					acroform.setField("Option4", list.get(0).getOption4());
					acroform.setField("Option5", list.get(0).getOption5());
					acroform.setField("Option6", list.get(0).getOption6());
					acroform.setField("Option7", list.get(0).getOption7());
					acroform.setField("Option8", list.get(0).getOption8());
					acroform.setField("Option9", list.get(0).getOption9());
					acroform.setField("Option10", list.get(0).getOption10());
					acroform.setField("Option11", list.get(0).getOption11());
					acroform.setField("Option12", list.get(0).getOption12());
					acroform.setField("Option13", list.get(0).getOption13());
					acroform.setField("Option14", list.get(0).getOption14());
					acroform.setField("Option15", list.get(0).getOption15());
					acroform.setField("Option16", list.get(0).getOption16());
					acroform.setField("Option17", list.get(0).getOption17());
					acroform.setField("Option18", list.get(0).getOption18());
					acroform.setField("Option19", list.get(0).getOption19());
					acroform.setField("Option20", list.get(0).getOption20());
					acroform.setField("Option21", list.get(0).getOption21());
				}else if(actionType.equals("D_BY_GZ")){//不予受理告知书
					acroform.setField("Option1", list.get(0).getOption1());
					acroform.setField("Option2", list.get(0).getOption2());
					acroform.setField("Option3", list.get(0).getOption3());
					acroform.setField("Option4", list.get(0).getOption4());
					acroform.setField("Option5", list.get(0).getOption5());
					acroform.setField("Option6", list.get(0).getOption6());
					acroform.setField("Option7", list.get(0).getOption7());
					acroform.setField("Option8", list.get(0).getOption8());
					acroform.setField("Option9", list.get(0).getOption9());
					acroform.setField("Option10", list.get(0).getOption10());
					acroform.setField("Option11", list.get(0).getOption11());
					acroform.setField("Option12", list.get(0).getOption12());
					acroform.setField("Option13", list.get(0).getOption13());
				}else if(actionType.equals("D_BU_SL")){//不予受理决定书
					acroform.setField("Option1", list.get(0).getOption1());
					acroform.setField("Option2", list.get(0).getOption2());
					acroform.setField("Option3", list.get(0).getOption3());
					acroform.setField("Option4", list.get(0).getOption4());
					acroform.setField("Option5", list.get(0).getOption5());
					acroform.setField("Option6", list.get(0).getOption6());
					acroform.setField("Option7", list.get(0).getOption7());
					acroform.setField("Option8", list.get(0).getOption8());
					acroform.setField("Option9", list.get(0).getOption9());
					acroform.setField("Option10", list.get(0).getOption10());
					acroform.setField("Option11", list.get(0).getOption11());
					acroform.setField("Option12", list.get(0).getOption12());
					acroform.setField("Option13", list.get(0).getOption13());
					acroform.setField("Option14", list.get(0).getOption14());
					acroform.setField("Option15", list.get(0).getOption15());
					acroform.setField("Option16", list.get(0).getOption16());
					acroform.setField("Option17", list.get(0).getOption17());
					acroform.setField("Option18", list.get(0).getOption18());
					acroform.setField("Option19", list.get(0).getOption19());
					acroform.setField("Option20", list.get(0).getOption20());
					acroform.setField("Option21", list.get(0).getOption21());
					acroform.setField("Option22", list.get(0).getOption22());
					acroform.setField("Option23", list.get(0).getOption23());
					acroform.setField("Option24", list.get(0).getOption24());
				}else if(actionType.equals("D_SL_GZ")){//申请受理告知书
					acroform.setField("Option1", list.get(0).getOption1());
					acroform.setField("Option2", list.get(0).getOption2());
					acroform.setField("Option3", list.get(0).getOption3());
					acroform.setField("Option4", list.get(0).getOption4());
					acroform.setField("Option5", list.get(0).getOption5());
					acroform.setField("Option6", list.get(0).getOption6());
					acroform.setField("Option7", list.get(0).getOption7());
					acroform.setField("Option8", list.get(0).getOption8());
					acroform.setField("Option9", list.get(0).getOption9());
					acroform.setField("Option10", list.get(0).getOption10());
					acroform.setField("Option11", list.get(0).getOption11());
					acroform.setField("Option12", list.get(0).getOption12());
					acroform.setField("Option13", list.get(0).getOption13());
					acroform.setField("Option14", list.get(0).getOption14());
					acroform.setField("Option15", list.get(0).getOption15());
					acroform.setField("Option16", list.get(0).getOption16());
					acroform.setField("Option17", list.get(0).getOption17());
					acroform.setField("Option18", list.get(0).getOption18());
					acroform.setField("Option19", list.get(0).getOption19());
					acroform.setField("Option20", list.get(0).getOption20());
					acroform.setField("Option21", list.get(0).getOption21());
				}else if(actionType.equals("D_SQ_SL")){//申请受理决定书
					acroform.setField("Option1", list.get(0).getOption1());
					acroform.setField("Option2", list.get(0).getOption2());
					acroform.setField("Option3", list.get(0).getOption3());
					acroform.setField("Option4", list.get(0).getOption4());
					acroform.setField("Option5", list.get(0).getOption5());
					acroform.setField("Option6", list.get(0).getOption6());
					acroform.setField("Option7", list.get(0).getOption7());
					acroform.setField("Option8", list.get(0).getOption8());
					acroform.setField("Option9", list.get(0).getOption9());
					acroform.setField("Option10", list.get(0).getOption10());
					acroform.setField("Option11", list.get(0).getOption11());
					acroform.setField("Option12", list.get(0).getOption12());
					acroform.setField("Option13", list.get(0).getOption13());
					acroform.setField("Option14", list.get(0).getOption14());
					acroform.setField("Option15", list.get(0).getOption15());
					acroform.setField("Option16", list.get(0).getOption16());
					acroform.setField("Option17", list.get(0).getOption17());
					acroform.setField("Option18", list.get(0).getOption18());
					acroform.setField("Option19", list.get(0).getOption19());
					acroform.setField("Option20", list.get(0).getOption20());
					acroform.setField("Option21", list.get(0).getOption21());
					acroform.setField("Option22", list.get(0).getOption22());
					acroform.setField("Option23", list.get(0).getOption23());
				}else if(actionType.equals("D_SDHZ") || actionType.equals("D_SDHZ2")
						|| actionType.equals("D_SDHZ3") || actionType.equals("D_SDHZ4")
						|| actionType.equals("D_PT_H_L_13")){//申请受理决定书
					acroform.setField("Option1", list.get(0).getOption1());
					acroform.setField("Option2", list.get(0).getOption2());
					acroform.setField("Option3", list.get(0).getOption3());
					acroform.setField("Option4", list.get(0).getOption4());
					acroform.setField("Option5", list.get(0).getOption5());
					acroform.setField("Option6", list.get(0).getOption6());
					acroform.setField("Option7", list.get(0).getOption7());
					acroform.setField("Option8", list.get(0).getOption8());
					acroform.setField("Option9", list.get(0).getOption9());
					acroform.setField("Option10", list.get(0).getOption10());
					acroform.setField("Option11", list.get(0).getOption11());
					acroform.setField("Option12", list.get(0).getOption12());
					acroform.setField("Option13", list.get(0).getOption13());
					acroform.setField("Option14", list.get(0).getOption14());
					acroform.setField("Option15", list.get(0).getOption15());
					acroform.setField("Option16", list.get(0).getOption16());
					acroform.setField("Option17", list.get(0).getOption17());
					acroform.setField("Option18", list.get(0).getOption18());
					acroform.setField("Option19", list.get(0).getOption19());
					acroform.setField("Option20", list.get(0).getOption20());
					acroform.setField("Option21", list.get(0).getOption21());
					acroform.setField("Option22", list.get(0).getOption22());
					acroform.setField("Option23", list.get(0).getOption23());
				}*/
			} catch (IOException e) {
				e.printStackTrace();
			} catch (DocumentException e) {
				e.printStackTrace();
			}
		}
	}
	
	/**
     * 向指定 URL 发送POST方法的请求
     * 
     * @param url
     *            发送请求的 URL
     * @param param
     *            请求参数，请求参数应该是 name1=value1&name2=value2 的形式。
     * @return 所代表远程资源的响应结果
	 * @throws IOException 
	 * @throws ParseException 
     */
    public String sendPost(String url, File file) throws Exception {
    	String flag = "false";
        DefaultHttpClient client = new DefaultHttpClient(); // 生成一个http客户端发送请求对象
        HttpPost httpPost = new HttpPost(url); //设定请求方式
        httpPost.setEntity(getMutipartEntry(file));
        HttpResponse httpResponse = client.execute(httpPost); // 发送请求并等待响应
        // 判断网络连接是否成功
        if (httpResponse.getStatusLine().getStatusCode() != 200) {
             System.out.println("网络错误异常！!!!");
        }
        HttpEntity entity = httpResponse.getEntity(); // 获取响应里面的内容
        flag = "OK";
        // 得到服务气端发回的响应的内容（都在一个字符串里面）
    	return flag;
    }
    
    private MultipartEntity getMutipartEntry(File file) throws UnsupportedEncodingException {
        if (file == null) {
            throw new IllegalArgumentException("文件不能为空");
        }
        FileBody fileBody = new FileBody(file);
        FormBodyPart filePart = new FormBodyPart("file", fileBody);
        MultipartEntity multipartEntity = new MultipartEntity();
        multipartEntity.addPart(filePart);

        return multipartEntity;
    }
    
    /**
     * 按Id查询出信息并跳转至申请书页面
     * @param request
     * @param id
     * @return
     */
    @RequestMapping("/sqsWinShow")
    public String toUpdateUsers(HttpServletRequest request,
    			@RequestParam(value="id", required=true) String id,
    			@RequestParam("license_dno") String license_dno){
    	try{
    		/***************************** 查询数据部分  ***********************************/
    		Map<String,String> map = new HashMap<String,String>();
    		map.put("id", id);
    		LicenseDecDTO dto = completeProcessDbService.findById(map);
    		
    		/***************************** 页面el表达式传递数据部分  ***********************************/
    		request.setAttribute("dto", dto);
    		CheckDocsRcdModel dto2=new CheckDocsRcdModel();
    		dto2.setProcMainId(license_dno);
    		dto2.setDocType("D_SQS");
    		List<CheckDocsRcdModel> list = origPlaceFlowService.getOptionList(dto2);
    		if(!list.isEmpty()){
    			request.setAttribute("doc",list.get(0)); 
    		}
    		
    		List<HygieneLicenseEventDto> listnl=licenseWorkService.selectHygieneCard(license_dno);
			HygieneLicenseEventDto st_1=null;
			HygieneLicenseEventDto st_2=null;
			HygieneLicenseEventDto st_6=null;
//			0：申报，1：受理，2：受理审核，3：人员随机:4：人员随机审核，5：决定，6：决定审批(补发同意)
//			7：终止申请，8：终止审批，9：补发申请，10补发审批，11：撤销，12：注销，13:整改，
//			14：现场查验，15：撤销审批，16：注销审批，17：补发不同意,18:材料补正,19企业端提交,20初审
			for(HygieneLicenseEventDto h:listnl){
				h.setOpr_date_str(DateUtil.DateToString(h.getOpr_date(),"yyyy-MM-dd HH:mm:ss"));
				if(h.getStatus().equals("1")){
					st_1=h;
				}
				if(h.getStatus().equals("2")){
					st_2=h;
				}
				if(h.getStatus().equals("6")){
					st_6=h;
				}
			}
			request.setAttribute("st_1", st_1);
			request.setAttribute("st_2", st_2);
			request.setAttribute("st_6", st_6);
			// 组长
			String approval_users_name = dto.getApproval_users_name();
			if(!StringUtils.isEmpty(approval_users_name)){
				String[] arr = approval_users_name.split(",");
				request.setAttribute("zz", arr[0]);
			}
			// 现场审核时间
			String xcscDate = completeProcessDbService.getDptFileuploadDate(license_dno);
			request.setAttribute("xcscDate", xcscDate.substring(0,xcscDate.length()-2));
		} catch (Exception e) {
			
			logger_.error("***********/xk/sqsWinShow************",e);
		}
    	return "xk/printHjkanWs";
	}
}
