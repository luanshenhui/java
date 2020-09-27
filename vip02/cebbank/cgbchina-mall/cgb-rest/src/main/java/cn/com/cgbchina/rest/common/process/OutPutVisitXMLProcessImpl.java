package cn.com.cgbchina.rest.common.process;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.utils.ReflectUtil;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import lombok.extern.slf4j.Slf4j;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.stereotype.Service;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.util.List;

@Service
@Slf4j
public class OutPutVisitXMLProcessImpl implements PackProcess<Object, String> {

	@Override
	public String packing(Object obj, Class<String> clazz) {
		Document document = DocumentHelper.createDocument();
		Class rootClazz = obj.getClass();
		Element ele = document.addElement("request_message").addElement("message");
		Field[] fileds = ReflectUtil.getFileds(rootClazz);

		for (Field field : fileds) {
			if (List.class.isAssignableFrom(field.getType())) {
				Element itemsEle = ele.addElement("items");
				// 获取list的泛型
				Class childrenClazz = (Class) ((ParameterizedType) field.getGenericType()).getActualTypeArguments()[0];
				// 获取当前的list
				Method getMethod;
				try {
					getMethod = rootClazz.getMethod("get" + StringUtil.captureName(field.getName()));
				} catch (NoSuchMethodException e) {
					String message = "【生成报文】【生成XML时， " + field.getName() + " 缺少get方法】";
					log.error(message);
					throw new ConverErrorException(message, e);
				}
				List list = null;
				try {
					list = (List) getMethod.invoke(obj);
				} catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
					String message = "【生成报文】【生成XML时， " + field.getName() + " 调用get方法出错】";
					log.error(message);
					throw new ConverErrorException(message, e);
				}
				if (list != null && list.size() > 0) {
					for (int i = 0; i < list.size(); i++) {
						// 当前list的对象
						Object objInlist = list.get(i);
						Field[] childrenFields = ReflectUtil.getFileds(childrenClazz);
						for (Field childrenField : childrenFields) {
							Element itemEle = itemsEle.addElement("item");
							fieldToXMLElement(objInlist, childrenClazz, itemEle, childrenField);
						}
					}
				}
			} else {
				fieldToXMLElement(obj, rootClazz, ele, field);

			}
		}
		return document.asXML();
	}

	private void fieldToXMLElement(Object obj, Class rootClazz, Element ele, Field field) {
		String name = field.getName().toLowerCase();
		/*
		 * if (field.getDeclaredAnnotation(XMLNodeName.class) != null) { XMLNodeName annotation =
		 * field.getAnnotation(XMLNodeName.class); if (annotation != null) { name = annotation.value(); } }
		 */
		// 改造上述代码为jdk1.7可使用
		Annotation[] declaredAnnotations = field.getDeclaredAnnotations();
		for (Annotation annotation : declaredAnnotations) {
			if (annotation.getClass().equals(XMLNodeName.class)) {
				XMLNodeName xmlNodeName = (XMLNodeName) annotation;
				name = xmlNodeName.value();
			}
		}

		String value = null;
		Method getMethod = null;
		try {
			getMethod = rootClazz.getDeclaredMethod("get" + StringUtil.captureName(field.getName()));
		} catch (NoSuchMethodException | SecurityException e) {
			String message = "【生成报文】【生成XML时， " + field.getName() + " 缺少get方法】";
			log.error(message);
			throw new ConverErrorException(message, e);
		}
		Object methodResult = null;
		try {
			methodResult = getMethod.invoke(obj);
		} catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
			String message = "【生成报文】【生成XML时， " + field.getName() + " 调用get方法出错】";
			log.error(message);
			throw new ConverErrorException(message, e);
		}
		if (methodResult != null) {
			value = methodResult.toString();
			ele.addElement(name).addText(value);
		} else {
			ele.addElement(name);
		}
	}

}
