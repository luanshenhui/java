package cn.rkylin.apollo.common.util;

import java.net.URLDecoder;
import java.net.URLEncoder;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.StringUtils;

import cn.rkylin.apollo.system.domain.UserInfo;

/**
 * 后台http接口请求 cookie传递中文转码
 * 
 * @author zxy
 *
 */
public class CookiesUtil {
	private static Log log = LogFactory.getLog(CookiesUtil.class);

	/**
	 * 拼装cookie信息，传递接口方
	 * 从request 获取cookie信息（中文已经转码，获取者需要解码）
	 * @param request
	 * @return
	 */
	public static String setCookies(HttpServletRequest request) {
		/*
		 * HttpSession session = request.getSession(); UserInfo user =
		 * (UserInfo) session.getAttribute("_userInfo"); if (null == user) {
		 * return null; }
		 */
		String user_id = null;
		String user_name = null;
		String token_id = null;
		Cookie[] cookie = request.getCookies();
		if (null != cookie) {
			for (int i = 0; i < cookie.length; i++) {
				Cookie dataCookie = cookie[i];
				if ("user_id".equals(dataCookie.getName())) {
					user_id = dataCookie.getValue();
				}
				if ("user_name".equals(dataCookie.getName())) {
					user_name = dataCookie.getValue();
				}
				if("token_id".equals(dataCookie.getName())){
					token_id = dataCookie.getValue();
				}
				
			}
		}

		StringBuffer cookies = new StringBuffer();
		cookies.append("{");
		cookies.append("\"user_id\":\"").append(user_id).append("\",");
		cookies.append("\"user_name\":\"").append(user_name).append("\",");
		cookies.append("\"token_id\":\"").append(token_id).append("\"");
		cookies.append("}");
		return cookies.toString();
	}

	/**
	 * 根据request 获取用户cookie信息
	 * (注：中文已经解码)
	 * 
	 * @param request
	 * @return
	 */
	public static UserInfo getUserCookies(HttpServletRequest request) {
		String user_id = null;
		String user_name = null;
		UserInfo user = new UserInfo();
		Cookie[] cookie = request.getCookies();
		if (null != cookie) {
			for (int i = 0; i < cookie.length; i++) {
				Cookie dataCookie = cookie[i];
				if ("user_id".equals(dataCookie.getName())) {
					user_id = dataCookie.getValue();
				}
				if ("user_name".equals(dataCookie.getName())) {
					user_name = dataCookie.getValue();
				}
			}
			String userName = strDecode(user_name);
			user.setUserid(user_id);
			user.setUserName(userName);
		}
		return user;
	}

	/**
	 * 拼装cookie数据
	 * 
	 * @param userId
	 * @param userName
	 * @return
	 */
	public static String setCookies(String userId, String userName) {
		if (StringUtils.isEmpty(userId) || StringUtils.isEmpty(userName)) {
			return null;
		}
		userName = strEncode(userName);
		StringBuffer cookies = new StringBuffer();
		cookies.append("{");
		cookies.append("\"user_id\":\"").append(userId).append("\",");
		cookies.append("\"user_name\":\"").append(userName).append("\"");
		cookies.append("}");
		return cookies.toString();
	}

	/**
	 * 接口传递中文参数转码
	 * 
	 * @param str
	 * @return
	 */
	private static String strEncode(String str) {
		if (StringUtils.isEmpty(str)) {
			return null;
		}
		String resultStr = null;
		try {
			resultStr = URLEncoder.encode(str, "utf-8");
		} catch (Exception e) {
			log.error("中文Encoder转码异常！", e);
		}
		return resultStr;
	}

	/**
	 * 接口传递中文参数解码
	 * 
	 * @param str
	 * @return
	 */
	private static String strDecode(String str) {
		if (StringUtils.isEmpty(str)) {
			return null;
		}
		String resultStr = null;
		try {
			resultStr = URLDecoder.decode(str, "UTF-8");
		} catch (Exception e) {
			log.error("中文Encoder解码异常！", e);
		}
		return resultStr;
	}

}
