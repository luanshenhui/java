package cn.com.cgbchina.rest.common.process;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.util.HashMap;
import java.util.List;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.Special;
import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import lombok.extern.slf4j.Slf4j;

/**
 * Comment: Created by 11150321050126 on 2016/5/4.
 */
@Service
@Slf4j
public class OutputSoapProcessImpl implements PackProcess<SoapModel, String> {
	// 测试联通性增加字段 接受到tradCode直接返回XML 默认为false
	static Boolean testReturnXml = false;
	private HashMap<String, String> testData;

	@Override
	public String packing(SoapModel model, Class<String> t) throws ConverErrorException {
		// 联通性测试 直接返回报文
		if (testReturnXml) {
			String res = testData.get(model.getTradeCode() + "_O");
			if (res != null && !res.isEmpty()) {
				return res;
			}
		}

		Document document = DocumentHelper.createDocument();
		try {
			Element soapenv = document.addElement("soapenv:Envelope");
			soapenv.addNamespace("soapenv", "http://schemas.xmlsoap.org/soap/envelope/");
			soapenv.addNamespace("gateway", "http://www.agree.com.cn/GDBGateway");
			// 通用报文头
			Element header = soapenv.addElement("soapenv:Header");
			Element headType = header.addElement("gateway:HeadType");
			Field[] fields = SoapModel.class.getDeclaredFields();
			for (Field field : fields) {
				if (!"content".equals(field.getName())) {
					if (!List.class.isAssignableFrom(field.getType())) {
						Method method = SoapModel.class
								.getDeclaredMethod("get" + StringUtil.captureName(field.getName()));
						Object invoke = method.invoke(model);
						Element elem = headType.addElement("gateway:" + field.getName());
						if (invoke != null) {
							elem.addText(String.valueOf(invoke));
						}
					}
				}
			}
			Element body = soapenv.addElement("soapenv:Body");
			Element noAS400 = body.addElement("gateway:NoAS400");
			Object content = model.getContent();
			Class<?> rootClass = content.getClass();
			loop(noAS400, rootClass, content);
		} catch (Exception e) {
			throw new ConverErrorException("entity转xml失败", e);
		}
		return document.asXML();
	}

	private void loop(Element noAS400, Class<?> rootClass, Object object)
			throws InvocationTargetException, IllegalAccessException {
		Field[] fields;
		fields = rootClass.getDeclaredFields();
		Field[] superfields = rootClass.getSuperclass().getDeclaredFields();
		fieldsToXML(noAS400, rootClass, object, fields);

		fieldsToXML(noAS400, rootClass.getSuperclass(), object, superfields);
	}

	private void fieldsToXML(Element noAS400, Class<?> rootClass, Object object, Field[] fields)
			throws IllegalAccessException, InvocationTargetException {
		for (Field field : fields) {
			if (field.getName().indexOf("this$") > -1) {
				continue;
			}
			if (List.class.isAssignableFrom(field.getType())) {
				Method method = null;
				try {
					method = rootClass.getDeclaredMethod("get" + StringUtil.captureName(field.getName()));
				} catch (NoSuchMethodException e) {
					continue;
				} catch (SecurityException e) {
					e.printStackTrace();
				}
				List list = (List) method.invoke(object);
				Class childrenClazz = (Class) ((ParameterizedType) field.getGenericType()).getActualTypeArguments()[0];
				if (list != null) {
					for (Object obj : list) {
						loop(noAS400, childrenClazz, obj);
					}
				}
			} else {
				String name = field.getName();
				Method method = null;
				try {

					XMLNodeName nodeName = field.getAnnotation(XMLNodeName.class);
					if (nodeName != null) {
						name = nodeName.value();
					}
					method = rootClass.getDeclaredMethod("get" + StringUtil.captureName(field.getName()));
				} catch (NoSuchMethodException e) {
					if (field.getName().equals("serialVersionUID")) {
						continue;
					}
					// throw new RuntimeException("生成XML异常，"+field.getName()+"没有GET方法",e);
					log.debug("OutputSoapProcessImpl -> " + field.getName() + "没有GET方法\n" + e);
				} catch (SecurityException e) {
					throw new RuntimeException("[fieldsToXML->]", e);
				}
				Object obj = method.invoke(object);
				if (obj != null) {
					String special = null;
					if ("java.util.Date".equals(field.getType())) {
						Special annotation = field.getAnnotation(Special.class);
						if (annotation != null) {
							special = annotation.value();
						}
					}
					String str = BeanUtils.convert2Str(obj, special);
					// noAS400.addElement("gateway:field").addAttribute("name",
					// field.getName().toUpperCase()).addText(str);
					noAS400.addElement("gateway:field").addAttribute("name", name).addText(str);
				}
			}
		}
	}
}
