package com.dpn.ciqqlc.common.component;

import java.io.IOException;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.service.UserManageDb;
import com.dpn.ciqqlc.standard.model.ResourcesDTO;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;

public class AuthenticationFilter
        implements Filter {
    
    private FilterConfig filterConfig;
    
    private UserManageDb dbServ = null;
    
    private static Log log = LogFactory.getLog(AuthenticationFilter.class);
    
    public Object getBean(final String name) {
        ServletContext context = this.filterConfig.getServletContext();
        ApplicationContext ctx = WebApplicationContextUtils
                .getRequiredWebApplicationContext(context);
        return ctx.getBean(name);
    }
    
    //全局拦截器
    public void doFilter(final ServletRequest request,
            final ServletResponse response, final FilterChain filterChain)
            throws IOException, ServletException {
        try {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            HttpServletResponse httpResponse = (HttpServletResponse) response;
            HttpSession session = httpRequest.getSession();
            
            if (this.checkUserSession(httpRequest)) {
                log.debug("login begin...");
                if (this.filterConfig.getServletContext()
                        .getAttribute("ALLURL") == null) {
                    ApplicationContext ctx = WebApplicationContextUtils
                            .getRequiredWebApplicationContext(
                                    session.getServletContext());
                    this.dbServ = (UserManageDb) ctx
                            .getBean("userManageDbServ");
                    List<ResourcesDTO> resourceList = this.dbServ
                            .getUserUrl(null);//所有可访问资源
                    String[] urls = new String[resourceList.size()];
                    for (int i = 0; i < resourceList.size(); i++) {
                        urls[i] = resourceList.get(i).getRes_string();
                    }
                    this.filterConfig.getServletContext().setAttribute("ALLURL",
                            urls);
                }
                
                if ("false".equals(this.getUserUrlCount(session))) {//用户可访问资源未设置
                    this.setUserUrl(session);
                }
                String requestQueryStr = httpRequest.getQueryString();
                if(StringUtils.isNotBlank(httpRequest.getQueryString())){
                	requestQueryStr = "?"+requestQueryStr;
                }else{
                	requestQueryStr = "";
                }
                boolean flag = this.authorizeURL(
                        httpRequest.getRequestURI().replace("/ciqs", "")+requestQueryStr,
                        (String[]) session.getAttribute(Constants.USER_URL),
                        (String[]) this.filterConfig.getServletContext()
                                .getAttribute("ALLURL"));
                if (flag == true) {
                    filterChain.doFilter(request, response);
                } else {
                    httpResponse.sendRedirect(
                            httpRequest.getContextPath() + "/403.jsp");
                }
                
            } else {
                if (this.isValidLogin(httpRequest)) {
                    filterChain.doFilter(request, response);
                } else {
                    httpResponse.sendRedirect(
                            httpRequest.getContextPath() + "/login.jsp");
                    //					filterChain.doFilter(request, response);
                }
            }
        } catch (Exception e) {
            log.error("user authenticate failed...", e);
        }
    }
    
    private boolean checkUserSession(final HttpServletRequest httpRequest) {
        HttpSession session = httpRequest.getSession();
        Object userObj = session.getAttribute(Constants.USER_KEY);
        if (userObj == null) {
            UserInfoDTO user = new UserInfoDTO();
            user.setName(Constants.GUEST_NAME);
            session.setAttribute(Constants.USER_KEY, user);
            return false;
        } else {
            if (session.getAttribute("USER_URL") == null) {
                String[] userURLs = this.getUserURLs(
                        (UserInfoDTO) session.getAttribute(Constants.USER_KEY),
                        session);
                session.setAttribute("USER_URL", userURLs);
            }
            if (((UserInfoDTO) userObj).getId() == null) {
                return false;
            }
            return true;
        }
    }
    
    private boolean isValidLogin(final HttpServletRequest httpRequest) {
        if (((httpRequest.getRequestURI() != null) && (httpRequest
                .getRequestURI().endsWith("login.jsp")
                || httpRequest.getRequestURI().endsWith("orderRequired.jsp")
                || httpRequest.getRequestURI().endsWith("/loginServlet")
                || httpRequest.getRequestURI().endsWith("/getRandom")
                || (httpRequest.getRequestURI().indexOf("/app/") != -1)))
                || httpRequest.getRequestURI().contains("/static/images/")
                || httpRequest.getRequestURI().contains("/ShowVideoServlet")
                || httpRequest.getRequestURI().contains("/Videoservlet")
                || httpRequest.getRequestURI().contains("/UploadAppServlet")
                || httpRequest.getRequestURI().contains("/apps/")
                || (httpRequest.getRequestURI().indexOf("/static/") != -1)
                || httpRequest.getRequestURI().endsWith("/login")
                || (httpRequest.getRequestURI().indexOf("/apkFile/") != -1)
                || (httpRequest.getRequestURI().indexOf("/service/") != -1)
                || httpRequest.getRequestURI().contains("/cuplayer/Images/")) {
            return true;
        } else {
            return false;
        }
    }
    
    //判断用户是否有可访问的资源
    private String getUserUrlCount(final HttpSession session) {
        if (session.getAttribute(Constants.USER_URL) == null) {
            return "false";
        } else {
            if (((String[]) session
                    .getAttribute(Constants.USER_URL)).length > 0) {
                return "true";
            } else {
                return "false";
            }
        }
    }
    
    //设置用户可访问的权限
    private void setUserUrl(final HttpSession session) {
        String[] str = this.getUserURLs(
                (UserInfoDTO) session.getAttribute(Constants.USER_KEY),
                session);
        session.setAttribute(Constants.USER_URL, str);
    }
    
    //获取用户可访问的权限
    protected String[] getUserURLs(final UserInfoDTO users,
            final HttpSession session) {
        try {
            ApplicationContext ctx = WebApplicationContextUtils
                    .getRequiredWebApplicationContext(
                            session.getServletContext());
            this.dbServ = (UserManageDb) ctx.getBean("userManageDbServ");
            List<ResourcesDTO> resourceList = this.dbServ
                    .getUserUrl(users.getId());
            String[] urls = new String[resourceList.size()];
            for (int i = 0; i < resourceList.size(); i++) {
                urls[i] = resourceList.get(i).getRes_string();
            }
            return urls;
        } catch (Exception e) {
            e.printStackTrace();
            log.error(
                    "************AuthenticationFilter.getUserURLs()*************",
                    e);
            return null;
        }
    }
    
    //可访问资源判断
    private boolean authorizeURL(String url, final String[] authorizedURLs,
            final String[] allURLs) {
        boolean inAllURLs = false;
        url = url.toLowerCase();
        String pattern = null;
        for (int i = 0; i < allURLs.length; i++) {
            String temp = allURLs[i].toLowerCase();
            if ((temp != null) && !temp.trim().equals("")
                    && !temp.startsWith("*")) {
                int index = temp.indexOf("*");
                if (index > 0) {
                    temp = temp.substring(0, index);
                    if (url.startsWith(temp)) {
                        inAllURLs = true;
                        pattern = allURLs[i].toLowerCase();
                        break;
                    }
                } else {
                    if (url.equalsIgnoreCase(temp)) {
                        inAllURLs = true;
                        pattern = allURLs[i].toLowerCase();
                        break;
                    }
                }
            }
        }
        
        if (inAllURLs == false) {
            return true;
        }
        
        for (int i = 0; i < authorizedURLs.length; i++) {
            String temp = authorizedURLs[i].toLowerCase();
            if ((temp != null) && temp.equals(pattern)) {
                return true;
            }
        }
        return false;
    }
    
    public void init(final FilterConfig filterConfig) throws ServletException {
        this.filterConfig = filterConfig;
    }
    
    public void destroy() {
    }
}
