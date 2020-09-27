package com.dpn.dpows.controller.log;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.dpn.dpows.Constants;
import com.dpn.dpows.standard.model.EventLogDto;
import com.dpn.dpows.standard.service.CommonService;

/**
 * logController
 * 
 * */
@Controller
@RequestMapping("/log/search")
public class EventLogController {
	
	 private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	private final static String PAGE_LIST = "log/list";
	
	private final static String PAGE_INDEX = "log/index";
	
	
	@Resource
    private CommonService commonService ;
	
	@RequestMapping(value = "/index")
	public String index(HttpServletRequest request) {
		return PAGE_INDEX;
	}
	
	
	@RequestMapping(value = "/sub")
	public void sub(HttpServletRequest request,HttpServletResponse response) throws IOException {
		String logUser = request.getParameter("logUser");
		HttpSession session = request.getSession();
    	if(logUser != null && !logUser.equals("")){
    		session.setAttribute(Constants.LOG_USR, logUser);
    		response.sendRedirect(request.getContextPath() + "/log/search/list"); 
    	}
	}
	
	@RequestMapping(value = "/list")
	public String list(HttpServletRequest request) {
		Map<String,String> map = this.packageMap(request);
        List<EventLogDto> list = null;
        Integer size = null;
        try{
        	map.put("action_user", request.getParameter("actionUser"));
    		map.put("action_org_code", request.getParameter("actionOrgCode"));
    		map.put("index_value", request.getParameter("indexValue"));
    		map.put("action_type", request.getParameter("actionType"));
    		map.put("action_name", request.getParameter("actionName"));
        	list = this.commonService.getListEventLogDto(map);
            size = this.commonService.getSizeEventLogDto(map);
        }catch(Exception ex){
        	log.error("查询出错"+ex.getMessage());
        	ex.printStackTrace();
        	
        }
        request.setAttribute("list",list);
        request.setAttribute("size",size);
        request.setAttribute("page", map.get("currentPages"));
        request.setAttribute("itemInPage", map.get("itemInPage"));
		return PAGE_LIST;
	}
	
	 private Map<String,String> packageMap(HttpServletRequest request) {
	        Map<String,String> map = new HashMap<String,String>();
	        int pages = Integer.parseInt(StringUtils.isBlank(request.getParameter("page")) ? "1" : request.getParameter("page"));
	        map.put("high", String.valueOf((Constants.PAGE_NUM.intValue() * pages) + 1) );
	        map.put("low", String.valueOf(Constants.PAGE_NUM.intValue() * (pages - 1) +1));
	        map.put("currentPages", String.valueOf(pages));
	        map.put("itemInPage", String.valueOf(Constants.PAGE_NUM));
	        return map;
	 }  
	  
}
