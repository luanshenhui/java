package com.dpn.ciqqlc.http;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.http.form.ExpFoodProdForm;
import com.dpn.ciqqlc.standard.model.ExpFoodProdDTO;
import com.dpn.ciqqlc.standard.service.ExpFoodProdService;

/**
 * 行政检查 - 辽阳局出口商品及企业监督全过程执法记录
 * @author xwj
 *
 */
@Controller
@RequestMapping(value = "/app/expFoodProd")
public class AppExpFoodProdController {
	
    private final Logger logger_ = LoggerFactory.getLogger(this.getClass());
    
    @Autowired
    @Qualifier("expFoodProdDb")
    private ExpFoodProdService dbServ = null;
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
	 * 列表
	 */
	@RequestMapping("/list")
	@ResponseBody
	public String list(HttpServletRequest request, ExpFoodProdForm form){
		String jsonStr = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try{
			int pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
			form.setFirstRcd(String.valueOf((pages-1)*Constants.PAGE_NUM+1));
			form.setLastRcd(String.valueOf(pages*Constants.PAGE_NUM+1));
			resultMap.put("results", dbServ.findList(form));
			resultMap.put("status", "OK");
			resultMap.put("orgname", form.getOrgname());
			resultMap.put("startdate_begin", form.getStartdate_begin());
			resultMap.put("startdate_end", form.getStartdate_end());
			resultMap.put("plantype", form.getPlantype());
			resultMap.put("subname", form.getSubname());
        } catch (Exception e) {
        	resultMap.put("status", "ERROR");
			logger_.error("***********/expFoodProd/list************",e);
		} finally {
			ObjectMapper mapper = new ObjectMapper();
			try {
				jsonStr = mapper.writeValueAsString(resultMap);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return  jsonStr;
	}
	
	@RequestMapping("/detail")
	@ResponseBody
	public String detail(HttpServletRequest request, @RequestParam(value="id", required=true)String id){
		String jsonStr = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			resultMap.put("results", dbServ.findById(id));
			resultMap.put("status", "OK");
		} catch (Exception e) {
			resultMap.put("status", "ERROR");
			logger_.error("***********/expFoodProd/toDetail************",e);
		} finally {
			ObjectMapper mapper = new ObjectMapper();
			try {
				jsonStr = mapper.writeValueAsString(resultMap);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return jsonStr;
	}
	
	@RequestMapping("/add")
	@ResponseBody
	public String add(HttpServletRequest request, ExpFoodProdDTO dto){
		String jsonStr = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			resultMap.put("results", dbServ.add(dto));
			resultMap.put("status", "OK");
		} catch (Exception e) {
			resultMap.put("status", "ERROR");
			logger_.error("***********/expFoodProd/toDetail************",e);
		} finally {
			ObjectMapper mapper = new ObjectMapper();
			try {
				jsonStr = mapper.writeValueAsString(resultMap);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return jsonStr;
	}
	
}
