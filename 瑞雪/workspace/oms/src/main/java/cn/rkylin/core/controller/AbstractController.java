/**
 * Title：AbstractController.java<br>
 * Date：2015-12-25 下午06:28:19<br>
 */
package cn.rkylin.core.controller;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;

import cn.rkylin.core.ApolloMap;


/**
 * Description:<br>
 * 
 * @author shixiaofeng@tootoo.cn
 * @version 1.0
 */
@Controller
public abstract class AbstractController {
	/**
	 * 
	 * @Description: 将前端页面传来的参数放到map中
	 * @param req
	 * @return Map
	 * @throws
	 * @author shixiaofeng@tootoo.cn
	 * @date 2015年12月15日 上午10:59:57
	 */
	@SuppressWarnings("rawtypes")
	protected Map<String, Object> getParamMap(HttpServletRequest request) {
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		Enumeration paramNames = request.getParameterNames();
		while (paramNames.hasMoreElements()) {
			String key = (String) paramNames.nextElement();
			paramMap.put(key, request.getParameter(key));
		}
		return paramMap;
	}
	protected ApolloMap<String, Object> getParams(HttpServletRequest request){
		ApolloMap<String, Object> params = new ApolloMap<String, Object>();
		Enumeration paramNames = request.getParameterNames();
		while (paramNames.hasMoreElements()) {
			String key = (String) paramNames.nextElement();
			params.put(key, request.getParameter(key));
		}
		return params;
	}
}
