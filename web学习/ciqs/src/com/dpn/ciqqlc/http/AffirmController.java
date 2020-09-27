package com.dpn.ciqqlc.http;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dpn.ciqqlc.common.util.CommonUtil;
import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.http.form.AffirmForm;
import com.dpn.ciqqlc.service.AffirmDb;
import com.dpn.ciqqlc.standard.model.DocTypeDTO;
import com.dpn.ciqqlc.standard.model.VideoDTO;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdDTO;
import com.dpn.ciqqlc.standard.model.CodeLibraryDTO;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.model.VideoFileEventModel;
import com.dpn.ciqqlc.standard.model.VisualDeclareDTO;

/*********************************************************************************************************************
 * 进出境运输工具检疫（货轮）
 *********************************************************************************************************************/
@Controller
@RequestMapping(value = "/affirm")
public class AffirmController {
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
    @Autowired
    @Qualifier("affirmDbServ")
    private AffirmDb affirmDbServ = null;
    
    /*********************************************************************************************************************
   	* 页面跳转
     * @throws IOException 
   	*********************************************************************************************************************/
	/**
	 * @param request
	 * @param session
	 * @param affirmForm
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/showtransports_jsp")
    public String showTransports_jsp(HttpServletRequest request,HttpSession session,AffirmForm affirmForm) throws Exception{
		UserInfoDTO user=(UserInfoDTO)session.getAttribute(Constants.USER_KEY);
		Map<String,String> map = new HashMap<String,String>();
		
		try{
			int pages = 1;
	        if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
	            pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
	        }
			List<CodeLibraryDTO> checktypes=CommonUtil.queryCodeLibrary(Constants.QLC_VSL_DEC_CHECK_TYPE_APRV,request);  //检疫方式下拉列表
			List<CodeLibraryDTO> organizes=CommonUtil.queryCodeLibrary(Constants.QLCORGANIZES,request);             //直属局下拉列表
			List<CodeLibraryDTO> deptments=CommonUtil.queryCodeLibrary(Constants.QLCDEPTMENTS,request);             //分支机构下拉列表
			/*
			if(user.getManage_sign().equals("Y")){                                                                  //系统管理员
	    	       organizes.add(0, new CodeLibraryDTO());
	    	       deptments.add(0, new CodeLibraryDTO()); 
	        }else if(CommonUtil.OrganizesContains(organizes, user.getOrg_code())){                                  //直属局人员
	        	   for(int i=organizes.size()-1;i>=0;i--){
	        		   if(!(organizes.get(i).getCode().equals(user.getOrg_code()))){
	        			   organizes.remove(i);
	        		   }
	        	   }
	        	   affirmForm.setPort_org(user.getOrg_code());
	        	   deptments.add(0, new CodeLibraryDTO());
	        }else{                                                                                                   //分支机构人员
	        	  for(int i=deptments.size()-1;i>=0;i--){
	        		   if(!(deptments.get(i).getCode().equals(user.getOrg_code()))){
	        			   deptments.remove(i);
	        		   }
	        	   }
	        	   affirmForm.setPort_org("CIQGVLN");                                                                //此处code应为该登陆人所属分支机构的上级的直属局code（因数据库没有逻辑关系或者数据补全，目前写死）
	        	   affirmForm.setPort_org_under(user.getOrg_code());
	        }
	        */
			//直属局-默认辽宁局
			if(null == affirmForm.getPort_org()){
				affirmForm.setPort_org(Constants.DEFAULT_ORG_CODE);
			}
			//分支机构-默认旅顺办事处
			if(null == affirmForm.getPort_org_under()){
				affirmForm.setPort_org_under("211960");
			}
			
			map.put("vsl_cn_name", affirmForm.getVsl_cn_name());
			map.put("vsl_en_name", affirmForm.getVsl_en_name());
			map.put("start_time", affirmForm.getStart_time());
			map.put("end_time", affirmForm.getEnd_time());
			map.put("port_org",affirmForm.getPort_org());                                                            
 	        map.put("port_org_under", affirmForm.getPort_org_under());
			map.put("check_type_aprv", affirmForm.getCheck_type_aprv());
			map.put("firstRcd", String.valueOf((pages-1)*Constants.PAGE_NUM+1));                                     //数据定位
			map.put("lastRcd", String.valueOf(pages*Constants.PAGE_NUM+1));        
	
			List<VisualDeclareDTO> results = affirmDbServ.findTransports(map);                                       //列表信息
			int counts=affirmDbServ.findTransportsCount(map);                                                        //查询数据总条数
			
			request.setAttribute("map", map);                                                                        //查询条件回显
			request.setAttribute("results", results);
			request.setAttribute("counts", counts);                                                                  //总条数
			request.setAttribute("itemInPage", Constants.PAGE_NUM);                                                  //每页显示条数
			request.setAttribute("pages",  pages);                                                                   //当前页面                                
			request.setAttribute("checktypes",checktypes);  
			request.setAttribute("organizes", organizes);                
			request.setAttribute("deptments", deptments);                
		}
    	catch(Exception e){
    		logger_.error("***********/affirm/showtransports_jsp************",e);
    	}
		return "affirm/transport/transports";
    }
    
    /*********************************************************************************************************************
   	* 页面跳转
   	*********************************************************************************************************************/
    @RequestMapping("/showtransportinfo_jsp")
    public String showTransportinfo_jsp(HttpServletRequest request, String transportid){
    	try {
    		VisualDeclareDTO results = affirmDbServ.findTransportOne(transportid);         //获得进出境运输工具检疫（货轮）基本信息
    		request.setAttribute("results", results);
		} catch (Exception e) {
			logger_.error("***********/affirm/transportinfo************",e);
		}
    	return "affirm/transport/transportinfo";
    }
    
    /**
     * 详细信息ajax请求
     */
    @ResponseBody
    @RequestMapping("/findtransportone")
    public Map<String,Object> findTransportOne(HttpServletRequest request, String transportid){
    	Map<String,Object> resultData=new HashMap<String,Object>();

    	try{
    		if(null==transportid||"".equals(transportid)){
    			 resultData.put("status", "FAIL");
    			 resultData.put("results", "输入数据不能为空");
    		}else{
    			 Map<String, String> filesParameter=new HashMap<String,String>();                  //存放照片，视频和doc的查询参数
    			 VisualDeclareDTO results = affirmDbServ.findTransportOne(transportid);         //获得进出境运输工具检疫（货轮）基本信息
    			 filesParameter.put("proc_main_id", transportid); 
    			 filesParameter.put("proj_code", "JC_T_T"); 
    			 filesParameter.put("port_org_code", "");
    			 filesParameter.put("port_dept_code", "");
    			 List<VideoDTO> transportFiles = affirmDbServ.queryTransportFiles(filesParameter);    //查询该详情页面所涉及的所有照片和视频 
    			 List<DocTypeDTO> transportDocs=affirmDbServ.queryTransportTemplates(filesParameter);   //查询该详情页面所涉及的所有doc
    			 resultData.put("status", "OK");
    			 resultData.put("results", results);
    			 resultData.put("transportFiles", transportFiles);
    			 resultData.put("transportDocs", transportDocs);
    			 //查询登轮前检查doc
    			 Map<String, String> paramMap = new HashMap<String,String>(); 
    			 paramMap.put("proc_main_id", transportid);
    			 paramMap.put("doc_type", "D_JC_T_T_10");
    			 CheckDocsRcdDTO doc1 = affirmDbServ.findDocByTypeNMainId(paramMap);
    			 if(null != doc1){
    				 resultData.put("doc1", doc1);
    			 }
    			 // 查询申报无异常事项表
    			 paramMap.put("proc_main_id", transportid);
    			 paramMap.put("doc_type", "D_JC_T_T_12");
    			 CheckDocsRcdDTO doc3 = affirmDbServ.findDocByTypeNMainId(paramMap);
    			 if(null != doc3){
    				 resultData.put("doc3", doc3);
    			 }
    			 
    			//检疫查验-是否发现病人doc
    			 paramMap.put("doc_type", "D_JC_T_T_11");
    			 CheckDocsRcdDTO doc2 = affirmDbServ.findDocByTypeNMainId(paramMap);
    			 if(null != doc2){
    				 resultData.put("doc2", doc2);
    			 }
    			 
    			//是否需要采样是否需要卫生处理存储doc表
    			 paramMap.put("doc_type", "D_JC_T_T_13");
    			 CheckDocsRcdDTO doc4 = affirmDbServ.findDocByTypeNMainId(paramMap);
    			 if(null != doc4){
    				 resultData.put("doc4", doc4);
    			 }
    			 
    			 //申报
    			 VideoFileEventModel proc1 = new VideoFileEventModel();
    			 proc1.setCreate_date_str(results.getAprv_date() != null ? DateUtil.DateToString(results.getAprv_date(), "yyyy-MM-dd hh:mm") : "");
    			 proc1.setCreate_user(results.getAprv_user());
    			 
    			 
    			 VideoFileEventModel[] procArray = new VideoFileEventModel[]{
    			     //申报
    				 proc1,
					 //检疫查验  - 1.登轮前检查  2.登轮后审核  3.检疫查验
					 CommonUtil.getMaxDateFileInProcTypes(request, transportid, new String[]{"V_JC_T_T_1", "V_JC_T_T_2", "V_JC_T_T_3",
						 "V_JC_T_T_4", "V_JC_T_T_5", "V_JC_T_T_6", "V_JC_T_T_7"}, new String[]{"D_JC_T_T_0", "D_JC_T_T_2"}),
					 //CommonUtil.getMaxDateFileInProcTypes(request, transportid, new String[]{"V_JC_T_T_3", "V_JC_T_T_4"}, null),
					 //CommonUtil.getMaxDateFileInProcTypes(request, transportid, new String[]{"V_JC_T_T_5", "V_JC_T_T_6", "V_JC_T_T_7",
					 //		 "V_JC_T_T_8", "V_JC_T_T_9", "V_JC_T_T_10", "V_JC_T_T_11", "V_JC_T_T_12", "V_JC_T_T_13", "V_JC_T_T_14"},
					 //		 new String[]{"D_JC_T_T_0", "D_JC_T_T_2"}),
					 //卫生监督
					 CommonUtil.getMaxDateFileInProcTypes(request, transportid, new String[]{"V_JC_T_T_15", "V_JC_T_T_16", "V_JC_T_T_17"}, 
							 new String[]{"D_JC_T_T_1", "D_JC_T_T_4", "D_JC_T_T_5", "D_JC_T_T_6"}),
					 //卫生处理
					 CommonUtil.getMaxDateFileInProcTypes(request, transportid, new String[]{"V_JC_T_T_18", "V_JC_T_T_19", "V_JC_T_T_20"}, null),
					 //证书签发
					 CommonUtil.getMaxDateFileInProcTypes(request, transportid, new String[]{"V_JC_T_T_21"}, null),
					 //归档
					 CommonUtil.getMaxDateFileInProcTypes(request, transportid, null, new String[]{"D_JC_T_T_9"})};
    			 resultData.put("procArray", procArray);
    		}
		}catch(Exception e){
			logger_.error("***********/affirm/findtransportone************",e);
		}
		return resultData;
    }
	
    /*********************************************************************************************************************
	* 进出境运输工具检疫（货轮）
    * @param request
    * @return
	*********************************************************************************************************************/
	@RequestMapping("/transportstemplate")
	public String transportsTemplate(HttpServletRequest request,String doc_id){
		CheckDocsRcdDTO results=null;
		try{
			if(null==doc_id||"".equals(doc_id)){
				return "/error";
			}else{
				results=affirmDbServ.transportsTemplate(doc_id);
			}
		}catch(Exception e){
			logger_.error("***********/affirm/transportstemplate************",e);
		}
		request.setAttribute("results", results);
		String turn_flag=results.getDoc_type();
		if("D_JC_T_T_0".equals(turn_flag)){
			return "template/jianyijiandujilubiao1";
		}else if("D_JC_T_T_1".equals(turn_flag)){
			return "template/jianyijiandujilubiao2";
		}else if("D_JC_T_T_2".equals(turn_flag)){
			
			if(!StringUtils.isEmpty(results.getOption_12())){
				String adress = results.getOption_12();
				String[] adressArr = adress.split(",");
				request.setAttribute("province", adressArr.length > 0?adress.split(",")[0]:"");
				request.setAttribute("city", adressArr.length > 1?adress.split(",")[1]:"");
				request.setAttribute("area", adressArr.length > 2?adress.split(",")[2]:"");
			}else{
				request.setAttribute("province", "");
				request.setAttribute("city", "");
				request.setAttribute("area", "");
			}
			return "template/chuanranbiandiaochabiao";
		}else if("D_JC_T_Y_2".equals(turn_flag)){
			return "redirect:/ciqs/quartn/doc?id="+doc_id+"&flag=dddtl1";
		}else if("D_JC_T_T_3".equals(turn_flag)){
			return "template/chuanranbingjilubiao";
		}else if("D_JC_T_T_4".equals(turn_flag)){
			return "template/jiaotonggongjuxunzheng";
		}else if("D_JC_T_T_5".equals(turn_flag)){
			return "template/jiaotonggongjupensa";
		}else if("D_JC_T_T_6".equals(turn_flag)){
			return "template/jiaotonggongjuxiaodu";
		}else if("D_JC_T_T_7".equals(turn_flag)){
			return "template/weishengjiandujilubiao";
		}else if("D_JC_T_T_8".equals(turn_flag)){
			return "template/weishenggongzuojilubiao";
		}else if("D_JC_T_T_9".equals(turn_flag)){
			return "template/guidangliebiao";
		}else if("D_JC_T_T_14".equals(turn_flag)){
			return "template/weishengjiandupingfen";
		}else if("D_JC_T_T_12".equals(turn_flag)){
			List<VideoFileEventModel> vList = null;
			try {
				vList = CommonUtil.queryVideoFileEvent(results.getProc_main_id(), null, null, request);
			} catch (IOException e) {
				e.printStackTrace();
			}
			CommonUtil.setFileEventToReqByProcType(vList, request);
			return "template/shenbaowuyichangshixiang";
		}else{
			return "/error";
		}
	}
}
