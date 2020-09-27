package cn.rkylin.apollo.common.interceptor;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

import org.apache.commons.lang.StringUtils;

import com.alibaba.fastjson.JSON;

import cn.rkylin.oms.common.context.CurrentUser;
import cn.rkylin.oms.common.context.WebContextFactory;
import cn.rkylin.oms.system.facade.ResourceBean;

/**
 * 资源访问拦截器，用于判断url路径是否可以访问
 * 
 * @author wangxiaoyi
 *
 */
public class ResourceAccessInterceptor implements Filter {
    // 不需要进行权限控制的html页面
    private String excludedPages;
    private String[] excludedPageArray;

    @Override
    public void destroy() {

    }

    /**
     * 页面权限过滤
     */
    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        Map<String, String> resultMap = new HashMap<String, String>();
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponseWrapper response = new HttpServletResponseWrapper((HttpServletResponse) resp);
        
        boolean isExcludedPage = false;
        for (String page : excludedPageArray) {// 判断是否在过滤url之外
            if (((HttpServletRequest) request).getServletPath().equals(page)) {
                isExcludedPage = true;
                break;
            }
        }
        if (isExcludedPage) {// 在过滤url之外
            chain.doFilter(request, response);
            return;
        }
        CurrentUser currUser = WebContextFactory.getWebContext().getCurrentUser();
        if (currUser == null) {
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                resultMap.put("result", "failed");
                resultMap.put("msg", "未登录，不能访问此资源");
                response.setContentType("text/html; charset=utf-8");
                PrintWriter out = response.getWriter();
                out.write(JSON.toJSONString(resultMap));
                out.flush();
                out.close();
            } else {
                response.sendRedirect(request.getContextPath() + "/login.html");
            }
            chain.doFilter(request, response);
            return;
        } else {
            boolean hasPermission = false;
            for (ResourceBean rb : currUser.getAvailableMenus()) {
                System.out.println("RequestURI:" + request.getRequestURI());
                System.out.println("对比ResourceLocation:" + rb.getResourceLocation());
                if (rb.getResourceLocation() != null && rb.getResourceLocation().equalsIgnoreCase(request.getRequestURI())) {
                    System.out.println("===============>> 匹配了 <<===============");
                    hasPermission = true;
                    break;
                }
            }
            if (hasPermission) {
                chain.doFilter(request, response);
                return;// 正常通过
            } else {
                resultMap.put("result", "failed");
                resultMap.put("msg", "无此资源访问权限");
                response.setContentType("text/html; charset=utf-8");
                PrintWriter out = response.getWriter();
                out.write(JSON.toJSONString(resultMap));
                out.flush();
                out.close();
                chain.doFilter(request, response);
                return;
            }
        }

    }

    /**
     * 初始化过滤器，把web.xml里的过滤器参数组装起来
     */
    @Override
    public void init(FilterConfig fConfig) throws ServletException {
        excludedPages = fConfig.getInitParameter("excludedPages");
        if (StringUtils.isNotEmpty(excludedPages)) {
            excludedPageArray = excludedPages.split(",");
        }
        return;
    }

}
