package cn.com.cgbchina.rest.common.utils;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.exception.MultipleTradeCodeException;
import org.springframework.beans.factory.InitializingBean;

import java.lang.annotation.Annotation;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * Comment: Created by 11150321050126 on 2016/4/22.
 */
public class ScanTradeCode implements InitializingBean {
	private static Map<String, Object> beans = null;

	public static Object getBean(String tradeCode) {
		return beans.get(tradeCode);
	}

	public synchronized void afterPropertiesSet() throws Exception {
		if (beans == null) {
			synchronized (this) {
				if (beans == null) {
					beans = new HashMap<String, Object>();
					Map<String, Object> map = SpringContextUtils.getApplicationContext()
							.getBeansWithAnnotation(TradeCode.class);
					Set<Map.Entry<String, Object>> set = map.entrySet();
					for (Map.Entry<String, Object> entry : set) {
						Object object = entry.getValue();
						Annotation[] annotations = object.getClass().getAnnotations();
						for (Annotation a : annotations) {
							if (TradeCode.class.isAssignableFrom(a.annotationType())) {
								TradeCode tradeCode = (TradeCode) a;
								String key = tradeCode.value();
								if (beans.containsKey(key)) {
									throw new MultipleTradeCodeException();
								}
								beans.put(key, object);
								break;
							}
						}
					}
				}
			}
		}
	}
}
