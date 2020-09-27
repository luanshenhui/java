package cn.com.cgbchina.rest.common.utils;

import cn.com.cgbchina.rest.common.annotation.AllowNull;
import cn.com.cgbchina.rest.common.annotation.Special;
import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.process.ReflectPacking;
import lombok.extern.slf4j.Slf4j;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.*;

@Slf4j
public class ReflectUtil {

	/**
	 * 根据报文生成对应的对象并赋值
	 * 
	 * @param rootClazz 类名
	 * @param result 返回的对象
	 * @param key 属性名
	 * @param value 属性值
	 * @return
	 */
	public static <T> T packing(Class<T> rootClazz, ReflectResult<T> reflectResult, String key, String value){
		return packing(rootClazz, reflectResult.getResult(), key, value, reflectResult.getCount());
	}
	
	public static <T> T packing(Class<T> rootClazz, Object result, String key, String value,Map<String, Integer> count)
			{
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
					Integer integer = count.get(key);
					Integer i=integer==null?0:integer;
					if (list != null&&list.size() > 0&&list.size()>i) {
						String findKey = key;
						Field[] childrenFields = getFileds(childrenClazz);
						for (Field cField : childrenFields) {
							XMLNodeName annotation = cField.getAnnotation(XMLNodeName.class);
							if (annotation != null) {
								String strAnnotation = annotation.value();
								if (key.equals(strAnnotation)) {
									findKey = cField.getName();
									break;
								}
							}
						}
						// 当前list的对象
						Object obj = list.get(i);
						// 用来装这个list对象(obj)中想要尝试取出要赋值(key)的对象
						Object obj2 = null;
						Method listMethod = null;
						Method[] listMethods = obj.getClass().getMethods();
						for (Method method : listMethods) {
							if (method.getName().toUpperCase().equals(("get" + findKey).toUpperCase())) {
								listMethod = method;
								break;
							}
						}
						/**
						 * a 
						 * c 
						 * 	 b1
						 *   b2
						 * d 
						 *   b3
						 * 1、如果当前key=b3,当前是循环d，当前循环会取不到b3则把当前的这个类放到迭代里， 看看还有没有循环对象了。如果有就就赋值，没有算了
						 * 2、如果当前key=b2，当前循环d，则会把b2取出来，如果b2是空则交给迭代中的下半部分赋值
						 * 3、如果取出来的b2有值，则交给迭代的下半部分，创建出来一个对象
						 */
						if (listMethod != null)
							// 如果这个对象里面有想要赋值的对象
							obj2 = listMethod.invoke(obj);
						if (obj2 == null) {
							// 如果取不出来则把
							obj3 = obj;
						}
					}
					// 扔进去的如果没有则返回对象
					Object obj4 = packing(childrenClazz, obj3, key, value,count);
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
								String message = "【解析报文】【解析Soap体时， " + field.getName() + " 缺少set方法】";
								log.error(message);
								throw new ConverErrorException(message, e);
							}
							setMethod.invoke(result, list);
						}
						// 插入
						list.add(obj4);
					}
				} else {
					String name = field.getName();
					XMLNodeName annotation = field.getAnnotation(XMLNodeName.class);
					if (annotation != null) {
						name = annotation.value();
					}
					if (name.toUpperCase().equals(key.toUpperCase())) {
						Integer integer = count.get(key);
						count.put(key, integer==null?1:++integer);
						// 如果有这个对象
						T returnResult = setFieldValue(rootClazz, result, field, value);
						return returnResult;
					}
				} 
			}
		} catch (IllegalAccessException|InvocationTargetException|InstantiationException|ClassNotFoundException e) {
			String message = "【解析报文】【解析报文异常】";
			throw new ConverErrorException(message, e);
		} 

		return null;
	}
	
	public static <T> T packingOld(Class<T> rootClazz, Object result, String key, String value)
	{
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
						String findKey = key;
						if (list.size() > 0) {
							Field[] childrenFields = getFileds(childrenClazz);
							for (Field cField : childrenFields) {
								XMLNodeName annotation = cField.getAnnotation(XMLNodeName.class);
								if (annotation != null) {
									String strAnnotation = annotation.value();
									if (key.equals(strAnnotation)) {
										findKey = cField.getName();
										break;
									}
								}
							}
						}
						for (int i = 0; i < list.size(); i++) {
							// 当前list的对象
							Object obj = list.get(i);
							// 用来装这个list对象(obj)中想要尝试取出要赋值(key)的对象
							Object obj2 = null;
							Method listMethod = null;
							Method[] listMethods = obj.getClass().getMethods();
							for (Method method : listMethods) {
								if (method.getName().toUpperCase().equals(("get" + findKey).toUpperCase())) {
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
					Object obj4 = packingOld(childrenClazz, obj3, key, value);
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
								String message = "【解析报文】【解析Soap体时， " + field.getName() + " 缺少set方法】";
								log.error(message);
								throw new ConverErrorException(message, e);
							}
							setMethod.invoke(result, list);
						}
						// 插入
						list.add(obj4);
					}
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
		} catch (IllegalAccessException|InvocationTargetException|InstantiationException|ClassNotFoundException e) {
			String message = "【解析报文】【解析报文异常】";
			throw new ConverErrorException(message, e);
		} 

		return null;
	}
	public static <T> void unpacking(T element, Class<?> rootClass, Object object, ReflectPacking processClass) {
		unpacking(element,rootClass,object,processClass,0);
	}
	private static <T> void unpacking(T element, Class<?> rootClass, Object object, ReflectPacking processClass,Integer level) {
		Field[] fields;
		fields = ReflectUtil.getFileds(rootClass);
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
					try {
						list = (List) method.invoke(object);
					} catch (IllegalAccessException|InvocationTargetException e) {
						log.error("[包装失败]",e);
						throw new ConverErrorException("[包装失败]",e);
					}
				}
				Class childrenClazz = (Class) ((ParameterizedType) field.getGenericType()).getActualTypeArguments()[0];
				if (list != null) {
					for (int i=0;i<list.size();i++) {
						Object obj=list.get(i);
						T tmpItem = processClass.processListPacking(element, list, ++level, i);
						unpacking(tmpItem, childrenClazz, obj, processClass);
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
					try{
						obj = method.invoke(object);
					} catch (IllegalAccessException|InvocationTargetException e) {
						log.error("[包装失败]",e);
						throw new ConverErrorException("[包装失败]",e);
					}
				}
				if(obj==null){
					AllowNull allowNull = field.getAnnotation(AllowNull.class);
					if(allowNull!=null){
						if(allowNull.value()){
							obj="";
						}
					}
				}
				String str=null;
				if (obj != null) {
					String special = null;
					if ("java.util.Date".equals(field.getType().getName())) {
						Special annotation = field.getAnnotation(Special.class);
						if (annotation != null) {
							special = annotation.value();
						}
					}
					str = BeanUtils.convert2Str(obj, special);
				}
				processClass.processObjPacking(element, name, str);
			}
		}
	}
	public static Field[] getFileds(Class clazz) {
		Field[] field1 = clazz.getDeclaredFields();
		List<Field> fieldsTmp = new ArrayList<>();
		getSupperFileds(clazz, fieldsTmp);
		for (Field field : field1) {
			fieldsTmp.add(field);
		}
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
			throws InstantiationException, IllegalAccessException, InvocationTargetException, ClassNotFoundException {
		T returnResult = (T) result;
		if (returnResult == null) {
			returnResult = newInstance(rootClazz);
		}
		Method setMethod = null;
		try {
			setMethod = rootClazz.getMethod("set" + StringUtil.captureName(field.getName()), field.getType());
		} catch (NoSuchMethodException e) {
			String message = "【解析报文】【解析Soap体时， " + field.getName() + " 缺少set方法】";
			log.error(message);
			throw new ConverErrorException(message);
		}
		String special = null;
		Special annotation = field.getAnnotation(Special.class);
		if (annotation != null) {
			special = annotation.value();
		}
		setMethod.invoke(returnResult, BeanUtils.convert2Obj(value, field.getType(), special));
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

	public static <T> T newInstance(Class<T> rootClazz)
			throws ClassNotFoundException, InstantiationException, IllegalAccessException, InvocationTargetException {
		T result;
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
		return result;
	}
}
