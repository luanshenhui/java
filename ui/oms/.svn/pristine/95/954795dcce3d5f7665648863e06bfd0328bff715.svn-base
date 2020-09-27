package cn.rkylin.oms.common.context;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;

import cn.rkylin.oms.common.Global;

/**
 * 缺省上下文实现
 * 
 * @author wangxiaoyi
 * @version 1.0
 * @since 2017年2月15日
 */
public class DefaultWebContext implements IWebContext {
	private HttpServletRequest request;
	private HttpServletResponse response;
	private HttpSession session;

	public HttpServletResponse getResponse() {
		return response;
	}

	public void setResponse(HttpServletResponse response) {
		this.response = response;
	}

	public HttpServletRequest getRequest() {
		return request;
	}

	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}

	public HttpSession getSession() {
		return session;
	}

	public void setSession(HttpSession session) {
		this.session = session;
	}

	public void setSessionAttr(String key, Object value) {
		if (session != null) {
			session.setAttribute(key, value);
		}
	}

	public Object getSessionAttr(String key) {
		if (session != null) {
			return session.getAttribute(key);
		}
		return null;
	}

	public void removeSessionAttr(String key) {
		if (session != null) {
			session.removeAttribute(key);
		}
	}

	public void setRequestAttr(String key, Object value) {
		if (request != null) {
			request.setAttribute(key, value);
		}
	}

	public Object getRequestAttr(String key) {
		if (request != null) {
			request.getAttribute(key);
		}
		return null;
	}

	public void removeRequestAttr(String key) {
		if (request != null) {
			request.removeAttribute(key);
		}
	}

	public void setCurrentUser(CurrentUser user) {
		if (session != null) {
			session.setAttribute(Global.CURRENT_USER, user);
		}
	}

	public CurrentUser getCurrentUser() {
		if (session != null) {
			return (CurrentUser) session.getAttribute(Global.CURRENT_USER);
		}
		return null;
	}

	@Override
	public String getHost() {
		if (request != null) {
			return request.getRemoteHost();
		}
		return null;
	}

	@Override
	public String getRemoteAddr() {
		if (request != null) {
			return request.getRemoteAddr();
		}
		return null;
	}

	@Override
	public Cookie getCookie(String cookieName) {
		if (getCookies() != null) {
			for (Cookie c : getCookies()) {
				if (c.getName().equalsIgnoreCase(cookieName)) {
					return c;
				}
			}
		}
		return null;
	}

	@Override
	public String getCookieValue(String cookieName) {
		Cookie cookie = getCookie(cookieName);
		return cookie == null ? "" : cookie.getValue();
	}

	@Override
	public Cookie[] getCookies() {
		return request.getCookies();
	}

	@Override
	public void setCookie(Cookie c) {
		response.addCookie(c);
	}

	@Override
	public void expireCookie(String cookieName) {
		Cookie cookie = getCookie(cookieName);
		if (cookie != null) {
			cookie.setMaxAge(-1);
			response.addCookie(cookie);
		}
	}

	public boolean checkValidateCode(String input, boolean remove) {
		String validateCode = (String) session.getAttribute(Global.VALIDATE_CODE);
		boolean result = StringUtils.equals(validateCode, input);
		if (remove || result) {
			session.removeAttribute(Global.VALIDATE_CODE);
		}
		return result;
	}

}
