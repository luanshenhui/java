package com.dpn.ciqqlc.http;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.MalformedURLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Sheet;
import jxl.Workbook;

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

import com.alibaba.fastjson.JSON;
import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.common.util.ElectronicSealUtil;
import com.dpn.ciqqlc.common.util.FileUtil;
import com.dpn.ciqqlc.common.util.FtpUtil;
import com.dpn.ciqqlc.common.util.PageBean;
import com.dpn.ciqqlc.http.form.ExpFoodPOFForm;
import com.dpn.ciqqlc.http.result.FormPdf;
import com.dpn.ciqqlc.service.Quartn;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.model.CheckModel;
import com.dpn.ciqqlc.standard.model.CodeLibraryDTO;
import com.dpn.ciqqlc.standard.model.EfpeApplyCertificationDTO;
import com.dpn.ciqqlc.standard.model.EfpeApplyCheckEquDTO;
import com.dpn.ciqqlc.standard.model.EfpeApplyCommentFileDto;
import com.dpn.ciqqlc.standard.model.EfpeApplyEquipmentDTO;
import com.dpn.ciqqlc.standard.model.EfpeApplyFileDTO;
import com.dpn.ciqqlc.standard.model.EfpeApplyModel;
import com.dpn.ciqqlc.standard.model.EfpeApplyNoticeDto;
import com.dpn.ciqqlc.standard.model.EfpeApplyProductDTO;
import com.dpn.ciqqlc.standard.model.EfpeApplyReviewNoticeDto;
import com.dpn.ciqqlc.standard.model.EfpeApplySurapplyDto;
import com.dpn.ciqqlc.standard.model.EfpePsnExptDto;
import com.dpn.ciqqlc.standard.model.ExpFoodProdCheckCodeDto;
import com.dpn.ciqqlc.standard.model.ExpFoodProdCheckVo;
import com.dpn.ciqqlc.standard.model.ExpFoodProdNewCodeDto;
import com.dpn.ciqqlc.standard.model.ExpFoodProdPointDto;
import com.dpn.ciqqlc.standard.model.ExpFoodProdPsnRdmDTO;
import com.dpn.ciqqlc.standard.model.ExpFoodProdReportDto;
import com.dpn.ciqqlc.standard.model.FileInfoDto;
import com.dpn.ciqqlc.standard.model.QlcEfpePsnDto;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.model.VideoEventModel;
import com.dpn.ciqqlc.standard.service.CommonService;
import com.dpn.ciqqlc.standard.service.ExpFoodPOFService;
import com.itextpdf.text.BadElementException;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.AcroFields;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfStamper;
import com.itextpdf.text.pdf.PdfWriter;


@SuppressWarnings("rawtypes")
@Controller
@RequestMapping("/expFoodPOF")
public class ExpFoodPOFController extends FormPdf{
	private final Logger logger_ = LoggerFactory.getLogger(this.getClass());
	@Autowired
	@Qualifier("expFoodPOFService")
	private ExpFoodPOFService expFoodPOFService = null;
	@Autowired
	private CommonService commonServer = null; 
	@Autowired
    private Quartn quartnService;
	
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
    		@RequestParam("applyNo") String applyNo){
    	try {
    		String filePath = "";
    		// 把文件保存到硬盘上
    		List<Map<String, String>> filePaths = FileUtil.uploadFile(request,false);
            if(filePaths != null && filePaths.size() > 0){
            	Map<String, String> map = filePaths.get(0);
            	filePath = map.get("filePath");
            	if(filePath.indexOf("D:")!= -1){
            		filePath = filePath.substring(filePath.indexOf("D:")+3,filePath.length());
            	}
            }
			// 把文件的路径信息保存到数据库中
            ExpFoodPOFForm video = new ExpFoodPOFForm();
            video.setApplyNo(applyNo);
            video.setApproveNotice(filePath);
			expFoodPOFService.updateApproveNotice(video);
		} catch (Exception e1) {
			e1.printStackTrace();
		}
    	//return "redirect:/expFoodPOF/?&applyNo="+applyNo;
    	return "redirect:/expFoodPOF/expFoodList";
	}
    
	/**
	 * 查询申请信息
	 * */
    
	@RequestMapping("/expFoodList")
	public String expFoodList(HttpServletRequest request,EfpeApplyModel model,String applyDate1,String applyDate2){
		try {
			
			model.setApplycode(model.getApplycode()==null?null:model.getApplycode().trim());
			model.setOrgname(model.getOrgname()==null?null:model.getOrgname().trim());
			int pages = 1;
			if (request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
				pages = Integer.parseInt(request.getParameter("page") == null ? "1": request.getParameter("page"));
			}
			model.setFirstRcd(String.valueOf((pages-1)*Constants.PAGE_NUM));
			model.setLastRcd(String.valueOf(pages*Constants.PAGE_NUM+1));
			model.setOrgcode(request.getParameter("portOrg"));
			List<EfpeApplyModel> list = expFoodPOFService.selectEfpeApply(model);//备案列表
			List<EfpeApplyModel> l = new ArrayList<EfpeApplyModel>();
			//List<ExpFoodPsnRdmForm> l1 = new ArrayList<ExpFoodPsnRdmForm>();
			ExpFoodProdPsnRdmDTO foodProdPsnRdmDTO = new ExpFoodProdPsnRdmDTO();
			EfpeApplyModel efpeApplyModel = null;
			for(int i=0;i<list.size();i++){
				String apply_no = list.get(i).getApplycode();
				foodProdPsnRdmDTO.setApply_no(apply_no);
				List<ExpFoodProdPsnRdmDTO> rdmName = new ArrayList<ExpFoodProdPsnRdmDTO>();
				rdmName = expFoodPOFService.selectRdmName(foodProdPsnRdmDTO);
				efpeApplyModel = new EfpeApplyModel();
				if(!rdmName.isEmpty()){
					String psnName = "";
					int index=0;
					for(ExpFoodProdPsnRdmDTO expFoodProdPsnRdmDTO :rdmName){
						psnName+=expFoodProdPsnRdmDTO.getPsn_name()+"、";
						if(null!=expFoodProdPsnRdmDTO.getStatus() && expFoodProdPsnRdmDTO.getStatus().equals("1")){
							index+=1;
						}
						if(null!=expFoodProdPsnRdmDTO.getStatus() && expFoodProdPsnRdmDTO.getStatus().equals("0")){
							efpeApplyModel.setStatus("不接受");
						}
					}
					if(index==rdmName.size()){
						efpeApplyModel.setStatus("接受");
					}
					if(null==efpeApplyModel.getStatus() || efpeApplyModel.getStatus().equals("") || efpeApplyModel.getStatus().equals(" ")){
						efpeApplyModel.setStatus("待接受");
					}
					if(StringUtils.isNotBlank(psnName)){
						psnName = psnName.substring(0,psnName.length()-1);
					}
					efpeApplyModel.setPsnName(psnName);
					efpeApplyModel.setApplyid(list.get(i).getApplyid());
					efpeApplyModel.setApplycode(list.get(i).getApplycode());
					efpeApplyModel.setStartdate(list.get(i).getStartdate());
					efpeApplyModel.setOrgname(list.get(i).getOrgname());
					efpeApplyModel.setApplytypename(list.get(i).getApplytypename());
					efpeApplyModel.setApplynotename(list.get(i).getApplynotename());
					if(list.get(i).getUsername().split(",").length>0){
						efpeApplyModel.setUsername(list.get(i).getUsername().split(",")[0]);
					}
					efpeApplyModel.setActivityid(list.get(i).getActivityid());
//					efpeApplyModel.setDualtype(list.get(i).getDualtype());
//					efpeApplyModel.setDualcontent(list.get(i).getDualcontent());
					if(list.get(i).getUsername().split(",").length>1){
						efpeApplyModel.setDualtype(list.get(i).getUsername().split(",")[1]);
					}
					if(list.get(i).getUsername().split(",").length>2){
						efpeApplyModel.setDualcontent(list.get(i).getUsername().split(",")[2]);
					}
					l.add(efpeApplyModel);
					
				}else{
					efpeApplyModel.setPsnName(" ");
					efpeApplyModel.setActivityid(list.get(i).getActivityid());
					efpeApplyModel.setApplyid(list.get(i).getApplyid());
					efpeApplyModel.setApplycode(list.get(i).getApplycode());
					efpeApplyModel.setStartdate(list.get(i).getStartdate());
					efpeApplyModel.setOrgname(list.get(i).getOrgname());
					efpeApplyModel.setApplytypename(list.get(i).getApplytypename());
					efpeApplyModel.setApplynotename(list.get(i).getApplynotename());
//					efpeApplyModel.setUsername(list.get(i).getUsername());
//					efpeApplyModel.setDualtype(list.get(i).getDualtype());
//					efpeApplyModel.setDualcontent(list.get(i).getDualcontent());
					if(list.get(i).getUsername().split(",").length>0){
						efpeApplyModel.setUsername(list.get(i).getUsername().split(",")[0]);
					}
					if(list.get(i).getUsername().split(",").length>1){
						efpeApplyModel.setDualtype(list.get(i).getUsername().split(",")[1]);
					}
					if(list.get(i).getUsername().split(",").length>2){
						efpeApplyModel.setDualcontent(list.get(i).getUsername().split(",")[2]);
					}
					l.add(efpeApplyModel);
				}
				
			}
			List<SelectModel> li = expFoodPOFService.allOrgList();//所属机构
			int counts = expFoodPOFService.selectEfpeApplyCount(model);//个数统计
			request.setAttribute("list", l);
			request.setAttribute("li", li);
			request.setAttribute("obj", model);
			request.setAttribute("applyDate1",applyDate1);
			request.setAttribute("applyDate2",applyDate2);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
	        request.setAttribute("itemInPage", Constants.PAGE_NUM);// 每页显示的记录数
	        request.setAttribute("counts",counts);
            request.setAttribute("portOrg",request.getParameter("portOrg"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "expFoodProd/showEFP";
	}
	/**
	 * 查询详情
	 * */
	@RequestMapping("/detailsList")
	public String detailsList(HttpServletRequest request,ExpFoodPOFForm expFoodPOFForm){
		return "expFoodProd/info";
	}
	
	@RequestMapping("/infoList")
	public String infoList(HttpServletRequest request,ExpFoodPOFForm expFoodPOFForm){
		return "expFoodProd/toDetailsAjx";
	}
	
	@ResponseBody
	@RequestMapping("/getInfoData")
	public Map<String,Object> getInfoData(HttpServletRequest request,EfpeApplyModel model,ExpFoodProdReportDto dto,ExpFoodProdPointDto point,ExpFoodProdCheckVo expFoodProdCheckVo){
		Map<String,Object> map=new HashMap<String,Object>();
		try {
			model= expFoodPOFService.selectOneEfpeApply(model);
			model.setStartStrdate(DateUtil.DateToString(model.getStartdate(),"yyyy-MM-dd HH:mm:ss"));
//			dto=expFoodPOFService.selectOneEfpeInfo(dto);
			List<ExpFoodProdPointDto> list=expFoodPOFService.selectExpFoodProdPoint(point);
			for(ExpFoodProdPointDto e:list){
//				e.setCommentid("402881e550d04f510150d2f0e2a926ae");
				List<EfpeApplyCommentFileDto> flist=expFoodPOFService.getFtpDownFile(e);
				e.setFileList(flist);
//				e.setWfnoteid("390de3f510314b8bbc71933838322754");
				List<EfpeApplyNoticeDto> mblist=expFoodPOFService.getMbModel(e);
				e.setMbList(mblist);
			}
			List<ExpFoodProdPsnRdmDTO> rdmPsn=expFoodPOFService.selectPsnRdm(model);
			
			Map<String,Object> param = new HashMap<String, Object>();
	    	param.put("DocType", "V_SP_F_D_QT");
	    	param.put("ProcMainId", expFoodProdCheckVo.getApply_no());
	    	List<CheckDocsRcdModel> doclist=expFoodPOFService.getQtOption(param);
    		List<ExpFoodProdCheckVo> checklist=expFoodPOFService.getChecklist(expFoodProdCheckVo);
    		if(!doclist.isEmpty() && !checklist.isEmpty()){
    			if(doclist.get(0).getDecDate().getTime()>checklist.get(0).getCheck_date().getTime()){
    				map.put("checkPsn", expFoodPOFService.findUsersByCode(doclist.get(0).getDecUser()));
    				map.put("checkTime", DateUtil.DateToString(doclist.get(0).getDecDate(),"yyyy-MM-dd HH:mm"));
    			}else{
    				map.put("checkPsn", expFoodPOFService.findUsersByCode(checklist.get(0).getChech_psn()));
    				map.put("checkTime", DateUtil.DateToString(checklist.get(0).getCheck_date(),"yyyy-MM-dd HH:mm"));
    			}
    		}else if(!doclist.isEmpty() && checklist.isEmpty()){
    			map.put("checkPsn", expFoodPOFService.findUsersByCode(doclist.get(0).getDecUser()));
				map.put("checkTime", doclist.get(0).getDecDate());
    		}else if(doclist.isEmpty() && !checklist.isEmpty()){
    			map.put("checkPsn", expFoodPOFService.findUsersByCode(checklist.get(0).getChech_psn()));
				map.put("checkTime", checklist.get(0).getCheck_date());
    		}else{
    			
    		}
			map.put("obj", model);
//			map.put("dto", dto);
			map.put("list", list);
			map.put("rdmPsn", rdmPsn);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
	}
	
	
	@ResponseBody
	@RequestMapping("/getDetailsListData")
	public Map<String,Object> getDetailsListData(HttpServletRequest request,EfpeApplyModel model){
		Map<String,Object> map=new HashMap<String,Object>();
		try {
			List<EfpeApplyCertificationDTO> certificationList = expFoodPOFService.selectCertificationList(model);
			List<EfpeApplyCheckEquDTO> checkEquList = expFoodPOFService.selectCheckEquList (model);
			List<EfpeApplyEquipmentDTO> equipmentList = expFoodPOFService.selectEquipmentList(model);
			List<EfpeApplyFileDTO> fileList = expFoodPOFService.selectFileList(model);
			List<EfpeApplyProductDTO> productList = expFoodPOFService.selectProductList(model);
			model= expFoodPOFService.selectOneEfpeApply(model);
			map.put("obj", model);
			map.put("certificationList", certificationList);
			map.put("checkEquList", checkEquList);
			map.put("equipmentList", equipmentList);
			map.put("fileList", fileList);
			map.put("productList", productList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
	}
	
	 /**
     * 跳转查看13个电子表格列表 之一 详情表格
     * http://localhost:7001/ciqs/ExpFoodPOF/toTextList?apply_no=111222
     * @param request
     * @return
     */
    @RequestMapping("/toTextXwjList")
    public String toTextXwjList(HttpServletRequest request,ExpFoodProdCheckCodeDto expFoodProdCheckCodeDto,String apply_no){
    	try {
    		List<ExpFoodProdCheckCodeDto> list=expFoodPOFService.getToTextList(expFoodProdCheckCodeDto);
			request.setAttribute("list", list);
			request.setAttribute("apply_no", apply_no);
		} catch (Exception e) {
			logger_.error("***********/ExpFoodPOF/toTextList************",e);
		}
    	return "expFoodProd/titleList";
	}
	
	 /**
     * 跳转查看11个电子表格列表 之一 详情表格
     * http://localhost:7001/ciqs/ExpFoodPOF/toTextList?apply_no=111222
     * @param request
     * @return
     */
    @RequestMapping("/toTextList")
    public String toTextList(HttpServletRequest request,ExpFoodProdNewCodeDto expFoodProdNewCodeDto,String apply_no,String compName){
    	try {
//    		List<ExpFoodProdCheckCodeDto> list=expFoodPOFService.getToTextList(expFoodProdCheckCodeDto);
    		List<ExpFoodProdNewCodeDto> list=expFoodPOFService.getToTextNewList(expFoodProdNewCodeDto);
			request.setAttribute("list", list);
			request.setAttribute("apply_no", apply_no);
			request.setAttribute("compName", compName);
		} catch (Exception e) {
			logger_.error("***********/ExpFoodPOF/toTextList************",e);
		}
    	return "expFoodProd/titleList";
	}
    
    /**
     *  跳转查看13个电子表格列表 之一 详情表格
     *  http://localhost:7001/ciqs/ExpFoodPOF/toTextView?apply_no=111&check_menu_type=菜单二
     * @return
     */
    @RequestMapping(value = "/toTextView",method=RequestMethod.GET)
    public String toTextView(HttpServletRequest request,ExpFoodProdCheckVo expFoodProdCheckVo){
//    	String index="";
    	try {
//    		if(expFoodProdCheckVo.getCheck_menu_type().equals("1")){
//    			index="1";
//    		}else if(expFoodProdCheckVo.getCheck_menu_type().equals("4")){
//    			index="4";
//    		}else if(expFoodProdCheckVo.getCheck_menu_type().equals("5")){
//    			index="5";	
//    		}else if(expFoodProdCheckVo.getCheck_menu_type().equals("6")){
//    			index="6";
//    		}else if(expFoodProdCheckVo.getCheck_menu_type().equals("8")){
//    			index="8";
//    		}else if(expFoodProdCheckVo.getCheck_menu_type().equals("9")){
//    			index="9";
//    		}else if(expFoodProdCheckVo.getCheck_menu_type().equals("10")){
//    			index="10";
//    		}else if(expFoodProdCheckVo.getCheck_menu_type().equals("12")){
//    			index="12";
//    		}
    		List<ExpFoodProdCheckVo> list=expFoodPOFService.getToTextView2(expFoodProdCheckVo,request);
//    		pdflist=list;
			request.setAttribute("list", list);
			if(!list.isEmpty()){
				request.setAttribute("title", expFoodProdCheckVo.getCheck_menu_type()+": "+list.get(0).getCheck_title());
			}
		} catch (Exception e) {
			logger_.error("***********/ExpFoodPOF/toTextView************",e);
		}
    	return "expFoodProd/newtext/text";
	}
    
    @RequestMapping(value = "/toTextViewQt",method=RequestMethod.GET)
    public String toTextViewQt(HttpServletRequest request,ExpFoodProdCheckVo expFoodProdCheckVo){
    	Map<String,Object> param = new HashMap<String, Object>();
    	try {
    		param.put("DocType", "V_SP_F_D_QT");
    		param.put("ProcMainId", expFoodProdCheckVo.getApply_no());
    		List<CheckDocsRcdModel> list=expFoodPOFService.getQtOption(param);
    		for(CheckDocsRcdModel c:list){
    			if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(c.getOption1())){
    				c.setOption91(c.getOption1().substring(6, 12)+"/"+c.getOption1().substring(6, 14)+"/"+c.getOption1());
    			}
    			if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(c.getOption2())){
    				c.setOption92(c.getOption2().substring(6, 12)+"/"+c.getOption2().substring(6, 14)+"/"+c.getOption2());
    			}
    		}
//    		doclist=list;
			request.setAttribute("list", list);
		} catch (Exception e) {
			logger_.error("***********/ExpFoodPOF/toTextViewQt************",e);
		}
    	return "expFoodProd/newtext/textQt";
	}
    
    /**
     *  不符合项跟踪报告 (模块1)
     *  http://localhost:7001/ciqs/ExpFoodPOF/unPassable?apply_no=111&compName=栾氏集团
     * @return
     */
    @RequestMapping(value = "/unPassable",method=RequestMethod.GET)
    public String unPassable(HttpServletRequest request,ExpFoodProdCheckVo expFoodProdCheckVo,String compName){
    	try {
    		expFoodProdCheckVo.setCheck_result("2");
    		expFoodProdCheckVo.setCheck_type("1");
    		List<ExpFoodProdCheckVo> list=expFoodPOFService.getToTextViewNoPassNew(expFoodProdCheckVo);
//    		pdflist=list;
    		Map<String,Object> map = new HashMap<String, Object>();
    		map.put("ProcMainId", expFoodProdCheckVo.getApply_no());
    		map.put("DocType", "V_SP_F_D");
			CheckDocsRcdModel doc  =quartnService.findOnlyDoc(map);
//			docsRcd=doc;
			Map<String,Object> param = new HashMap<String, Object>();
			param.put("DocType", "V_SP_F_D_QT");
    		param.put("ProcMainId", expFoodProdCheckVo.getApply_no());
    		List<CheckDocsRcdModel> listQt=expFoodPOFService.getQtOption(param);
    		request.setAttribute("listQt", listQt);
			request.setAttribute("list", list);
			request.setAttribute("doc", doc);
			request.setAttribute("apply_no", expFoodProdCheckVo.getApply_no());
			request.setAttribute("compName", compName);
		} catch (Exception e) {
			logger_.error("***********/ExpFoodPOF/unPassable************",e);
		}
    	return "expFoodProd/newtext/unPassableNew";
	}
    
    
    /**
     *  不符合项跟踪报告 (模块3)
     *  http://localhost:7001/ciqs/ExpFoodPOF/unPassable?apply_no=111&compName=栾氏集团
     * @return
     */
    @RequestMapping(value = "/unPassXwjable",method=RequestMethod.GET)
    public String unPassXwjable(HttpServletRequest request,ExpFoodProdCheckVo expFoodProdCheckVo,String compName){
    	try {
    		expFoodProdCheckVo.setCheck_result("2");
    		expFoodProdCheckVo.setCheck_type("1");
    		if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(request.getParameter("type"))){
    			expFoodProdCheckVo.setTd(request.getParameter("type"));
    		}
    		List<ExpFoodProdCheckVo> list=expFoodPOFService.getToTextViewNoPass(expFoodProdCheckVo,request);
    		Map<String,Object> map = new HashMap<String, Object>();
    		map.put("ProcMainId", expFoodProdCheckVo.getApply_no());
    		if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(request.getParameter("type"))){
    			map.put("DocType", request.getParameter("type"));
    		}else{
    			map.put("DocType", "V_SP_F_D");
    		}
			CheckDocsRcdModel doc  =quartnService.findOnlyDoc(map);
//			docsRcd=doc;
			Map<String,Object> param = new HashMap<String, Object>();
			if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(request.getParameter("type"))){
    			expFoodProdCheckVo.setTd(request.getParameter("type"));
    			param.put("DocType", request.getParameter("type")+"_QT");
    		}else{
    			param.put("DocType", "V_SP_F_D_QT");
    		}
    		param.put("ProcMainId", expFoodProdCheckVo.getApply_no());
    		List<CheckDocsRcdModel> listQt=expFoodPOFService.getQtOption(param);
    		request.setAttribute("listQt", listQt);
			request.setAttribute("list", list);
			request.setAttribute("doc", doc);
			request.setAttribute("apply_no", expFoodProdCheckVo.getApply_no());
			request.setAttribute("compName", compName);
		} catch (Exception e) {
			logger_.error("***********/ExpFoodPOF/unPassable************",e);
		}
    	return "expFoodProd/txt/unPassable2";
	}
    
    @RequestMapping(value = "/download",method=RequestMethod.GET)
    public void download(HttpServletRequest request,HttpServletResponse response,String fileName){
    	try {
			FileUtil.downloadFile(fileName, response, true);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
/*************************************LiuChao 2017/11/16 *******************************************************/    
    /**
	 * 添加随机人员页面
	 * @param dto 随机人员对象
	 * @param model Model对象
	 * @return list
	 */
    
    @RequestMapping("/addpeson")
	public String addPeson(QlcEfpePsnDto dto,Model model,HttpServletRequest request,String personNum){
    	QlcEfpePsnDto qlcEfpepsnDto = new QlcEfpePsnDto();
    	Map<String, String> mapCode = new HashMap<String, String>();
		try {
			//将expertise_code获得的值存入mapCode
			List<EfpePsnExptDto> expList = expFoodPOFService.expertise_code();
			for(int i=0;i<expList.size();i++){
				mapCode.put(expList.get(i).getExpertise_code(), expList.get(i).getExpertise_detail());
			}
			String psnType = request.getParameter("z_psnType");
			String psnExpertiseS = "";
			String psnExpertise = request.getParameter("z_psnExpertise");
			if(psnExpertise!=null && psnExpertise!="" ){
			String [] psnExpertiseStr = psnExpertise.split(",");
				for(int i=0;i<psnExpertiseStr.length;i++){
					psnExpertiseS += " or instr(p.psn_goodat,'"+psnExpertiseStr[i]+"')>0";
				}
			}
			String z_psnExpertise_order = request.getParameter("z_psnExpertise_order");
			if(z_psnExpertise_order!=null && z_psnExpertise_order!="" ){
				String [] z_psnExpertise_orderStr = z_psnExpertise_order.split(",");
				for(int i=0;i<z_psnExpertise_orderStr.length;i++){
					psnExpertiseS += " or instr(p.psn_other_goodat,'"+z_psnExpertise_orderStr[i]+"')>0";
				}
			}
			if(!psnExpertiseS.equals("")){
				psnExpertiseS = psnExpertiseS.substring(3);
				qlcEfpepsnDto.setPsnExpertise("("+psnExpertiseS+")");
			}
			
			String psnLevel = request.getParameter("z_psnLevel");
			String in_post = request.getParameter("z_in_post");
			String levelDept_1 = getNewString(request.getParameter("z_levelDept_1"));
			String levelDept_2 = getNewString(request.getParameter("z_levelDept_2"));
			String levelDept_3 = getNewString(request.getParameter("z_levelDept_3"));
			qlcEfpepsnDto.setPsnType(psnType);
			qlcEfpepsnDto.setPsnLevel(psnLevel);
			qlcEfpepsnDto.setIn_post(in_post);
			qlcEfpepsnDto.setLevelDept_1(levelDept_1);
			qlcEfpepsnDto.setLevelDept_2(levelDept_2);
			qlcEfpepsnDto.setLevelDept_3(levelDept_3);
			//组员
			List<QlcEfpePsnDto> memberLi = expFoodPOFService.selectBasePsn(qlcEfpepsnDto);//组员
			List<QlcEfpePsnDto> memList = new ArrayList<QlcEfpePsnDto>();
			for(int a=0;a<memberLi.size();a++){
				QlcEfpePsnDto exps = new QlcEfpePsnDto();
				String psnExpStr = memberLi.get(a).getPsnExpertise();
				if(StringUtils.isNotBlank(psnExpStr)){ 
					String [] str = psnExpStr.split(";");
					String exp = "";
					for(int j=0;j<str.length;j++){
						exp += ","+mapCode.get(str[j]);
					}
					
					exp = exp.substring(1);
					exps.setExpName(exp);
					exps.setPsnId(memberLi.get(a).getPsnId());
					exps.setPsnName(memberLi.get(a).getPsnName());
					exps.setPsnType(memberLi.get(a).getPsnType());
					exps.setPsnExpertise(memberLi.get(a).getPsnExpertise());
					exps.setIn_post(memberLi.get(a).getIn_post());
					exps.setLevelDept_1(memberLi.get(a).getLevelDept_1());
					exps.setLevelDept_2(memberLi.get(a).getLevelDept_2());
					exps.setLevelDept_3(memberLi.get(a).getLevelDept_3());
					exps.setPsnLevel(memberLi.get(a).getPsnLevel());
					
					memList.add(exps);
				}
			}
			request.setAttribute("member", memList);
			//随机组员
			Set<QlcEfpePsnDto> memberSet = new HashSet<QlcEfpePsnDto>();
			List<QlcEfpePsnDto> memberRdmLi = expFoodPOFService.selectBasePsn(qlcEfpepsnDto);//组员
			List<QlcEfpePsnDto> memberRdmList = new ArrayList<QlcEfpePsnDto>();
			List<QlcEfpePsnDto> memberRdmList3 = new ArrayList<QlcEfpePsnDto>();
			List<QlcEfpePsnDto> memberRdmList4 = new ArrayList<QlcEfpePsnDto>();
			for(int a=0;a<memberRdmLi.size();a++){
				QlcEfpePsnDto exps = new QlcEfpePsnDto();
				String psnExpStr = memberRdmLi.get(a).getPsnExpertise();
				if(StringUtils.isNotBlank(psnExpStr)){
					String [] str = psnExpStr.split(";");
					String exp = "";
					for(int j=0;j<str.length;j++){
						//mapCode.get(str[j]);
						exp += ","+mapCode.get(str[j]);
					}
					exp = exp.substring(1);
					exps.setExpName(exp);
					exps.setPsnId(memberRdmLi.get(a).getPsnId());
					exps.setPsnName(memberRdmLi.get(a).getPsnName());
					exps.setPsnType(memberRdmLi.get(a).getPsnType());
					exps.setPsnExpertise(memberRdmLi.get(a).getPsnExpertise());
					exps.setIn_post(memberRdmLi.get(a).getIn_post());
					exps.setLevelDept_1(memberRdmLi.get(a).getLevelDept_1());
					exps.setLevelDept_2(memberRdmLi.get(a).getLevelDept_2());
					exps.setLevelDept_3(memberRdmLi.get(a).getLevelDept_3());
					exps.setPsnLevel(memberLi.get(a).getPsnLevel());
					memberRdmList.add(exps);
				}
			}
			//随机操作
			Random randemMember = new Random();
			if(personNum==null || personNum.equals("2")){
				personNum = "2";
				if(!memberRdmList.isEmpty()){
					int memberSize = randemMember.nextInt(memberRdmList.size());
					memberSet.add(memberRdmList.get(memberSize));
				}
			}else if(personNum.equals("3")){
				if(!memberRdmList.isEmpty()){
					int memberSize = randemMember.nextInt(memberRdmList.size());
					memberSet.add(memberRdmList.get(memberSize));
				}
				memberRdmList3=this.getRadmList2(dto,model,request,personNum); 
				if(!memberRdmList3.isEmpty()){
					int memberSize = randemMember.nextInt(memberRdmList3.size());
					memberSet.add(memberRdmList3.get(memberSize));
				}
			}else if(personNum.equals("4")){
				if(!memberRdmList.isEmpty()){
					int memberSize = randemMember.nextInt(memberRdmList.size());
					memberSet.add(memberRdmList.get(memberSize));
				}
				memberRdmList3=this.getRadmList2(dto,model,request,personNum); 
				if(!memberRdmList3.isEmpty()){
					int memberSize = randemMember.nextInt(memberRdmList3.size());
					memberSet.add(memberRdmList3.get(memberSize));
				}
				memberRdmList4=this.getRadmList3(dto,model,request,personNum); 
				if(!memberRdmList4.isEmpty()){
					int memberSize = randemMember.nextInt(memberRdmList4.size());
					memberSet.add(memberRdmList4.get(memberSize));
				}
			}
			request.setAttribute("memberList", memberSet);//随机出的组员
//			if(memberRdmList.size()>Integer.parseInt(personNum)-1){
//				while(memberSet.size() != Integer.parseInt(personNum)-1){
//					for(int num=0;num < Integer.parseInt(personNum)-1;num++){
//						int memberSize = randemMember.nextInt(memberRdmList.size());
//						memberSet.add(memberRdmList.get(memberSize));
//					}
//				}	
//				request.setAttribute("memberList", memberSet);//随机出的组员
//			}else{
//				request.setAttribute("memberList", memberRdmList);//随机出的组员
//			}
			//组长search		
			String laderPsnExpertiseS = "";
			String laderPsnExpertise = dto.getPsnExpertise();
			if(laderPsnExpertise!=null && laderPsnExpertise!="" ){
				String [] laderPsnExpertiseStr = laderPsnExpertise.split(",");
					for(int i=0;i<laderPsnExpertiseStr.length;i++){
						laderPsnExpertiseS += " or instr(p.psn_goodat,'"+laderPsnExpertiseStr[i]+"')>0";
					}
				}
			String laderPsnExpertiseOther = dto.getPsnExpertise_order();
			if(laderPsnExpertiseOther!=null && laderPsnExpertiseOther!="" ){
				String [] laderPsnExpertiseOtherStr = laderPsnExpertiseOther.split(",");
				for(int i=0;i<laderPsnExpertiseOtherStr.length;i++){
					laderPsnExpertiseS += " or instr(p.psn_other_goodat,'"+laderPsnExpertiseOtherStr[i]+"')>0";
				}
			}
			if(!laderPsnExpertiseS.equals("")){
				laderPsnExpertiseS = laderPsnExpertiseS.substring(3);
				dto.setPsnExpertise("("+laderPsnExpertiseS+")");
			}
			
			//组长list
//			dto.setType(type==null?"1":"2");
			dto.setLevelDept_1(getNewString(dto.getLevelDept_1()));
			dto.setLevelDept_2(getNewString(dto.getLevelDept_2()));
			dto.setLevelDept_3(getNewString(dto.getLevelDept_3()));
			List<QlcEfpePsnDto> laderLi = expFoodPOFService.selectBasePsn(dto);//组长
			List<QlcEfpePsnDto> laderList = new ArrayList<QlcEfpePsnDto>();
			for(int a=0;a<laderLi.size();a++){
				QlcEfpePsnDto exps = new QlcEfpePsnDto();
				String psnExpStr = laderLi.get(a).getPsnExpertise();
				if(StringUtils.isNotBlank(psnExpStr)){
					String [] str = psnExpStr.split(";");
					String exp = "";
					for(int j=0;j<str.length;j++){
						//mapCode.get(str[j]);
						exp += ","+mapCode.get(str[j]);
					}
					exp = exp.substring(1);
					exps.setExpName(exp);
					exps.setPsnId(laderLi.get(a).getPsnId());
					exps.setPsnName(laderLi.get(a).getPsnName());
					exps.setPsnType(laderLi.get(a).getPsnType());
					exps.setPsnExpertise(laderLi.get(a).getPsnExpertise());
					exps.setIn_post(laderLi.get(a).getIn_post());
					exps.setLevelDept_1(laderLi.get(a).getLevelDept_1());
					exps.setLevelDept_2(laderLi.get(a).getLevelDept_2());
					exps.setLevelDept_3(laderLi.get(a).getLevelDept_3());
					exps.setPsnLevel(laderLi.get(a).getPsnLevel());
					laderList.add(exps);
				}
			}
			request.setAttribute("lader", laderList);
			
			//组长随机
			List<QlcEfpePsnDto> list = new ArrayList<QlcEfpePsnDto>();
			
			List<QlcEfpePsnDto> laderRdmLi = expFoodPOFService.selectBasePsn(dto);//组员
			List<QlcEfpePsnDto> laderRdmList = new ArrayList<QlcEfpePsnDto>();
			for(int a=0;a<laderRdmLi.size();a++){
				QlcEfpePsnDto exps = new QlcEfpePsnDto();
				String psnExpStr = laderRdmLi.get(a).getPsnExpertise();
				if(StringUtils.isNotBlank(psnExpStr)){
					String [] str = psnExpStr.split(";");
					String exp = "";
					for(int j=0;j<str.length;j++){
						//mapCode.get(str[j]);
						exp += ","+mapCode.get(str[j]);
					}
					exp = exp.substring(1);
					exps.setExpName(exp);
					exps.setPsnId(laderRdmLi.get(a).getPsnId());
					exps.setPsnName(laderRdmLi.get(a).getPsnName());
					exps.setPsnType(laderRdmLi.get(a).getPsnType());
					exps.setPsnExpertise(laderRdmLi.get(a).getPsnExpertise());
					exps.setIn_post(laderRdmLi.get(a).getIn_post());
					exps.setLevelDept_1(laderRdmLi.get(a).getLevelDept_1());
					exps.setLevelDept_2(laderRdmLi.get(a).getLevelDept_2());
					exps.setLevelDept_3(laderRdmLi.get(a).getLevelDept_3());
					exps.setPsnLevel(laderRdmLi.get(a).getPsnLevel());
					laderRdmList.add(exps);
				}
			}
			
			
			if(laderRdmList.size()>0){
				Random randemLader = new Random();
				int laderSize = randemLader.nextInt(laderRdmList.size());
				list.add(laderRdmList.get(laderSize));
				request.setAttribute("laderList", list);//随机出的组长
			}
			
			//search
			request.setAttribute("psnTypeCode", expFoodPOFService.psnTypeCode());//分类
			request.setAttribute("psnLevelCode",expFoodPOFService.psnLevelCode());//级别
			request.setAttribute("psnLevelDept_1Code",expFoodPOFService.psnLevelDept_1Code());//一级部门
			request.setAttribute("psnLevelDept_2Code",expFoodPOFService.psnLevelDept_2Code());//二级部门
			request.setAttribute("psnLevelDept_3Code",expFoodPOFService.psnLevelDept_3Code());//三级部门
			request.setAttribute("expertiseCode1", expFoodPOFService.expertise_code1());//专长
			request.setAttribute("expertiseCode2", expFoodPOFService.expertise_code2());//专长
			request.setAttribute("expertiseCode3", expFoodPOFService.expertise_code3());//专长
			request.setAttribute("expertiseCode4", expFoodPOFService.expertise_code4());//专长
			request.setAttribute("expertiseCode5", expFoodPOFService.expertise_code5());//专长
			request.setAttribute("personNum",personNum);
			/******************回显********************/
			request.setAttribute("psnType",request.getParameter("psnType"));
			request.setAttribute("psnExpertise",request.getParameter("psnExpertise"));
			request.setAttribute("psnLevel",request.getParameter("psnLevel"));
			request.setAttribute("in_post",request.getParameter("in_post"));
			request.setAttribute("levelDept_1",request.getParameter("levelDept_1"));
			request.setAttribute("levelDept_2",request.getParameter("levelDept_2"));
			request.setAttribute("levelDept_3",request.getParameter("levelDept_3"));
			
			request.setAttribute("z_psnType",request.getParameter("z_psnType"));
			request.setAttribute("z_psnExpertise",request.getParameter("z_psnExpertise"));
			request.setAttribute("z_psnLevel",request.getParameter("z_psnLevel"));
			request.setAttribute("z_in_post",request.getParameter("z_in_post"));
			request.setAttribute("z_levelDept_1",request.getParameter("z_levelDept_1"));
			request.setAttribute("z_levelDept_2",request.getParameter("z_levelDept_2"));
			request.setAttribute("z_levelDept_3",request.getParameter("z_levelDept_3"));

			request.setAttribute("apply_no",request.getParameter("apply_no"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "expFoodProd/addpeson";
	}
	
	@SuppressWarnings("unused")
	private Set<QlcEfpePsnDto> getMemberSet(Set<QlcEfpePsnDto> memberSet,
			Random randemMember, List<QlcEfpePsnDto> memberRdmList) {
		int memberSize = randemMember.nextInt(memberRdmList.size());
		memberSet.add(memberRdmList.get(memberSize));
		return memberSet;
	}
	
	/**
	 * 第4行的 组员随机
	 * @param dto
	 * @param model
	 * @param request
	 * @param personNum
	 * @return
	 * @throws Exception 
	 */
	private List<QlcEfpePsnDto> getRadmList3(QlcEfpePsnDto dto, Model model,
		HttpServletRequest request, String personNum) throws Exception {
		QlcEfpePsnDto qlcEfpepsnDto = new QlcEfpePsnDto();
    	Map<String, String> mapCode = new HashMap<String, String>();
			//将expertise_code获得的值存入mapCode
			List<EfpePsnExptDto> expList = expFoodPOFService.expertise_code();
			for(int i=0;i<expList.size();i++){
				mapCode.put(expList.get(i).getExpertise_code(), expList.get(i).getExpertise_detail());
			}
			String psnType = request.getParameter("z_psnType_4");
			String psnExpertiseS = "";
			String psnExpertise = request.getParameter("z_psnExpertise_4");
			if(psnExpertise!=null && psnExpertise!="" ){
				String [] psnExpertiseStr = psnExpertise.split(",");
				for(int i=0;i<psnExpertiseStr.length;i++){
					psnExpertiseS += "or instr (p.psn_goodat,'"+psnExpertiseStr[i]+"')>0";
				}
			}
			String z_psnExpertise_order = request.getParameter("z_psnExpertise_order_4");
			if(z_psnExpertise_order!=null && z_psnExpertise_order!="" ){
				String [] z_psnExpertise_orderStr = z_psnExpertise_order.split(",");
				for(int i=0;i<z_psnExpertise_orderStr.length;i++){
					psnExpertiseS += "or instr (p.psn_other_goodat,'"+z_psnExpertise_orderStr[i]+"')>0";
				}
			}
			if(!psnExpertiseS.equals("")){
				psnExpertiseS = psnExpertiseS.substring(3);
				qlcEfpepsnDto.setPsnExpertise("("+psnExpertiseS+")");
			}
			
			String psnLevel = request.getParameter("z_psnLevel_4");
			String in_post = request.getParameter("z_in_post_4");
			String levelDept_1 = getNewString(request.getParameter("z_levelDept_1_4"));
			String levelDept_2 = getNewString(request.getParameter("z_levelDept_2_4"));
			String levelDept_3 = getNewString(request.getParameter("z_levelDept_3_4"));
			
			qlcEfpepsnDto.setPsnType(psnType);
			qlcEfpepsnDto.setPsnLevel(psnLevel);
			qlcEfpepsnDto.setIn_post(in_post);
			qlcEfpepsnDto.setLevelDept_1(levelDept_1);
			qlcEfpepsnDto.setLevelDept_2(levelDept_2);
			qlcEfpepsnDto.setLevelDept_3(levelDept_3);
			//组员
//			List<QlcEfpePsnDto> memberLi = expFoodPOFService.selectBasePsn(qlcEfpepsnDto);//组员
			//随机组员
			List<QlcEfpePsnDto> memberRdmLi = expFoodPOFService.selectBasePsn(qlcEfpepsnDto);//组员
			List<QlcEfpePsnDto> memberRdmList = new ArrayList<QlcEfpePsnDto>();
			for(int a=0;a<memberRdmLi.size();a++){
				QlcEfpePsnDto exps = new QlcEfpePsnDto();
				String psnExpStr = memberRdmLi.get(a).getPsnExpertise();
				if(StringUtils.isNotBlank(psnExpStr)){
					String [] str = psnExpStr.split(";");
					String exp = "";
					for(int j=0;j<str.length;j++){
						//mapCode.get(str[j]);
						exp += ","+mapCode.get(str[j]);
					}
					exp = exp.substring(1);
					exps.setExpName(exp);
					exps.setPsnId(memberRdmLi.get(a).getPsnId());
					exps.setPsnName(memberRdmLi.get(a).getPsnName());
					exps.setPsnType(memberRdmLi.get(a).getPsnType());
					exps.setPsnExpertise(memberRdmLi.get(a).getPsnExpertise());
					exps.setIn_post(memberRdmLi.get(a).getIn_post());
					exps.setLevelDept_1(memberRdmLi.get(a).getLevelDept_1());
					exps.setLevelDept_2(memberRdmLi.get(a).getLevelDept_2());
					exps.setLevelDept_3(memberRdmLi.get(a).getLevelDept_3());
					exps.setPsnLevel(memberRdmLi.get(a).getPsnLevel());
					memberRdmList.add(exps);
				}
			}
			return memberRdmList;
	}
	private String getNewString(String value) {
		if(com.dpn.ciqqlc.common.util.StringUtils.isEmpty(value)){
			return "";
		}
		String [] str = value.split(",");
		String newvalue="";
		for(String s:str){
			newvalue+="'"+s+"',";
		}
		return newvalue.substring(0,newvalue.length()-1);
	}
	
	/**
	 * 第3行的 组员随机
	 * @param dto
	 * @param model
	 * @param request
	 * @param personNum
	 * @return
	 * @throws Exception 
	 */
	private List<QlcEfpePsnDto> getRadmList2(QlcEfpePsnDto dto, Model model,
		HttpServletRequest request, String personNum) throws Exception {
		QlcEfpePsnDto qlcEfpepsnDto = new QlcEfpePsnDto();
    	Map<String, String> mapCode = new HashMap<String, String>();
			//将expertise_code获得的值存入mapCode
			List<EfpePsnExptDto> expList = expFoodPOFService.expertise_code();
			for(int i=0;i<expList.size();i++){
				mapCode.put(expList.get(i).getExpertise_code(), expList.get(i).getExpertise_detail());
			}
			String psnType = request.getParameter("z_psnType_3");
			String psnExpertiseS = "";
			String psnExpertise = request.getParameter("z_psnExpertise_3");
			if(psnExpertise!=null && psnExpertise!="" ){
			String [] psnExpertiseStr = psnExpertise.split(",");
				for(int i=0;i<psnExpertiseStr.length;i++){
					psnExpertiseS += "or instr (p.psn_goodat,'"+psnExpertiseStr[i]+"')>0";
				}
			}
			String z_psnExpertise_order = request.getParameter("z_psnExpertise_order_3");
			if(z_psnExpertise_order!=null && z_psnExpertise_order!="" ){
				String [] z_psnExpertise_orderStr = z_psnExpertise_order.split(",");
				for(int i=0;i<z_psnExpertise_orderStr.length;i++){
					psnExpertiseS += "or instr (p.psn_other_goodat,'"+z_psnExpertise_orderStr[i]+"')>0";
				}
			}
			if(!psnExpertiseS.equals("")){
				psnExpertiseS = psnExpertiseS.substring(3);
				qlcEfpepsnDto.setPsnExpertise("("+psnExpertiseS+")");
			}
			String psnLevel = request.getParameter("z_psnLevel_3");
			String in_post = request.getParameter("z_in_post_3");
			String levelDept_1 = getNewString(request.getParameter("z_levelDept_1_3"));
			String levelDept_2 = getNewString(request.getParameter("z_levelDept_2_3"));
			String levelDept_3 = getNewString(request.getParameter("z_levelDept_3_3"));
			qlcEfpepsnDto.setPsnType(psnType);
			qlcEfpepsnDto.setPsnLevel(psnLevel);
			qlcEfpepsnDto.setIn_post(in_post);
			qlcEfpepsnDto.setLevelDept_1(levelDept_1);
			qlcEfpepsnDto.setLevelDept_2(levelDept_2);
			qlcEfpepsnDto.setLevelDept_3(levelDept_3);
			//组员
//			List<QlcEfpePsnDto> memberLi = expFoodPOFService.selectBasePsn(qlcEfpepsnDto);//组员
			//随机组员
			List<QlcEfpePsnDto> memberRdmLi = expFoodPOFService.selectBasePsn(qlcEfpepsnDto);//组员
			List<QlcEfpePsnDto> memberRdmList = new ArrayList<QlcEfpePsnDto>();
			for(int a=0;a<memberRdmLi.size();a++){
				QlcEfpePsnDto exps = new QlcEfpePsnDto();
				String psnExpStr = memberRdmLi.get(a).getPsnExpertise();
				if(StringUtils.isNotBlank(psnExpStr)){
					String [] str = psnExpStr.split(";");
					String exp = "";
					for(int j=0;j<str.length;j++){
						//mapCode.get(str[j]);
						exp += ","+mapCode.get(str[j]);
					}
					exp = exp.substring(1);
					exps.setExpName(exp);
					exps.setPsnId(memberRdmLi.get(a).getPsnId());
					exps.setPsnName(memberRdmLi.get(a).getPsnName());
					exps.setPsnType(memberRdmLi.get(a).getPsnType());
					exps.setPsnExpertise(memberRdmLi.get(a).getPsnExpertise());
					exps.setIn_post(memberRdmLi.get(a).getIn_post());
					exps.setLevelDept_1(memberRdmLi.get(a).getLevelDept_1());
					exps.setLevelDept_2(memberRdmLi.get(a).getLevelDept_2());
					exps.setLevelDept_3(memberRdmLi.get(a).getLevelDept_3());
					exps.setPsnLevel(memberRdmLi.get(a).getPsnLevel());
					memberRdmList.add(exps);
				}
			}
			return memberRdmList;
	}
	/**
	 * 添加随机人员初始化页面
	 * @param dto 随机人员对象
	 * @param model Model对象
	 * @return list
	 */
	@RequestMapping("/pesoninit")
	public String pesoninit(HttpServletRequest request,ExpFoodProdPsnRdmDTO dto,Model model,String apply_no){
		request.setAttribute("psnTypeCode", expFoodPOFService.psnTypeCode());//分类
		request.setAttribute("psnLevelCode",expFoodPOFService.psnLevelCode());//级别
		request.setAttribute("psnLevelDept_1Code",expFoodPOFService.psnLevelDept_1Code());//一级部门
		request.setAttribute("psnLevelDept_2Code",this.addTitle(expFoodPOFService.psnLevelDept_2Code()));//二级部门
		request.setAttribute("psnLevelDept_3Code",this.addTitle(expFoodPOFService.psnLevelDept_3Code()));//三级部门
		request.setAttribute("expertiseCode1", expFoodPOFService.expertise_code1());//专长
		request.setAttribute("expertiseCode2", expFoodPOFService.expertise_code2());//专长
		request.setAttribute("expertiseCode3", expFoodPOFService.expertise_code3());//专长
		request.setAttribute("expertiseCode4", expFoodPOFService.expertise_code4());//专长
		request.setAttribute("expertiseCode5", expFoodPOFService.expertise_code5());//专长
		request.setAttribute("apply_no",apply_no);
		//request.setAttribute("personNum","2");
		return "expFoodProd/addpeson";
	}
	
	
	
	private List<CodeLibraryDTO>  addTitle(List<CodeLibraryDTO> ilist) {
		List<CodeLibraryDTO> list=new ArrayList<CodeLibraryDTO>();
		String icode="";
		for(int i=0;i<ilist.size();i++){
			if(i==0){
				icode=ilist.get(i).getPort_org_code();
				CodeLibraryDTO m=new  CodeLibraryDTO();
				m.setPort_org_code(ilist.get(i).getPort_org_code());
				m.setCode(ilist.get(i).getCode());
				m.setName(ilist.get(i).getFlag_op());
				list.add(m);
			}
			if(!ilist.get(i).getPort_org_code().equals(icode)){
				icode=ilist.get(i).getPort_org_code();
				CodeLibraryDTO m=new  CodeLibraryDTO();
				m.setPort_org_code(ilist.get(i).getPort_org_code());
				m.setCode(ilist.get(i).getCode());
				m.setName(ilist.get(i).getFlag_op());
				list.add(m);
			}
			list.add(ilist.get(i));
		}
		return list;
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
	@ResponseBody
	@RequestMapping("/insert")
	public Map<String,Object> insertPeson(HttpServletRequest request,String learId,String merId,String num,String applyNo,String submitType){
		Map<String,Object> ajaxResult = new HashMap<String, Object>();
		int result = 0 ;
		System.out.println(learId);
		try {
			String allId= merId;
			String[] all = allId.split(",");
			if(all !=null && all !=null){
				for(int i=0; i<all.length;i++){
					result = this.savePerson2(request,all[i], applyNo, submitType);
					if(result==0){
						ajaxResult.put("status", "FALL");
						ajaxResult.put("results","失败");
						return ajaxResult;
					}
				}
			}
			if(learId != null && learId != ""){
				result = this.savePerson1(request,learId, applyNo, submitType);
				if(result==0){
					ajaxResult.put("status", "FALL");
					ajaxResult.put("results","失败");
					return ajaxResult;
				}
			}
		}catch (Exception e) {
			e.printStackTrace();
			ajaxResult.put("status", "FALL");
			ajaxResult.put("results","失败");
			return ajaxResult;	
		}
		ajaxResult.put("status", "OK");
		ajaxResult.put("results","成功");
		return ajaxResult;		
	}
	//insert组长
	private int savePerson1(HttpServletRequest request,String id,String applyNo,String submitType) throws Exception{
		ExpFoodProdPsnRdmDTO dto = new ExpFoodProdPsnRdmDTO();
		dto.setId(id);
		//遍历出随机集合内的所有id
		List<QlcEfpePsnDto> ist =null;	
		ist = expFoodPOFService.findBasePsn(id);
		System.out.println(ist.size());
		if(ist!=null && ist.size()>0){
			dto.setApply_no(applyNo);
			dto.setPsn_id(ist.get(0).getPsnId());
			dto.setPsn_name(ist.get(0).getPsnName());								
			dto.setPsn_goodat(ist.get(0).getPsnExpertise());
			dto.setPsn_level(ist.get(0).getPsnLevel());
			dto.setIn_post(ist.get(0).getIn_post());
			dto.setPsn_type("0");
			dto.setType("2");
//			if(ist.get(0).getType()!=null && ist.get(0).getType().equals("2")){
//				dto.setType("3");
//			}
			//dto.setBel_scope(ist.get(0).getLevelDept_1()+ist.get(0).getLevelDept_2()+ist.get(0).getLevelDept_3());
			dto.setRdm_type(submitType);
			UserInfoDTO user = (UserInfoDTO)request.getSession().getAttribute(Constants.USER_KEY);
			dto.setRdm_user(user.getId());
		return expFoodPOFService.insterPersonRdm(dto);							
		}
		return 0;
	}
	//insert组员
	private int savePerson2(HttpServletRequest request,String id,String applyNo,String submitType) throws Exception{
		ExpFoodProdPsnRdmDTO dto = new ExpFoodProdPsnRdmDTO();
		dto.setId(id);
		//遍历出随机集合内的所有id
		List<QlcEfpePsnDto> ist =null;	
		ist = expFoodPOFService.findBasePsn(id);
		System.out.println(ist.size());
		if(ist!=null && ist.size()>0){
			dto.setApply_no(applyNo);
			dto.setPsn_id(ist.get(0).getPsnId());
			dto.setPsn_name(ist.get(0).getPsnName());								
			dto.setPsn_goodat(ist.get(0).getPsnExpertise());
			dto.setPsn_level(ist.get(0).getPsnLevel());
			dto.setIn_post(ist.get(0).getIn_post());
			dto.setPsn_type("1");
			dto.setType("2");
//			if(ist.get(0).getType()!=null && ist.get(0).getType().equals("2")){
//				dto.setType("3");
//			}
			//dto.setBel_scope(ist.get(0).getLevelDept_1()+ist.get(0).getLevelDept_2()+ist.get(0).getLevelDept_3());
			dto.setRdm_type(submitType);
			UserInfoDTO user = (UserInfoDTO)request.getSession().getAttribute(Constants.USER_KEY);
			dto.setRdm_user(user.getId());
		return expFoodPOFService.insterPersonRdm(dto);							
		}
		return 0;
	}
	
	
	/**
	 * 
	 * 搜索企业库列表
	 * 
	 * @param dto对象

	 */
	@RequestMapping("/showFileMessage")
	public String showFileMessage(FileInfoDto dto,HttpServletRequest request) {
		try {
			int pages = 1;
			if (request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
				pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
			}
			PageBean page_bean = new PageBean(pages,String.valueOf(Constants.PAGE_NUM));
			dto.setFirstRcd(page_bean.getLow());
			dto.setLastRcd(page_bean.getHigh());
			request.setAttribute("list", expFoodPOFService.findFileInfo(dto));
			int counts = expFoodPOFService.findFileCount(dto);
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
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/getBcBzPdf")
	public void getBcBzPdf(HttpServletRequest request,HttpServletResponse response) {
	
		try {
			UserInfoDTO user=(UserInfoDTO)request.getSession().getAttribute(Constants.USER_KEY);
			Boolean bo=ElectronicSealUtil.getElectronicSealPDF("/message/ciqqlc/ca/srcFile/test1.pdf", "3");
			if(bo){
				this.toPrintPlanNote(request,response,null,"/message/ciqqlc/ca/srcFile/test1.pdf","",true);
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
	@RequestMapping("/getPdfYz")
	public void getPdfYz(HttpServletRequest request,HttpServletResponse response,@RequestParam("id") String id) {
		try {
			Boolean bo=ElectronicSealUtil.getElectronicSealPDF("/message/ciqqlc/ca/srcFile/test1.pdf", "3");
			if(bo){
				this.toPrintPlanNote(request,response,null,"/message/ciqqlc/ca/srcFile/test1.pdf","",true);
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
	
	@Override
	protected void formSet(HttpServletRequest request,PdfStamper stamper,AcroFields acroform, Object t, String actionType) {
		// TODO Auto-generated method stub
		try {
			if(null!=actionType && actionType.equals("lookPdf")){
				EfpeApplyReviewNoticeDto dto=(EfpeApplyReviewNoticeDto) t;
				acroform.setField("orgName", dto.getOrgName());
				acroform.setField("checkDate", dto.getCheckDate());
				acroform.setField("address", dto.getAddress());
				acroform.setField("moveTel", dto.getMoveTel());
				acroform.setField("contactName", dto.getContactName());
				acroform.setField("compileName", dto.getCompileName());
				acroform.setField("tel", dto.getTel());
				acroform.setField("depName", dto.getDepName());
				acroform.setField("noticeDate", dto.getNoticeDate());
				acroform.setField("userName", dto.getUserName());
				acroform.setField("userLeader", dto.getUserLeader());

			}else{
				EfpeApplyNoticeDto dto=(EfpeApplyNoticeDto) t;
//				List<CertificationFileModel> list=expFoodPOFService.findCertificationList(dto);
				EfpeApplySurapplyDto surapply=new EfpeApplySurapplyDto();
				if(null!=actionType && (actionType.equals("04") || actionType.equals("01") || actionType.equals("02"))){//04,01,02
					String applyid=request.getParameter("applyid");
					surapply.setSurapplyid(applyid);
					surapply=expFoodPOFService.getSurapply(surapply);
					acroform.setField("RESON", surapply.getReson());
					acroform.setField("SELDATE1", null==surapply.getSeldate()?"":dto.getAcceptdate().substring(0, 4));
					acroform.setField("SELDATE2", null==surapply.getSeldate()?"":dto.getAcceptdate().substring(6, 7));
					acroform.setField("SELDATE3", null==surapply.getSeldate()?"":dto.getAcceptdate().substring(9, 10));
				}
				if(null!=actionType && actionType.equals("11")){//11
					String applyid=request.getParameter("applyid");
					EfpeApplyModel fileDto=new EfpeApplyModel();
					fileDto.setApplyid(applyid);
					List<EfpeApplyFileDTO> fileList=expFoodPOFService.selectFileList(fileDto);
					for(int i=1;i<=fileList.size();i++){
						acroform.setField("FILENAME"+i, fileList.get(i).getFilename());
						acroform.setField("a"+i, String.valueOf(i));
					}
				}
				
				acroform.setField("ACCEPTDATE1", null==dto.getAcceptdate()?"":dto.getAcceptdate().substring(0, 4));
				acroform.setField("ACCEPTDATE2", null==dto.getAcceptdate()?"":dto.getAcceptdate().substring(6, 7));
				acroform.setField("ACCEPTDATE3", null==dto.getAcceptdate()?"":dto.getAcceptdate().substring(9, 10));
				acroform.setField("NATURALADDRESS", dto.getNaturaladdress());
				acroform.setField("HEADNAME", dto.getHeadname());
				acroform.setField("ORGNAME", dto.getOrgname());
				acroform.setField("CODE1", dto.getCode1());
				acroform.setField("CODE2", dto.getCode2());
				acroform.setField("CODE3", dto.getCode3());
				if(null!=dto.getContent()){
					if(dto.getContent().equals("0") || dto.getContent().equals("1") || dto.getContent().equals("2")
							|| dto.getContent().equals("3") || dto.getContent().equals("4") || dto.getContent().equals("5")
							|| dto.getContent().equals("6") || dto.getContent().equals("7")){
						acroform.setField("CONTENT_"+dto.getContent(), "√");
					}else{
						acroform.setField("CONTENT", dto.getContent());
					}
				}
				acroform.setField("NOTICEDATE1",null==dto.getNoticedate()?"":dto.getNoticedate().substring(0, 4));
				acroform.setField("NOTICEDATE2",null==dto.getNoticedate()?"":dto.getNoticedate().substring(6, 7));
				acroform.setField("NOTICEDATE3",null==dto.getNoticedate()?"":dto.getNoticedate().substring(9, 10));
				acroform.setField("CONTACTNAME", dto.getContactname());
				acroform.setField("TEL", dto.getTel());
				acroform.setField("ORGDEPT", dto.getOrgdept());
				acroform.setField("USERNAME", dto.getUsername());
				acroform.setField("CHECKDATE", dto.getCheckdate());
				acroform.setField("CREATEUSER", dto.getCreateuser());
				acroform.setField("CREATEDATE", dto.getCreatedate());
				acroform.setField("NATURALPERSON", dto.getNaturalperson());
				acroform.setField("IDNUMBER", dto.getIdnumber());
				acroform.setField("BLNO", dto.getBlno());
				acroform.setField("ORGADDRESS", dto.getOrgaddress());
				acroform.setField("ACCEPTORG", dto.getAcceptorg());
				acroform.setField("ACCEPTNAME", dto.getAcceptname());
				acroform.setField("ACCEPTTEL", dto.getAccepttel());
				acroform.setField("ISCHARGE", dto.getIscharge());
				acroform.setField("APPLYDATE1", null==dto.getApplydate()?"":dto.getApplydate().substring(0, 4));
				acroform.setField("APPLYDATE2", null==dto.getApplydate()?"":dto.getApplydate().substring(6, 7));
				acroform.setField("APPLYDATE3", null==dto.getApplydate()?"":dto.getApplydate().substring(9, 10));
				acroform.setField("LEGALBDAYS", dto.getLegalbdays());
				acroform.setField("LEGALSDAYS", dto.getLegalsdays());
				acroform.setField("ACTUALBDAYS", dto.getActualbdays());
				acroform.setField("ACTUALSDAYS", dto.getActualsdays());
				acroform.setField("DISBURSEMENT", dto.getDisbursement());
				acroform.setField("MAILADDRESS", dto.getMailaddress());
				acroform.setField("ZIPCODE", dto.getZipcode());
				acroform.setField("MUSTADDRESS", dto.getMustaddress());
				acroform.setField("AGENTNAME", dto.getAgentname());
				acroform.setField("RECIPIENTNAME", dto.getRecipientname());
				acroform.setField("PROVISIONS", dto.getProvisions());
				acroform.setField("MOUJU", dto.getMouju());
				acroform.setField("MOUGOV", dto.getMougov());
				acroform.setField("MOUCOURT", dto.getMoucourt());
				acroform.setField("DECIDEDNAME", dto.getDecidedname());
				acroform.setField("EFFECTIVEDATE", dto.getEffectivedate());
				acroform.setField("NFA", dto.getNfa());
				acroform.setField("NTIAO", dto.getNtiao());
				acroform.setField("NKUAN", dto.getNkuan());
				acroform.setField("NXIANG", dto.getNxiang());
				acroform.setField("ISNEW", dto.getIsnew());
				acroform.setField("DISBURSEMENTOTHER", dto.getDisbursementother());
				acroform.setField("RECORDCODE", dto.getRecordcode());
				acroform.setField("文本97", "出口食品生产企业备案核准");
				acroform.setField("KINDNAME", dto.getKindname());
				acroform.setField("PRODUCTNAME", dto.getProductname());
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
	}
	
	/**
	 * 修改 不符合项报告
	 * @param list
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "update")
	public String save(String list, Model model,RedirectAttributes redirectAttributes,String n1,String n2,String t1,String t2,String docId) {
		try {
			List<CheckModel> chklist=JSON.parseArray(list,CheckModel.class);
			if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(n1) ||com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(n2)
			 || com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(t1) ||com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(t2)
			){
				CheckDocsRcdModel doc=new CheckDocsRcdModel();
				doc.setDocId(docId);
				doc.setOption6(n1);
				doc.setOption7(t1);
				doc.setOption8(n2);
				doc.setOption9(t2);
				commonServer.updateDocs(doc);
			}
			for(CheckModel c:chklist){
				if(null!=c.getCheck_code_id() && c.getCheck_code_id().equals("option")){
					CheckDocsRcdModel doc=new CheckDocsRcdModel();
					doc.setDocId(c.getId());
					doc.setOption4(c.getCheck_disc());
//					doc.setOption5(c.getVerdict());
					commonServer.updateDocs(doc);
				}else{
					expFoodPOFService.updateChklist(c);
				}
			}
			return "sucess";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "error";
	}
	
	/**
	 * 不符合项报告pdf 下载
	 * @param request
	 * @param response
	 * @param compName
	 */
	@RequestMapping(value = "downLoading")
	public void downLoading(HttpServletRequest request,HttpServletResponse response,String compName,ExpFoodProdCheckVo expFoodProdCheckVo){
		try 
        {
			 OutputStream os = response.getOutputStream();
			 response.setContentType("application/pdf");
			 response.setHeader("Content-disposition","attachment; filename=" +"D:\\"+new Date()+".pdf" );
             Document document = new Document(PageSize.A4.rotate()); 
             PdfWriter.getInstance(document, os);

            document.open();
            PdfPTable pt01 = new PdfPTable(8);
            int widthpt01[] = {20,20,20,20,20,20,20,20};
            pt01.setWidths(widthpt01);
            
            pt01.addCell(createCell("公司名称", new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,2,1));    
            pt01.addCell(createCell(compName, new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,6,1));
            
            document.add(pt01);
            
            PdfPTable pt02 = new PdfPTable(8);
            int widthpt02[] ={20,20,20,20,20,20,20,20};
            pt02.setWidths(widthpt02); 
            
            pt02.addCell(createCell("不符合项描述", new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,2,1));
            pt02.addCell(createCell("违反的审核依据内容及条款号", new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,4,1));
//            pt02.addCell(createCell("现场查验", new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,2,1));
            pt02.addCell(createCell("整改完成情况及跟踪审核结论", new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,2,1));
            expFoodProdCheckVo.setCheck_result("2");
    		expFoodProdCheckVo.setCheck_type("1");
    		List<ExpFoodProdCheckVo> pdflist=expFoodPOFService.getToTextViewNoPassNew(expFoodProdCheckVo);
            for(int i=0;i<pdflist.size();i++){
                pt02.addCell(createCell(pdflist.get(i).getCheck_disc(), new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,2,1));
                pt02.addCell(createCell(pdflist.get(i).getTk_nubmer()+"\n"+pdflist.get(i).getCheck_contents(), new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,4,1));
//                pt02.addCell(createCell(getFime(pdflist.get(i)), new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,2,1));
//                pt02.addCell(createCell(getRes(pdflist.get(i).getCheck_result()), new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,2,1));
                pt02.addCell(createCell(pdflist.get(i).getVerdict(), new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,2,1));
            }
            Map<String,Object> param = new HashMap<String, Object>();
            if(null!=request.getParameter("type") && !request.getParameter("type").equals("")){
            	param.put("DocType", request.getParameter("type")+"_QT");
            }else{
            	param.put("DocType", "V_SP_F_D_QT");
            }
            param.put("ProcMainId", expFoodProdCheckVo.getApply_no());
            List<CheckDocsRcdModel> qtlist=expFoodPOFService.getQtOption(param);
            for(int i=0;i<qtlist.size();i++){
            	if(null!=qtlist.get(i).getOption3() && qtlist.get(i).getOption3().equals("1")){
            		pt02.addCell(createCell(qtlist.get(i).getOption4(), new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,2,1));
            		pt02.addCell(createCell(qtlist.get(i).getOption5(), new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,4,1));
            		pt02.addCell(createCell("", new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,2,1));
            	}
            }
            document.add(pt02);
            
            PdfPTable pt03 = new PdfPTable(8);
            int widthpt03[] = {20,20,20,20,20,20,20,20};
            pt03.setWidths(widthpt03);
            
            Map<String,Object> map = new HashMap<String, Object>();
    		map.put("ProcMainId", expFoodProdCheckVo.getApply_no());
    		if(null!=request.getParameter("type") && !request.getParameter("type").equals("")){
            	param.put("DocType", request.getParameter("type"));
            }else{
            	map.put("DocType", "V_SP_F_D");
            }
			CheckDocsRcdModel docsRcd  =quartnService.findOnlyDoc(map);
            
            pt03.addCell(createCell(13,"以上不符合项，必须在 "+(null!=docsRcd && null!=docsRcd.getOption1()?docsRcd.getOption1():"")+"日内完成整改。",  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,4,1));
            pt03.addCell(createCell(13,"",  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,4,1));

            pt03.addCell(createCell(4,"评审组长\n（签名）",  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,1,1));
            pt03.addCell(createImgCell(0,(null!=docsRcd?docsRcd.getOption2():""),  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,1,1));
            pt03.addCell(createCell(0,"日期",  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,1,1));
            pt03.addCell(createCell(8,(null!=docsRcd?docsRcd.getOption3():""),  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,1,1));
            pt03.addCell(createCell(4,"跟踪检查人\n（签名）",  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,1,1));
            pt03.addCell(createImgCell(0,(null!=docsRcd?docsRcd.getOption6():""),  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,1,1));
            pt03.addCell(createCell(0,"日期",  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,1,1));
            pt03.addCell(createCell(8,(null!=docsRcd?docsRcd.getOption7():""),  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,1,1));
            
            
            pt03.addCell(createCell(6,"企业负责人：",  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,1,1));
            pt03.addCell(createImgCell(2,(null!=docsRcd?docsRcd.getOption4():""),  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,1,1));
            pt03.addCell(createCell(2,"日期",  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,1,1));
            pt03.addCell(createCell(10,(null!=docsRcd?docsRcd.getOption5():""),  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,1,1));
            pt03.addCell(createCell(6,"企业负责人：",  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,1,1));
            pt03.addCell(createImgCell(2,"",  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,1,1));
            pt03.addCell(createCell(2,"日期",  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,1,1));
            pt03.addCell(createCell(10,"",  new Font(BaseFont.createFont("STSong-Light","UniGB-UCS2-H",BaseFont.NOT_EMBEDDED), 10, Font.NORMAL),Element.ALIGN_MIDDLE, Element.ALIGN_CENTER,1,1));
            
            document.add(pt03);
            document.close();
            os.flush();
            os.close();

        } catch (Exception ex) 
        {
          ex.printStackTrace();
        }
	}
	
	/**
	 * 为pdf 创建图片单元格
	 * @param border
	 * @param value
	 * @param font
	 * @param alignMiddle
	 * @param alignCenter
	 * @param i
	 * @param j
	 * @return
	 * @throws BadElementException
	 * @throws MalformedURLException
	 * @throws IOException
	 */
	private PdfPCell createImgCell(int border, String value, Font font, int alignMiddle,
			int alignCenter, int i, int j) throws BadElementException,
			MalformedURLException, IOException {
		PdfPCell cell = new PdfPCell();
		if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(value)){
			Image img = Image.getInstance(Constants.UP_LOAD_PATH+"/"+value);
			img.scaleAbsolute(mmTopx(20), mmTopx(5));// 直接设定显示尺寸
			// img.setAbsolutePosition(220,680);
			img.setAbsolutePosition(0, 0);
			img.setAlignment(Element.ALIGN_CENTER);
			img.scaleAbsolute(400, 400);
			img.scalePercent(50);
			img.scalePercent(50, 50);
			img.setRotation(0);
			cell.setImage(img);
		}
		cell.setBorder(border);
		return cell;
	}
	
	/**
	 * 为pdf 创建单元格
	 * @param border
	 * @param value
	 * @param font
	 * @param align_v
	 * @param align_h
	 * @param colspan
	 * @param rowspan
	 * @return
	 */
	private PdfPCell createCell(int border ,String value,Font font,int align_v,int align_h,int colspan,int rowspan) {
		  	PdfPCell cell = new PdfPCell();   
	        cell.setMinimumHeight(50);
	        cell.setVerticalAlignment(align_v);    
	        cell.setHorizontalAlignment(align_h);
	        cell.setColspan(colspan); 
	        cell.setRowspan(rowspan); 
	        cell.setPhrase(new Phrase(value,font));  
	        cell.setBorder(border);
	        return cell;
	}
	private float mmTopx(float mm) {
    	mm = (float) (mm *3.33) ;
        return mm ;
	}
	private String getRes(String check_result) {
		if(com.dpn.ciqqlc.common.util.StringUtils.isEmpty(check_result)){
			return "□符合\n\n□不符合\n\n□不适用";
		}else if(check_result.equals("1")){
			return "☑符合\n\n□不符合\n\n□不适用";
		}else if(check_result.equals("2")){
			return "□符合\n\n☑不符合\n\n□不适用";
		}else{
			return "□符合\n\n□不符合\n\n☑不适用";
		}
	}
	
	private String getRes2(String check_result) {
		if(com.dpn.ciqqlc.common.util.StringUtils.isEmpty(check_result)){
			return "□符合\n\n□不符合\n\n□不适用";
		}else if(check_result.equals("0")){
			return "☑符合\n\n□不符合\n\n□不适用";
		}else if(check_result.equals("1")){
			return "□符合\n\n☑不符合\n\n□不适用";
		}else{
			return "□符合\n\n□不符合\n\n☑不适用";
		}
	}
	private String getFime(ExpFoodProdCheckVo expFoodProdCheckVo) {
		String v_str="";
		String s_str="";
		if(null!=expFoodProdCheckVo.getEventList() && expFoodProdCheckVo.getEventList().size()>0){
			for(VideoEventModel v:expFoodProdCheckVo.getEventList()){
				if(null!=v && v.getFileType().equals("1")){
					v_str+="查看图片文件\n\n";
				}
				if(null!=v && v.getFileType().equals("2")){
					s_str+="查看视频文件\n\n";
				}
			}
		}else{
			return "无文件";
		}
		return v_str+s_str;
	}
	
	/**
	 * 为pdf 创建 单元格
	 * @param value
	 * @param font
	 * @param align_v
	 * @param align_h
	 * @param colspan
	 * @param rowspan
	 * @return
	 * @throws DocumentException
	 * @throws IOException
	 */
    public PdfPCell createCell(String value,Font font,int align_v,int align_h,int colspan,int rowspan) throws DocumentException, IOException{
//    	BaseFont bf = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
        PdfPCell cell = new PdfPCell();   
        cell.setMinimumHeight(50);
        cell.setVerticalAlignment(align_v);    
        cell.setHorizontalAlignment(align_h);
        cell.setColspan(colspan); 
        cell.setRowspan(rowspan); 
        cell.setPhrase(new Phrase(value,font));  
        return cell;
    }
    
	/**
	 * 11菜单 pdf 下载
	 * @param request
	 * @param response
	 * @param compName
	 * @param expFoodProdCheckVo
	 */
	@RequestMapping(value = "downPdfVeiw")
	public void downPdfVeiw(HttpServletRequest request,
			HttpServletResponse response, String compName,
			ExpFoodProdCheckVo expFoodProdCheckVo) {
		try {
			OutputStream os = response.getOutputStream();
			response.setContentType("application/pdf");
			response.setHeader("Content-disposition","attachment; filename=" +"D:\\"+new Date()+".pdf" );
			Document document = new Document(PageSize.A4.rotate());
			PdfWriter.getInstance(document, os);
			document.open();
			
//			expFoodProdCheckVo.setCheck_result("2");
//    		expFoodProdCheckVo.setCheck_type("1");
//    		List<ExpFoodProdCheckVo> pdflist=expFoodPOFService.getToTextViewNoPassNew(expFoodProdCheckVo);
			List<ExpFoodProdCheckVo> pdflist=expFoodPOFService.getToTextView2(expFoodProdCheckVo,request);
			if(null!=pdflist && pdflist.size()>0){
				document.add(createParagraph(pdflist.get(0).getCheck_title(),new Font(BaseFont.createFont("STSong-Light",
						"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
						Font.NORMAL),Element.ALIGN_LEFT));
			}
			PdfPTable pt01 = new PdfPTable(6);
			int widthpt01[] = { 20, 20, 20, 20, 20, 20 };
			pt01.setWidths(widthpt01);

			pt01.addCell(createCell(
					"备案要求",
					new Font(BaseFont.createFont("STSong-Light",
							"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
							Font.NORMAL), Element.ALIGN_MIDDLE,
					Element.ALIGN_CENTER, 1, 1));
			pt01.addCell(createCell(
					"审核要点",
					new Font(BaseFont.createFont("STSong-Light",
							"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
							Font.NORMAL), Element.ALIGN_MIDDLE,
					Element.ALIGN_CENTER, 1, 1));
			pt01.addCell(createCell(
					"现场检查内容",
					new Font(BaseFont.createFont("STSong-Light",
							"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
							Font.NORMAL), Element.ALIGN_MIDDLE,
					Element.ALIGN_CENTER, 1, 1));
			pt01.addCell(createCell(
					"现场查验",
					new Font(BaseFont.createFont("STSong-Light",
							"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
							Font.NORMAL), Element.ALIGN_MIDDLE,
					Element.ALIGN_CENTER, 1, 1));
			pt01.addCell(createCell(
					"结果判定",
					new Font(BaseFont.createFont("STSong-Light",
							"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
							Font.NORMAL), Element.ALIGN_MIDDLE,
					Element.ALIGN_CENTER, 1, 1));
			pt01.addCell(createCell(
					"说明",
					new Font(BaseFont.createFont("STSong-Light",
							"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
							Font.NORMAL), Element.ALIGN_MIDDLE,
					Element.ALIGN_CENTER, 1, 1));
			for (int i = 0; i < pdflist.size(); i++) {
				if(null!=pdflist.get(i) && !pdflist.get(i).getTd().equals("0")){
				pt01.addCell(createCell(
							pdflist.get(i).getCheck_contents(),
							new Font(BaseFont.createFont("STSong-Light",
									"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
									Font.NORMAL), Element.ALIGN_MIDDLE,
									Element.ALIGN_CENTER, 1, Integer.parseInt(pdflist.get(i).getTd())));
							
				}
				pt01.addCell(createCell(
						pdflist.get(i).getCheck_req(),
						new Font(BaseFont.createFont("STSong-Light",
								"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
								Font.NORMAL), Element.ALIGN_MIDDLE,
						Element.ALIGN_CENTER, 1, 1));
				pt01.addCell(createCell(
						pdflist.get(i).getReq(),
						new Font(BaseFont.createFont("STSong-Light",
								"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
								Font.NORMAL), Element.ALIGN_MIDDLE,
						Element.ALIGN_CENTER, 1, 1));
				pt01.addCell(createCell(
						getFime(pdflist.get(i)),
						new Font(BaseFont.createFont("STSong-Light",
								"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
								Font.NORMAL), Element.ALIGN_MIDDLE,
						Element.ALIGN_CENTER, 1, 1));
				pt01.addCell(createTsCell(//
						request,
						getRes(pdflist.get(i).getCheck_result()),
						new Font(BaseFont.createFont("STSong-Light",
								"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
								Font.NORMAL), Element.ALIGN_MIDDLE,
								Element.ALIGN_CENTER, 1, 1));
				pt01.addCell(createCell(
						pdflist.get(i).getCheck_disc(),
						new Font(BaseFont.createFont("STSong-Light",
								"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
								Font.NORMAL), Element.ALIGN_MIDDLE,
						Element.ALIGN_CENTER, 1, 1));
			}

			document.add(pt01);
			document.close();
			os.flush();
			os.close();

		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
	
	/**
	 * 为pdf单元格加特殊符号样式
	 * @param request 
	 * @param value
	 * @param font
	 * @param align_v
	 * @param align_h
	 * @param colspan
	 * @param rowspan
	 * @return
	 * @throws DocumentException
	 * @throws IOException
	 */
	@SuppressWarnings("deprecation")
	private PdfPCell createTsCell(HttpServletRequest request, String value, Font font, int align_v,int align_h, int colspan, int rowspan) throws DocumentException,IOException {
		String path = request.getRealPath("/static/font/arialuni.ttf");
		BaseFont bf = BaseFont.createFont(path,BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);
		font = new Font(bf, 12, Font.NORMAL);
		PdfPCell cell = new PdfPCell();
		cell.setMinimumHeight(50);
		cell.setVerticalAlignment(align_v);
		cell.setHorizontalAlignment(align_h);
		cell.setColspan(colspan);
		cell.setRowspan(rowspan);
		cell.setPhrase(new Phrase(value, font));
		return cell;
	}
	
	/**
	 * 其他 pdf 下载
	 * @param request
	 * @param response
	 * @param compName
	 * @param expFoodProdCheckVo
	 */
	@RequestMapping(value = "downPdfQt")
	public void downPdfQt(HttpServletRequest request,
			HttpServletResponse response, String compName,
			ExpFoodProdCheckVo expFoodProdCheckVo) {
			try {
				OutputStream os = response.getOutputStream();
				response.setContentType("application/pdf");
				response.setHeader("Content-disposition","attachment; filename=" +"D:\\"+new Date()+".pdf" );
				Document document = new Document(PageSize.A4.rotate());
				PdfWriter.getInstance(document, os);
				document.open();
				document.add(createParagraph("其他",new Font(BaseFont.createFont("STSong-Light",
							"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
							Font.NORMAL),Element.ALIGN_LEFT));
				PdfPTable pt01 = new PdfPTable(4);
				int widthpt01[] = { 20, 20, 20, 20};
				pt01.setWidths(widthpt01);
				pt01.addCell(createCell(
						"录入内容",
						new Font(BaseFont.createFont("STSong-Light",
								"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
								Font.NORMAL), Element.ALIGN_MIDDLE,
						Element.ALIGN_CENTER, 1, 1));
				pt01.addCell(createCell(
						"现场查验",
						new Font(BaseFont.createFont("STSong-Light",
								"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
								Font.NORMAL), Element.ALIGN_MIDDLE,
						Element.ALIGN_CENTER, 1, 1));
				pt01.addCell(createCell(
						"结果判定",
						new Font(BaseFont.createFont("STSong-Light",
								"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
								Font.NORMAL), Element.ALIGN_MIDDLE,
						Element.ALIGN_CENTER, 1, 1));
				pt01.addCell(createCell(
						"说明",
						new Font(BaseFont.createFont("STSong-Light",
								"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
								Font.NORMAL), Element.ALIGN_MIDDLE,
						Element.ALIGN_CENTER, 1, 1));
				
				Map<String,Object> param = new HashMap<String, Object>();
		    	param.put("DocType", "V_SP_F_D_QT");
		    	param.put("ProcMainId", expFoodProdCheckVo.getApply_no());
		    	List<CheckDocsRcdModel> doclist=expFoodPOFService.getQtOption(param);
		    	for(CheckDocsRcdModel c:doclist){
		    		if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(c.getOption1())){
		    			c.setOption91(c.getOption1().substring(6, 12)+"/"+c.getOption1().substring(6, 14)+"/"+c.getOption1());
		    		}
		    		if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(c.getOption2())){
		    			c.setOption92(c.getOption2().substring(6, 12)+"/"+c.getOption2().substring(6, 14)+"/"+c.getOption2());
		    		}
		    	}
				
			if (null != doclist) {
				for (int i = 0; i < doclist.size(); i++) {
					pt01.addCell(createCell(
							doclist.get(i).getOption4(),
							new Font(BaseFont.createFont("STSong-Light",
									"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
									Font.NORMAL), Element.ALIGN_MIDDLE,
							Element.ALIGN_CENTER, 1, 1));
					String name=this.getFile(doclist.get(i));
					pt01.addCell(createCell(
								name,
								new Font(BaseFont.createFont("STSong-Light",
										"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED),
										10, Font.NORMAL), Element.ALIGN_MIDDLE,
								Element.ALIGN_CENTER, 1, 1));
					pt01.addCell(createTsCell(request,
							getRes2(doclist.get(i).getOption3()),
							new Font(BaseFont.createFont("STSong-Light",
									"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
									Font.NORMAL), Element.ALIGN_MIDDLE,
							Element.ALIGN_CENTER, 1, 1));
					pt01.addCell(createCell(
							doclist.get(i).getOption5(),
							new Font(BaseFont.createFont("STSong-Light",
									"UniGB-UCS2-H", BaseFont.NOT_EMBEDDED), 10,
									Font.NORMAL), Element.ALIGN_MIDDLE,
							Element.ALIGN_CENTER, 1, 1));
				}
			}
				document.add(pt01);
				document.close();	
			} catch (IOException e) {
				e.printStackTrace();
			} catch (DocumentException e) {
				e.printStackTrace();
			}
	}
	
	private String getFile(CheckDocsRcdModel checkDocsRcdModel) {
		String fileName="";
		if (null != checkDocsRcdModel) {
			if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(checkDocsRcdModel.getOption1())){
				fileName+="查看图片文件\n";
			}
			if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(checkDocsRcdModel.getOption2())){
				fileName+="\n查看视频文件";
			}
		} else{
			return "无文件";
		}
		return fileName;
	}
	/**
	 * 为 pdf 创建段落
	 * 
	 * @param value
	 * @param font
	 * @param align
	 * @return
	 */
	   public Paragraph createParagraph(String value,Font font,int align){ 
	        Paragraph paragraph = new Paragraph();
	        paragraph.add(new Phrase(value,font));
	        paragraph.setAlignment(align);
	        return paragraph;
	    }
	   
		@ResponseBody
		@RequestMapping(value = "findFile")
		public Map<String,Object> findFile(HttpServletRequest request,FileInfoDto dto) {
			Map<String,Object> map=new HashMap<String,Object>();
			try {
				List<FileInfoDto> list=expFoodPOFService.findFile(dto);
				if(list!=null && list.size()>0){
					map.put("path", list.get(0).getFile_location());
					map.put("status", "OK");
					return map;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			map.put("status", "error");
			return map;
		}
		
		@RequestMapping(value = "/fileList",method=RequestMethod.GET)
		public void fileList(HttpServletRequest request,
				HttpServletResponse response,EfpeApplyCommentFileDto efpeApplyCommentFile) {
			String path=Constants.FTP_HOST_FILE;
//			String year=efpeApplyCommentFile.getStartdate().substring(0, 4);
//			String month=efpeApplyCommentFile.getStartdate().substring(5, 7);
			String year=efpeApplyCommentFile.getPath().split("/")[0];
			String month=efpeApplyCommentFile.getPath().split("/")[1];
			String fileName=efpeApplyCommentFile.getFileid()+"."+efpeApplyCommentFile.getFiletype();
			response.setContentType("text/html;charset=gb2312");
			PrintWriter out = null;
			try {
				Boolean b = FtpUtil.downloadFile(
						Constants.FTP_HOST,
						Constants.FTP_HOST_PORT,
						Constants.FTP_HOST_USERNAME,
						Constants.FTP_HOST_PASSWORD,
						path+year+"/"+month,
						fileName,
						Constants.UP_LOAD_PATH + "/"
								+ efpeApplyCommentFile.getPath(),
						efpeApplyCommentFile.getFilename(), year, month);
//				Boolean b=FtpUtil.downloadFile("10.21.255.148", 21, "lnciq_cnca", "ciq@148", "/home/lnciq_cnca/attachment/2017/12", "e527ac99664d4660a27748095d56ce14.pdf", Constants.UP_LOAD_PATH+"/2017/12",efpeApplyCommentFile.getFilename());
				if(b){
//					FileUtil.downloadFile(Constants.UP_LOAD_PATH+"/2017/12" + "/e527ac99664d4660a27748095d56ce14.pdf",response,true);
					this.newDownLoad(
							Constants.UP_LOAD_PATH + "/"
									+ efpeApplyCommentFile.getPath()
									+ efpeApplyCommentFile.getFilename(), response);
				}else{
					out=response.getWriter();
					out.println("<script>");
					out.print("alert('文件不存在!');location.href=document.referrer;");
					out.println("</script>");
					out.flush();
					out.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
				try {
					out=response.getWriter();
					out.println("<script>");
					out.print("alert('文件下载失败!');location.href=document.referrer;");
					out.println("</script>");
					out.flush();
					out.close();
				} catch (IOException e1) {
					e1.printStackTrace();
				}
			}
		}
		
		@SuppressWarnings("unchecked")
		@RequestMapping(value = "mbList")
		public void mbList(HttpServletRequest request,HttpServletResponse response,EfpeApplyNoticeDto notice) {
			try {
				EfpeApplyNoticeDto efpeApplyNotice=expFoodPOFService.findEfpeApplyNoticeDto(notice);
				this.toPrintPlanNote(request,response,efpeApplyNotice,Constants.PDF_ROOT+"/"+notice.getNoticetype()+".pdf",notice.getNoticetype(),true);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		@SuppressWarnings({ "unchecked" })
		@RequestMapping("/sealPdf")
		public void sealPdf(HttpServletRequest request,HttpServletResponse response,EfpeApplyNoticeDto notice) {
			try {
				UserInfoDTO user=(UserInfoDTO)request.getSession().getAttribute(Constants.USER_KEY);
				EfpeApplyNoticeDto efpeApplyNotice=expFoodPOFService.findEfpeApplyNoticeDto(notice);
				/*pdf生成*/
				String fileName = this.toPrintFile(request,response,efpeApplyNotice,Constants.PDF_ROOT+"/"+notice.getNoticetype()+".pdf",notice.getNoticetype());
				/*盖章*/
				Boolean bo=ElectronicSealUtil.getElectronicSealPDF(fileName, user.getOrg_code().substring(2, 6)+Constants.SEAL_PDF_TYPE[1]);
				if(bo){
					this.toPrintPlanNote(request,response,null,fileName,"",true);
				}else{
					response.setHeader("Content-type","text/html;charset=UTF-8");//向浏览器发送一个响应头，设置浏览器的解码方式为UTF-8  
					String data = "<script language='javascript'>alert('电子盖章失败');location.href=document.referrer;</script>";  
					OutputStream stream = response.getOutputStream();  
					stream.write(data.getBytes("UTF-8")); 
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		@SuppressWarnings("unchecked")
		@RequestMapping(value = "lookPdf")
		public void lookPdf(HttpServletRequest request,HttpServletResponse response,EfpeApplyReviewNoticeDto efpeApplyReviewNoticeDto) {
			try {
				List<EfpeApplyReviewNoticeDto> list=expFoodPOFService.findEfpeApplyReviewNoticeDto(efpeApplyReviewNoticeDto);
				if(!list.isEmpty()){
					this.toPrintPlanNote(request,response,list.get(0),Constants.PDF_ROOT+"/"+"psrwtzs.pdf","lookPdf",false);
				}else{
					this.toPrintPlanNote(request,response,new EfpeApplyReviewNoticeDto(),Constants.PDF_ROOT+"/"+"psrwtzs.pdf","lookPdf",false);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		@RequestMapping(value = "/toLoacation",method=RequestMethod.GET)
		public String toLoacation(HttpServletRequest request,
				HttpServletResponse response,ExpFoodProdPsnRdmDTO foodProdPsnRdmDTO) {
			try {
				List<ExpFoodProdPsnRdmDTO> 	rdmName = expFoodPOFService.selectRdmName2(foodProdPsnRdmDTO);
				Map<String, String> mapCode = new HashMap<String, String>();
				List<EfpePsnExptDto> expList = expFoodPOFService.expertise_code();
				for(int i=0;i<expList.size();i++){
					mapCode.put(expList.get(i).getExpertise_code(), expList.get(i).getExpertise_detail());
				}
				for(ExpFoodProdPsnRdmDTO ra:rdmName){
					if(com.dpn.ciqqlc.common.util.StringUtils.isNotEmpty(ra.getPsn_goodat())){
						String [] str = ra.getPsn_goodat().split(";");
						String exp = "";
						for(int j=0;j<str.length;j++){
							exp += ","+mapCode.get(str[j]);
						}
						exp = exp.substring(1);
						ra.setPsn_prof(exp);
					}
				}
				request.setAttribute("list", rdmName);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return "expFoodProd/showPerson";
		}
		
		@RequestMapping(value = "/newJump",method=RequestMethod.GET)
		public String newJump(HttpServletRequest request,HttpServletResponse response,ExpFoodProdPsnRdmDTO foodProdPsnRdmDTO) {
			try {
				request.setAttribute("psnTypeCode", expFoodPOFService.psnTypeCode());//分类
				request.setAttribute("psnLevelCode",expFoodPOFService.psnLevelCode());//级别
				request.setAttribute("psnLevelDept_1Code",expFoodPOFService.psnLevelDept_1Code());//一级部门
				request.setAttribute("psnLevelDept_2Code",expFoodPOFService.psnLevelDept_2Code());//二级部门
				request.setAttribute("psnLevelDept_3Code",expFoodPOFService.psnLevelDept_3Code());//三级部门
				request.setAttribute("expertiseCode1", expFoodPOFService.expertise_code1());//专长
				request.setAttribute("expertiseCode2", expFoodPOFService.expertise_code2());//专长
				request.setAttribute("expertiseCode3", expFoodPOFService.expertise_code3());//专长
				request.setAttribute("expertiseCode4", expFoodPOFService.expertise_code4());//专长
				request.setAttribute("expertiseCode5", expFoodPOFService.expertise_code5());//专长
				request.setAttribute("id", foodProdPsnRdmDTO.getId());//主键
			} catch (Exception e) {
				e.printStackTrace();
			}
			return "expFoodProd/newJump";
		}
		
		
		
		
		 @RequestMapping("/jumpAddpeson")
			public String jumpAddpeson(QlcEfpePsnDto dto,Model model,HttpServletRequest request){
		    	Map<String, String> mapCode = new HashMap<String, String>();
				try {
					//将expertise_code获得的值存入mapCode
					List<EfpePsnExptDto> expList = expFoodPOFService.expertise_code();
					for(int i=0;i<expList.size();i++){
						mapCode.put(expList.get(i).getExpertise_code(), expList.get(i).getExpertise_detail());
					}
					//search		
					String laderPsnExpertiseS = "";
					String laderPsnExpertise = dto.getPsnExpertise();
					if(laderPsnExpertise!=null && laderPsnExpertise!="" ){
						String [] laderPsnExpertiseStr = laderPsnExpertise.split(",");
							for(int i=0;i<laderPsnExpertiseStr.length;i++){
								laderPsnExpertiseS += "or instr (p.psn_goodat,'"+laderPsnExpertiseStr[i]+"')>0";
							}
						}
					String laderPsnExpertiseOther = dto.getPsnExpertise_order();
					if(laderPsnExpertiseOther!=null && laderPsnExpertiseOther!="" ){
						String [] laderPsnExpertiseOtherStr = laderPsnExpertiseOther.split(",");
						for(int i=0;i<laderPsnExpertiseOtherStr.length;i++){
							laderPsnExpertiseS += "or instr (p.psn_other_goodat,'"+laderPsnExpertiseOtherStr[i]+"')>0";
						}
					}
					if(!laderPsnExpertiseS.equals("")){
						laderPsnExpertiseS = laderPsnExpertiseS.substring(3);
						dto.setPsnExpertise("("+laderPsnExpertiseS+")");
					}
					
					dto.setLevelDept_1(getNewString(dto.getLevelDept_1()));
					dto.setLevelDept_2(getNewString(dto.getLevelDept_2()));
					dto.setLevelDept_3(getNewString(dto.getLevelDept_3()));
					List<QlcEfpePsnDto> laderLi = expFoodPOFService.selectBasePsn(dto);
					List<QlcEfpePsnDto> laderList = new ArrayList<QlcEfpePsnDto>();
					for(int a=0;a<laderLi.size();a++){
						QlcEfpePsnDto exps = new QlcEfpePsnDto();
						String psnExpStr = laderLi.get(a).getPsnExpertise();
						if(StringUtils.isNotBlank(psnExpStr)){
							String [] str = psnExpStr.split(";");
							String exp = "";
							for(int j=0;j<str.length;j++){
								exp += ","+mapCode.get(str[j]);
							}
							exp = exp.substring(1);
							exps.setExpName(exp);
							exps.setPsnId(laderLi.get(a).getPsnId());
							exps.setPsnName(laderLi.get(a).getPsnName());
							exps.setPsnType(laderLi.get(a).getPsnType());
							exps.setPsnExpertise(laderLi.get(a).getPsnExpertise());
							exps.setIn_post(laderLi.get(a).getIn_post());
							exps.setLevelDept_1(laderLi.get(a).getLevelDept_1());
							exps.setLevelDept_2(laderLi.get(a).getLevelDept_2());
							exps.setLevelDept_3(laderLi.get(a).getLevelDept_3());
							exps.setPsnLevel(laderLi.get(a).getPsnLevel());
							laderList.add(exps);
						}
					}
					
					if(laderList.size()>0){
						Random randemLader = new Random();
						int laderSize = randemLader.nextInt(laderList.size());
						request.setAttribute("one", laderList.get(laderSize));//随机出的组长
					}
					
					//search
					request.setAttribute("id", request.getParameter("id"));
					request.setAttribute("psnTypeCode", expFoodPOFService.psnTypeCode());//分类
					request.setAttribute("psnLevelCode",expFoodPOFService.psnLevelCode());//级别
					request.setAttribute("psnLevelDept_1Code",expFoodPOFService.psnLevelDept_1Code());//一级部门
					request.setAttribute("psnLevelDept_2Code",expFoodPOFService.psnLevelDept_2Code());//二级部门
					request.setAttribute("psnLevelDept_3Code",expFoodPOFService.psnLevelDept_3Code());//三级部门
					request.setAttribute("expertiseCode1", expFoodPOFService.expertise_code1());//专长
					request.setAttribute("expertiseCode2", expFoodPOFService.expertise_code2());//专长
					request.setAttribute("expertiseCode3", expFoodPOFService.expertise_code3());//专长
					request.setAttribute("expertiseCode4", expFoodPOFService.expertise_code4());//专长
					request.setAttribute("expertiseCode5", expFoodPOFService.expertise_code5());//专长
					/******************回显********************/
					request.setAttribute("psnType",request.getParameter("psnType"));
					request.setAttribute("psnExpertise",request.getParameter("psnExpertise"));
					request.setAttribute("psnLevel",request.getParameter("psnLevel"));
					request.setAttribute("in_post",request.getParameter("in_post"));
					request.setAttribute("levelDept_1",request.getParameter("levelDept_1"));
					request.setAttribute("levelDept_2",request.getParameter("levelDept_2"));
					request.setAttribute("levelDept_3",request.getParameter("levelDept_3"));
					request.setAttribute("apply_no",request.getParameter("apply_no"));
				} catch (Exception e) {
					e.printStackTrace();
				}
				return "expFoodProd/newJump";
			}
		 
		 
			
			@RequestMapping(value = "/updateAddpeson",method=RequestMethod.POST)
			public String updateAddpeson(HttpServletRequest request,HttpServletResponse response,ExpFoodProdPsnRdmDTO foodProdPsnRdmDTO) {
				try {
					expFoodPOFService.updateSelectPerson(foodProdPsnRdmDTO);
				} catch (Exception e) {
					e.printStackTrace();
				}
				return "redirect:/expFoodPOF/toLoacation?apply_no="+foodProdPsnRdmDTO.getApply_no();
			}
			
		/**
		 * 查询评审员管理列表(食品备案)
		 * 
		 * @param request
		 * @param qlcefpepsndto
		 *            查询条件form
		 * @return
		 */
		@RequestMapping("/psyList")
		public String psyList(HttpServletRequest request,
				QlcEfpePsnDto qlcefpepsndto) {
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
				// 姓名
				if (!StringUtils.isEmpty(qlcefpepsndto.getPsnName())) {
					map.put("psn_name", qlcefpepsndto.getPsnName());
				}
				// 评审员编号
				if (!StringUtils.isEmpty(qlcefpepsndto.getPsnCode())) {
					map.put("psn_code",
							qlcefpepsndto.getPsnCode());
				}
				// 一级部门
				if (!StringUtils.isEmpty(qlcefpepsndto.getLevelDept_1())) {
					String str ="(";
					String[] arr = qlcefpepsndto.getLevelDept_1().split(",");
					for (int i = 0; i < arr.length; i++) {
						str += "'"+arr[i]+"',";
					}
					str = str.substring(0,str.length()-1);
					str +=")";
					map.put("level_dept_1",str);
					
				}
				// 是否在岗
				if (!StringUtils.isEmpty(qlcefpepsndto.getIn_post())) {
					map.put("in_post",qlcefpepsndto.getIn_post());
				}
				map.put("firstRcd", page_bean.getLow());
				map.put("lastRcd", page_bean.getHigh());
				List<QlcEfpePsnDto> list = expFoodPOFService.psyList(map);
				int counts = expFoodPOFService.psyCounts(map);
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
				request.setAttribute("psn_name", qlcefpepsndto.getPsnName());
				request.setAttribute("psn_code", qlcefpepsndto.getPsnCode());
				request.setAttribute("psnLevelDept_1Code",expFoodPOFService.psnLevelDept_1Code());//一级部门
			} catch (Exception e) {
				logger_.error("***********/expFoodPOF/psyList************", e);
			} finally {
				map = null;
			}
			return "expFoodProd/psyList";
		}
		
		/**
		 * 查询评审员管理列表(行政处罚)
		 * 
		 * @param request
		 * @param qlcefpepsndto
		 *            查询条件form
		 * @return
		 */
		@RequestMapping("/psyList2")
		public String psyList2(HttpServletRequest request,
				QlcEfpePsnDto qlcefpepsndto) {
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
				// 姓名
				if (!StringUtils.isEmpty(qlcefpepsndto.getPsnName())) {
					map.put("psn_name", qlcefpepsndto.getPsnName());
				}
				// 评审员编号
				if (!StringUtils.isEmpty(qlcefpepsndto.getPsnCode())) {
					map.put("psn_code",
							qlcefpepsndto.getPsnCode());
				}
				// 一级部门
				if (!StringUtils.isEmpty(qlcefpepsndto.getLevelDept_1())) {
					String str ="(";
					String[] arr = qlcefpepsndto.getLevelDept_1().split(",");
					for (int i = 0; i < arr.length; i++) {
						str += "'"+arr[i]+"',";
					}
					str = str.substring(0,str.length()-1);
					str +=")";
					map.put("level_dept_1",str);
					
				}
				// 是否在岗
				if (!StringUtils.isEmpty(qlcefpepsndto.getIn_post())) {
					map.put("in_post",qlcefpepsndto.getIn_post());
				}
				map.put("firstRcd", page_bean.getLow());
				map.put("lastRcd", page_bean.getHigh());
				List<QlcEfpePsnDto> list = expFoodPOFService.psyList2(map);
				int counts = expFoodPOFService.psyCounts2(map);
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
				request.setAttribute("psn_name", qlcefpepsndto.getPsnName());
				request.setAttribute("psn_code", qlcefpepsndto.getPsnCode());
				request.setAttribute("psnLevelDept_1Code",expFoodPOFService.psnLevelDept_1Code());//一级部门
			} catch (Exception e) {
				logger_.error("***********/expFoodPOF/psyList2************", e);
			} finally {
				map = null;
			}
			return "expFoodProd/psyList2";
		}
		
		/**
		 * 根据psnId查询评审人员表的相关信息，并跳转到修改页面
		 * 
		 * @param request
		 * @param qlcefpepsndto
		 *            查询条件form
		 * @return
		 */
		@RequestMapping("/toPsyUpdateForm")
		public String toPsyUpdateForm(HttpServletRequest request,
				@RequestParam("psnId") String psnId,
				@RequestParam("type") String type) {
			Map<String,Object> map=new HashMap<String,Object>();
			map.put("psn_id", psnId);
			map.put("type", type);
			Map<String,String> commonMap=new HashMap<String,String>();
			commonMap.put("type", "QLC_PSN_PSN_LEVEL");
			QlcEfpePsnDto dto = expFoodPOFService.getQlcefpepsnDto(map);
			List<CodeLibraryDTO> psnLevelList = commonServer.getCodeLibrary(commonMap);
			//将expertise_code获得的值存入mapCode
            Map<String, String> mapCode = new HashMap<String, String>();
			List<EfpePsnExptDto> expList = expFoodPOFService.expertise_code();
			for(int i=0;i<expList.size();i++){
				mapCode.put(expList.get(i).getExpertise_code(), expList.get(i).getExpertise_detail());
			}
			String psnGoodat = dto.getPsnGoodat();
			String str = "";
			if(psnGoodat !=null){
				String[] arr = psnGoodat.split(";");
				for (int i = 0; i < arr.length; i++) {
					str += mapCode.get(arr[i])+" ";
				}
			}
			request.setAttribute("zcname", str);
			String psnother_goodat = dto.getPsnOther_goodat();
			String psnother_goodat_str = "";
			if(psnother_goodat !=null){
				String[] arr = psnother_goodat.split(";");
				for (int i = 0; i < arr.length; i++) {
					psnother_goodat_str += mapCode.get(arr[i])+" ";
				}
			}
			request.setAttribute("psnother_goodat_str", psnother_goodat_str);
			/***************************** 页面el表达式传递数据部分 ***********************************/
			request.setAttribute("dto", dto);
			request.setAttribute("psnLevelList", psnLevelList);//评审员级别集合
			request.setAttribute("psnLevelDept_1Code",expFoodPOFService.psnLevelDept_1Code());//一级部门
			request.setAttribute("psnLevelDept_2Code",expFoodPOFService.psnLevelDept_2Code());//二级部门
			request.setAttribute("psnLevelDept_3Code",expFoodPOFService.psnLevelDept_3Code());//三级部门
			
			if(type.equals("1")){
				return "expFoodProd/psyUpdateForm";
			}else{
				return "expFoodProd/psyUpdateForm2";
			}
		}
		
		/**
		 * 根据psnId查询评审人员表的相关信息，并跳转到详情页面
		 * 
		 * @param request
		 * @param qlcefpepsndto
		 *            查询条件form
		 * @return
		 */
		@RequestMapping("/toDetailForm")
		public String toDetailForm(HttpServletRequest request,
				@RequestParam("psnId") String psnId,
				@RequestParam("type") String type) {
			Map<String,Object> map=new HashMap<String,Object>();
			map.put("psn_id", psnId);
			map.put("type", type);
			Map<String,String> commonMap=new HashMap<String,String>();
			commonMap.put("type", "QLC_PSN_PSN_LEVEL");
			QlcEfpePsnDto dto = expFoodPOFService.getQlcefpepsnDto(map);
			//将expertise_code获得的值存入mapCode
            Map<String, String> mapCode = new HashMap<String, String>();
			List<EfpePsnExptDto> expList = expFoodPOFService.expertise_code();
			for(int i=0;i<expList.size();i++){
				mapCode.put(expList.get(i).getExpertise_code(), expList.get(i).getExpertise_detail());
			}
			String psnGoodat = dto.getPsnGoodat();
			String str = "";
			if(psnGoodat !=null){
				String[] arr = psnGoodat.split(";");
				for (int i = 0; i < arr.length; i++) {
					str += mapCode.get(arr[i])+" ";
				}
			}
			request.setAttribute("zcname", str);
			String psnother_goodat = dto.getPsnOther_goodat();
			String psnother_goodat_str = "";
			if(psnother_goodat !=null){
				String[] arr = psnother_goodat.split(";");
				for (int i = 0; i < arr.length; i++) {
					psnother_goodat_str += mapCode.get(arr[i])+" ";
				}
			}
			request.setAttribute("psnother_goodat_str", psnother_goodat_str);
			List<CodeLibraryDTO> psnLevelList = commonServer.getCodeLibrary(commonMap);
			
			/***************************** 页面el表达式传递数据部分 ***********************************/
			request.setAttribute("dto", dto);
			request.setAttribute("psnLevelList", psnLevelList);//评审员级别集合
			request.setAttribute("psnLevelDept_1Code",expFoodPOFService.psnLevelDept_1Code());//一级部门
			request.setAttribute("psnLevelDept_2Code",expFoodPOFService.psnLevelDept_2Code());//二级部门
			request.setAttribute("psnLevelDept_3Code",expFoodPOFService.psnLevelDept_3Code());//三级部门
			
			if(type.equals("1")){
				return "expFoodProd/psyDetailForm";
			}else{
				return "expFoodProd/psyDetailForm2";
			}
		}
		
		/**
		 * 修改评审人员表的相关信息
		 * 
		 * @param request
		 * @param qlcefpepsndto
		 *            查询条件form
		 * @return
		 */
		@RequestMapping("/updateQlcefpepsn")
		public String updateQlcefpepsn(HttpServletRequest request,
				QlcEfpePsnDto qlcefpepsndto,Model model) {
			try {
				// 更新评审人员表信息
				expFoodPOFService.updateQlcefpepsn(qlcefpepsndto);
				model.addAttribute("succMsg", "操作成功!");
			} catch (Exception e) {
				logger_.error("***********/expFoodPOF/updateQlcefpepsn************", e);
				model.addAttribute("errorMsg", "操作失败,"+e.getMessage());
			}
			String type = qlcefpepsndto.getType();
			if(type.equals("1")){
				return "redirect:/expFoodPOF/psyList?";
			}else{
				return "redirect:/expFoodPOF/psyList2?";
			}
		}
		
		/**
		 * 跳转到新增评审人员页面
		 * 
		 * @param request
		 * @param qlcefpepsndto
		 *            查询条件form
		 * @return
		 */
		@RequestMapping("/createPsyForm")
		public String createPsyForm(HttpServletRequest request) {
			return "expFoodProd/createPsyForm";
		}
		
		/**
		 * 跳转到新增评审人员页面(行政处罚)
		 * 
		 * @param request
		 * @param qlcefpepsndto
		 *            查询条件form
		 * @return
		 */
		@RequestMapping("/createPsyForm2")
		public String createPsyForm2(HttpServletRequest request) {
			return "expFoodProd/createPsyForm2";
		}
		
		/**
		 * 新增评审人员相关信息
		 * 
		 * @param request
		 * @return
		 * @throws Exception 
		 */
		@RequestMapping("/createPsy")
		public String createPsy(HttpServletRequest request,Model model) throws Exception {
			try {
				List<Map<String, String>> filePaths = FileUtil.uploadFile(request,false);
				String filePath = "";
	            if(filePaths != null && filePaths.size() > 0){
	            	Map<String, String> map = (Map)filePaths.get(0);
	            	filePath = map.get("filePath");
	            }
				List<QlcEfpePsnDto> list = getAllByExcel(filePath,request);
				// 把返回的excel集合数据插入数据库,并关联users_ciq
				UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
	    				Constants.USER_KEY);
				expFoodPOFService.insertEfpePsn(list,user);
				model.addAttribute("succMsg", "操作成功!");
			}catch (Exception e) {
				logger_.error("***********/expFoodPOF/createPsy************", e);
				model.addAttribute("errorMsg", "操作失败,"+e.getMessage());
			}
			String type = request.getParameter("type");
			if(type.equals("1")){
				return "redirect:/expFoodPOF/psyList";
			}else{
				return "redirect:/expFoodPOF/psyList2";
			}
		}
		
		/**
	     * 查询指定目录中电子表格中所有的数据
	     * @param file 文件完整路径
	     * @return
	     */
	    public static List<QlcEfpePsnDto> getAllByExcel(String filePath,
	    		HttpServletRequest request) throws Exception{
	        List<QlcEfpePsnDto> list=new ArrayList<QlcEfpePsnDto>();
            Workbook rwb=Workbook.getWorkbook(new File(Constants.UP_LOAD_P+filePath));
            Sheet rs=rwb.getSheet(0);
            int clos=25;//得到所有的列
            int rows=rs.getRows();//得到所有的行
            System.out.println(clos+" rows:"+rows);
            
            //第一个是列数，第二个是行数
            for (int i = 1; i < rows; i++) {
                for (int j = 0; j < clos; j++) {
                	String locations = "第"+(i+1)+"行:";
                	QlcEfpePsnDto dto = new QlcEfpePsnDto();
                	String psnName=rs.getCell(j++, i).getContents();
                	String psnCode=rs.getCell(j++, i).getContents();
                	String psnLevel=rs.getCell(j++, i).getContents(); 
                    String psnStatus=rs.getCell(j++, i).getContents();
                	String levelDept_1=rs.getCell(j++, i).getContents();
                	String levelDept_2=rs.getCell(j++, i).getContents();
                	String levelDept_3=rs.getCell(j++, i).getContents();
                	// 空行直接略过
                	if(StringUtils.isEmpty(psnName) && StringUtils.isEmpty(psnCode)
                			&& StringUtils.isEmpty(levelDept_1) && StringUtils.isEmpty(levelDept_2)
                			&& StringUtils.isEmpty(levelDept_3)){
                		break;
                	}
                	// 姓名非空验证
                    if(StringUtils.isEmpty(psnName)){
                    	throw new Exception(locations+"姓名不能为空!");
                    }
                    // 评审员编号非空验证
                    if(StringUtils.isEmpty(psnCode)){
                    	new Exception(locations+"评审员编号不能为空!");
                    }
                    String zc1=rs.getCell(j++, i).getContents();
                    if(zc1.length()>3 && zc1.length()<5 && zc1.indexOf(";") == -1){
                    	throw new Exception(locations+"备案监管格式不正确!");
                    }
                    if(StringUtils.isNotBlank(zc1) && zc1.lastIndexOf(";") == -1){
                    	zc1+=zc1+";";
                    }
                    String zc2=rs.getCell(j++, i).getContents();
                    if(zc2.length()>3 && zc2.length()<5 && zc2.indexOf(";") == -1){
                    	throw new Exception(locations+"行政执法格式不正确!");
                    }
                    if(StringUtils.isNotBlank(zc2) && zc2.lastIndexOf(";") == -1){
                    	zc2+=zc2+";";
                    }
                    String zc3=rs.getCell(j++, i).getContents();
                    if(zc3.length()>3 && zc3.length()<5 && zc3.indexOf(";") == -1){
                    	throw new Exception(locations+"认证监管格式不正确!");
                    }
                    if(StringUtils.isNotBlank(zc3) && zc3.lastIndexOf(";") == -1){
                    	zc3+=zc3+";";
                    }
                    String zc4=rs.getCell(j++, i).getContents();
                    if(zc4.length()>3 && zc4.length()<5 && zc4.indexOf(";") == -1){
                    	throw new Exception(locations+"评审专长格式不正确!");
                    }
                    if(StringUtils.isNotBlank(zc4) && zc4.lastIndexOf(";")==-1){
                    	zc4 = zc4+";";
                    }
                    String psnOther_goodat = rs.getCell(j++, i).getContents();
                    String six = rs.getCell(j++, i).getContents();
                    String psnBirth = rs.getCell(j++, i).getContents();
                    if(StringUtils.isNotBlank(psnBirth) && psnBirth.indexOf("\"")!=-1){
                    	psnBirth = psnBirth.replaceAll("\"", "");
                    }
                    String psnGraduate = rs.getCell(j++, i).getContents();
                    String psnMajor = rs.getCell(j++, i).getContents();
                	String psnEducation= rs.getCell(j++, i).getContents();
                	String engLevel= rs.getCell(j++, i).getContents();
                	String bsTel= rs.getCell(j++, i).getContents();
                	String mobilePhone= rs.getCell(j++, i).getContents();
                	String curPost= rs.getCell(j++, i).getContents();
                	String curWork= rs.getCell(j++, i).getContents();
                	String psnResume= rs.getCell(j++, i).getContents();
                	String psnTrain= rs.getCell(j++, i).getContents();
                	String workExpertise= rs.getCell(j++, i).getContents();
                	String rmk= rs.getCell(j++, i).getContents();
                    dto.setPsnName(psnName);
                    dto.setPsnCode(psnCode);
                    dto.setPsnLevel(psnLevel);
                    dto.setPsn_status(psnStatus);
                    dto.setLevelDept_1(levelDept_1);
                    dto.setLevelDept_2(levelDept_2);
                    dto.setLevelDept_3(levelDept_3);
                    dto.setPsnGoodat(zc1+zc2+zc3+zc4);
                    dto.setPsnOther_goodat(psnOther_goodat);
                    dto.setSix(six);
                    dto.setPsnBirth(psnBirth);
                    dto.setPsnGraduate(psnGraduate);
                    dto.setPsnMajor(psnMajor);
                    dto.setPsnEducation(psnEducation);
                    dto.setBsTel(bsTel);
                    dto.setMobilePhone(mobilePhone);
                    dto.setCurPost(curPost);
                    dto.setCurWork(curWork);
                    dto.setEngLevel(engLevel);
                    dto.setPsnResume(psnResume);
                    dto.setPsnTrain(psnTrain);
                    dto.setWorkExpertise(workExpertise);
                    dto.setRmk(rmk);
                    dto.setType(request.getParameter("type"));
                    list.add(dto);
                }
            }
	        
	        return list;
	        
	    }
	    	    
	    /**
	     * 查询二级部门和三级部门
	     * @param request
	     * @param id
	     * @return
	     */
	    @ResponseBody
	    @RequestMapping("/psnLevelDeptList")
	    public Map<String,Object> psnLevelDeptList(HttpServletRequest request,
	    			@RequestParam(value="code", required=true) String code,
	    			@RequestParam(value="type", required=true) String type){
	    	Map<String,String> map = new HashMap<String,String>();
			Map<String,Object> resultMap = new HashMap<String,Object>();
	    	try{
	    		/***************************** 查询视频和图片集合  ***********************************/
	    		map.put("code", code);
	    		map.put("type", type);
	    		List<CodeLibraryDTO> psnLevelDeptList = expFoodPOFService.psnLevelDeptList(map);
	    		/***************************** 页面el表达式传递数据部分  ***********************************/
	    		resultMap.put("psnLevelDeptList", psnLevelDeptList);
			} catch (Exception e) {				
				logger_.error("***********/expFoodPOF/psnLevelDeptList************",e);
			}
	    	return resultMap;
		}
}
