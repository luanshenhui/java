package cn.com.cgbchina.rest.common.utils;

import java.io.ByteArrayInputStream;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.xml.namespace.QName;
import javax.xml.soap.MessageFactory;
import javax.xml.soap.MimeHeaders;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPHeader;
import javax.xml.soap.SOAPMessage;

import org.apache.commons.lang3.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;

import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.model.EBankModel;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.LoopInterface;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;

import com.spirit.util.JsonMapper;

/**
 * Comment: Created by 11150321050126 on 2016/4/19.
 */
public class SOAPUtils {

	public static final Logger log = org.slf4j.LoggerFactory.getLogger(SOAPUtils.class);
	private static JsonMapper jsonMapper = JsonMapper.nonDefaultMapper();
	private static final String channel = (String) PropertieUtils.getParam().get("channel");
	private static final String webChannel = PropertieUtils.getParam().get("webChannel");

	@Deprecated
	public static String entityToSoap(SoapModel model) throws ConverErrorException {
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
						headType.addElement("gateway:" + field.getName()).addText(String.valueOf(method.invoke(model)));
					}
				}
			}
			Element body = soapenv.addElement("soapenv:Body");
			Element noAS400 = body.addElement("gateway:NoAS400");
			Object content = model.getContent();
			Class<?> rootClass = content.getClass();
			test2(noAS400, rootClass, content);
			// } catch
			// (NoSuchMethodException|InvocationTargetException|IllegalArgumentException|IllegalAccessException|SecurityException
			// e) {
		} catch (Exception e) {
			throw new ConverErrorException("entity转xml失败");
		}
		return document.asXML();
	}

	private static void test2(Element noAS400, Class<?> rootClass, Object object)
			throws NoSuchMethodException, InvocationTargetException, IllegalAccessException {
		Field[] fields;
		fields = rootClass.getDeclaredFields();
		for (Field field : fields) {
			if (field.getName().indexOf("this$") > -1) {
				continue;
			}
			if (List.class.isAssignableFrom(field.getType())) {
				Method method = rootClass.getDeclaredMethod("get" + StringUtil.captureName(field.getName()));
				List list = (List) method.invoke(object);
				Class childrenClazz = (Class) ((ParameterizedType) field.getGenericType()).getActualTypeArguments()[0];
				if (list != null) {
					for (Object obj : list) {
						test2(noAS400, childrenClazz, obj);
					}
				}
			} else {
				Method method = rootClass.getDeclaredMethod("get" + StringUtil.captureName(field.getName()));
				Object obj = method.invoke(object);
				if (obj != null) {
					String str = BeanUtils.convert2Str(obj);
					noAS400.addElement("gateway:field").addAttribute("name", field.getName().toUpperCase())
							.addText(str);
				}
			}
		}
	}

	public static SoapModel parseXml(String xml, String charset) throws ConverErrorException {
		log.debug("【转换前的xml】：\n" + xml);
		try {
			SOAPMessage soapMessage = SOAPUtils.formatSoapString(xml, charset);
			SOAPHeader header = soapMessage.getSOAPHeader();
			SOAPBody body = soapMessage.getSOAPBody();
			// log.debug("【获取xml报文头】：\n"+ JSON.toJSONString(header));
			// log.debug("【获取xml报文内容】：\n"+ JSON.toJSONString(body));

			// ========>不用fastjson，改用这个方法

			log.debug("【获取xml报文头】：\n" + jsonMapper.toJson(header));
			log.debug("【获取xml报文内容】：\n" + jsonMapper.toJson(body));
			SoapModel model = SOAPUtils.soapheadToEntity(header);
			String tradeCode = model.getTradeCode();
			Object object = ScanTradeCode.getBean(tradeCode);
			if (object == null) {
				throw new RuntimeException("找不到交易类");
			}
			Class clazz = null;
			if (SoapProvideService.class.isAssignableFrom(object.getClass())) {
				Type[] interfaces = object.getClass().getGenericInterfaces();
				for (Type inface : interfaces) {
					if (SoapProvideService.class == ((ParameterizedType) inface).getRawType()) {
						clazz = (Class) ((ParameterizedType) inface).getActualTypeArguments()[0];
						break;
					}
				}
			} else {
				throw new RuntimeException(object.getClass().getName() + " 没有继承 " + SoapProvideService.class.getName());
			}
			Object content = SOAPUtils.soapBodyToEntity(body, clazz);
			model.setContent(content);
			return model;
		} catch (ConverErrorException e) {
			throw e;
		} catch (Exception e) {
			throw new ConverErrorException("xml转entity转化失败");
		}
	}

	public static <T> SoapModel<T> parseXml(String xml, Class<T> clazz, String charset) throws ConverErrorException {
		try {
			SOAPMessage soapMessage = SOAPUtils.formatSoapString(xml, charset);
			SOAPHeader header = soapMessage.getSOAPHeader();
			SOAPBody body = soapMessage.getSOAPBody();
			SoapModel model = SOAPUtils.soapheadToEntity(header);
			Object content = SOAPUtils.soapBodyToEntity(body, clazz);
			model.setContent(content);
			return model;
		} catch (ConverErrorException e) {
			throw e;
		} catch (Exception e) {
			throw new ConverErrorException("xml转entity转化失败", e);
		}
	}

	private static SoapModel soapheadToEntity(SOAPElement headElement) throws ConverErrorException,
			NoSuchFieldException, NoSuchMethodException, InvocationTargetException, IllegalAccessException {
		QName qName = new QName("http://www.agree.com.cn/GDBGateway", "HeadType", "gateway");
		Iterator<SOAPElement> headType = headElement.getChildElements(qName);
		if (headType == null || !headType.hasNext()) {
			throw new ConverErrorException();
		}
		SOAPElement headType2 = headType.next();
		Iterator<SOAPElement> iterator = headType2.getChildElements();
		SoapModel result = new SoapModel();
		SOAPElement element = null;
		while (iterator.hasNext()) {
			Object tmp = iterator.next();
			if (!(tmp instanceof SOAPElement)) {
				continue;
			}
			element = (SOAPElement) tmp;
			element.getChildNodes();
			Iterator childrenElem = element.getChildElements();
			while (childrenElem.hasNext()) {
				if (childrenElem.next() instanceof SOAPElement) {
					throw new ConverErrorException();
				}
			}
			String key = element.getElementQName().getLocalPart();
			if (StringUtils.isEmpty(key)) {
				throw new ConverErrorException();
			}
			String value = element.getValue();
			Field field = SoapModel.class.getDeclaredField(key);
			Method setMethod = SoapModel.class.getDeclaredMethod("set" + StringUtil.captureName(key), field.getType());
			setMethod.invoke(result, BeanUtils.convert2Obj(value, field.getType()));
		}
		return result;
	}

	/**
	 * soapתEntity
	 * 
	 * @param rootClazz
	 * @param <T>
	 * @return
	 * @throws Exception
	 */
	private static <T> T soapBodyToEntity(SOAPElement bodyElement, Class<T> rootClazz)
			throws ClassNotFoundException, IllegalAccessException, InvocationTargetException, InstantiationException,
			NoSuchMethodException, ConverErrorException {
		try {
			QName qName = new QName("http://www.agree.com.cn/GDBGateway", "NoAS400", "gateway");
			Iterator<SOAPElement> bodyType = bodyElement.getChildElements(qName);
			if (bodyType == null || !bodyType.hasNext()) {
				throw new ConverErrorException();
			}
			SOAPElement noAs400 = bodyType.next();
			Iterator<SOAPElement> iterator = noAs400.getChildElements();
			T result = null;
			String _$ = "$";
			if (rootClazz.getName().indexOf(_$) > -1) {
				String[] classNames = rootClazz.getName().split("\\" + _$);
				String nameStr = "";
				Object obj = null;
				for (String name : classNames) {
					if (obj == null) {
						nameStr += name;
					} else {
						nameStr += _$ + name;
					}
					Class<?> clazzz = Class.forName(nameStr);
					if (obj == null) {
						obj = clazzz.getDeclaredConstructors()[0].newInstance();
					} else {
						obj = clazzz.getDeclaredConstructors()[0].newInstance(obj);
					}
				}
				result = (T) obj;
			} else {
				result = rootClazz.newInstance();
			}
			SOAPElement element = null;
			while (iterator.hasNext()) {
				Object tmp = iterator.next();
				if (!(tmp instanceof SOAPElement)) {
					continue;
				}
				element = (SOAPElement) tmp;
				element.getChildNodes();
				Iterator childrenElem = element.getChildElements();
				while (childrenElem.hasNext()) {
					if (childrenElem.next() instanceof SOAPElement) {
						throw new ConverErrorException();
					}
				}
				String key = element.getAttribute("name");
				if (StringUtils.isEmpty(key)) {
					throw new ConverErrorException();
				}
				String value = element.getValue();
				Object obj = loop(rootClazz, result, key, value, new LoopInterface() {
					@Override
					public boolean compareName(String filedName, String key) {
						return filedName.toUpperCase().equals(key.toUpperCase());
					}
				});
			}
			return result;
		} catch (ConverErrorException e) {
			throw e;
		}

	}

	private static <T> T loop(Class<T> rootClazz, T result, String key, String value, LoopInterface loopInterface)
			throws ConverErrorException {
		try {
			// 取出内部成员
			Field[] rootFields = rootClazz.getDeclaredFields();
			for (Field field : rootFields) {
				// 判断是否有list
				if (List.class.isAssignableFrom(field.getType())) {
					// 获取list的泛型
					Class childrenClazz = (Class) ((ParameterizedType) field.getGenericType())
							.getActualTypeArguments()[0];
					// 获取当前的list
					Method getMethod;
					try {
						getMethod = rootClazz.getDeclaredMethod("get" + StringUtil.captureName(field.getName()));
					} catch (NoSuchMethodException e) {
						String message = "【解析报文】【解析Soap体时， " + field.getName() + " 缺少get方法】";
						throw new ConverErrorException(message, e);
					}
					List list = (List) getMethod.invoke(result);
					// 装给下一次迭代的对象
					Object obj3 = null;
					// 判断下list是否是空，如果不是空循环看看前面的那些对象那个缺了当前的成员
					if (list != null) {
						for (int i = 0; i < list.size(); i++) {
							// 当前list的对象
							Object obj = list.get(i);
							// 用来装这个list对象(obj)中想要尝试取出要赋值(key)的对象
							Object obj2 = null;
							Method listMethod = null;
							Method[] listMethods = obj.getClass().getDeclaredMethods();
							for (Method method : listMethods) {
								// if(method.getName().toUpperCase().equals(("get"+key).toUpperCase())){
								if (loopInterface.compareName(method.getName(), "get" + key)) {
									listMethod = method;
								}
							}
							/**
							 * a c b1 b2 d b3 1、如果当前key=b3,当前是循环d，当前循环会取不到b3则把当前的这个类放到迭代里， 看看还有没有循环对象了。如果有就就赋值，没有算了
							 * 2、如果当前key=b2，当前循环d，则会把b2取出来，如果b2是空则交给迭代中的下半部分赋值 3、如果取出来的b2有值，则交给迭代的下半部分，创建出来一个对象
							 */
							if (listMethod != null)
								// 如果这个对象里面有想要赋值的对象
								obj2 = listMethod.invoke(obj);
							if (obj2 == null) {
								// 如果取不出来则把
								obj3 = obj;
								break;
							}
						}
					}
					// 扔进去的如果没有则返回对象
					Object obj4 = loop(childrenClazz, obj3, key, value, loopInterface);
					if (obj3 == null && obj4 != null) {
						// 如果是新的对象，需要插入的
						if (list == null) {
							// 判断没有list，则生成list
							list = (List) field.getType().newInstance();
							Method setMethod = null;
							try {
								setMethod = rootClazz.getDeclaredMethod("set" + StringUtil.captureName(field.getName()),
										field.getType());
							} catch (NoSuchMethodException e) {
								String message = "【解析报文】【解析Soap体时， " + field.getName() + " 缺少get方法】";
								throw new ConverErrorException(message, e);
							}
							setMethod.invoke(result, list);
						}
						// 插入
						list.add(obj4);
					}
					// }else
					// if(field.getName().toUpperCase().equals(key.toUpperCase())){
				} else if (loopInterface.compareName(field.getName(), key.toUpperCase())) {
					// 如果有这个对象
					T returnResult = result;
					if (result == null) {
						returnResult = rootClazz.newInstance();
					}
					Method setMethod = null;
					try {
						setMethod = rootClazz.getDeclaredMethod("set" + StringUtil.captureName(field.getName()),
								field.getType());
					} catch (NoSuchMethodException e) {
						String message = "【解析报文】【解析Soap体时， " + field.getName() + " 缺少get方法】";
						throw new ConverErrorException(message, e);
					}
					setMethod.invoke(returnResult, BeanUtils.convert2Obj(value, field.getType()));
					return returnResult;
				}
			}
		} catch (IllegalAccessException e) {
			String message = "【解析报文】【解析Soap体时异常】";
			throw new ConverErrorException(message, e);
		} catch (InvocationTargetException e) {
			String message = "【解析报文】【解析Soap体时异常】";
			throw new ConverErrorException(message, e);
		} catch (InstantiationException e) {
			String message = "【解析报文】【解析Soap体时异常】";
			throw new ConverErrorException(message, e);
		}

		return null;
	}

	/**
	 * 把string的xml转换成soap对象
	 * 
	 * @param soapString
	 * @param character
	 * @return
	 */
	public static SOAPMessage formatSoapString(String soapString, String character) throws ConverErrorException {
		MessageFactory msgFactory;
		try {
			soapString = soapString.replaceAll("\\>\\s+\\<", "><");
			soapString = soapString.replaceAll("http:// www.gdb.com.cn /GDBGateway ",
					"http://www.agree.com.cn/GDBGateway");
			soapString = soapString.replaceAll("http://schemas.xmlsoap.org/soap/envelope/ ",
					"http://schemas.xmlsoap.org/soap/envelope/");
			msgFactory = MessageFactory.newInstance();
			SOAPMessage reqMsg = msgFactory.createMessage(new MimeHeaders(),
					new ByteArrayInputStream(soapString.getBytes(character)));
			reqMsg.saveChanges();
			return reqMsg;
		} catch (Exception e) {
			throw new ConverErrorException();
		}
	}

	public static SoapModel createSOAPModel(Object obj) {
		SoapModel model = new SoapModel();
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat sdf2 = new SimpleDateFormat("HHmmss");
		model.setVersionNo("1");
		model.setToEncrypt("0");
		model.setCommCode("500001");
		model.setCommType("0");
		model.setSenderId(channel);
		model.setSenderSN(sdf.format(date) + sdf2.format(date) + BeanUtils.randomNum(8));
		model.setSenderDate(sdf.format(date));
		model.setSenderTime(sdf2.format(date));
		model.setContent(obj);
		return model;
	}

	public static <T> EBankModel<T> createEBankModel(T obj) {
		EBankModel<T> eBankModel = new EBankModel<>();
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat sdf2 = new SimpleDateFormat("HHmmss");
		eBankModel.setRf("XML");
		/*
		 * eBankModel.setSrcChannel(webChannel); eBankModel.setSenderSN(webChannel + sdf.format(date) +
		 * sdf2.format(date) + BeanUtils.randomNum(8));
		 */
		eBankModel.setContent(obj);
		return eBankModel;
	}

}
