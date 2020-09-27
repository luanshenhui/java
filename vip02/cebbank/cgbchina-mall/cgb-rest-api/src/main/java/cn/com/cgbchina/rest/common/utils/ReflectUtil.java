package cn.com.cgbchina.rest.common.utils;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.common.exception.ConverErrorException;

public class ReflectUtil {
	private static Logger log = LoggerFactory.getLogger(ReflectUtil.class);

	/**
	 * 根据报文生成对应的对象并赋值
	 * 
	 * @param rootClazz 类名
	 * @param result 返回的对象
	 * @param key 属性名
	 * @param value 属性值
	 * @return
	 * @throws ConverErrorException
	 */
	public static <T> T loop(Class<T> rootClazz, Object result, String key, String value) throws ConverErrorException {
		return loop(rootClazz, result, key, value, null);
	}

	/**
	 * 根据报文生成对应的对象并赋值
	 * 
	 * @param rootClazz 类名
	 * @param result 返回的对象
	 * @param key 属性名
	 * @param value 属性值
	 * @param type xml或者soap 填Null默认soap
	 * @return
	 * @throws ConverErrorException
	 */
	public static <T> T loop(Class<T> rootClazz, Object result, String key, String value, String type)
			throws ConverErrorException {

		// private <T> T loop(Class<T> rootClazz, T result, String key, String
		// value, LoopInterface loopInterface) throws ConverErrorException {
		if (type != null)
			type = type.toLowerCase();
		try {
			// 取出内部成员
			Field[] rootFields = getFileds(rootClazz);
			for (Field field : rootFields) {
				// 判断是否有list
				if (List.class.isAssignableFrom(field.getType())) {
					// 获取list的泛型
					Class childrenClazz = (Class) ((ParameterizedType) field.getGenericType())
							.getActualTypeArguments()[0];
					// 获取当前的list
					Method getMethod;
					try {
						getMethod = rootClazz.getMethod("get" + StringUtil.captureName(field.getName()));
					} catch (NoSuchMethodException e) {
						String message = "【解析报文】【解析Soap体时， " + field.getName() + " 缺少get方法】";
						log.error(message);
						throw new ConverErrorException(message);
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
							Method[] listMethods = obj.getClass().getMethods();
							for (Method method : listMethods) {
								if (method.getName().toUpperCase().equals(("get" + key).toUpperCase())) {
									// if
									// (loopInterface.compareName(method.getName(),
									// "get" + key)) {
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
					// Object obj4 = loop(childrenClazz, obj3, key, value,
					// loopInterface);
					Object obj4 = loop(childrenClazz, obj3, key, value);
					if (obj3 == null && obj4 != null) {
						// 如果是新的对象，需要插入的
						if (list == null) {
							// 判断没有list，则生成list
							list = new ArrayList<>();
							Method setMethod = null;
							try {
								setMethod = rootClazz.getMethod("set" + StringUtil.captureName(field.getName()),
										field.getType());
							} catch (NoSuchMethodException e) {
								String message = "【解析报文】【解析Soap体时， " + field.getName() + " 缺少get方法】";
								log.error(message);
								throw new ConverErrorException(message, e);
							}
							setMethod.invoke(result, list);
						}
						// 插入
						list.add(obj4);
					}
				} else if (type == null || type == "soap") {
					String name = field.getName();
					XMLNodeName annotation = field.getAnnotation(XMLNodeName.class);
					if (annotation != null) {
						name = annotation.value();
					}
					if (name.toUpperCase().equals(key.toUpperCase())) {
						// 如果有这个对象
						T returnResult = setFieldValue(rootClazz, result, field, value);
						return returnResult;
					}
				} else if (type.equals("xml")) {
					String nodeName = field.getAnnotation(XMLNodeName.class).value();
					if (nodeName.equals(key)) {
						T returnResult = setFieldValue(rootClazz, result, field, value);
						return returnResult;
					}
					return null;
				} else {
					String name = field.getName();
					XMLNodeName annotation = field.getAnnotation(XMLNodeName.class);
					if (annotation != null) {
						name = annotation.value();
					}
					if (name.toUpperCase().equals(key.toUpperCase())) {
						// 如果有这个对象
						T returnResult = setFieldValue(rootClazz, result, field, value);
						return returnResult;
					}
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

	private static Method getMethod(Class clazz, String name) {
		String nm = "get" + StringUtil.captureName(name);
		return null;
	}

	private static Method getSupperMethod(Class clazz, String name) {
		return null;
	}

	public static Field[] getFileds(Class clazz) {
		Field[] field1 = clazz.getDeclaredFields();
		List<Field> fieldsTmp = new ArrayList<>();
		for (Field field : field1) {
			fieldsTmp.add(field);
		}
		getSupperFileds(clazz, fieldsTmp);
		return fieldsTmp.toArray(field1);
	}

	private static void getSupperFileds(Class clazz, List<Field> list) {
		Class classRoot = clazz.getSuperclass();
		if (classRoot != null) {
			Field[] tmp = classRoot.getDeclaredFields();
			for (Field f : tmp) {
				list.add(f);
			}
			getSupperFileds(classRoot, list);
		}
	}

	private static <T> T setFieldValue(Class<T> rootClazz, Object result, Field field, String value)
			throws InstantiationException, IllegalAccessException, InvocationTargetException {
		T returnResult = (T) result;
		if (result == null) {
			returnResult = rootClazz.newInstance();
		}
		Method setMethod = null;
		try {
			setMethod = rootClazz.getMethod("set" + StringUtil.captureName(field.getName()), field.getType());
		} catch (NoSuchMethodException e) {
			String message = "【解析报文】【解析Soap体时， " + field.getName() + " 缺少set方法】";
			log.error(message);
			throw new ConverErrorException(message);
		}
		setMethod.invoke(returnResult, BeanUtils.convert2Obj(value, field.getType()));
		return returnResult;
	}

	public static Map getObjMap(Object obj) {
		HashMap<String, String> res = new HashMap<>();
		Class clazz = obj.getClass();
		StringBuilder sb = new StringBuilder();
		Field[] fields = getFileds(clazz);
		for (Field field : fields) {
			String fName = field.getName();
			if (!isBaseDataType(field.getType())) {
				continue;
			}
			Method getMethod = null;
			try {
				getMethod = clazz.getMethod("get" + StringUtil.captureName(field.getName()));
			} catch (NoSuchMethodException e) {
				continue;
			}
			String str = "";
			try {
				Object value = getMethod.invoke(obj);

				if (value != null) {
					str = value.toString();
				}
				// sb.append("<" + fName + ">" + value + "</" + fName + ">");
				res.put(fName, str);
				// ele.addElement(fName).addText(str);
			} catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
				throw new RuntimeException("对象生成XML失败 " + fName + " " + str, e);
			}
		}
		return res;
	}

	private static boolean isBaseDataType(Class clazz) {
		return (clazz.equals(String.class) || clazz.equals(Integer.class) || clazz.equals(Byte.class)
				|| clazz.equals(Long.class) || clazz.equals(Double.class) || clazz.equals(Float.class)
				|| clazz.equals(Character.class) || clazz.equals(Short.class) || clazz.equals(BigDecimal.class)
				|| clazz.equals(BigInteger.class) || clazz.equals(Boolean.class) || clazz.equals(Date.class)
				|| clazz.isPrimitive());
	}
}
