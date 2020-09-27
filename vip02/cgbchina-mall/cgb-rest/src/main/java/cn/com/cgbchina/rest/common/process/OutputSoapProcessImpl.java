package cn.com.cgbchina.rest.common.process;

import cn.com.cgbchina.rest.common.annotation.AllowNull;
import cn.com.cgbchina.rest.common.annotation.Special;
import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.common.constants.Constant;
import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.ReflectUtil;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import lombok.extern.slf4j.Slf4j;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Comment: Created by 11150321050126 on 2016/5/4.
 */
@Service
@Slf4j
public class OutputSoapProcessImpl implements PackProcess<SoapModel, String>, EncodingPackProcess<SoapModel, String> {
	@Autowired
	private OutputSoapReflectPackingImpl reflectPacking;

	@Override
	public String packing(SoapModel model, Class<String> t) throws ConverErrorException {
		return this.packing(model, t, Constant.CHARSET_GBK);
	}

	@Deprecated
	private void loop(Element noAS400, Class<?> rootClass, Object object)
			throws InvocationTargetException, IllegalAccessException {
		Field[] fields;
		fields = ReflectUtil.getFileds(rootClass);
		fieldsToXML(noAS400, rootClass, object, fields);

	}

	@Deprecated
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
				List list = null;
				if(method!=null){
					list = (List) method.invoke(object);
				}
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
					method = rootClass.getMethod("get" + StringUtil.captureName(field.getName()));
				} catch (NoSuchMethodException e) {
					if (field.getName().equals("serialVersionUID")) {
						continue;
					}
					 log.warn("",new RuntimeException("生成XML异常，"+field.getName()+"没有GET方法",e));
				} catch (SecurityException e) {
					throw new RuntimeException("[fieldsToXML->]", e);
				}
				Object obj = null;
				if(method!=null){
					obj = method.invoke(object);
				}
				if(obj==null){
					AllowNull allowNull = field.getAnnotation(AllowNull.class);
					if(allowNull!=null){
						if(allowNull.value()){
							obj="";
						}
					}
				}
				if (obj != null) {
					String special = null;
					if ("java.util.Date".equals(field.getType().getName())) {
						Special annotation = field.getAnnotation(Special.class);
						if (annotation != null) {
							special = annotation.value();
						}
					}
					String str = BeanUtils.convert2Str(obj, special);
					noAS400.addElement("gateway:field").addAttribute("name", name).addText(str);
				}
			}
		}
	}

	@Override
	public String packing(SoapModel model, Class<String> t, String encoding) {
		Document document = DocumentHelper.createDocument();
		try {
			document.setXMLEncoding(encoding);
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
						if (invoke == null) {
							invoke = "";
						}
						elem.addText(String.valueOf(invoke));
					}
				}
			}
			Element body = soapenv.addElement("soapenv:Body");
			Element noAS400 = body.addElement("gateway:NoAS400");
			Object content = model.getContent();
			Class<?> rootClass = content.getClass();
			ReflectUtil.unpacking(noAS400, rootClass, content, reflectPacking);
		} catch (Exception e) {
			throw new ConverErrorException("entity转xml失败", e);
		}
		String xml=document.asXML();
		Pattern p=Pattern.compile("\\&\\#[0-9]+\\;");
		Matcher matcher=p.matcher(xml);
		while(matcher.find()){
			xml=xml.replace(matcher.group(),"");
		}
		return xml;
	}
}
