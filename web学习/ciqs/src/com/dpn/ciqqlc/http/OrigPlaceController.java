package com.dpn.ciqqlc.http;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.common.util.FileUtil;
import com.dpn.ciqqlc.service.AppServerDb;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.model.CodeLibraryDTO;
import com.dpn.ciqqlc.standard.model.CountryDTO;
import com.dpn.ciqqlc.standard.model.OrigPlaceCargoDto;
import com.dpn.ciqqlc.standard.model.OrigPlaceDto;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.model.VideoEventModel;
import com.dpn.ciqqlc.standard.service.CommonService;
import com.dpn.ciqqlc.standard.service.MailObjCheckDbService;
import com.dpn.ciqqlc.standard.service.OrigPlaceFlowService;

@Controller
@RequestMapping(value = "/origplace")
public class OrigPlaceController {
	
	private final Logger logger_ = LoggerFactory.getLogger(this.getClass());
	
    @Autowired
    private OrigPlaceFlowService origPlaceFlowService;
    @Autowired
	private CommonService commonServer; 
    @Autowired
	@Qualifier("appServerDbServ")
	private AppServerDb commonUtil = null;
	@Autowired
	@Qualifier("mailObjCheckServ")
	private MailObjCheckDbService mailObjCheckServ = null;
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
	 * 
	 * 原产地列表
	 * 
	 **/
	@RequestMapping("/origList")
	public String origList(HttpServletRequest request,OrigPlaceDto origPlace){
		try{
			if(null==origPlace.getOrg_code()){
				origPlace.setOrg_code("210000");
			}
			if(null==origPlace.getDept_code()){
				origPlace.setDept_code("211300");
			}
			origPlace.setDec_org_name(origPlace.getDec_org_name()==null?null:origPlace.getDec_org_name().trim());
			origPlace.setOrg_reg_no(origPlace.getOrg_reg_no()==null?null:origPlace.getOrg_reg_no().trim());
			origPlace.setCert_no(origPlace.getCert_no()==null?null:origPlace.getCert_no().trim());
	        int pages = 1;
	        if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
	            pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
	        }
	        origPlace.setFirstRcd(String.valueOf((pages-1)*Constants.PAGE_NUM+1));
	        origPlace.setLastRcd(String.valueOf(pages*Constants.PAGE_NUM+1));
			List<OrigPlaceDto> list = origPlaceFlowService.findorigList(origPlace);
			int counts = origPlaceFlowService.findOrigCount(origPlace);
			List<CountryDTO> countryList=commonServer.getCountryList(new CountryDTO());
//			List<SelectModel> allorgList =mailObjCheckServ.allOrgList();
			List<SelectModel> allorgList =commonUtil.findNameAndCode(Constants.QLCORGANIZES);
			List<SelectModel> alldepList =mailObjCheckServ.allDepList();
			Map<String, String> map=new HashMap<String, String>();
			map.put("type", "QLC_ZSLX");
			List<CodeLibraryDTO> libraryList=commonServer.getCodeLibrary(map);
			request.setAttribute("list", list);
			request.setAttribute("allorgList", allorgList);
			request.setAttribute("alldepList", alldepList);
			request.setAttribute("countryList", countryList);
			request.setAttribute("libraryList", libraryList);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
	        request.setAttribute("itemInPage", Constants.PAGE_NUM);// 每页显示的记录数
            request.setAttribute("counts",counts);
            request.setAttribute("obj", origPlace);
		} catch (Exception e) {
			logger_.error("***********/origplace/findOrganizes************",e);
		}
		return "origplace/list";
	}


    /**
     * 按组织代码查看用户
     * @param request
     * @param orgcode
     * @return
     */
    @RequestMapping("/showOrig")
    public String showOrig(HttpServletRequest request,@RequestParam(value="id", required=true)String id,@ModelAttribute("msg")String msg){
    	try{
//    		OrigPlaceDto origPlace = origPlaceFlowService.findOrigById(id);
//			request.setAttribute("obj", origPlace);
    		request.setAttribute("id", id);
    		request.setAttribute("alert", msg);
		} catch (Exception e) {
			logger_.error("***********/origplace/showOrig************",e);
		}
    	return "origplace/viewAjx";
	}
    
    @ResponseBody
    @RequestMapping(value = "/getData",method=RequestMethod.GET)
    public  Map<String,Object>  getData(HttpServletRequest request,@RequestParam(value="id", required=true)String id){
    	Map<String,Object> map=new HashMap<String,Object>();
    	try{
    		List<Map<String, String>> origPlace= origPlaceFlowService.getOrigById(id);
    		String SHIPPING_DATE=String.valueOf(origPlace.get(0).get("SHIPPING_DATE"));
    		String RECEIPT_DATE=String.valueOf(origPlace.get(0).get("RECEIPT_DATE"));
    		String APPLY_DATE=String.valueOf(origPlace.get(0).get("APPLY_DATE"));
    		String FILE_DATE=String.valueOf(origPlace.get(0).get("FILE_DATE"));
    		origPlace.get(0).put("SHIPPING_DATE",SHIPPING_DATE==null?"":SHIPPING_DATE.substring(0,16));
    		origPlace.get(0).put("RECEIPT_DATE",RECEIPT_DATE==null?"":RECEIPT_DATE.substring(0,16));
    		origPlace.get(0).put("APPLY_DATE",APPLY_DATE==null?"":APPLY_DATE.substring(0,16));
    		origPlace.get(0).put("FILE_DATE",FILE_DATE==null?"":FILE_DATE.substring(0,19));
    		VideoEventModel videoEvent=new VideoEventModel();
    		videoEvent.setProcMainId(origPlace.get(0).get("MAIN_ID"));
    		videoEvent.setProj_code("OC_C_M");
    		List<VideoEventModel> videoList=origPlaceFlowService.getViewImg(videoEvent);
    		map.put("data", origPlace);
    		map.put("video",videoList);
		} catch (Exception e) {
			e.printStackTrace();
		}
    	return map;
	}
    
    /**
     * 跳转原产地电子表格
     * @param request
     * @param id
     * @return
     */
    @RequestMapping("/jumpText")
    public String jumpText(HttpServletRequest request,@RequestParam(value="id", required=true)String id,@RequestParam(value="main_id", required=true)String main_id){
    	try {
			OrigPlaceDto origPlace = origPlaceFlowService.findOrigById(id);
			CheckDocsRcdModel checkDocsRcd=new CheckDocsRcdModel();
			checkDocsRcd.setProcMainId(main_id);
			checkDocsRcd.setDocType("D_OC_C_M_1");
			List<CheckDocsRcdModel> list = origPlaceFlowService.getOptionList(checkDocsRcd);
			if(!list.isEmpty()){
				request.setAttribute("docs", list.get(0));
			}
			request.setAttribute("obj", origPlace);
		} catch (Exception e) {
			logger_.error("***********/origplace/jumpText************",e);
		}
    	return "origplace/text";
	}
    
    /**
     * 图片预览页面
     * @param request
     * @return
     */
    @RequestMapping("/viewImg")
    public String viewImg(HttpServletRequest request,VideoEventModel videoEvent){
    	try {
    		List<VideoEventModel> list = origPlaceFlowService.getViewImg(videoEvent);
			request.setAttribute("list",list);
		} catch (Exception e) {
			logger_.error("***********/origplace/viewImg************",e);
		}
    	return "origplace/img";
	}
    
    @RequestMapping("/video")
    public String video(HttpServletRequest request){
    	return "origplace/index";
	}
    
    /**
     * 图片上传
     * @param request
     * @return
     */
    @ResponseBody
    @RequestMapping("/uploadImg")
    public String uploadImg(HttpServletRequest request,VideoEventModel videoEvent){
    	try {
    		commonServer.save(videoEvent);
		} catch (Exception e) {
			logger_.error("***********/origplace/uploadImg************",e);
			return "error";
		}
    	return "success";
	}
    
	/**
	 * 上传视频
	 * @return
	 */
	@RequestMapping("/addVideoEventModel")
	public String addVideoEventModel(HttpServletRequest request,HttpServletResponse response,VideoEventModel videoEvent,
			RedirectAttributes attr,@RequestParam(value="file", required=true)MultipartFile file)throws Exception{
		String id=videoEvent.getId();
		try {
			System.out.println(request.getContentLength());
			UserInfoDTO user=(UserInfoDTO)request.getSession().getAttribute(Constants.USER_KEY);
			if(null==user){
				throw new Exception("用户失效");
			}
//			request.setAttribute("fileName", UUID.randomUUID().toString());
			List<Map<String, String>> filePathList= FileUtil.uploadFile(request,false);
			for(Map<String, String> map:filePathList){
//				videoEvent.setFileName(map.get("filePath").substring(map.get("filePath").indexOf('/')+1,map.get("filePath").length()));
//				String newFileName=map.get("filePath").substring(map.get("filePath").indexOf(':')+2,map.get("filePath").length());
				String newFileName=map.get("filePath");
				videoEvent.setFileName(newFileName.replaceAll("\\\\", "/"));
				videoEvent.setCreateUser(user.getId());
				videoEvent.setCreateDate(DateUtil.newDate());
				commonServer.save(videoEvent);
			}
			attr.addFlashAttribute("msg","success");
			return "redirect:/origplace/showOrig?id="+id;
		} catch (Exception e) {
			e.printStackTrace();
		}
		attr.addFlashAttribute("msg","error");
		return "redirect:/origplace/showOrig?id="+id;
		
	}
	
    @RequestMapping("/myinfo")
    public String myinfo(HttpServletRequest request,@RequestParam(value="id", required=true)String id,@RequestParam(value="main_id", required=true)String main_id){
    	try {
    		
    		OrigPlaceDto origPlace=new OrigPlaceDto();
    		origPlace.setId(id);
    		origPlace= origPlaceFlowService.getOrigPlace(origPlace);
    		OrigPlaceCargoDto origPlaceCargo=new OrigPlaceCargoDto();
    		origPlaceCargo.setOrg_id(id);
    		List<OrigPlaceCargoDto> list=origPlaceFlowService.getOrigPlaceCargo(origPlaceCargo);
			request.setAttribute("obj", origPlace);
			request.setAttribute("list", list);
		} catch (Exception e) {
			logger_.error("***********/origplace/myinfo************",e);
		}
    	return "origplace/myinfo"+request.getParameter("type");
	}
    
}
