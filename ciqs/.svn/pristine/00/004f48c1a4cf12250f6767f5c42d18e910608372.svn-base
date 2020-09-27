package com.dpn.ciqqlc.http;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import ch.qos.logback.core.util.FileUtil;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.PageBean;
import com.dpn.ciqqlc.http.form.CheckDocsRcdFrom;
import com.dpn.ciqqlc.http.form.DcForm;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdDTO;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.model.LicenseDecDTO;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.service.CommonService;
import com.dpn.ciqqlc.standard.service.DeclareService;
import com.dpn.ciqqlc.standard.service.LicenseDecDbService;
import com.dpn.ciqqlc.standard.service.MailObjCheckDbService;

@Controller
@RequestMapping(value = "/dc")
public class DeclareController {

	/**
     * logger.
     * 
     * @since 1.0.0
     */
	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	@Qualifier("declareService")
	private DeclareService declareService = null;
	@Autowired
	private CommonService commonServer = null; 
	@Autowired
	private LicenseDecDbService licenseDecDbService= null;
	@Autowired
	@Qualifier("mailObjCheckServ")
	private MailObjCheckDbService mailObjCheckServ = null;
	
	/**
	 * 查询许可证申报
	 * @param mapping
	 * @param form
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/getLicenseDecs")
	public String getLicenseDecs (HttpServletRequest request,DcForm form){
		
		try {
			int pages = 1;
	        if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
	            pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
	        }
	        PageBean page_bean = new PageBean(pages, String.valueOf(Constants.PAGE_NUM));
			Map<String, Object> map = new HashMap<String, Object>();
			if(page_bean!=null){
				map.put("lastRecord", page_bean.getHigh());
				map.put("firstRecord", page_bean.getLow());
			}
			if(!StringUtils.isEmpty(form.getApproval_result())){
				map.put("approval_result", form.getApproval_result());
			}
			int counts = this.declareService.getLicenseDecsCount(map);
			List<LicenseDecDTO> list = this.declareService.getLicenseDecsList (map);
			
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
	        request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
            request.setAttribute("counts",counts);
	        request.setAttribute("allPage", counts % page_bean.getPageSize()==0 ? (counts/page_bean.getPageSize()) : (counts/page_bean.getPageSize())+1);
			request.setAttribute("flag", form.getFlag());
			request.setAttribute("approval_result", form.getApproval_result());			
		} catch (Exception ex) {
			log.error("****ERROR****LicenseDecAction*****getLicenseDecs", ex);
		}
		return "dc/licenseDecsList";
	}
	
	/**
	 * 查询许可证申报
	 * @param mapping
	 * @param form
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/getLicenseDecs2")
	public String getLicenseDecs2 (HttpServletRequest request,DcForm form){
		
		try {
			int pages = 1;
	        if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
	            pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
	        }
	        PageBean page_bean = new PageBean(pages, String.valueOf(Constants.PAGE_NUM));
			Map<String, Object> map = new HashMap<String, Object>();
			if(page_bean!=null){
				map.put("lastRecord", page_bean.getHigh());
				map.put("firstRecord", page_bean.getLow());
			}
			if(!StringUtils.isEmpty(form.getHygiene_license_number())){
				map.put("hygiene_license_number", form.getHygiene_license_number());
			}
			if(!StringUtils.isEmpty(request.getParameter("initflag"))){
				map.put("initflag", "initflag");
			}
			int counts = this.declareService.getLicenseDecsCount(map);
			List<LicenseDecDTO> list = this.declareService.getLicenseDecsList (map);
			
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
	        request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
            request.setAttribute("counts",counts);
	        request.setAttribute("allPage", counts % page_bean.getPageSize()==0 ? (counts/page_bean.getPageSize()) : (counts/page_bean.getPageSize())+1);
			request.setAttribute("flag", form.getFlag());
			request.setAttribute("approval_result", form.getApproval_result());			
		} catch (Exception ex) {
			log.error("****ERROR****LicenseDecAction*****getLicenseDecs", ex);
		}
		return "dc/licenseDecsList2";
	}
	
	/**
	 * 新增许可证申报页面转向
	 * @param actionMapping
	 * @param DcForm
	 * @param request
	 * @param servletResponse
	 * @return
	 *
	 */
	@RequestMapping("/toLicenseDecForm")
	public String toLicenseDecForm(HttpServletRequest request,
			HttpServletResponse servletResponse) {	
		List<SelectModel> allorgList =this.declareService.getOrganizeCiq();
		request.setAttribute("allorgList", allorgList);
		return "dc/licenseDecAdd";
	}
	
	/**
	 * 新增许可证申报保存
	 * @param actionMapping
	 * @param DcForm
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/addLicenseDec")
	public String addLicenseDec (DcForm form,
			HttpServletRequest request, HttpServletResponse response) {
		String url = "/toform";
		try {
			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
    				Constants.USER_KEY);
				
				Map<String,Object> map = new HashMap<String,Object>();
				DateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
				String license_dno ="LN"+format.format(new Date());
				form.setLicense_dno(license_dno);
				map.put("license_dno", license_dno);
				map.put("comp_name", form.getComp_name());
				map.put("comp_addr", form.getComp_addr());
				map.put("management_addr", form.getManagement_addr());
				map.put("management_area", form.getManagement_area());
				map.put("legal_name", form.getLegal_name());
				map.put("contacts_name", form.getContacts_name());
				map.put("contacts_phone", form.getContacts_phone());
				map.put("mailbox", form.getMailbox());
				map.put("fax", form.getFax());
				map.put("employee_num", form.getEmployee_num());
				map.put("certificate_numver", form.getCertificate_numver());
				map.put("management_type", form.getManagement_type());
				map.put("apply_scope", form.getApply_scope());
				map.put("apply_type", form.getApply_type());
				map.put("hygiene_license_number", form.getHygiene_license_number());
				map.put("port_org_code", form.getPort_org_code());
				// 自动赋予一个编号
				long l  = System.currentTimeMillis();
				String comp_code =new SimpleDateFormat("yyyyMMdd").format(new Date(l));
				map.put("comp_code", license_dno+comp_code);
				map.put("declare_user", user.getId());
				declareService.addLicenseDec(map);

				// 更新event表
				Map<String, String> eventmap = new HashMap<String, String>();
				eventmap.put("licence_id", license_dno);
				eventmap.put("status", "0");
				eventmap.put("opr_psn", user.getId());
				licenseDecDbService.insertEvent(eventmap);
				
				// 保存上传文件到指定目录(文件附件)
				String uploadPath = declareService.saveUpload(request,"fileUpload");
				// 调用局端上传接口
				// sendPost(Constants.PROJECT_PATH+"saveUpload", null);
				// 保存上传文件路径到
				declareService.saveUploadPath(form,uploadPath,user,"4");
				url = "redirect:/dc/getLicenseDecs?flag=OK";
		} catch (Exception ex) {
			log.error("****ERROR****LicenseDecAction*****addLicenseDec", ex);
			url = "redirect:/dc/getLicenseDecs?flag=ERROR";
		}
		
		return url;
	}

	/**
	 * 申报删除
	 * @param form
	 * @return
	 */
	@RequestMapping("/licenseDecsDelete")
	public String licenseDecsDelete(DcForm form,
			HttpServletRequest request, HttpServletResponse response) {	
		String url="";
		try {
			declareService.licenseDecsDelete(form.getLicense_dno());
			url = "redirect:/dc/getLicenseDecs?flag=OK";
		} catch (Exception e) {
			url = "redirect:/dc/getLicenseDecs?flag=ERROR";
		}
		return url;
	}
	
	/**
	 * 查询许可证申报详情信息并跳转到详情页面
	 * @param mapping
	 * @param form
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/getLicenseDec")
	public String getLicenseDec (DcForm form,
			HttpServletRequest request, HttpServletResponse response) {
		
		try {
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("license_dno", form.getLicense_dno());
			LicenseDecDTO dto = this.declareService.getLicenseDec(map);
			String filePath = this.declareService.selectfilePath(form.getLicense_dno(),4);// 文件附件
			String filePath2 = this.declareService.selectfilePath(form.getLicense_dno(),9);// 补发附件
			if(filePath != null && !filePath.equals("")){
				filePath = filePath.replace("/", "\\");
				dto.setFilePath(filePath);
			}
			if(filePath2 != null && !filePath2.equals("")){
				filePath2 = filePath2.replace("/", "\\");
				dto.setFilePath2(filePath2);
			}
			request.setAttribute("dto", dto);
			request.setAttribute("filePath", filePath);
			request.setAttribute("filePath2", filePath2);
			// 查询后续操作信息
			//map.put("status", 7);// 终止申请
			//LicenseDecDTO zz_sq_dto  = declareService.gethxzzInfo(map);
			map.put("status", 8);// 终止审批
			LicenseDecDTO zz_sp_dto  = declareService.gethxzzInfo(map);
			//map.put("status", 12);// 注销申请
			//LicenseDecDTO zx_sq_dto  = declareService.gethxzzInfo(map);
			map.put("status", 16);// 注销审批
			LicenseDecDTO zx_sp_dto  = declareService.gethxzzInfo(map);
			//map.put("status", 9);// 补发申请
			//LicenseDecDTO bf_sq_dto  = declareService.gethxzzInfo(map);
			map.put("status", 10);// 补发同意
			LicenseDecDTO bf_sp_ty_dto  = declareService.gethxzzInfo(map);
			map.put("status", 17);// 补发不同意
			LicenseDecDTO bf_sp_bty_dto  = declareService.gethxzzInfo(map);
			request.setAttribute("dto", dto);
			request.setAttribute("zz_date",declareService.getOprDate("7",form.getLicense_dno()));//终止申请时间
			request.setAttribute("zz_result", zz_sp_dto==null?"":zz_sp_dto.getZz_result());//终止申请审批结果
			request.setAttribute("zx_date",declareService.getOprDate("12",form.getLicense_dno()));//注销申请时间
			request.setAttribute("zx_result", zx_sp_dto==null?"":zx_sp_dto.getZx_result());//注销申请审批结果
			request.setAttribute("bf_date",declareService.getOprDate("9",form.getLicense_dno()));//补发申请时间
			if(bf_sp_ty_dto ==null && bf_sp_bty_dto == null){
				request.setAttribute("bf_result", "");//补发申请审批结果
			}else if(bf_sp_ty_dto ==null && bf_sp_bty_dto != null){
				request.setAttribute("bf_result", "不同意");//补发申请审批结果
			}else{
				request.setAttribute("bf_result", "同意");//补发申请审批结果
			}
		} catch (Exception ex) {
			log.error("****ERROR****LicenseDecAction*****getLicenseDec", ex);
		}
		
		return "dc/licenseDecDetail";
	}
	
	/**
	 * 查询许可证申报详情信息并跳转到详情页面
	 * @param mapping
	 * @param form
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/getLicenseDec2")
	public String getLicenseDec2 (DcForm form,
			HttpServletRequest request, HttpServletResponse response) {
		
		try {
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("license_dno", form.getLicense_dno());
			
			LicenseDecDTO dto = this.declareService.getLicenseDec(map);
			String filePath = this.declareService.selectfilePath(form.getLicense_dno(),4);// 附件
			String filePath2 = this.declareService.selectfilePath(form.getLicense_dno(),9);// 补发附件
			if(filePath != null && !filePath.equals("")){
				filePath = filePath.replace("/", "\\");
				dto.setFilePath(filePath);
			}
			if(filePath2 != null && !filePath2.equals("")){
				filePath2 = filePath2.replace("/", "\\");
				dto.setFilePath2(filePath2);
			}
			request.setAttribute("filePath", filePath);
			request.setAttribute("filePath2", filePath2);
			// 查询后续操作信息
			//map.put("status", 7);// 终止申请
			//LicenseDecDTO zz_sq_dto  = declareService.gethxzzInfo(map);
			map.put("status", 8);// 终止审批
			LicenseDecDTO zz_sp_dto  = declareService.gethxzzInfo(map);
			//map.put("status", 12);// 注销申请
			//LicenseDecDTO zx_sq_dto  = declareService.gethxzzInfo(map);
			map.put("status", 16);// 注销审批
			LicenseDecDTO zx_sp_dto  = declareService.gethxzzInfo(map);
			//map.put("status", 9);// 补发申请
			//LicenseDecDTO bf_sq_dto  = declareService.gethxzzInfo(map);
			map.put("status", 6);// 补发同意
			LicenseDecDTO bf_sp_ty_dto  = declareService.gethxzzInfo(map);
			map.put("status", 17);// 补发不同意
			LicenseDecDTO bf_sp_bty_dto  = declareService.gethxzzInfo(map);
			request.setAttribute("dto", dto);
			request.setAttribute("zz_date",declareService.getOprDate("7",form.getLicense_dno()));//终止申请时间
			request.setAttribute("zz_result", zz_sp_dto==null?"":zz_sp_dto.getZz_result());//终止申请审批结果
			request.setAttribute("zx_date",declareService.getOprDate("12",form.getLicense_dno()));//注销申请时间
			request.setAttribute("zx_result", zx_sp_dto==null?"":zx_sp_dto.getZx_result());//注销申请审批结果
			request.setAttribute("bf_date",declareService.getOprDate("9",form.getLicense_dno()));//补发申请时间
			if(bf_sp_ty_dto ==null && bf_sp_bty_dto == null){
				request.setAttribute("bf_result", "");//补发申请审批结果
			}else if(bf_sp_ty_dto ==null && bf_sp_bty_dto != null){
				request.setAttribute("bf_result", "不同意");//补发申请审批结果
			}else{
				request.setAttribute("bf_result", "同意");//补发申请审批结果
			}
			
		} catch (Exception ex) {
			log.error("****ERROR****LicenseDecAction*****getLicenseDec", ex);
		}
		
		return "dc/licenseDecDetail4";
	}
	
	/**
	 * 查询许可证申报详情信息并跳转到修改页面
	 * @param mapping
	 * @param form
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/toLicenseDecUpdateForm2")
	public String toLicenseDecUpdateForm2 (DcForm form,
			HttpServletRequest request, HttpServletResponse response) {
		
		try {
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("license_dno", form.getLicense_dno());
			LicenseDecDTO dto = this.declareService.getLicenseDec(map);
			String filePath = this.declareService.selectfilePath(form.getLicense_dno(),4);// 文件附件
			String filePath2 = this.declareService.selectfilePath(form.getLicense_dno(),5);// 整改书
			if(filePath != null && !filePath.equals("")){
				filePath = filePath.replace("/", "\\");
				dto.setFilePath(filePath);
			}
			if(filePath2 != null && !filePath2.equals("")){
				filePath2 = filePath2.replace("/", "\\");
				dto.setFilePath2(filePath2);
			}
			List<SelectModel> allorgList =this.declareService.getOrganizeCiq();
			request.setAttribute("allorgList", allorgList);
			request.setAttribute("dto", dto);
			request.setAttribute("type", request.getParameter("type"));
		} catch (Exception ex) {
			log.error("****ERROR****licenseDecEdit2*****getLicenseDec", ex);
		}
		
		return "dc/licenseDecEdit2";
	}
	
	/**
	 * 跳转到注销页面
	 * @param mapping
	 * @param form
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/tozxForm")
	public String tozxForm (DcForm form,
			HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("license_dno", form.getLicense_dno());
			LicenseDecDTO dto = this.declareService.getLicenseDec(map);
			String filePath = this.declareService.selectfilePath(form.getLicense_dno(),4);// 文件附件
			String filePath2 = this.declareService.selectfilePath(form.getLicense_dno(),8);// 整改书
			if(filePath != null && !filePath.equals("")){
				filePath = filePath.replace("/", "\\");
				dto.setFilePath(filePath);
			}
			if(filePath2 != null && !filePath2.equals("")){
				filePath2 = filePath2.replace("/", "\\");
				dto.setFilePath2(filePath2);
			}
			request.setAttribute("dto", dto);
			request.setAttribute("status", request.getParameter("status"));
		} catch (Exception ex) {
			log.error("****ERROR****LicenseDecAction*****getLicenseDec", ex);
		}
		
		return "dc/licenseDecDetail2";
	}
	
	/**
	 * 跳转到补发页面
	 * @param mapping
	 * @param form
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/tozxForm2")
	public String tozxForm2 (DcForm form,
			HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("license_dno", form.getLicense_dno());
			LicenseDecDTO dto = this.declareService.getLicenseDec(map);
			String filePath = this.declareService.selectfilePath(form.getLicense_dno(),4);// 文件附件
			String filePath2 = this.declareService.selectfilePath(form.getLicense_dno(),9);// 整改书
			if(filePath != null && !filePath.equals("")){
				filePath = filePath.replace("/", "\\");
				dto.setFilePath(filePath);
			}
			if(filePath2 != null && !filePath2.equals("")){
				filePath2 = filePath2.replace("/", "\\");
				dto.setFilePath2(filePath2);
			}
			request.setAttribute("dto", dto);
			request.setAttribute("status", request.getParameter("status"));
		} catch (Exception ex) {
			log.error("****ERROR****LicenseDecAction*****tozxForm2", ex);
		}
		
		return "dc/licenseDecDetail3";
	}
	
	/**
	 * 查询许可证申报详情信息并跳转到修改页面
	 * @param mapping
	 * @param form
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/toLicenseDecUpdateForm")
	public String toLicenseDecUpdateForm (DcForm form,
			HttpServletRequest request, HttpServletResponse response) {
		
		try {
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("license_dno", form.getLicense_dno());
			LicenseDecDTO dto = this.declareService.getLicenseDec(map);
			String filePath = this.declareService.selectfilePath(form.getLicense_dno(),4);// 文件附件
			String filePath2 = this.declareService.selectfilePath(form.getLicense_dno(),5);// 整改书
			if(filePath != null && !filePath.equals("")){
				filePath = filePath.replace("/", "\\");
				dto.setFilePath(filePath);
			}
			if(filePath2 != null && !filePath2.equals("")){
				filePath2 = filePath2.replace("/", "\\");
				dto.setFilePath2(filePath2);
			}
			List<SelectModel> allorgList =this.declareService.getOrganizeCiq();
			request.setAttribute("allorgList", allorgList);
			request.setAttribute("dto", dto);
		} catch (Exception ex) {
			log.error("****ERROR****LicenseDecAction*****getLicenseDec", ex);
		}
		
		return "dc/licenseDecEdit";
	}
	
	/**
	 * 修改可证申报信息
	 * @param mapping
	 * @param form
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/licenseDecUpdate")
	public String licenseDecUpdate (DcForm form,
			HttpServletRequest request, HttpServletResponse response) {
		String url="";
		try {
			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("license_dno", form.getLicense_dno());
			map.put("comp_name", form.getComp_name());
			map.put("comp_addr", form.getComp_addr());
			map.put("management_addr", form.getManagement_addr());
			map.put("management_area", form.getManagement_area());
			map.put("legal_name", form.getLegal_name());
			map.put("contacts_name", form.getContacts_name());
			map.put("contacts_phone", form.getContacts_phone());
			map.put("mailbox", form.getMailbox());
			map.put("fax", form.getFax());
			map.put("employee_num", form.getEmployee_num());
			map.put("certificate_numver", form.getCertificate_numver());
			map.put("management_type", form.getManagement_type());
			map.put("apply_type", form.getApply_type());
			map.put("apply_scope", form.getApply_scope());
			map.put("hygiene_license_number", form.getHygiene_license_number());
			map.put("port_org_code", form.getPort_org_code());
			this.declareService.licenseDecUpdate(map);
			
			// 保存上传文件到指定目录(文件附件)
			String uploadPath = declareService.saveUpload(request,"fileUpload");
			// 保存上传文件路径到
			declareService.saveUploadPath(form,uploadPath,user,"4");
			// 保存上传文件到指定目录(整改书)
			//String uploadPath2 = declareService.saveUpload(request,"zgbgFileUpload");
			// 保存上传文件路径到
			//declareService.saveUploadPath(form,uploadPath2,user,"5");
			url="redirect:/dc/getLicenseDecs?flag=OK";
		} catch (Exception ex) {
			log.error("****ERROR****LicenseDecAction*****getLicenseDec", ex);
			url="redirect:/dc/getLicenseDecs?flag=ERROR";
		}		
		return url;
	}
	
	/**
	 * 上传文书
	 * @param mapping
	 * @param form
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/wsFileUpload")
	public String wsFileUpload (DcForm form,
			HttpServletRequest request, HttpServletResponse response) {
		
		try {
			Map<String,Object> map = new HashMap<String,Object>();
			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
			// 保存上传文件到指定目录(文件附件)
			String uploadPath = declareService.saveUpload(request,"fileUpload");
			// 保存上传文件路径到
			declareService.saveUploadPath(form,uploadPath,user,"4");
			// 保存上传文件到指定目录(整改书)
			String uploadPath2 = declareService.saveUpload(request,"zgbgFileUpload");
			// 保存上传文件路径到
			declareService.saveUploadPath(form,uploadPath2,user,"5");
			map.put("license_dno", form.getLicense_dno());
			map.put("declare_user", user.getId());
			// 更新重新申请的受理状态为0并清空受理结果
			declareService.applyUpdate(map);
			
			// 更新event表
			Map<String, String> eventmap = new HashMap<String, String>();
			eventmap.put("licence_id", form.getLicense_dno());
			eventmap.put("status", "0");
			eventmap.put("opr_psn", user.getId());
			licenseDecDbService.insertEvent(eventmap);
			licenseDecDbService.updateDStatus(form.getLicense_dno(), 0);
			
			// 补正材料状态
			if(form.getApproval_result().equals("1")){
				Map<String, String> eventmap2 = new HashMap<String, String>();
				eventmap2.put("licence_id", form.getLicense_dno());
				eventmap2.put("status", "19");
				eventmap2.put("opr_psn", user.getId());
				licenseDecDbService.insertEvent(eventmap2);
			}
		} catch (Exception ex) {
			log.error("****ERROR****LicenseDecAction*****getLicenseDec", ex);
		}
		
		return "redirect:/dc/getLicenseDecs";
	}
	
	/**
	 * 注销增加
	 * @param mapping
	 * @param form
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/wsFileUpload2")
	public String wsFileUpload2 (DcForm form,
			HttpServletRequest request, HttpServletResponse response) {
		
		try {
			Map<String,Object> map = new HashMap<String,Object>();
			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
			// 保存上传文件到指定目录(文件附件)
			String uploadPath = declareService.saveUpload(request,"fileUpload");
			// 保存上传文件路径到
			declareService.saveUploadPath(form,uploadPath,user,"8");		
			map.put("license_dno", form.getLicense_dno());
			map.put("declare_user", user.getId());
			
			// 更新event表
			Map<String, String> eventmap = new HashMap<String, String>();
			eventmap.put("licence_id", form.getLicense_dno());
			eventmap.put("status", "12");
			eventmap.put("opr_psn", user.getId());
			licenseDecDbService.insertEvent(eventmap);
			licenseDecDbService.updateDStatus(form.getLicense_dno(), 12);
		} catch (Exception ex) {
			log.error("****ERROR****LicenseDecAction*****wsFileUpload2", ex);
		}
		
		return "redirect:/dc/getLicenseDecs2";
	}
	
	/**
	 * 补发增加
	 * @param mapping
	 * @param form
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/wsFileUpload3")
	public String wsFileUpload3 (DcForm form,
			HttpServletRequest request, HttpServletResponse response) {
		
		try {
			Map<String,Object> map = new HashMap<String,Object>();
			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
			// 保存上传文件到指定目录(文件附件)
			String uploadPath = declareService.saveUpload(request,"fileUpload");
			// 保存上传文件路径到
			declareService.saveUploadPath(form,uploadPath,user,"9");		
			map.put("license_dno", form.getLicense_dno());
			map.put("declare_user", user.getId());
			
			// 更新event表
			Map<String, String> eventmap = new HashMap<String, String>();
			eventmap.put("licence_id", form.getLicense_dno());
			eventmap.put("status", "9");
			eventmap.put("opr_psn", user.getId());
			licenseDecDbService.insertEvent(eventmap);
			licenseDecDbService.updateDStatus(form.getLicense_dno(), 9);
		} catch (Exception ex) {
			log.error("****ERROR****LicenseDecAction*****wsFileUpload3", ex);
		}
		
		return "redirect:/dc/getLicenseDecs2";
	}
	
	/**
	 * 跳转到不予受理决定书页面
	 * @param actionMapping
	 * @param DcForm
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/toPrintXzBysl")
	public String toPrintXzBysl(
			DcForm DcForm, HttpServletRequest request,
			HttpServletResponse servletResponse) {	
		return "dc/byslsEdit";
	}
    
	/**
	 * 跳转到告知书页面
	 * @param actionMapping
	 * @param DcForm
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/toPrintXzSljds")
	public String toPrintXzSljds(
			CheckDocsRcdFrom form, HttpServletRequest request,
			HttpServletResponse servletResponse) {	
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("proc_main_id", form.getProc_main_id());
		map.put("doc_type", form.getDoc_type());
		UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
		CheckDocsRcdDTO dto = this.declareService.getOptionList(map);
		if(dto==null){
			dto = new CheckDocsRcdDTO();
		}
		request.setAttribute("doc",dto); 
		String findForwardUrl = "";
		if(form.getDoc_type() != null){
			//受理决定书页面
			if(form.getDoc_type().equals("D_SL_GZ")){
				findForwardUrl = "dc/slgzsEdit";
			//不予受理决定书页面
			}else if(form.getDoc_type().equals("D_BY_GZ")){
				findForwardUrl = "dc/byslsEdit";
			//申请材料补正告知书
			}else if(form.getDoc_type().equals("D_SQ_BZ")){
				findForwardUrl = "dc/bzgzsEdit";
			}else if(form.getDoc_type().equals("D_SDHZ")){
				findForwardUrl = "dc/bzsEdit";
				String type = request.getParameter("type");
				if(type !=null && type.equals("sdhz")){
					findForwardUrl = "xk/bzs";
				} 
			}else if(form.getDoc_type().equals("D_SDHZ5")){
				findForwardUrl = "xk/bzsEdit5";
			}else if(form.getDoc_type().equals("D_SDHZ4")){
				findForwardUrl = "xk/bzsEdit4";
			}else if(form.getDoc_type().equals("D_PT_H_L_13")){
				findForwardUrl = "xk/bzsEdit3";
			}else if(form.getDoc_type().equals("D_ZGS")){
				findForwardUrl = "dc/informDoc";
			}else{
				findForwardUrl = "dc/bzsEdit2";	
				String type = request.getParameter("type");
				/*if(type !=null && type.equals("sdhz2")){
					findForwardUrl = "xk/bzs2";
				}*/
			}
		}else{
			findForwardUrl = "dc/error";
		}
		request.setAttribute("username",user.getName()); 
		request.setAttribute("sq_status",request.getParameter("sq_status")); 
		request.setAttribute("comp_name", request.getParameter("comp_name"));
		request.setAttribute("ws_type", request.getParameter("ws_type"));
		request.setAttribute("license_dno",form.getProc_main_id()); 
		return findForwardUrl;
	}
	
	/**
	 * 文件下载
	 * @param actionMapping
	 * @param DcForm
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/downloadFile")
	public void downloadFile(
			@RequestParam("path") String path, HttpServletRequest request,
			HttpServletResponse servletResponse){
		try {
			
			com.dpn.ciqqlc.common.util.FileUtil.downXkloadFile(path, servletResponse);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 文件下载
	 * @param actionMapping
	 * @param DcForm
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/downloadFile2")
	public void downloadFile2(
			@RequestParam("path") String path, HttpServletRequest request,
			HttpServletResponse servletResponse){
		try {
			
			com.dpn.ciqqlc.common.util.FileUtil.downXkloadFile(path, servletResponse);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 文件下载
	 * @param fileName 文件名
	 * 
	 * @param response
	 * @param isDownload 是否下载（不下载则在线打开）
	 * @throws Exception
	 */
	
	public void downFile(String filename, HttpServletResponse response, boolean isDownload)
			throws Exception {
		String contentType = "application/x-msdownload";
		String enc = "UTF-8";
		try {
			String filePath = Constants.UP_XK_PATH+"/"+filename;
			File file = new File(filePath);// 通过路径读入文件，下载的文件的物理路径＋文件名
			
			if (file.exists()) {
				
				filename = URLEncoder.encode(filename, enc);
				// getResponse的getWriter()方法连续两次输出流到页面的时候，第二次的流会包括第一次的流，所以可以使用将response.reset或者resetBuffer的方法。

				// 加上response.reset()，并且所有的％>后面不要换行，包括最后一个；
				response.reset(); // 非常重要,清空buffer,设置页面不缓存，有则不用bos.flush();
				response.setCharacterEncoding("GB2312");
				if (isDownload) { // 纯下载方式

					response.setContentType(contentType);
					// 客户使用目标另存为对话框保存指定文件
					response.setHeader("Content-Disposition", "attachment; filename=" + filename);
				} else { // 在线打开方式
					URL u = new URL("file:///" + filePath);
					response.setContentType(u.openConnection().getContentType());
					response.setHeader("Content-Disposition", "inline; filename=" + filename);
				}
				int fileLength = (int) file.length();
				response.setContentLength(fileLength);
				if (fileLength != 0) {
					InputStream fis = new FileInputStream(file);
					OutputStream fos = response.getOutputStream();
					BufferedInputStream bis = new BufferedInputStream(fis);
					BufferedOutputStream bos = new BufferedOutputStream(fos);
					// 设置缓存为1M
					byte[] buffer = new byte[1024];
					int bytesRead = 0;
					// 循环取出流中的数据

					while ((bytesRead = bis.read(buffer)) != -1) {
						bos.write(buffer, 0, bytesRead);
					}
					fis.close();
					bis.close();
					fos.close();
					bos.flush();
					bos.close();
				}
			}else{
				throw new Exception("文件已不存在");
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
	
	/**
	 * doc提交方法
	 * @param request
	 * @param checkDocsRcd
	 * @return
	 */
	@RequestMapping(value = "/submitDoc" ,method = RequestMethod.POST)
	public String submitDoc(HttpServletRequest request,CheckDocsRcdModel checkDocsRcd,RedirectAttributes attr) {
		if(checkDocsRcd.getOption20() == null || "".equals(checkDocsRcd.getOption20())){
			checkDocsRcd.setOption20("1");
			request.setAttribute("option_20", checkDocsRcd.getOption20());
		}else if("1".equals(checkDocsRcd.getOption20())){
			checkDocsRcd.setOption20("2");
			request.setAttribute("option_20", checkDocsRcd.getOption20());
		}
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
		//request.setAttribute("doc", checkDocsRcd);
		request.setAttribute("ok", "ok");
		return "dc/bzsEdit";		
		//return "redirect:getLicenseDecs";
	}
	
	/**
	 * doc提交方法
	 * @param request
	 * @param checkDocsRcd
	 * @return
	 */
	@RequestMapping(value = "/informSubmitDoc" ,method = RequestMethod.POST)
	public String informSubmitDoc(HttpServletRequest request,CheckDocsRcdModel checkDocsRcd,RedirectAttributes attr) {
		try {
			if(com.dpn.ciqqlc.common.util.StringUtils.isEmpty(checkDocsRcd.getOption5())){
				checkDocsRcd.setOption5("2");
			}
			if(com.dpn.ciqqlc.common.util.StringUtils.isEmpty(checkDocsRcd.getOption6())){
				checkDocsRcd.setOption6("2");
			}
			if(com.dpn.ciqqlc.common.util.StringUtils.isEmpty(checkDocsRcd.getOption7())){
				checkDocsRcd.setOption7("2");
			}
			if(com.dpn.ciqqlc.common.util.StringUtils.isEmpty(checkDocsRcd.getDocId())){
				commonServer.insertDocs(checkDocsRcd);
			}else{
				commonServer.updateDocs(checkDocsRcd);
			}
			attr.addFlashAttribute("msg","success");
		} catch (Exception e) {
			e.printStackTrace();
		}
		request.setAttribute("doc", checkDocsRcd);
		request.setAttribute("ok", "ok");
		return "xk/informDoc";		
		//return "redirect:getLicenseDecs";
	}
	
	/**
	 * 转换前台数据转换器
	 * @param binder
	 */
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
	
	/**
	 * 上传整改书
	 * @param mapping
	 * @param form
	 * @param request
	 * @param servletResponse
	 * @return
	 */
	@RequestMapping("/gzsUpload")
	public String gzsUpload (DcForm form,
			HttpServletRequest request, HttpServletResponse response) {
		
		try {
			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
			// 保存上传文件到指定目录(整改书)
			String uploadPath2 = declareService.saveUpload(request,"zgbgFileUpload");
			// 保存上传文件路径到
			declareService.saveUploadPath(form,uploadPath2,user,"5");
		} catch (Exception ex) {
			log.error("****ERROR****LicenseDecAction*****getLicenseDec", ex);
		}
		
		return "redirect:/dc/getLicenseDecs";
	}
	
	/**
     * 向指定 URL 发送POST方法的请求
     * 
     * @param url
     *            发送请求的 URL
     * @param param
     *            请求参数，请求参数应该是 name1=value1&name2=value2 的形式。
     * @return 所代表远程资源的响应结果
     */
    public String sendPost(String url, String param) {
        PrintWriter out = null;
        BufferedReader in = null;
        String result = "";
        try {
            URL realUrl = new URL(url);
            // 打开和URL之间的连接
            URLConnection conn = realUrl.openConnection();
            // 设置通用的请求属性
            conn.setRequestProperty("accept", "*/*");
            conn.setRequestProperty("connection", "Keep-Alive");
            conn.setRequestProperty("user-agent",
                    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
            // 发送POST请求必须设置如下两行
            conn.setDoOutput(true);
            conn.setDoInput(true);
            // 获取URLConnection对象对应的输出流
            out = new PrintWriter(conn.getOutputStream());
            // 发送请求参数
            out.print(param);
            // flush输出流的缓冲
            out.flush();
            // 定义BufferedReader输入流来读取URL的响应
            in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream()));
            String line;
            while ((line = in.readLine()) != null) {
                result += line;
            }
        } catch (Exception e) {
            System.out.println("发送 POST 请求出现异常！"+e);
            e.printStackTrace();
        }
        //使用finally块来关闭输出流、输入流
        finally{
            try{
                if(out!=null){
                    out.close();
                }
                if(in!=null){
                    in.close();
                }
            }
            catch(IOException ex){
                ex.printStackTrace();
            }
        }
        return result;
    }    

}
