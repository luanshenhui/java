package com.dpn.ciqqlc.common.component;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.service.UserConfigDb;
import com.dpn.ciqqlc.service.UserManageDb;
import com.dpn.ciqqlc.standard.model.UserConfigurationModel;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.model.UsersDTO;

public class LoginServlet extends HttpServlet {
    
	private static final long serialVersionUID = 1L;
	
    private static Log log = LogFactory.getLog(LoginServlet.class);
    
    private UserManageDb dbServ = null;
    
    private UserConfigDb udbServ = null;
    
    //Initialize global variables
    public void init() throws ServletException {
    }

    //Process the HTTP Get request
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String password = request.getParameter("password");
        String username = (request.getParameter("username"));
        if(StringUtils.isBlank(password) || StringUtils.isBlank(username)) {
        	request.setAttribute("message", "请输入正确的用户名及密码！");
        	getServletContext().getRequestDispatcher("/login.jsp").forward(request, response);
        	return;
        }
        username = username.toLowerCase();
        
        try {
            if(request.getSession(false) != null) {
                request.getSession().invalidate();
            }
            
            UserInfoDTO user = new UserInfoDTO();
            
    		try {
    		    Map<String,String> map = new HashMap<String,String>();
    			map.put("pwd", password);
    			map.put("userid", username);
    			
    			ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());
				dbServ = (UserManageDb)ctx.getBean("userManageDbServ");
    			UsersDTO userInfo = dbServ.userLogin(map);
    			
    			if(userInfo!=null) {
    			    if("A".equals(userInfo.getFlag_op())) {
    			        user.setId(userInfo.getId());
                        user.setName(userInfo.getName());
                        user.setOrg_code(userInfo.getOrg_code());
                        user.setOrg_name(userInfo.getOrg_name());
                        user.setOrg_type(userInfo.getOrg_type());
                        user.setDept_code(userInfo.getDept_code());
                        user.setPort_code(userInfo.getPort_code());
                        user.setFixed_phone(userInfo.getFixed_phone());
                        user.setManage_sign(userInfo.getManage_sign());
                        user.setMobile_phone_no(userInfo.getMobile_phone_no());
                        user.setDirecty_under_org(userInfo.getDirecty_under_org());
                        user.setDuties(userInfo.getDuties());
    			    }
    			    else {
    			        request.setAttribute("message", "该用户已停用！");
    	                getServletContext().getRequestDispatcher("/login.jsp").forward(request, response);
    	                return;
    			    }
    			}
    		}
    		catch(Exception e) {
    			e.printStackTrace();
    			log.debug("***********/Login:************"+e.getMessage());
    		}
    		
            if(user.getId() == null) {
            	request.setAttribute("message", "用户名或密码错误！");
            	getServletContext().getRequestDispatcher("/login.jsp").forward(request, response);
            	return;
            }
            else {
            	
            	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());
            	udbServ = (UserConfigDb)ctx.getBean("userConfigDbServ");
            	UserConfigurationModel um = new UserConfigurationModel();
            	um.setOrderBy("uc.order_by asc");
            	um.setUserId(user.getId());
            	List<UserConfigurationModel> l = udbServ.findUserConfigList(um);
            	
            	request.getSession().removeAttribute(Constants.USER_KEY);
	            request.getSession().setAttribute(Constants.USER_KEY, user);
//	            response.sendRedirect("index.html");
	            
	            if(l == null || l.isEmpty()){
	            	response.sendRedirect(request.getContextPath() + "/index.jsp");
	            }else{
	            	request.getSession().setAttribute("login_visits", l);
	            	response.sendRedirect(request.getContextPath() + "/index_visit.jsp");
	            }
            }
        }
        catch(Exception ex) {
            log.error(ex.getMessage(),ex);
            request.setAttribute("message", "请输入正确的用户名及密码！");
            getServletContext().getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	doPost(request, response);
    }

    //Clean up resources
    public void destroy() {
    }
}