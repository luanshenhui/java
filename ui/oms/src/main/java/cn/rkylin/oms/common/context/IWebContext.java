package cn.rkylin.oms.common.context;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 上下文接口
 * @author wangxiaoyi
 * @version 1.0
 * @since 2017年2月15日
 */
public interface IWebContext {
    public HttpServletRequest getRequest();
    public HttpServletResponse getResponse();
    
    public void setSessionAttr(String key,Object value);
    public Object getSessionAttr(String key);
    public void removeSessionAttr(String key);

    public void setRequestAttr(String key,Object value);
    public Object getRequestAttr(String key);
    public void removeRequestAttr(String key);

    public void setCurrentUser(CurrentUser user);
    public CurrentUser getCurrentUser();

    public String getHost();
    public String getRemoteAddr();

    // Cookie操作
    public Cookie getCookie(String cookieName);
    public String getCookieValue(String cookieName);
    public Cookie[] getCookies();
    public void setCookie(Cookie c);
    public void expireCookie(String cookieName);

    /**
     * 检验验证码的正确
     * @param input 输入值
     * @param remove true:无论匹配验证码正确还是错误都进行清除 false:只在匹配成功后才清除
     * @return
     */
    public boolean checkValidateCode(String input,boolean remove);

}
