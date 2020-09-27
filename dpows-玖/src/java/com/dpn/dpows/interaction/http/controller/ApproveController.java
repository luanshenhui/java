package com.dpn.dpows.interaction.http.controller;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.dpn.dpows.standard.service.WorkService;
import com.dpn.dpows.standard.model.Message;
import com.dpn.dpows.standard.model.WorkDeclareDto;
import com.dpn.dpows.standard.model.WorkDeclareGoods;

@RestController
public class ApproveController {
	
	
	private final static Logger logger = LoggerFactory.getLogger(ApproveController.class);
	
	
	@Resource
	private WorkService workService;
	
	@RequestMapping(value={"/work/approve"},method=RequestMethod.POST,produces={"application/json;charset=utf-8"})
	public Message save(HttpServletResponse response, HttpServletRequest request) throws Exception{
		response.setContentType("application/json;charset=UTF-8");
		response.setHeader("Pragma", "No-cache");
		response.setHeader("Cache-Control", "no-cache");
		response.setDateHeader("Expires", 0L);
		StringBuffer sb = new StringBuffer() ;  
		InputStream is = request.getInputStream();   
	    InputStreamReader isr = new InputStreamReader(is, "utf-8");     
	    BufferedReader br = new BufferedReader(isr);   
	    String s = "" ;   
	    while((s=br.readLine())!=null){   
	         sb.append(s) ;   
	    }   
	    String strData = sb.toString();     
		System.out.println("========================"+strData);
		JSONObject jsStr = JSONObject.parseObject(strData);
		//1.验证主表数据是否存在，不存在则返回提示 
		//2.验证状态是否不为“已通过”，已通过则返回提示
		//3.更新子、主表状态。事物存储。
		//4.事件日志log,无论成功失败都记。
		WorkDeclareDto workDeclareDto = new WorkDeclareDto();
		workDeclareDto.setId(jsStr.get("id").toString());
		workDeclareDto.setManager_user_id(jsStr.get("managerUserId").toString());
		workDeclareDto.setCurrent_user_id(jsStr.get("currentUserId").toString());
		workDeclareDto.setVerify_status(Integer.parseInt(jsStr.get("verifyStatus").toString()));
		workDeclareDto.setVerify_opinion(jsStr.get("verifyOpinion").toString());
		WorkDeclareDto workDeclare = this.workService.getWorkDeclareDto(jsStr.get("id").toString());
		JSONArray jsonArr = (JSONArray) jsStr.get("goods");
		List<WorkDeclareGoods> workDeclarGoodslist = new ArrayList<WorkDeclareGoods>();
		if(jsonArr != null && jsonArr.size()>0){
			workDeclarGoodslist = JSONArray.parseArray(jsonArr.toString(), WorkDeclareGoods.class);
		}
		Message mess = null;
		String msg = "";
		String data = "";
		if(workDeclare == null){
			msg = "主表数据不存在";
			data = strData;
			mess = new Message(false,msg,data);
			logger.info("主表数据不存在");
		} else {
			if(workDeclare.getVerify_status()!= null){
				if(workDeclare.getVerify_status() == 2){
					msg = "主表数据已经审核通过";
					data = strData;
					mess = new Message(false,msg,data);
					logger.info("主表数据已经审核通过");
				} else {
					this.workService.updateWorkDeclareAndDeclareGoods(workDeclareDto,workDeclarGoodslist);
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("success",true);
					map.put("msg","请求成功");
					map.put("data",strData);
					mess = new Message(map);
					logger.info("主表数据未审核通过");
				}
			} else {
				this.workService.updateWorkDeclareAndDeclareGoods(workDeclareDto,workDeclarGoodslist);
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("success",true);
				map.put("msg","请求成功");
				map.put("data",strData);
				mess = new Message(map);
				logger.info("主表数据审核状态为空");
			}
		}
		/*logger.info("sql出错了");
		msg = "sql出错了";
		data = strData;
		mess = new Message(false,msg,data);*/
		return mess;
	}  
}
