package cn.com.cgbchina.rest.common.util;

import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Map;

import javax.validation.constraints.NotNull;

import org.apache.commons.lang3.StringUtils;

public class SignUtils {

	/**
	 * 
	 * Description : 合成sign的字符串
	 * 
	 * @param bean
	 * @return
	 */
	public static String getSign(@NotNull Map<String, String> map, String names[]) {
		try {
			if (map == null) {
				throw new RuntimeException("获取sign时，map不可为空");
			}
			// String[] names = { "msgtype", "format", "version", "shopid", "timestamp", "method", "message" };
			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < names.length; i++) {
				sb.append(names[i]);
				String obj = map.get(names[i]);
				if (StringUtils.isNotEmpty(obj)) {
					sb.append(String.valueOf(obj));
				}
			}
			return sb.toString();
		} catch (SecurityException | IllegalArgumentException e) {
			throw new RuntimeException(e);
		}
	}

	/**
	 * 
	 * Description : 合成sign的字符串
	 * 
	 * @param bean
	 * @return
	 */
	public static String getSign(@NotNull Object obj, String names[]) {
		try {
			if (obj == null) {
				throw new RuntimeException("获取sign时，map不可为空");
			}
			// String[] names = { "msgtype", "format", "version", "shopid", "timestamp", "method", "message" };
			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < names.length; i++) {
				sb.append(names[i]);
				PropertyDescriptor pd = new PropertyDescriptor(names[i], obj.getClass());
				Method readMethod = pd.getReadMethod();
				Object value = readMethod.invoke(obj);
				if (value != null) {
					sb.append(String.valueOf(value));
				}
			}
			return sb.toString();
		} catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException
				| IntrospectionException e) {
			throw new RuntimeException(e);
		}
	}

}
