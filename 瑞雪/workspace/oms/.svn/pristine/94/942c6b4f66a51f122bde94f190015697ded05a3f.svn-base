package cn.rkylin.apollo.common.interceptor;

import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import cn.rkylin.apollo.common.util.CookiesUtil;
import cn.rkylin.apollo.system.domain.UserInfo;
import cn.rkylin.apollo.system.service.ISystemUserService;

/**
 * 拦截器类处理整个系统用户的合法性
 * 
 * @author zxy
 *
 */
public class MeasurementInterceptor implements HandlerInterceptor {

    @Autowired
    private ISystemUserService systemUserService;
    @Value("#{api_properties}")
    private Properties apiProperties;

    /**
     * 所有请求处理完成之后被调用 (前端页面展示之后)
     */
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object obj, Exception e) throws Exception {

    }

    /**
     * 在程序请求处理之后被调用(允许返回ModelAndView对象，但是异步请,求返回的貌似无法获取ModelAndView对象)
     */
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object obj, ModelAndView modelAndView) throws Exception {

    }

    /**
     * 在程序请求处理之前被调用 获取登录时候token
     * 发送验证用户接口验证，如果返回异常直接返回登录界面，如果返回非法直接返回登录界面，如果返回过期，获取新的token替换登录时存入的旧token值
     * 通过新的token并且再次验证用户接口是否合法用户，过期就返回登录界面。——双重判断即可，如果过期双重验证不行，继续第三次毫无意义，
     * 所以直接返回登录界面重新登录获取token.
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object obj) throws Exception {
        String cookies = CookiesUtil.setCookies(request);
        boolean forwardAction = true;
        if (StringUtils.isNotEmpty(cookies)) {
            UserInfo userInfo = systemUserService.validityUser(cookies);
            if (null == userInfo) { // 校验接口异常或其他错误
                PrintWriter pw = response.getWriter();
                pw.print("<script>window.parent.location.href='/login.html';</script>");
                forwardAction = false;
            } else {
                if (StringUtils.isNotEmpty(userInfo.getIsValid())) {
                    if ("3".equals(userInfo.getIsValid())) { // 不合法
                        PrintWriter pw = response.getWriter();
                        pw.print("<script>window.parent.location.href='/login.html';</script>");
                        forwardAction = false;
                    } else if ("2".equals(userInfo.getIsValid())) { // token 已过期,替换掉旧的重新验证
                        if (StringUtils.isNotEmpty(userInfo.getTokenId())) {
                            Cookie tokenCookie = new Cookie("token_id", userInfo.getTokenId());
                            String domainName = String.valueOf(apiProperties.get("domainName"));
                            // tokenCookie.setMaxAge(24*60);
                            tokenCookie.setPath("/");
                            tokenCookie.setDomain(domainName);
                            response.addCookie(tokenCookie);
                            // 获取新的token继续验证-双重验证
                            StringBuffer cookiesParam = new StringBuffer();
                            cookiesParam.append("{");
                            cookiesParam.append("\"user_id\":\"").append(userInfo.getUserid()).append("\",");
                            cookiesParam.append("\"user_name\":\"").append(userInfo.getUserName()).append("\",");
                            cookiesParam.append("\"token_id\":\"").append(userInfo.getTokenId()).append("\"");
                            cookiesParam.append("}");
                            UserInfo newUserInfo = systemUserService.validityUser(cookiesParam.toString());
                            if (null == newUserInfo) {
                                PrintWriter pw = response.getWriter();
                                pw.print("<script>window.parent.location.href='/login.html';</script>");
                                forwardAction = false;
                            } else {
                                if (StringUtils.isNotEmpty(newUserInfo.getIsValid())) {
                                    if ("3".equals(newUserInfo.getIsValid())) { // 不合法
                                        PrintWriter pw = response.getWriter();
                                        pw.print("<script>window.parent.location.href='/login.html';</script>");
                                        forwardAction = false;
                                    } else if ("2".equals(newUserInfo.getIsValid())) { // 过期
                                        PrintWriter pw = response.getWriter();
                                        pw.print("<script>window.parent.location.href='/login.html';</script>");
                                        forwardAction = false;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            forwardAction = false;
        }
        return forwardAction;
    }

}
