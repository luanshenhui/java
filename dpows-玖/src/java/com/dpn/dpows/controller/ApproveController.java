package com.dpn.dpows.controller;



import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.dpn.dpows.standard.service.CommonService;
import com.dpn.dpows.standard.service.WorkService;
import com.dpn.dpows.standard.entity.Message;
import com.dpn.dpows.standard.model.WorkDeclareDto;
import com.dpn.dpows.standard.model.WorkDeclareGoodsDto;




@RestController
public class ApproveController {
	
	
	private final static Logger logger = LoggerFactory.getLogger(ApproveController.class);
	
	
	@Resource
	private WorkService workService = null;
	
	@Resource
	private CommonService commonService = null;
	
	
	
	@RequestMapping(value={"/work/approve"},method=RequestMethod.POST,produces={"application/json;charset=utf-8"})
	public Message approve(HttpServletResponse response, HttpServletRequest request) throws Exception{
		response.setContentType("application/json;charset=UTF-8");
		response.setHeader("Pragma", "No-cache");
		response.setHeader("Cache-Control", "no-cache");
		response.setDateHeader("Expires", 0L);
		
		Message mess = null;JSONObject jsonObj = null;WorkDeclareDto dto = null;
		String param = null;
		try{
			StringBuffer sb = new StringBuffer();
			InputStream is = request.getInputStream();
		    InputStreamReader isr = new InputStreamReader(is, "utf-8");
		    BufferedReader br = new BufferedReader(isr);
		    String s = "" ;
		    while((s=br.readLine())!=null){
		    	sb.append(s) ;
		    }
		    
		    param = sb.toString();
		    logger.debug("--- request param : ---   " + param);
		}catch(Exception e){
			logger.error("param is null");
			mess = new Message(false,"参数错误或参数为空！","");
			return mess;
		}
	    
		
		try{
			jsonObj = JSONObject.parseObject(param);
			
			if(StringUtils.isBlank(jsonObj.getString("id"))){
				logger.error("declare table id is null！");
				mess = new Message(false,"申报表ID不能为空！","");
				return mess;
			}
		}catch(Exception e){
			logger.error("request param str -> jsonObj turn faile! format bad!");
			this.commonService.saveEventLog("error", null, param);
			mess = new Message(false,"参数格式错误！","");
			return mess;
		}
	    
		
		try{
			dto = JSON.parseObject(jsonObj.toJSONString(),WorkDeclareDto.class);
			//JSONArray jsonArr = (JSONArray) jsonObj.get("goods");
			List<WorkDeclareGoodsDto> goods = JSONArray.parseArray(jsonObj.get("goods").toString(),WorkDeclareGoodsDto.class);
			if(dto.getGoods() == null || dto.getGoods().size() == 0){
				logger.error("param format illegal ,goodlist  require!");
				mess = new Message(false,"参数格式非法,货物列表不能为空！","");
				return mess;
			}
			
			dto.setGoods(goods);
		}catch(Exception e){
			logger.error("");
			mess = new Message(false,"参数格式非法！","");
			this.commonService.saveEventLog("error", dto.getId(), param);
			return mess;
		}
		
		
		//1.验证主表数据是否存在，不存在则返回提示 
		Integer num = this.workService.getSizeWorkDeclareDto(dto.getId());
		if(num == 0){
			logger.error("param format illegal ,goodlist  require!");
			mess = new Message(false,"数据不存在，id=" + dto.getId(),"");
			return mess;
		}
		
		
		//2.验证各数据项是否为空
		if(StringUtils.isBlank(dto.getManagerUserId()) || StringUtils.isBlank(dto.getCurrentUserId())){
			logger.error("managerUserId require or currentUserId require！");
			mess = new Message(false,"初始审批人用户ID 或 当前审批人用户ID不能同时为空！","");
			return mess;
		}
		
		if(StringUtils.isBlank(dto.getVerify_status())){
			logger.error("approve status require");
			mess = new Message(false,"审批状态不能为空！","");
			return mess;
		}
		
		for(WorkDeclareGoodsDto wdgDto : dto.getGoods()){
			if(StringUtils.isBlank(wdgDto.getId())){
				mess = new Message(false,"货物申报表ID不能为空！","");
				break;
			}
			if(StringUtils.isBlank(wdgDto.getStatus())){
				mess = new Message(false,"货物申报表审批状态不能为空！","");
				break;
			}
			if(StringUtils.isBlank(wdgDto.getVerify_user_id())){
				mess = new Message(false,"货物申报表审批人用户ID不能为空！","");
				break;
			}
		}
	
		if(mess != null){
			logger.error(mess.getMsg());
			this.commonService.saveEventLog("error", dto.getId(), param);
			return mess;
		}
		
		//3.更新子、主表状态。事务存储。
		this.workService.updateWorkDeclareAndDeclareGoods(dto);
		this.commonService.saveEventLog("info",dto.getId(), param);
		mess = new Message(true,"请求成功","");
		logger.debug("approve oper success ! param : " + param);
		
		return mess;
	}  
}
