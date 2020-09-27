package com.dpn.ciqqlc.http;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.FileUtil;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.model.ChkRckModel;
import com.dpn.ciqqlc.standard.model.CountryDTO;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.model.VideoEventModel;
import com.dpn.ciqqlc.standard.service.CommonService;

@Controller
@RequestMapping(value = "/common")
public class CommonController {
	
	@Autowired
	private CommonService commonServer = null; 
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
	
	@RequestMapping(value = "/toWelWithTarget")
	public String toWelWithTarget(HttpServletRequest request, @RequestParam(value="targetUrl", required=false)String targetUrl){
		request.setAttribute("targetUrl", targetUrl);
		return "/wel";
	}
	
	/**
	 * 结果保存
	 * http://localhost:7001/ciqs/common/confirm?id=1&procMainId=22&projCode=678&resultState=1&resultRmk=备注&oprUser=操作人&oprDate=1989-09-08
	 * @param chkRckModel
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/confirm",method=RequestMethod.GET)
	public Map<String, Object> confirm(ChkRckModel chkRckModel) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			commonServer.insertConfirm(chkRckModel);
			map.put("status", "OK");
			map.put("results", "无数据");
			return map;
		} catch (Exception e) {
			e.printStackTrace();
		}
		map.put("status", "FAIL");
		map.put("results", "无数据");
		return map;
	}
	
	
	/**
	 * 离线批量上传图片
	 * @param VideoEventModel 图片对象
	 * @return "OK"成功，"FALL"失败
	 */
	@ResponseBody
	@RequestMapping( value = "/upphotos")
	public Map<String,Object> upLoadPhotos(@RequestBody List<VideoEventModel> VideoEventModel,HttpServletRequest request){	
		Map<String,Object> ajaxResult = new HashMap<String, Object>();
		try {
			//时间转换获取目录文件夹名字
			long l  = System.currentTimeMillis();
			String s =new SimpleDateFormat("yyyyMM/yyyyMMdd").format(new Date(l));
			VideoEventModel eventBean = new VideoEventModel();		
			int i =0 ;
			if(VideoEventModel!=null){
				for(VideoEventModel eventModel : VideoEventModel){
					String namePath = s+"/"+eventModel.getFileName();
					eventBean.setFileName(namePath);
					eventBean.setFileType(eventModel.getFileType());
					eventBean.setPortDeptCode(eventModel.getPortDeptCode());
					eventBean.setPortOrgCode(eventModel.getPortOrgCode());
					eventBean.setProcMainId(eventModel.getProcMainId());
					eventBean.setProcType(eventModel.getProcType());
					eventBean.setCreateUser(eventModel.getCreateUser());
					i =commonServer.save(eventBean);
				}
			}								
			if(i!=0){
				ajaxResult.put("status", "OK");
				ajaxResult.put("results","成功");
			}else{
				ajaxResult.put("status", "FALL");
				ajaxResult.put("results","失败");
			}		
		} catch (Exception e) {
			e.printStackTrace();
		}					
		return ajaxResult;
	}
	
	/**
	 * 单据数据存储接口多传
	 * http://localhost:7001/ciqs/common/moreDocs?procMainId=22
	 * @param CheckDocsRcdModel
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/moreDocs" ,method = RequestMethod.POST)
	public Map<String, Object> moreDocs(@RequestBody List<CheckDocsRcdModel> checkDocsRcdModel){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			for (int i = 0; i < checkDocsRcdModel.size(); i++) {
				commonServer.insertDocs(checkDocsRcdModel.get(i));
			}
			map.put("status", "OK");
			map.put("results", "成功");
			return map;
		} catch (Exception e) {
			e.printStackTrace();
			map.put("status", "FAIL");
			map.put("results", "无数据");
		}
		return map;
		
	}
	
	/**
	 * 单据数据存储接口单传
	 * http://localhost:7001/ciqs/common/docs?procMainId=22
	 * @param CheckDocsRcdModel
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/docs" ,method = RequestMethod.POST)
	public Map<String, Object> docs(@RequestBody CheckDocsRcdModel checkDocsRcdModel){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			commonServer.insertDocs(checkDocsRcdModel);
			map.put("status", "OK");
			map.put("results", "成功");
			return map;
		} catch (Exception e) {
			e.printStackTrace();
			map.put("status", "FAIL");
			map.put("results", "无数据");
		}
		return map;
	}
	
	/**
	 * 单个图片信息上传
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/insertVideoEventModel",method=RequestMethod.POST)
	public String insertVideoEventModel(HttpServletRequest request,HttpServletResponse response,VideoEventModel videoEvent,@RequestParam(value="file", required=true)MultipartFile file){
		try {
			List<Map<String, String>> filePathList= FileUtil.uploadFile(request,true);
			for(Map<String, String> map:filePathList){
				videoEvent.setFileName(map.get("filePath"));
//				videoEvent.setFileName(map.get("filePath").substring(map.get("filePath").indexOf('/')+1,map.get("filePath").length()));
				commonServer.save(videoEvent);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
		
	}
	
	/**
	 * http://10.10.39.235:7001/ciqs/common/contoryList
	 * 国家列表接口
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/contoryList", method = RequestMethod.GET)
	public Map<String, Object> contoryList(HttpServletRequest request,HttpServletResponse response) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			List<CountryDTO> countryList = commonServer.getCountryList(new CountryDTO());
			map.put("status", "OK");
			map.put("results", countryList);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("status", "FAIL");
			map.put("results", "无数据");
		}
		return map;

	}
	
	/**
     * 跳转页面dpn.jsp
     */
    @RequestMapping("/dpnPage")
    public String logOut(HttpServletRequest request){
    	try{
    		UserInfoDTO user=(UserInfoDTO)request.getSession().getAttribute(Constants.USER_KEY);
    		if(null==user){
    			return "redirect:"+"/loginForm.jsp";
    		}
		} catch (Exception e) {
			return "redirect:"+"/loginForm.jsp";
		}
    	return "dpn";
	}
	
}
