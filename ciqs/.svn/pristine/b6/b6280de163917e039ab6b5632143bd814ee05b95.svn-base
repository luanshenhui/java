package com.dpn.ciqqlc.http;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.common.util.FileUtil;
import com.dpn.ciqqlc.common.util.PageBean;
import com.dpn.ciqqlc.common.util.StringUtils;
import com.dpn.ciqqlc.http.form.IntercepeForm;
import com.dpn.ciqqlc.http.form.TravCarryObjForm;
import com.dpn.ciqqlc.standard.model.IntercepeModel;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.model.VideoEventModel;
import com.dpn.ciqqlc.standard.model.VideoFileEventModel;
import com.dpn.ciqqlc.standard.service.BelongingsService;
import com.dpn.ciqqlc.standard.service.CommonService;
import com.dpn.ciqqlc.standard.service.MailObjCheckDbService;

@Controller
@RequestMapping(value = "/Belongings")
public class BelongingsController {
	/**
     * logger.
     * 
     * @since 1.0.0
     */
	private final Logger logger_ = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	@Qualifier("belongingsService")
	private BelongingsService belongingsService = null;
	
	@Autowired
	@Qualifier("mailObjCheckServ")
	private MailObjCheckDbService mailObjCheckServ = null;
	
	@Autowired
	private CommonService commonServer = null; 
		
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
	 * 查询拦截物信息
	 * uri
	 * @param DTO
	 * @return
	 */
	@RequestMapping(value = "/Intercepe")
	public String intercepe(HttpServletRequest request,IntercepeForm intercepeForm){
		Map<String,String> map = new HashMap<String,String>();
		/***************************** 分页列表查询部分  ***********************************/
        int pages = 1;
        if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
            pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
        }
        PageBean page_bean = new PageBean(pages, String.valueOf(Constants.PAGE_NUM));
		map.put("cardNo", intercepeForm.getCardNo());
		map.put("interceptDate1", intercepeForm.getInterceptDate1());
		map.put("interceptDate2", intercepeForm.getInterceptDate2());
		//直属局 ：默认辽宁局
		if(null == intercepeForm.getPortOrg()){
			intercepeForm.setPortOrg(Constants.DEFAULT_ORG_CODE);
		}
		map.put("portOrg", intercepeForm.getPortOrg());
		//分支机构：默认丹东局
		if(null == intercepeForm.getPortOrgUmder()){
			intercepeForm.setPortOrgUmder("210700");
		}
		map.put("portOrgUmder", intercepeForm.getPortOrgUmder());
		map.put("goodsType", intercepeForm.getGoodsType());
		map.put("goodsItemName", intercepeForm.getGoodsItemName());
		map.put("declNo", intercepeForm.getDeclNo());
		map.put("firstRcd", page_bean.getLow());
		map.put("lastRcd", page_bean.getHigh());
		/***************************** 查询数据部分  ***********************************/
		List<IntercepeModel> list = new ArrayList<IntercepeModel>();
		list = belongingsService.selectIntercepe(map);
		int counts = belongingsService.findIntercepeCount(map);
		/***************************** 查询条件下拉列表数据部分  ***********************************/
		
		List<SelectModel> allorgList =belongingsService.allOrgList();
		List<SelectModel> alldepList =belongingsService.allDepList();
		List<SelectModel> allGoodsTypeList =belongingsService.allGoodsTypeList();
		/***************************** 页面el表达式传递数据部分  ***********************************/
		request.setAttribute("pages", Integer.toString(pages));// 当前页码
        request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
        request.setAttribute("counts",counts);
        request.setAttribute("allPage", counts % page_bean.getPageSize()==0 ? (counts/page_bean.getPageSize()) : (counts/page_bean.getPageSize())+1);
		request.setAttribute("list", list);
		request.setAttribute("allorgList", allorgList);
		request.setAttribute("alldepList", alldepList);
		request.setAttribute("allGoodsTypeList", allGoodsTypeList);
		request.setAttribute("cardNo", intercepeForm.getCardNo());
		request.setAttribute("declNo", intercepeForm.getDeclNo());
		request.setAttribute("interceptDate1", intercepeForm.getInterceptDate1());
		request.setAttribute("interceptDate2", intercepeForm.getInterceptDate2());
		request.setAttribute("portOrg", intercepeForm.getPortOrg());
		request.setAttribute("portOrgUmder", intercepeForm.getPortOrgUmder());
		request.setAttribute("goodsType", intercepeForm.getGoodsType());
		request.setAttribute("goodsItemName", intercepeForm.getGoodsItemName());
		return "belongings/intercepe";
	}
	
	/**
	 * 提交业务单号
	 * @param request
     * @param travCarryObjForm
	 * @return
	 */
    @ResponseBody
    @RequestMapping("/insertItravCarryObj")
    public Map<String,Object> insertItravCarryObj(HttpServletRequest request,
    			@RequestParam("cardNo") String cardNo,
    			@RequestParam("prodMainId") String prodMainId,
    			@RequestParam("qlcTravCarryObjId") String qlcTravCarryObjId){
    	Map<String,Object> map = new HashMap<String,Object>();
		Map<String,Object> resultMap = new HashMap<String,Object>();
    	try{
    		UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
     				Constants.USER_KEY);
    		String port_org_code = "210700";// 默认的分支机构
    		map.put("prod_main_id", prodMainId); // EICQ表的decl_no/（业务单号）
    		map.put("card_no", cardNo);       // 护照号
    		map.put("port_zs_org_code", Constants.DEFAULT_ORG_CODE);// 直属局
    		port_org_code = getOrgCode(user,port_org_code);
    		map.put("port_org_code", port_org_code);// 分支机构
    		map.put("port_dept_code", port_org_code);
    		map.put("create_user", user.getId());
    		map.put("create_date", DateUtil.newDate());
    	
    		if(StringUtils.isEmpty(qlcTravCarryObjId)){
    			belongingsService.insertItravCarryObj(map);
    		}else{
    			map.put("id", qlcTravCarryObjId);
    			belongingsService.updateItravCarryObj(map);
    		}
    		resultMap.put("result", "OK");
		} catch (Exception e) {
			logger_.error("***********/belongings/details************",e);
			resultMap.put("result", "ERROR");
		}
    	return resultMap;
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
            }
            UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
    				Constants.USER_KEY);
			// 把文件的路径信息保存到数据库中
			VideoEventModel video = new VideoEventModel();
			video.setProcMainId(package_no);
			video.setFileName(filePath);
			video.setFileType(fileType);
			video.setProcType(procType);
			video.setPortOrgCode(Constants.DEFAULT_ORG_CODE);
			String port_org_code = "210700";
			video.setPortDeptCode(getOrgCode(user,port_org_code));
			video.setCreateUser(user.getId());
			video.setCreateDate(DateUtil.newDate());
			commonServer.save(video);
		} catch (Exception e1) {
			e1.printStackTrace();
		}
    	try{
    		
		} catch (Exception e) {
			
			logger_.error("***********/mail/saveFileVideoOrImg************",e);
		}
    	return "redirect:/Belongings/details?prod_main_id="+id+"&card_no="+package_no;
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
	 * 查询拦截物详细信息
	 * @param request
	 * @param card_no
	 * @return
	 */
	 @RequestMapping("/details")
	    public String details(HttpServletRequest request,String card_no,String prod_main_id){
	    	try{
	    		/***************************** 查询数据部分  ***********************************/
	    		Map<String,String> map = new HashMap<String,String>();
	    		map.put("card_no", card_no);
	    		map.put("prod_main_id", prod_main_id);
	    		List<IntercepeModel> list = belongingsService.selectIntercepeDetails(map);
	    		// 查询电子签名
	    		map.put("doc_type", "V_DD_P_C_4");//现场查验环节
	    		String qmpath1 = belongingsService.getDzqm(map);
	    		map.put("doc_type", "V_DD_P_C_6");//现场检疫环节
	    		String qmpath2 = belongingsService.getDzqm(map);
	    		map.put("doc_type", "V_DD_P_C_8");//封存、截留决定及实施环节
	    		String qmpath3 = belongingsService.getDzqm(map);
	    		map.put("doc_type", "V_DD_P_C_10");//解除封存、截留环节
	    		String qmpath4 = belongingsService.getDzqm(map);
	    		/***************************** 页面el表达式传递数据部分  ***********************************/
	    		request.setAttribute("qmpath1", qmpath1);
	    		request.setAttribute("qmpath2", qmpath2);
	    		request.setAttribute("qmpath3", qmpath3);
	    		request.setAttribute("qmpath4", qmpath4);
	    		request.setAttribute("list", list);
	    		request.setAttribute("prod_main_id", prod_main_id);
	    		request.setAttribute("card_no", card_no);
			} catch (Exception e) {
				
				logger_.error("***********/belongings/details************",e);
			}
	    	return "belongings/details";
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
	    			@RequestParam(value="card_no", required=true) String card_no){
	    	Map<String,String> map = new HashMap<String,String>();
			Map<String,Object> resultMap = new HashMap<String,Object>();
	    	try{
	    		/***************************** 查询视频和图片集合  ***********************************/
	    		map.put("card_no", card_no);
	    		List<VideoFileEventModel> videoFileEventList = belongingsService.videoFileEventList(map);
	    		/***************************** 页面el表达式传递数据部分  ***********************************/
	    		resultMap.put("videoFileEventList", videoFileEventList);
			} catch (Exception e) {
				
				logger_.error("***********/belongings/details************",e);
			}
	    	return resultMap;
		}
}
