package com.dpn.ciqqlc.http;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.service.UserManageDbService;

@Controller
@RequestMapping(value = "/login")
public class LoginController {
	
	private final Logger logger_ = LoggerFactory.getLogger(this.getClass());
	@Autowired
    @Qualifier("userManageDbServ")
    private UserManageDbService dbServ = null;
	/**
	 * 跳转至登录
	 * @param request
	 * @return
	 */
	@RequestMapping("/login")
	public String findOrganizes(HttpServletRequest request){
		return "/loginForm";
	}
	
	/**
	 * 退出登录
	 * @param request
	 * @return
	 */
    @RequestMapping("/logout")
    public String logOut(HttpServletRequest request){
    	try{
    		request.getSession().removeAttribute(Constants.USER_KEY);
    		request.getSession().removeAttribute(Constants.USER_URL);
		} catch (Exception e) {
			logger_.error("***********/login/logout************",e);
		}
    	return "redirect:/login.jsp";
	}
    
    /**
     * 跳转到重置密码
     * @param request
     * @return
     */
    @RequestMapping("/toResetPwd")
	public String toResetPwd(HttpServletRequest request){
		return "userManage/users/resetPwd";
	}
    
    /**
     * 重置密码
     * @param request
     * @return
     */
    @RequestMapping("/resetPwdByUser")
	public String resetPwdByUser(HttpServletRequest request,
			@RequestParam(value="op", required=true)String op,
			@RequestParam(value="np", required=true)String np,
			@RequestParam(value="uid", required=true)String uid){
    	Map<String,String> map = new HashMap<String,String>();
    	UserInfoDTO user =  (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
    	try{
    		int counts = 0;
	    	if(user.getId().equals(uid)){
	    		map.put("op", op);
		    	map.put("np", np);
		    	map.put("uid", uid);
		    	counts = dbServ.resetPwdByUser(map);
	    	}
	    	if(counts>0){
	    		request.setAttribute(Constants.SUCCESS_INFO, "密码修改成功");
	    	}else{
	    		request.setAttribute(Constants.ERROR_INFO, "密码修改失败");
	    	}
    	} catch (Exception e) {
			
			logger_.error("***********/users/resetPwd************",e);
		}finally{
			map = null;
		}
    	return "userManage/users/resetPwd";
	}
	
}
