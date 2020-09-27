package com.dpn.ciqqlc.http;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
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
import org.codehaus.jackson.map.ObjectMapper;
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

import com.dpn.ciqqlc.common.util.CommonUtil;
import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.common.util.FileUtil;
import com.dpn.ciqqlc.common.util.PageBean;
import com.dpn.ciqqlc.service.Quartn;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.model.EfpeRegulatoryModel;
import com.dpn.ciqqlc.standard.model.ExpFoodProdCheckDto;
import com.dpn.ciqqlc.standard.model.ExpFoodProdCheckVo;
import com.dpn.ciqqlc.standard.model.ExpFoodProdPsnRdmDTO;
import com.dpn.ciqqlc.standard.model.ExpFoodProdReportDto;
import com.dpn.ciqqlc.standard.model.FileInfoDto;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.model.UsersDTO;
import com.dpn.ciqqlc.standard.model.VideoFileEventModel;
import com.dpn.ciqqlc.standard.service.ExpFoodPOFService;
import com.dpn.ciqqlc.standard.service.ExpFoodProdService;

/**
 * 行政检查 - 辽阳局出口商品及企业监督全过程执法记录
 * @author xwj
 *
 */
@Controller
@RequestMapping(value = "/expFoodProd")
public class ExpFoodProdController {
	
    private final Logger logger_ = LoggerFactory.getLogger(this.getClass());
    
    @Autowired
    @Qualifier("expFoodProdDb")
    private ExpFoodProdService dbServ = null;
    @Autowired
	@Qualifier("expFoodPOFService")
	private ExpFoodPOFService expFoodPOFService = null;
    @Autowired
    private Quartn quartnService;
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
    
    
    @RequestMapping("/toList")
    public String toList(HttpServletRequest request){
    	return "expFoodProd/list";
    }
    
	/**
	 * 列表
	 */
	@RequestMapping("/list")
	public String list(HttpServletRequest request, EfpeRegulatoryModel form){
		try{
			int pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
			form.setFirstRcd(String.valueOf((pages-1)*Constants.PAGE_NUM+1));
			form.setLastRcd(String.valueOf(pages*Constants.PAGE_NUM+1));
			form.setDepname("辽阳局本部");
			request.setAttribute("list", dbServ.findEfpeRegulatoryList(form));
			request.setAttribute("counts", dbServ.findEfpeRegulatoryListCount(form));
			request.setAttribute("form", form);
			request.setAttribute("itemInPage", Constants.PAGE_NUM);                                               //每页显示条数
			request.setAttribute("pages",  pages);
        } catch (Exception e) {
			logger_.error("***********/expFoodProd/list************",e);
		}
		return  "expFoodProd/list";
	}
	
	@RequestMapping("/detail")
	public String detail(HttpServletRequest request, @RequestParam(value="applycode", required=true)String applycode,
			String apply_no,EfpeRegulatoryModel model ,@RequestParam(value="userId", required=true)String userId){
		try {
//			EfpeApplyDTO e = dbServ.findById(applyid);
//			request.setAttribute("model", e);
			model.setDepname("辽阳局本部");
			model.setSubId(applycode);
			List<EfpeRegulatoryModel> companylist=dbServ.findEfpeRegulatoryAll(model);
			request.setAttribute("model", companylist.get(0));
			Map<String,String> map = new HashMap<String,String>();
			map.put("proc_main_id", applycode);//subid
//			map.put("proc_main_id", "lshlshlsh");
			List<VideoFileEventModel> vList = dbServ.videoFileEventList(map);
//			List<VideoFileEventModel> qtList=new ArrayList<VideoFileEventModel>();
			List<VideoFileEventModel> nlist=new ArrayList<VideoFileEventModel>();
			List<VideoFileEventModel> V_BGSC_JD_QT = new ArrayList<VideoFileEventModel>();
			List<VideoFileEventModel> V_BGSC_CZ_QT = new ArrayList<VideoFileEventModel>();
			List<VideoFileEventModel> V_XCCY_JD_QT = new ArrayList<VideoFileEventModel>();
			List<VideoFileEventModel> V_XCCY_CZ_QT = new ArrayList<VideoFileEventModel>();
			List<VideoFileEventModel> V_SP_JD_QT = new ArrayList<VideoFileEventModel>();
			List<VideoFileEventModel> V_SP_CZ_QT = new ArrayList<VideoFileEventModel>();
			for(VideoFileEventModel v:vList){
				if(v.getProc_type().contains("_QT@")){
					v.setProc_type(v.getProc_type().split("@")[0]);
//					qtList.add(v);
					if("V_BGSC_JD_QT".equals(v.getProc_type())){
						V_BGSC_JD_QT.add(v);
					}
					if("V_BGSC_CZ_QT".equals(v.getProc_type())){
						V_BGSC_CZ_QT.add(v);
					}
					
					if("V_XCCY_JD_QT".equals(v.getProc_type())){
						V_XCCY_JD_QT.add(v);
					}
					if("V_XCCY_CZ_QT".equals(v.getProc_type())){
						V_XCCY_CZ_QT.add(v);
					}
					if("V_SP_JD_QT".equals(v.getProc_type())){
						V_SP_JD_QT.add(v);
					}
					if("V_SP_CZ_QT".equals(v.getProc_type())){
						V_SP_CZ_QT.add(v);
					}
				}else{
					nlist.add(v);
				}
			}
			request.setAttribute("subId", applycode);
			request.setAttribute("userId", userId);
			request.setAttribute("V_BGSC_JD_QT", V_BGSC_JD_QT.toArray());
			request.setAttribute("V_BGSC_CZ_QT", V_BGSC_CZ_QT.toArray());
			request.setAttribute("V_XCCY_JD_QT", V_XCCY_JD_QT.toArray());
			request.setAttribute("V_XCCY_CZ_QT", V_XCCY_CZ_QT.toArray());
			request.setAttribute("V_SP_JD_QT", V_SP_JD_QT.toArray());
			request.setAttribute("V_SP_CZ_QT", V_SP_CZ_QT.toArray());
			CommonUtil.setFileEventToReqByProcType(nlist, request);
			request.setAttribute("apply_no", applycode);
			VideoFileEventModel[] procArray = new VideoFileEventModel[]{
//					CommonUtil.getMaxDateFileInProcTypes(request, applyid, new String[]{
//							"V_XZJC_SJ_BS_1", "V_BGSC_JD_ZG", "V_XZJC_SJ_XJ_1", "V_XZJC_SJ_XJ_2", "V_XZJC_SJ_XJ_3",
//							 "V_XZJC_SJ_XJ_4", "V_XZJC_SJ_XJ_5", "V_XZJC_SJ_ZJ_1", "V_XZJC_SJ_ZJ_2", "V_XZJC_SJ_ZJ_3",
//							 "V_XZJC_SJ_ZJ_4", "V_XZJC_SJ_ZJ_5"},
//							 null),
//					 CommonUtil.getMaxDateFileInProcTypes(request, applyid, new String[]{
//							 "V_XZJC_HC_BS_1", "V_XZJC_HC_XS_1", 
//							 "V_XZJC_HC_XS_2", "V_XZJC_HC_XS_3", "V_XZJC_HC_ZS_1",
//							 "V_XZJC_HC_ZS_2", "V_XZJC_HC_ZS_3"},
//							 null),
//							 
//					CommonUtil.getMaxDateFileInProcTypes(request, applyid, new String[]{
//							"V_XZJC_SJ_BS_1", "V_XZJC_SJ_BS_2", "V_XZJC_SJ_XJ_1", "V_XZJC_SJ_XJ_2", "V_XZJC_SJ_XJ_3",
//							 "V_XZJC_SJ_XJ_4", "V_XZJC_SJ_XJ_5", "V_XZJC_SJ_ZJ_1", "V_XZJC_SJ_ZJ_2", "V_XZJC_SJ_ZJ_3", 
//							 "V_XZJC_SJ_ZJ_4", "V_XZJC_SJ_ZJ_5"},
//							 null),
			};
			request.setAttribute("boo1",this.getUnable(request,applycode,"V_SP_A_C"));
			request.setAttribute("boo2",this.getUnable(request,applycode,"V_SP_A_D"));
			
			Map<String,Object> ac = new HashMap<String, Object>();
	    	ac.put("DocType", "V_SP_A_C");
	    	ac.put("ProcMainId", applycode);
	    	List<CheckDocsRcdModel> doclist=expFoodPOFService.getQtOption(ac);
    		List<ExpFoodProdCheckVo> checklist=expFoodPOFService.getAllResult(ac);
    		if(!doclist.isEmpty() && !checklist.isEmpty()){
    			if(doclist.get(0).getDecDate().getTime()>checklist.get(0).getCheck_date().getTime()){
    				UsersDTO user=expFoodPOFService.findUsersByCode(doclist.get(0).getDecUser());
    				if(null!=user){
    					request.setAttribute("textPerson",user.getName());
    				}
    				request.setAttribute("textTime",doclist.get(0).getDecDate());
    			}else{
    				request.setAttribute("textPerson",checklist.get(0).getChech_psn());
    				request.setAttribute("textTime",checklist.get(0).getCheck_date());
    			}
    		}else if(!doclist.isEmpty() && checklist.isEmpty()){
    			UsersDTO user=expFoodPOFService.findUsersByCode(doclist.get(0).getDecUser());
    			if(null!=user){
					request.setAttribute("textPerson",user.getName());
				}
				request.setAttribute("textTime",doclist.get(0).getDecDate());
    		}else if(doclist.isEmpty() && !checklist.isEmpty()){
    			request.setAttribute("textPerson",checklist.get(0).getChech_psn());
				request.setAttribute("textTime",checklist.get(0).getCheck_date());
    		}else{
    			
    		}
    		
    		Map<String,Object> ad = new HashMap<String, Object>();
	    	ad.put("DocType", "V_SP_A_D");
	    	ad.put("ProcMainId", applycode);
	    	List<CheckDocsRcdModel> addoclist=expFoodPOFService.getQtOption(ad);
    		List<ExpFoodProdCheckVo> adchecklist=expFoodPOFService.getAllResult(ad);
    		if(!addoclist.isEmpty() && !adchecklist.isEmpty()){
    			if(addoclist.get(0).getDecDate().getTime()>adchecklist.get(0).getCheck_date().getTime()){
    				UsersDTO user=expFoodPOFService.findUsersByCode(addoclist.get(0).getDecUser());
    				if(null!=user){
    					request.setAttribute("adtextPerson",user.getName());
    				}
    				request.setAttribute("adtextTime",addoclist.get(0).getDecDate());
    			}else{
    				request.setAttribute("adtextPerson",adchecklist.get(0).getChech_psn());
    				request.setAttribute("adtextTime",adchecklist.get(0).getCheck_date());
    			}
    		}else if(!addoclist.isEmpty() && adchecklist.isEmpty()){
    			UsersDTO user=expFoodPOFService.findUsersByCode(doclist.get(0).getDecUser());
    			if(null!=user){
    				request.setAttribute("adtextPerson",user.getName());
    			}
				request.setAttribute("adtextTime",addoclist.get(0).getDecDate());
    		}else if(addoclist.isEmpty() && !adchecklist.isEmpty()){
    			request.setAttribute("adtextPerson",adchecklist.get(0).getChech_psn());
				request.setAttribute("adtextTime",adchecklist.get(0).getCheck_date());
    		}else{
    			
    		}
			request.setAttribute("procArray", new ObjectMapper().writeValueAsString(procArray).replace("null", "\"\"").replace("\"", "\'"));
		} catch (Exception e) {
			logger_.error("***********/expFoodProd/detail************",e);
		}
		return "expFoodProd/detail2";
	}
	
	private boolean getUnable(HttpServletRequest request, String applycode, String type){
		ExpFoodProdCheckVo expFoodProdCheckVo=new ExpFoodProdCheckVo();
		expFoodProdCheckVo.setCheck_result("2");
		expFoodProdCheckVo.setCheck_type("1");
		expFoodProdCheckVo.setApply_no(applycode);
		expFoodProdCheckVo.setTd(type);
		List<ExpFoodProdCheckVo> list=expFoodPOFService.getToTextViewNoPass(expFoodProdCheckVo,request);
//		Map<String,Object> map = new HashMap<String, Object>();
//		map.put("ProcMainId", expFoodProdCheckVo.getApply_no());
//		if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(request.getParameter("type"))){
//			map.put("DocType", request.getParameter("type"));
//		}else{
//			map.put("DocType", "V_SP_F_D");
//		}
//		CheckDocsRcdModel doc  =quartnService.findOnlyDoc(map);
		Map<String,Object> param = new HashMap<String, Object>();
		param.put("DocType", type);
		param.put("ProcMainId", expFoodProdCheckVo.getApply_no());
		List<CheckDocsRcdModel> listQt=expFoodPOFService.getQtOption(param);
		if(list.isEmpty() && listQt.isEmpty() ){
			return false;
		}
		return true;
	}
	
	/**
	 * 不符合项报告
	 */
	@RequestMapping(value = "/unPassXwjable",method=RequestMethod.GET)
    public String unPassXwjable(HttpServletRequest request,ExpFoodProdCheckVo expFoodProdCheckVo,String compName){
    	try {
			request.setAttribute("compName", compName);
		} catch (Exception e) {
			logger_.error("***********/ExpFoodPOF/unPassable************",e);
		}
    	return "expFoodProd/txt/unPassable2";
	}
	
	
	@SuppressWarnings("unused")
	private void paxuList(List<VideoFileEventModel> qtList,
			HttpServletRequest request) {
		List<VideoFileEventModel> V_BGSC_JD_QT = new ArrayList<VideoFileEventModel>();
		List<VideoFileEventModel> V_BGSC_CZ_QT = new ArrayList<VideoFileEventModel>();
		List<VideoFileEventModel> V_XCCY_JD_QT = new ArrayList<VideoFileEventModel>();
		List<VideoFileEventModel> V_XCCY_CZ_QT = new ArrayList<VideoFileEventModel>();
		List<VideoFileEventModel> V_SP_JD_QT = new ArrayList<VideoFileEventModel>();
		List<VideoFileEventModel> V_SP_CZ_QT = new ArrayList<VideoFileEventModel>();
		for(VideoFileEventModel v : qtList){
			if("V_BGSC_JD_QT".equals(v.getProc_type())){
				V_BGSC_JD_QT.add(v);
			}
			if("V_BGSC_CZ_QT".equals(v.getProc_type())){
				V_BGSC_CZ_QT.add(v);
			}
			
			if("V_XCCY_JD_QT".equals(v.getProc_type())){
				V_XCCY_JD_QT.add(v);
			}
			if("V_XCCY_CZ_QT".equals(v.getProc_type())){
				V_XCCY_CZ_QT.add(v);
			}
			if("V_SP_JD_QT".equals(v.getProc_type())){
				V_SP_JD_QT.add(v);
			}
			if("V_SP_CZ_QT".equals(v.getProc_type())){
				V_SP_CZ_QT.add(v);
			}
		}
		request.setAttribute("V_BGSC_JD_QT", V_BGSC_JD_QT.toArray());
		request.setAttribute("V_BGSC_CZ_QT", V_BGSC_CZ_QT.toArray());
		request.setAttribute("V_XCCY_JD_QT", V_XCCY_JD_QT.toArray());
		request.setAttribute("V_XCCY_CZ_QT", V_XCCY_CZ_QT.toArray());
		request.setAttribute("V_SP_JD_QT", V_SP_JD_QT.toArray());
		request.setAttribute("V_SP_CZ_QT", V_SP_CZ_QT.toArray());
		
	}

	/**
     * 跳转电子表格
     * @param request
     * @param id
     * @return
     */
    @RequestMapping("/jumpText")
    public String jumpText(HttpServletRequest request,ExpFoodProdReportDto expFoodProdReport){
    	try {
//    		expFoodProdReport = dbServ.findFoodProdReport(expFoodProdReport);
			List<ExpFoodProdReportDto> list=dbServ.findFoodProdReport(expFoodProdReport);
    		request.setAttribute("obj", list);
		} catch (Exception e) {
			logger_.error("***********/expFoodProd/jumpText************",e);
		}
    	return "expFoodProd/jumpText";
	}
	
	/**
	 * 案件移送函
	 * @param request
	 * @param id
	 * @param step
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/toPage")
    public String toAjysh(HttpServletRequest request, @RequestParam(value="applyid", required=true)String applyid,
    		@RequestParam(value="page", required=true)String page,
    		@RequestParam(value="update", required=false)String update,
    		@RequestParam(value="compname", required=false)String compname){
		try {
			//遍历check记录begin
			List<ExpFoodProdCheckDto> list = dbServ.findCheckList(applyid);
			for(ExpFoodProdCheckDto dto : list){
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("check", dto);
				request.setAttribute(dto.getCheck_proc_type(), map);
			}
			//遍历check记录end
			
			Map<String, String> paramMap = new HashMap<String, String>();
			paramMap.put("proc_main_id", applyid);
			List<VideoFileEventModel> vList = dbServ.videoFileEventList(paramMap);
			//遍历附件 begin
			List<VideoFileEventModel> subList = new ArrayList<VideoFileEventModel>();
			String proc_type = "";
			for(VideoFileEventModel v : vList){
				if(!proc_type.equals(v.getProc_type())){
					Map<String, Object> map = (request.getAttribute(v.getProc_type()) == null ? new HashMap<String, Object>() : (Map<String, Object>)request.getAttribute(v.getProc_type()));
					map.put("files", subList);
					request.setAttribute(v.getProc_type(), map);
					
					subList.clear();
					proc_type = v.getProc_type();
				}
				subList.add(v);
			}
			request.setAttribute(proc_type, subList.toArray());//last one
			//遍历附件 end
			request.setAttribute("compname", compname);
		} catch (Exception e) {
			logger_.error("***********/generalPunishment/toPage************",e);
		}
    	return "template/"+page+("update".equals(update) ? "_input" : "");
    }
	
	/**
	 * 添加随机人员初始化页面
	 * @param dto 随机人员对象
	 * @param model Model对象
	 * @return list
	 */
	@RequestMapping("/addpeson")
	public String addPeson(ExpFoodProdPsnRdmDTO dto,Model model,HttpServletRequest request,String personNum){
		ExpFoodProdPsnRdmDTO foodProdPsnRdmDTO = new ExpFoodProdPsnRdmDTO();
		try {
			String psn_prof = request.getParameter("z_psn_prof");
			String psn_goodat = request.getParameter("z_psn_goodat");
			String psn_level = request.getParameter("z_psn_level");
			String in_post = request.getParameter("z_in_post");
			String bel_scope = request.getParameter("z_bel_scope");
			foodProdPsnRdmDTO.setPsn_prof(psn_prof);
			foodProdPsnRdmDTO.setPsn_goodat(psn_goodat);
			foodProdPsnRdmDTO.setPsn_level(psn_level);
			foodProdPsnRdmDTO.setIn_post(in_post);
			foodProdPsnRdmDTO.setBel_scope(bel_scope);
			//组员
			model.addAttribute("member", dbServ.findByBasePseon(foodProdPsnRdmDTO));
			//组长		
			model.addAttribute("lader", dbServ.findByBasePseon(dto));
			request.setAttribute("z_psn_prof",psn_prof);
			request.setAttribute("z_psn_goodat",psn_goodat);
			request.setAttribute("z_psn_level",psn_level);
			request.setAttribute("z_in_post",in_post);
			request.setAttribute("z_bel_scope",bel_scope);
			request.setAttribute("personNum",personNum);
			request.setAttribute("obj",dto);
			request.setAttribute("apply_no",dto.getApply_no());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "expFoodProd/addpeson";
	}
/*	@RequestMapping("/addpeson")
	public String addPeson(QlcEfpePsnDto dto,Model model,HttpServletRequest request,String personNum){
		QlcEfpePsnDto efpePsn = new QlcEfpePsnDto();
		try {
			String psn_prof = request.getParameter("z_psn_prof");//专业
			String psn_goodat = request.getParameter("z_psn_goodat");//特长
			String psn_level = request.getParameter("z_psn_level");//级别
			String in_post = request.getParameter("z_in_post");
			String bel_scope = request.getParameter("z_bel_scope");//所在范围
			efpePsn.setPsnMajor(psn_prof);
			efpePsn.setPsnOther_goodat(psn_goodat);
			efpePsn.setPsnLevel(psn_level);
			efpePsn.setIn_post(in_post);
			efpePsn.setLevelDept_2(bel_scope);
			//组员
			model.addAttribute("member", dbServ.findByBasePseon2(efpePsn));
			//组长		
			model.addAttribute("lader", dbServ.findByBasePseon2(dto));
			request.setAttribute("z_psn_prof",psn_prof);
			request.setAttribute("z_psn_goodat",psn_goodat);
			request.setAttribute("z_psn_level",psn_level);
			request.setAttribute("z_in_post",in_post);
			request.setAttribute("z_bel_scope",bel_scope);
			request.setAttribute("personNum",personNum);
			request.setAttribute("obj",dto);
			request.setAttribute("apply_no",dto.getApply_no());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "expFoodProd/addpeson";
	}*/
	
	/**
	 * 添加随机人员初始化页面
	 * @param dto 随机人员对象
	 * @param model Model对象
	 * @return list
	 */
	@RequestMapping("/pesoninit")
	public String pesoninit(HttpServletRequest request,ExpFoodProdPsnRdmDTO dto,Model model,String no){
		request.setAttribute("apply_no",no);
		return "expFoodProd/addpeson";
	}
		
	/**
	 * 
	 *搜索 随机人员列表
	 * @param dto 随机人员对象
	 * @param model Model对象
	 * @param no 企业编号
	 * @return list
	 */
	@RequestMapping("/peson")
	public String searchPeson(ExpFoodProdPsnRdmDTO dto,HttpServletRequest request,String apply_time_begin,String apply_time_over){
		 int pages = 1;
	        if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
	            pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
	        }
	        PageBean page_bean = new PageBean(pages, String.valueOf(Constants.PAGE_NUM));
	        dto.setFirstRcd(String.valueOf((pages-1)*Constants.PAGE_NUM+1));
	        dto.setLastRcd(String.valueOf(pages*Constants.PAGE_NUM+1));
	        String type=request.getParameter("type");
	        dto.setType(type);
	        request.setAttribute("list", dbServ.findByPseon(dto));
			int counts = dbServ.findPersonCount(dto);
			
			int page =0;
			if(counts%5>0){
				page=counts/5;
				page+=1;
			}else{
				page=counts/5;
			}
			request.setAttribute("obj",dto);
			request.setAttribute("apply_time_begin",apply_time_begin);
			request.setAttribute("apply_time_over",apply_time_over);
			//企业申请编号号
			//request.getSession().setAttribute("no", dto.getApply_no());
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
	        request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
            request.setAttribute("counts",counts);
            request.setAttribute("page",page);
            request.setAttribute("allPage", counts % page_bean.getPageSize()==0 ? (counts/page_bean.getPageSize()) : (counts/page_bean.getPageSize())+1);
		return "expFoodProd/peson";
	}
	
	/**
	 * 
	 * 保存到本地随机人员库
	 * @param learId 队长选中的id
	 * @param merId 组员选中的id
	 * @param num 选中的人数
	 * @param applyNo 企业申请的号
	 * @param submitType 提交方式 1是默认提交，0是人为选中的提交
	 * @return ajaxResult
	 */
	@SuppressWarnings("unused")
	@ResponseBody
	@RequestMapping("/insert")
	public Map<String,Object> insertPeson(HttpServletRequest request,String learId,String merId,String num,String applyNo,String submitType){
		Map<String,Object> ajaxResult = new HashMap<String, Object>();
		try {
			String[] lId =learId.split(",");
			String[] mId =merId.split(",");
			int size =Integer.parseInt(num);
			Set<String> set  = new HashSet<String>();
			int result = 0;
			//随机提交
				if(StringUtils.isNotBlank(submitType)){
					String lad ="";
					String tmer ="";
					if("2".equals(submitType)){					
							Random ss =new Random();
							for(int i =0; i<lId.length;i++){
								int ld =ss.nextInt(lId.length-1);
								//随机取出队长id
								 lad =	lId[ld];
								 set.add(lad);
								 break;
							}		
							List<String> list=Arrays.asList(mId);
							List<String> mlist=new ArrayList<String>();
							for(String s:list){
								if(!lad.equals("") && !s.equals(lad)){
									mlist.add(s);
								}
							}
							if(mlist.size()>size-1){
								for(int k = 1; k < size; k++){
									int i = ss.nextInt(mlist.size());
									while (set.contains(mlist.get(i))) { // 如果重复 就退回去
										k--;
										i= ss.nextInt(mlist.size());
									}
									set.add(mlist.get(i));
								}
							}else{
								set.addAll(mlist);
							}
							for(String id:set){
								result=	this.savePerson(request,id, applyNo, submitType);
							}						
					}else {
						//人工选择
						String allId= learId+merId;
						String[] all = allId.split(",");
						if(all !=null && all !=null){
							for(int i=0; i<all.length;i++){
								result=	this.savePerson(request,all[i], applyNo, submitType);
							}
						}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				ajaxResult.put("status", "FALL");
				ajaxResult.put("results","失败");
				return ajaxResult;	
			}
			ajaxResult.put("status", "OK");
			ajaxResult.put("results","成功");
			return ajaxResult;		
	}
	
	private int savePerson(HttpServletRequest request,String id,String applyNo,String submitType) throws Exception{
		ExpFoodProdPsnRdmDTO dto = new ExpFoodProdPsnRdmDTO();
		dto.setId(id);
		//遍历出随机集合内的所有id
		List<ExpFoodProdPsnRdmDTO> ist =null;	
		ist =	dbServ.findByBasePseon(dto);
		if(ist!=null && ist.size()>0){
			dto.setApply_no(applyNo);
			dto.setPsn_id(ist.get(0).getId());
			dto.setPsn_name(ist.get(0).getPsn_name());								
			dto.setPsn_prof(ist.get(0).getPsn_prof());
			dto.setPsn_goodat(ist.get(0).getPsn_goodat());
			dto.setPsn_level(ist.get(0).getPsn_level());
			dto.setIn_post(ist.get(0).getIn_post());						
			dto.setBel_scope(ist.get(0).getBel_scope());
			dto.setRdm_type(submitType);
			UserInfoDTO user=(UserInfoDTO)request.getSession().getAttribute(Constants.USER_KEY);
			dto.setRdm_user(user.getId());
			return dbServ.insterPersonRdm(dto);							
		}
		return 0;
	}
	
    @RequestMapping(value = "/downExcel",method=RequestMethod.GET)
    public void downExcel(ExpFoodProdPsnRdmDTO dto,HttpServletRequest request,HttpServletResponse response){
    	 ByteArrayOutputStream os = new ByteArrayOutputStream();
	        try {
	        	String columnNames[]={"申请时间","企业名称","随机人员","地区范围","申请形式","流程环节"};//列名
			    String keys[]    =     {"apply_time","comp_name","psn_name","bel_scope","apply_type","proc_type"};//map中的key
			    List<ExpFoodProdPsnRdmDTO> list=dbServ.findAllPseon(dto);
			    List<Map<String, Object>> mlist=createListRecord(list);
	        	FileUtil.createWorkBook(mlist,keys,columnNames).write(os);
	        	FileUtil.outPutExcel(os,response,"随机人员"+DateUtil.DateToString(new Date(), "yyyyMMddHHmmss"));
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	}
    
	 private List<Map<String, Object>> createListRecord(List<ExpFoodProdPsnRdmDTO> list) {
		  List<Map<String, Object>> listmap = new ArrayList<Map<String, Object>>();
	        Map<String, Object> map = new HashMap<String, Object>();
	        map.put("sheetName", "sheet1");
	        listmap.add(map);
	        ExpFoodProdPsnRdmDTO dto=null;
	        for (int j = 0; j < list.size(); j++) {
	            dto=list.get(j);
	            Map<String, Object> mapValue = new HashMap<String, Object>();
	            mapValue.put("apply_time", DateUtil.DateToString(dto.getApply_time(),DateUtil.DATE_DEFAULT_FORMAT));
	            mapValue.put("comp_name", dto.getComp_name());
	            mapValue.put("psn_name", dto.getPsn_name());
	            if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(dto.getBel_scope())){
	            	dto.setBel_scope(dto.getBel_scope()+"级部门");
	            }
	            mapValue.put("bel_scope", dto.getBel_scope());
	            mapValue.put("apply_type", dto.getApply_type());
	            mapValue.put("proc_type", dto.getProc_type());
	            listmap.add(mapValue);
	        }
	        return listmap;
	}
	 
	/**
	 * 
	 * 搜索企业库列表
	 * 
	 * @param dto对象

	 */
	/*@RequestMapping("/showFileMessage")
	public String showFileMessage(FileInfoDto dto,HttpServletRequest request) {
		try {
			int pages = 1;
			if (request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
				pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
			}
			PageBean page_bean = new PageBean(pages,String.valueOf(Constants.PAGE_NUM));
			dto.setFirstRcd(page_bean.getLow());
			dto.setLastRcd(page_bean.getHigh());
			request.setAttribute("list", dbServ.findFileInfo(dto));
			int counts = dbServ.findFileCount(dto);
			request.setAttribute("obj", dto);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
			request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
			request.setAttribute("counts", counts);
			request.setAttribute("allPage",counts % page_bean.getPageSize() == 0 ? (counts / page_bean.getPageSize()): (counts / page_bean.getPageSize()) + 1);
		} catch (NumberFormatException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "expFoodProd/FileMessage";
	}
	
	@RequestMapping("/newFileMessage")
	public String newFileMessage(FileInfoDto dto,HttpServletRequest request) {
	
		return "expFoodProd/newFileMessage";
	}*/
	
	 /**
     * 文件上传
     * @param request
     * @return
     */
    @RequestMapping("/uploadFile")
    public String uploadImg(HttpServletRequest request,FileInfoDto dto){
    	try {
    		String path= FileUtil.uploadOneFile(request);
    		if(StringUtils.isEmpty(path)){
    			throw new Exception("上传失败");
    		}
    		dto.setFile_location(path);
    		UserInfoDTO user=(UserInfoDTO)request.getSession().getAttribute(Constants.USER_KEY);
    		if(null==user){
    			throw new Exception("用户失效");
    		}
    		dto.setCreate_user(user.getId());
    		dbServ.saveUpload(dto);
		} catch (Exception e) {
			logger_.error("***********/expFoodProd/uploadFile************",e);
			return "error";
		}
    	return "redirect:/expFoodPOF/showFileMessage";
	}
    
    /**
	 * 
	 *搜索 随机人员列表
	 * @param dto 随机人员对象
	 * @param model Model对象
	 * @param no 企业编号
	 * @return list
	 */
	@RequestMapping("/xj/peson")
	public String xjsearchPeson(ExpFoodProdPsnRdmDTO dto,HttpServletRequest request,String apply_time_begin,String apply_time_over){
		 int pages = 1;
	        if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
	            pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
	        }
	        PageBean page_bean = new PageBean(pages, String.valueOf(Constants.PAGE_NUM));
	        dto.setFirstRcd(String.valueOf((pages-1)*Constants.PAGE_NUM+1));
	        dto.setLastRcd(String.valueOf(pages*Constants.PAGE_NUM+1));
			request.setAttribute("list", dbServ.findByPseon(dto));
			int counts = dbServ.findPersonCount(dto);
			
			int page =0;
			if(counts%5>0){
				page=counts/5;
				page+=1;
			}else{
				page=counts/5;
			}
			request.setAttribute("obj",dto);
			request.setAttribute("apply_time_begin",apply_time_begin);
			request.setAttribute("apply_time_over",apply_time_over);
			//企业申请编号号
			//request.getSession().setAttribute("no", dto.getApply_no());
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
	        request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
            request.setAttribute("counts",counts);
            request.setAttribute("page",page);
            request.setAttribute("allPage", counts % page_bean.getPageSize()==0 ? (counts/page_bean.getPageSize()) : (counts/page_bean.getPageSize())+1);
		return "expFoodProd/xjpeson";
	}
    
}
