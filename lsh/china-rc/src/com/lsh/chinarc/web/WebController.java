package com.lsh.chinarc.web;

import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lsh.chinarc.domain.RcDomain;
import com.lsh.chinarc.domain.User;
import com.lsh.chinarc.service.Service;

@Controller
@RequestMapping(value = "/web")
public class WebController {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private Service service;
	
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
	
	@RequestMapping("/list")
    public String list(HttpServletRequest request,RcDomain domain){
		try {
			int pages = 1;
			if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
			        pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
			}
			domain.setBeginPage(((pages-1)*10));
			domain.setEndPage(10);
			List<RcDomain> list=service.selectListPage(domain);
			int counts=service.selectCount(domain);
			request.setAttribute("domain", domain);
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
			request.setAttribute("itemInPage", 10);// 每页显示的记录数
			request.setAttribute("counts",counts);
		} catch (NumberFormatException e) {
			e.printStackTrace();
			logger.debug(e.getMessage());
		}
    	return "list";
	}
	
	@RequestMapping("/myAddList")
    public String myAddList(HttpServletRequest request,User user){
		try {
			int pages = 1;
			if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
			        pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
			}
			user.setBeginPage(((pages-1)*10));
			user.setEndPage(10);
			List<User> list=service.selectUserListPage(user);
			int counts=service.selectUserCount(user);
			request.setAttribute("domain", user);
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
			request.setAttribute("itemInPage", 10);// 每页显示的记录数
			request.setAttribute("counts",counts);
		} catch (NumberFormatException e) {
			e.printStackTrace();
			logger.debug(e.getMessage());
		}
    	return "myAddList";
	}
	
	
//	@PlatPermission(validate=true)
//	@RequestMapping(params="action=reg") 
    @RequestMapping("/add" )
    public String add(HttpServletRequest request){
		System.out.println("111111111111");
    	return "add";
    }
	
    @RequestMapping("/addTab" )
    public String addTab(HttpServletRequest request){
		System.out.println("111111111111");
    	return "addTab";
    }
	
	@RequestMapping("/info")
    public String info(HttpServletRequest request,@RequestParam(value="tel", required=true)String tel){
		try {
			RcDomain domain=new RcDomain();
			domain.setTel(tel);
			List<RcDomain> list=service.selectList(domain);
			request.setAttribute("list", list);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
		}
    	return "info";
	}
	
	@ResponseBody
	@RequestMapping("/update")
    public String update(HttpServletRequest request,@RequestParam(value="tel", required=true)String tel){
		try {
			RcDomain domain=new RcDomain();
			domain.setTel(tel);
			domain.setDel("0");
			service.updateDomain(domain);
			return "success";
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
		}
		return "error";
	}
	
	@ResponseBody
	@RequestMapping(value = "/addOne", method = RequestMethod.POST)
    public String addOne(HttpServletRequest request,@RequestParam(value="tel", required=true)String tel,RcDomain domain){
		try {
			domain.setEmil("auto");
			service.insertDomain(domain);
			System.out.println(domain);
			return "success";
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
		}
		return "error";
	}
	
	@ResponseBody
	@RequestMapping(value = "/addUserOne", method = RequestMethod.POST)
    public String addUserOne(HttpServletRequest request,@RequestParam(value="tel", required=true)String tel,User user){
		try {
			service.insertUser(user);
			return "success";
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
		}
		return "error";
	}
	
	@RequestMapping("/updateUser")
    public String updateUser(HttpServletRequest request,HttpServletResponse response,User user){
		response.setContentType("text/html;charset=gb2312");
		PrintWriter out = null;
		try {
			out=response.getWriter();
			service.updateUser(user);
			out.println("<script>");
			out.print("alert('修改成功!');location.href=document.referrer;");
			out.println("</script>");
			out.flush();
			out.close();
		} catch (Exception e) {
			out.println("<script>");
			out.print("alert('修改失败!');location.href=document.referrer;");
			out.println("</script>");
			out.flush();
			out.close();
			logger.debug(e.getMessage());
			e.printStackTrace();
		}
    	return "redirect:/web/myAddList";
	}
	
	@RequestMapping("/updateList")
    public String updateList(HttpServletRequest request,HttpServletResponse response,@RequestParam(value="tel", required=true)String tel){
		response.setContentType("text/html;charset=gb2312");
		PrintWriter out = null;
		try {
			out=response.getWriter();
			RcDomain domain=new RcDomain();
			domain.setTel(tel);
			domain.setDel("0");
			service.updateDomain(domain);
			out.println("<script>");
			out.print("alert('修改成功!');location.href=document.referrer;");
			out.println("</script>");
			out.flush();
			out.close();
		} catch (Exception e) {
			out.println("<script>");
			out.print("alert('修改失败!');location.href=document.referrer;");
			out.println("</script>");
			out.flush();
			out.close();
			logger.debug(e.getMessage());
			e.printStackTrace();
		}
    	return "redirect:/web/list";
	}
}
