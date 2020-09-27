package com.dpn.ciqqlc.http;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.service.PhysicalExamService;

@Controller
@RequestMapping(value = "/checkDocs")
public class PhysicalExamController {
	
	@Autowired
	@Qualifier("docsServer")
	private PhysicalExamService physicalExamService;
	
	
	
	/**
	 * 单据数据存储接口
	 * http://localhost:7001/ciqs/checkDocs/docs?procMainId=22
	 * @param CheckDocsRcdModel
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/docs")
	public Map<String, Object> Docs(CheckDocsRcdModel checkDocsRcdModel){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			physicalExamService.insertDocs(checkDocsRcdModel);
			map.put("status", "OK");
			map.put("results", "成功");
			return map;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		map.put("status", "FAIL");
		map.put("results", "无数据");
		return map;
		
	}
}
