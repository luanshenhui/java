package cn.lsh.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value = "/myweb")
public class MyController {
//	private final Logger logger_ = LoggerFactory.getLogger(this.getClass());
    @RequestMapping("/html")
    public String showOrig(HttpServletRequest request){
    	try{
		} catch (Exception e) {
//			logger_.error("***********myweb/html************",e);
		}
    	return "myweb/html";
	}

}
