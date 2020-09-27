package cn.rkylin.core.utils;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

public class CookieUtil {
	public static String getCookieValueByName(Cookie[] cookies,String name){
		if(cookies == null || cookies.length == 0)
			return "";
		for(Cookie cookie : cookies){
            if (cookie.getName().equalsIgnoreCase(name))
            	return cookie.getValue();
        }
		return "";  
	}
	
	public static void addCookie(HttpServletResponse response, String name,String content,int time,String path,String domain){
		Cookie cookie = new Cookie(name,content);
		cookie.setMaxAge(time);
		cookie.setDomain(domain);
		//设置路径，这个路径即该工程下都可以访问该cookie 如果不设置路径，那么只有设置该cookie路径及其子路径可以访问
		//cookie.setPath(path);
		response.addCookie(cookie);
	}
}
