package cn.com.cgbchina.restful.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Comment: Created by 11150321050126 on 2016/4/24.
 */
@Controller
@RequestMapping("/api/rest/")
public class ExternalController {

	@RequestMapping("test")
	@ResponseBody
	public String test() {
		return "123";
	}

}
