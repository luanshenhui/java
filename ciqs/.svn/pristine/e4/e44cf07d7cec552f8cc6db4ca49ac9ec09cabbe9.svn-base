package com.dpn.ciqqlc.http;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.common.util.FileUtil;
import com.dpn.ciqqlc.common.util.PageBean;
import com.dpn.ciqqlc.http.form.IntercepeForm;
import com.dpn.ciqqlc.http.form.MailObjCheckForm;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.model.IntercepeModel;
import com.dpn.ciqqlc.standard.model.LicenseDecDTO;
import com.dpn.ciqqlc.standard.model.MailObjCheckModel;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.model.VideoEventModel;
import com.dpn.ciqqlc.standard.model.VideoFileEventModel;
import com.dpn.ciqqlc.standard.service.CommonService;
import com.dpn.ciqqlc.standard.service.MailObjCheckDbService;
import com.dpn.ciqqlc.standard.service.OrigPlaceFlowService;

/**
 * MailObjCheckController.
 * 
 * @author wangzhy
 * @since 1.0.0
 * @version 1.0.0
 */
/* *****************************************************************************
 * 备忘记录
 * -> 以"/mail"作为URL前缀的action，进行进出境邮寄物全过程执法记录的处理。
********************************************************************************
 * 变更履历
 * -> 
***************************************************************************** */
@Controller
@RequestMapping(value = "/mail")
public class MailObjCheckController {

	/**
     * logger.
     * 
     * @since 1.0.0
     */
    private final Logger logger_ = LoggerFactory.getLogger(this.getClass());
    
	@Autowired
	@Qualifier("mailObjCheckServ")
	private MailObjCheckDbService mailObjCheckServ = null;
	
	@Autowired
	private CommonService commonServer = null; 
	@Autowired
	private OrigPlaceFlowService origPlaceFlowService;
	
	/**
     * 查询进出境邮寄物全过程执法记录列表
     * @param request
     * @return
     */
    @RequestMapping("/findMail")
	public String findMail(HttpServletRequest request,MailObjCheckForm mailObjCheckform){
    	Map<String,String> map = new HashMap<String,String>();
		try{
			/***************************** 分页列表查询部分  ***********************************/
	        int pages = 1;
	        if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
	            pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
	        }
	        PageBean page_bean = new PageBean(pages, String.valueOf(Constants.PAGE_NUM));
			map.put("package_no", mailObjCheckform.getPackage_no());
			map.put("consignee_name", mailObjCheckform.getConsignee_name());
			map.put("cago_name", mailObjCheckform.getCago_name());
			map.put("startIntrceptDate", mailObjCheckform.getStartIntrceptDate());
			map.put("endIntrceptDate", mailObjCheckform.getEndIntrceptDate());
			if(mailObjCheckform == null || "K".equals(mailObjCheckform.getDeal_type())){
				map.put("deal_type", "");
			}else{
				map.put("deal_type", mailObjCheckform.getDeal_type());
			}
			//******************** 修改直属局和分支局默认值  ********************
			map.put("port_zsorg_code", mailObjCheckform.getPort_zsorg_code()==null?"210000":mailObjCheckform.getPort_zsorg_code());
			map.put("port_org_code", mailObjCheckform.getPort_org_code()==null?"211940":mailObjCheckform.getPort_org_code());
			map.put("port_dept_code", mailObjCheckform.getPort_dept_code());
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			List<MailObjCheckModel> list = mailObjCheckServ.findMail(map);
			int counts = mailObjCheckServ.findMainCount(map);
			
			/***************************** 查询条件下拉列表数据部分  ***********************************/
			List<SelectModel> allDeal_type = mailObjCheckServ.allDealType();
			List<SelectModel> allorgList =mailObjCheckServ.allOrgList();
			List<SelectModel> alldepList =mailObjCheckServ.allDepList();
			SelectModel selectModel = new SelectModel();
			selectModel.setName("全部");
			selectModel.setCode("");
			alldepList.add(selectModel);
			
			/***************************** 页面el表达式传递数据部分  ***********************************/
			request.setAttribute("oselected", mailObjCheckform.getPort_org_code());
			request.setAttribute("dselected", mailObjCheckform.getPort_dept_code());
			request.setAttribute("zselected", mailObjCheckform.getPort_zsorg_code());
			request.setAttribute("deal_type_selected", mailObjCheckform.getDeal_type());
			request.setAttribute("allorgList", allorgList);
			request.setAttribute("alldepList", alldepList);
			request.setAttribute("allDeal_type", allDeal_type);
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
	        request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
            request.setAttribute("counts",counts);
	        request.setAttribute("allPage", counts % page_bean.getPageSize()==0 ? (counts/page_bean.getPageSize()) : (counts/page_bean.getPageSize())+1);
	        request.setAttribute("package_no",mailObjCheckform.getPackage_no());
	        request.setAttribute("consignee_name",mailObjCheckform.getConsignee_name());
	        request.setAttribute("startIntrceptDate", mailObjCheckform.getStartIntrceptDate());
	        request.setAttribute("endIntrceptDate", mailObjCheckform.getEndIntrceptDate());
		} catch (Exception e) {
			
			logger_.error("***********/main/findMail************",e);
		}finally{
			map =  null;
		}
		return "mailObjCheck/mailObjCheckList";
	}
    
    /**
     * 按Id查询出邮寄物信息并跳转至详情页面
     * @param request
     * @param id
     * @return
     */
    @RequestMapping("/toMailObjCheckDetail")
    public String toUpdateUsers(HttpServletRequest request,
    			@RequestParam(value="id", required=true) String id,
    			@RequestParam(value="package_no", required=true) String package_no){
    	try{
    		/***************************** 查询数据部分  ***********************************/
    		Map<String,String> map = new HashMap<String,String>();
    		map.put("id", id);
    		MailObjCheckModel mailObjCheckModel = mailObjCheckServ.findUMailById(map);
    		/***************************** 查询视频和图片集合  ***********************************/
    		//map.put("package_no", package_no);
    		//List<VideoFileEventModel> videoFileEventList = mailObjCheckServ.videoFileEventList(map);
    		/***************************** 页面el表达式传递数据部分  ***********************************/
    		//request.setAttribute("videoFileEventList", videoFileEventList);
    		request.setAttribute("mail", mailObjCheckModel);
		} catch (Exception e) {
			
			logger_.error("***********/mail/toMailObjCheckDetail************",e);
		}
    	return "mailObjCheck/mailObjCheckDetail";
	}
    
    /**
     * 查询图片视频
     * @param request
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/videoFileEventList")
    public Map<String,Object> videoFileEventList(HttpServletRequest request,
    			@RequestParam(value="package_no", required=true) String package_no){
    	Map<String,String> map = new HashMap<String,String>();
		Map<String,Object> resultMap = new HashMap<String,Object>();
    	try{
    		/***************************** 查询视频和图片集合  ***********************************/
    		map.put("package_no", package_no);
    		List<VideoFileEventModel> videoFileEventList = mailObjCheckServ.videoFileEventList(map);
    		/***************************** 页面el表达式传递数据部分  ***********************************/
    		resultMap.put("videoFileEventList", videoFileEventList);
		} catch (Exception e) {
			
			logger_.error("***********/mail/toMailObjCheckDetail************",e);
		}
    	return resultMap;
	}
    
    /**
	 * 跳转到采样凭证页面
	 * @throws Exception
	 */
	@RequestMapping("/toCypz")
	public String toPsyDtail(HttpServletRequest request) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		map.put("id", request.getParameter("id"));
		MailObjCheckModel dto = mailObjCheckServ.findUMailById(map);
		CheckDocsRcdModel model=new CheckDocsRcdModel();
		model.setProcMainId(request.getParameter("package_no"));
		model.setDocType("D_CYPZ");
		List<CheckDocsRcdModel> list = origPlaceFlowService.getOptionList(model);
		if(!list.isEmpty()){
			request.setAttribute("doc",list.get(0)); 
		}else{
			//request.setAttribute("doc",null); 
		}
		request.setAttribute("dto", dto);
		return "mailObjCheck/cypzEdit";
	}
	
    /**
	 * 跳转到委托检验申请单页面
	 * @throws Exception
	 */
	@RequestMapping("/toWtjy")
	public String toWtjy(HttpServletRequest request) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		map.put("id", request.getParameter("id"));
		MailObjCheckModel dto = mailObjCheckServ.findUMailById(map);
		CheckDocsRcdModel model=new CheckDocsRcdModel();
		model.setProcMainId(request.getParameter("package_no"));
		model.setDocType("D_WTJY");
		List<CheckDocsRcdModel> list = origPlaceFlowService.getOptionList(model);
		if(!list.isEmpty()){
			request.setAttribute("doc",list.get(0)); 
		}else{
			//request.setAttribute("doc",null); 
		}
		request.setAttribute("dto", dto);
		return "mailObjCheck/wtjyEdit";
	}
	
	/**
	 * doc提交方法
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
		String type = request.getParameter("type");
		if(type !=null && type.equals("1")){
			request.setAttribute("save", "ok");
		}else{
			request.setAttribute("submit", "ok");
		}
		return "mailObjCheck/wtjyEdit";		
	}
	
    /**
     * 查询销毁列表
     * @param request
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/xhList")
    public Map<String,Object> xhList(HttpServletRequest request,
    			@RequestParam(value="ditroy_id", required=true) String ditroy_id){
    	Map<String,String> map = new HashMap<String,String>();
		Map<String,Object> resultMap = new HashMap<String,Object>();
    	try{
    		/***************************** 查询视频和图片集合  ***********************************/
    		map.put("ditroy_id", ditroy_id);
    		List<MailObjCheckModel> xhList = mailObjCheckServ.xhList(map);
    		/***************************** 页面el表达式传递数据部分  ***********************************/
    		resultMap.put("xhList", xhList);
		} catch (Exception e) {
			
			logger_.error("***********/mail/toMailObjCheckDetail************",e);
		}
    	return resultMap;
	} 
    
    /**
     * 图片页面跳转
     * @param request
     * @param id
     * @return
     */
    @RequestMapping("/toImgDetail")
    public String toImgDetail(HttpServletRequest request){
    	try{
		} catch (Exception e) {
			
			logger_.error("***********/mail/toMailObjCheckDetail************",e);
		}
    	return "mailObjCheck/view_img";
	}
    
    /**
     * 图片和视频上传
     * @param request
     * @param id
     * @return
     */
    @RequestMapping("/fileVideoOrImg")
    public String saveFileVideoOrImg(HttpServletRequest request,
    		@RequestParam("id") String id,
    		@RequestParam("package_no") String package_no,
    		@RequestParam("procType") String procType,
    		@RequestParam("fileType") String fileType){
    	try {
    		String filePath = "";
    		// 把文件保存到硬盘上
    		List<Map<String, String>> filePaths = FileUtil.uploadFile(request,false);
            if(filePaths != null && filePaths.size() > 0){
            	Map<String, String> map = (Map)filePaths.get(0);
            	filePath = map.get("filePath");
//            	filePath = filePath.substring(filePath.indexOf(Constants.UP_LOAD_PATH)+3,filePath.length());
            }
            UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
    				Constants.USER_KEY);
			// 把文件的路径信息保存到数据库中
			VideoEventModel video = new VideoEventModel();
			video.setProcMainId(package_no);
			video.setFileName(filePath);
			video.setFileType(fileType);
			video.setProcType(procType);
			//直属局
			video.setPortOrgCode(Constants.DEFAULT_ORG_CODE);
			//分支局科室
			String port_org_code = "211940";
			video.setPortDeptCode(getOrgCode(user,port_org_code));
			//上传人
			video.setCreateUser(user.getId());
			//System.setProperty("user.timezone", "GMT+8");
			video.setCreateDate(DateUtil.newDate());
			commonServer.save(video);
		} catch (Exception e1) {
			e1.printStackTrace();
		}
    	try{
    		
		} catch (Exception e) {
			
			logger_.error("***********/mail/saveFileVideoOrImg************",e);
		}
    	return "redirect:/mail/toMailObjCheckDetail?id="+id+"&package_no="+package_no;
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
}
