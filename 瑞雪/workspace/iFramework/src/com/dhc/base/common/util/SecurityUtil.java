package com.dhc.base.common.util;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

public class SecurityUtil {

	/**
	 * 特殊字符集
	 */
	private static char[] ESCAPED = { '<', '>', '&',
			// '"',
			// '\n',
			// '\r',
			// '\t',
			// '!',
			'#', '$',
			// '%',
			// ':',
			'\'',
			// '(',
			// ')',
			'+',
			// '-',
			// '_',
			// ',',
			// ';',
			// '=',
			// '?',
			// '@',
			'[',
			// '\\',
			']', '^', '`',
			// '{',
			'|',
			// '}'
	};
	private static char[] ESCAPED4JSON = { '<', '>', '&',
			// '"',
			// '\n',
			// '\r',
			// '\t',
			// '!',
			'#', '$', '%',
			// ':',
			// '\'',
			// '(',
			// ')',
			'+',
			// '-',
			// '_',
			// ',',
			// ';',
			// '=',
			'?',
			// '@',
			// '[',
			// '\\',
			// ']',
			'^', '`',
			// '{',
			'|'// ,
				// '}'
	};
	private static List ESCAPED_CODE_POINTS = new ArrayList();
	private static List JSON_ESCAPED_CODE_POINTS = new ArrayList();
	static {
		/*
		 * for (int i = 0; i < ESCAPED.length; i++) {
		 * ESCAPED_CODE_POINTS.add(new Character(ESCAPED[i])); }
		 */
		getESCAPED_CODE_POINTS();
		for (int i = 0; i < ESCAPED4JSON.length; i++) {
			JSON_ESCAPED_CODE_POINTS.add(new Character(ESCAPED4JSON[i]));
		}
	}

	/**
	 * 校验是否含有特殊字符
	 * 
	 * @param text
	 *            要校验的内容
	 * @return 校验结果 true不含 false含有
	 */
	public static boolean validate(String text) {
		return (specialCharValidate(text) && specialKeyWordValidate(text));
	}

	/**
	 * 校验是否含有特殊字符
	 * 
	 * @param text
	 *            要校验的内容
	 * @return 校验结果 true不含 false含有
	 */
	public static boolean jsonValidate(String text) {
		return (specialCharValidate4Json(text) && specialKeyWordValidate(text));
	}

	/**
	 * 校验是否含有特殊字符或特殊关键字
	 * 
	 * @param text
	 *            要校验的内容
	 */
	public static boolean specialCharValidate(String text) {
		boolean result = false;
		int flag = 0;
		if (text == null || text.trim().length() == 0) {
			return true;
		}
		char[] cs = text.toCharArray();

		for (int i = 0, l = cs.length; i < l && flag < 1; i++) {
			Character ch = new Character(cs[i]);
			if (ESCAPED_CODE_POINTS.contains(ch.toString())) {
				flag = flag + 1;
			}
		}
		if (flag == 0)
			result = true;

		return result;
	}

	/**
	 * 校验是否含有特殊字符或特殊关键字
	 * 
	 * @param text
	 *            要校验的内容
	 */
	public static boolean specialCharValidate4Json(String text) {
		boolean result = false;
		int flag = 0;
		if (text == null || text.trim().length() == 0) {
			return true;
		}
		char[] cs = text.toCharArray();
		for (int i = 0, l = cs.length; i < l && flag < 1; i++) {
			Character ch = new Character(cs[i]);
			if (JSON_ESCAPED_CODE_POINTS.contains(ch)) {
				flag = flag + 1;
			}
		}
		if (flag == 0)
			result = true;

		return result;
	}

	/**
	 * 校验是否含有特殊关键字
	 * 
	 * @param text
	 *            要校验的内容
	 */
	public static boolean specialKeyWordValidate(String text) {
		boolean result = false;
		int flag = 0;
		if (text == null || text.trim().length() == 0) {
			return true;
		}
		String[] ars = text.split("\\s");
		// String regex = "^script |^select |^net |^or |^and |^insert |^delete
		// |^from |^count |^drop |^table |^update |^truncate |^mid |^char
		// |^xp_cmdshell |^exec |^master |^netlocalgroup |^administrators ";//
		String regex = getRegexKeyWord();
		Pattern p = Pattern.compile(regex, Pattern.CASE_INSENSITIVE);
		int temp = ars.length;
		for (int i = 0; i < temp && flag < 1; i++) {
			String aa = ars[i] + " ";
			Matcher m = p.matcher(aa);
			if (m.find()) {
				flag = flag + 1;
			}
		}
		if (flag == 0)
			result = true;
		return result;
	}

	/**
	 * 获取request中所有的参数及值，如果发现参数值含有特殊字符，则值为null
	 * 
	 * @param request
	 *            HttpServletRequest
	 */
	public static Map getParameterMap(HttpServletRequest request) throws SecurityException {
		Map oldmap = request.getParameterMap();
		Map newmap = new HashMap();
		Iterator iter = oldmap.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();
			String key = entry.getKey().toString();
			Object obj = entry.getValue();
			String val = "";
			if (obj instanceof String[]) {
				String[] strs = (String[]) obj;
				val = Arrays.toString(strs);
			} else {
				val = obj.toString();
			}
			val = val.substring(1, val.length() - 1);
			if (!validate(val)) {
				val = null;
				throw new SecurityException("Unpermitted character or key word");
			}
			newmap.put(key, val);
		}
		return newmap;
	}

	/**
	 * 按key获取request中参数值，如果发现参数值含有特殊字符，则值为null
	 * 
	 * @param request
	 *            HttpServletRequest
	 * @param key
	 */
	public static String getSecurityParameter(HttpServletRequest request, String key) throws SecurityException {
		String value = request.getParameter(key);
		if (!validate(value)) {
			value = null;
			throw new SecurityException("Unpermitted character or key word");
		}
		return value;
	}

	public static String getSecurityJSONParameter(HttpServletRequest request, String key) throws SecurityException {
		String value = request.getParameter(key);
		if (value != null) {
			if (!specialCharValidate4Json(value)) {
				value = null;
				throw new SecurityException("Unpermitted character or key word");
			}
		} else {
			if (!validate(value)) {
				value = null;
				throw new SecurityException("Unpermitted character or key word");
			}
		}
		return value;
	}

	/**
	 * 校验http请求中是否含有特殊字符
	 * 
	 */
	public static boolean httpRequestSecurityCheck(HttpServletRequest request) throws SecurityException {
		boolean result = true;
		Map oldmap = request.getParameterMap();
		Map newmap = null;
		Iterator iter = oldmap.entrySet().iterator();
		while (iter != null && iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();
			String key = entry.getKey().toString();
			Object obj = entry.getValue();
			String val = "";
			if (obj instanceof String[]) {
				String[] strs = (String[]) obj;
				val = Arrays.toString(strs);
			} else {
				val = obj.toString();
			}
			val = val.substring(1, val.length() - 1);
			if (!validate(val)) {
				iter = null;
				result = false;
				// throw new SecurityException("Unpermitted character or key
				// word");
			}
		}
		return result;
	}

	/**
	 * 校验http请求中是否含有特殊字符
	 * 
	 */
	public static boolean httpRequestSecurityCheck4JSON(HttpServletRequest request) throws SecurityException {
		boolean result = true;
		Map oldmap = request.getParameterMap();
		Map newmap = null;
		Iterator iter = oldmap.entrySet().iterator();
		while (iter != null && iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();
			String key = entry.getKey().toString();
			Object obj = entry.getValue();
			String val = "";
			if (obj instanceof String[]) {
				String[] strs = (String[]) obj;
				val = Arrays.toString(strs);
			} else {
				val = obj.toString();
			}
			val = val.substring(1, val.length() - 1);
			if (!jsonValidate(val)) {
				iter = null;
				result = false;
				throw new SecurityException("Unpermitted character or key word");
			}
		}
		return result;
	}

	/**
	 * 检查跨站点脚本编制和SQL注入，包括“共同的检测项”和“指定的检测项”
	 * 
	 * @param request
	 *            请求对象
	 * @param parameterNamesWantCheck
	 *            要检查的参数名，使用","进行分隔。
	 * @return 含有非法字符返回true，不含有非法字符返回false
	 */
	public static boolean existUnavailableChar(HttpServletRequest request, String parameterNamesWantCheck) {
		boolean returnValue = false;

		// 先检测共同的校验项
		if (!validate(request.getParameter("method")) || !validate(request.getParameter("flag"))
				|| !validate(request.getParameter("forward")) || !validate(request.getParameter("table2_efn"))
				|| !validate(request.getParameter("table2_totalpages"))
				|| !validate(request.getParameter("table2_totalrows")) || !validate(request.getParameter("table2_crd"))
				|| !validate(request.getParameter("table2_p")) || !validate(request.getParameter("table1_efn"))
				|| !validate(request.getParameter("table1_totalpages"))
				|| !validate(request.getParameter("table1_totalrows")) || !validate(request.getParameter("table1_crd"))
				|| !validate(request.getParameter("table1_p"))
				|| !validate(request.getParameter("findAjaxZoneAtClient"))) {
			returnValue = true;
		}
		// 再检测指定的校验项
		if (parameterNamesWantCheck != null && parameterNamesWantCheck.length() > 0) {
			String[] checkList = parameterNamesWantCheck.split(",");
			for (int i = 0; i < checkList.length; i++) {
				if (!validate(request.getParameter(checkList[i])))
					returnValue = true;
			}
		}
		return returnValue;
	}

	private static String getRegexKeyWord() {
		return SystemConfig.getRegexKeyWord();
	}

	private static void getESCAPED_CODE_POINTS() {
		SystemConfig sc = new SystemConfig();
		String keyChars = sc.getKeyChar();
		String[] keyCharArray = keyChars.split("0");
		for (int i = 0; i < keyCharArray.length; i++) {
			ESCAPED_CODE_POINTS.add(keyCharArray[i]);
		}

	}
}
