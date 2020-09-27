package cn.com.cgbchina.rest.common.utils;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

import lombok.extern.slf4j.Slf4j;

import org.apache.commons.lang3.StringUtils;

import cn.com.cgbchina.rest.common.exception.ConverErrorException;

/**
 * Comment: Created by 11150321050126 on 2016/4/25.
 */
@Slf4j
public class BeanUtils {
	/**
	 * String转Obj
	 * 
	 * @param value
	 * @param clazz
	 * @return
	 */
	public static Object convert2Obj(String value, Class clazz, String... special) {
		String className = clazz.getName();
		Object param = null;
		if ("java.lang.String".equals(className)) {
			param = value;
		} else if ("int".equals(className) || "java.lang.Integer".equals(className)) {
			param = Integer.valueOf(value);
		} else if ("double".equals(className) || "java.lang.Double".equals(className)) {
			param = Integer.valueOf(value);
		} else if ("long".equals(className) || "java.lang.Long".equals(className)) {
			param = Long.valueOf(value);
		} else if ("byte".equals(className) || "java.lang.Byte".equals(className)) {
			param = Byte.valueOf(value);
		} else if ("boolean".equals(className) || "java.lang.Boolean".equals(className)) {
			param = Boolean.valueOf(value);
		} else if ("java.util.Date".equals(className)) {
			try {
				String str = "yyyyMMDDHHmmss";
				if (StringUtils.isNotEmpty(special[0])) {
					str = special[0];
				}
				SimpleDateFormat sdf = new SimpleDateFormat(str);
				param = sdf.parse(value);
			} catch (ParseException e) {
				throw new ConverErrorException("【类型转换异常】");
			}
		} else if (BigDecimal.class.getName().equals(className)) {
			param = new BigDecimal(value);
		} else {
			throw new ConverErrorException("【只支持基本数据类型】传入的类型为" + className);
		}
		return param;
	}

	public static String convert2Str(Object object, String... special) {
		// return String.valueOf(object);
		String className = object.getClass().getName();
		String param = null;
		if ("java.lang.String".equals(className)) {
			param = (String) object;
		} else if ("int".equals(className) || "java.lang.Integer".equals(className)) {
			param = String.valueOf(object);
		} else if ("double".equals(className) || "java.lang.Double".equals(className)) {
			param = String.valueOf(object);
		} else if ("long".equals(className) || "java.lang.Long".equals(className)) {
			param = String.valueOf(object);
		} else if ("byte".equals(className) || "java.lang.Byte".equals(className)) {
			param = String.valueOf(object);
		} else if ("boolean".equals(className) || "java.lang.Boolean".equals(className)) {
			param = String.valueOf(object);
		} else if ("java.util.Date".equals(className)) {
			String format = "yyyyMMDDHHmmss";
			if (StringUtils.isNotEmpty(special[0])) {
				format = special[0];
			}
			SimpleDateFormat sdf = new SimpleDateFormat(format);
			param = sdf.format(object);
		} else if (BigDecimal.class.getName().equals(className)) {
			String format = "#.00";
			if (StringUtils.isNotEmpty(special[0])) {
				format = special[0];
			}
			DecimalFormat df = new DecimalFormat(format);
			param = df.format(object);
		} else {
			throw new ConverErrorException("【只支持基本数据类型】");
		}
		return param;
	}

	public static <T> T copy(Object obj, Class<T> clazz) {
		T result = null;
		try {
			result = clazz.newInstance();
		} catch (InstantiationException e) {

			throw new RuntimeException("类型转换异常", e);
		} catch (IllegalAccessException e) {
			throw new RuntimeException("类型转换异常", e);
		}
		org.springframework.beans.BeanUtils.copyProperties(obj, result);
		Field[] fields = clazz.getDeclaredFields();
		for (Field f : fields) {
			if (List.class.isAssignableFrom(f.getType())) {
				String name = f.getName();
				Field objField = null;
				try {
					objField = obj.getClass().getDeclaredField(name);
				} catch (NoSuchFieldException e) {
					continue;
				}
				Method objListMethod;
				try {
					objListMethod = obj.getClass()
							.getDeclaredMethod("get" + StringUtil.captureName(objField.getName()));
				} catch (NoSuchMethodException e) {
					continue;
				}
				List objList = null;
				try {
					objList = (List) objListMethod.invoke(obj);
				} catch (IllegalAccessException e) {
					throw new RuntimeException("类型转换异常", e);
				} catch (InvocationTargetException e) {
					throw new RuntimeException("类型转换异常", e);
				}
				Method classListMethod = null;
				try {
					classListMethod = clazz.getDeclaredMethod("set" + StringUtil.captureName(f.getName()), f.getType());
				} catch (NoSuchMethodException e) {
					continue;
				}
				List clazzList = new ArrayList();
				if (objList != null) {
					for (Object objs : objList) {
						Object addBean = BeanUtils.copy(objs, getFanxing(f));
						clazzList.add(addBean);
					}
				}
				try {

					classListMethod.invoke(result, clazzList);
				} catch (IllegalAccessException e) {
					throw new RuntimeException("类型转换异常", e);
				} catch (InvocationTargetException e) {
					throw new RuntimeException("类型转换异常", e);
				}
			}
		}
		return result;
	}

	private static Class getFanxing(Field field) {
		ParameterizedType pt = (ParameterizedType) field.getGenericType();
		if (pt.getActualTypeArguments().length > 0) {
			return (Class) pt.getActualTypeArguments()[0];
		} else {
			return Object.class;
		}
	}

	public static <T> T randomClass(Class<T> clazz) {
		T result = null;

		try {
			result = clazz.newInstance();
		} catch (InstantiationException e) {

			throw new RuntimeException("类型转换异常", e);
		} catch (IllegalAccessException e) {
			throw new RuntimeException("类型转换异常", e);
		}
		Field[] fields = clazz.getDeclaredFields();
		Field[] pFields = clazz.getSuperclass().getDeclaredFields();
		FillFields(fields, clazz, result);
		FillFields(pFields, clazz.getSuperclass(), result);

		return result;
	}

	private static <T> void FillFields(Field[] fields, Class<T> clazz, T result) {
		for (Field f : fields) {
			String fTypeName = f.getType().getName();
			if (List.class.isAssignableFrom(f.getType())) {
				Method objListMethod;
				try {
					objListMethod = clazz.getDeclaredMethod("get" + StringUtil.captureName(f.getName()));
				} catch (NoSuchMethodException e) {
					continue;
				}
				List objList = null;
				try {
					objList = (List) objListMethod.invoke(result);// 反射获取List
					Type listObjType = f.getGenericType();
					String typeName = null;
					if (listObjType instanceof ParameterizedType) {
						ParameterizedType paramType = (ParameterizedType) listObjType;
						Type[] actualTypes = paramType.getActualTypeArguments();
						for (Type aType : actualTypes) {
							if (aType instanceof Class) {
								Class clz = (Class) aType;
								typeName = clz.getName();
							}
						}
					}
					String clazzName = null;
					if (typeName.indexOf("<") > -1) {
						clazzName = typeName.substring(typeName.indexOf("<") + 1, typeName.indexOf(">"));
					} else {
						clazzName = typeName;
					}
					Class listObjClazz = Class.forName(clazzName);
					objList = new ArrayList<>();
					for (int i = 0; i < 2; i++) {
						try {
							Object obj = listObjClazz.newInstance();
							obj = BeanUtils.randomClass(listObjClazz);
							objList.add(obj);
						} catch (InstantiationException e) {
							e.printStackTrace();
						}
					}
				} catch (IllegalAccessException e) {
					throw new RuntimeException("类型转换异常", e);
				} catch (InvocationTargetException e) {
					throw new RuntimeException("类型转换异常", e);
				} catch (ClassNotFoundException e) {
					throw new RuntimeException("类型转换异常", e);
				}
				Method classListMethod = null;
				try {
					classListMethod = clazz.getDeclaredMethod("set" + StringUtil.captureName(f.getName()), f.getType());
				} catch (NoSuchMethodException e) {
					continue;
				}
				try {
					classListMethod.invoke(result, objList);
				} catch (IllegalAccessException e) {
					throw new RuntimeException("类型转换异常", e);
				} catch (InvocationTargetException e) {
					throw new RuntimeException("类型转换异常", e);
				}
			} else if (fTypeName.equals("java.lang.Double") || fTypeName.equals("double")) {
				Method method;
				try {
					method = clazz.getMethod("set" + StringUtil.captureName(f.getName()), f.getType());
					method.invoke(result, new Random().nextDouble());
				} catch (NoSuchMethodException e) {
					e.printStackTrace();
				} catch (SecurityException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}

			} else if (fTypeName.equals("java.lang.Byte") || fTypeName.equals("byte")) {
				continue;
			} else if ("int".equals(fTypeName) || "java.lang.Integer".equals(fTypeName)) {
				Method method;
				try {
					method = clazz.getMethod("set" + StringUtil.captureName(f.getName()), f.getType());
					method.invoke(result, new Random().nextInt());
				} catch (NoSuchMethodException e) {
					System.err.println(clazz.getName() + ":" + f.getName() + ":" + f.getType().getName());
					e.printStackTrace();
				} catch (SecurityException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
			} else if (BigDecimal.class.getName().equals(fTypeName)) {
				Method method;
				try {
					method = clazz.getMethod("set" + StringUtil.captureName(f.getName()), f.getType());
					method.invoke(result, new BigDecimal(new Random().nextDouble()));
				} catch (NoSuchMethodException e) {
					e.printStackTrace();
				} catch (SecurityException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
			} else if ("java.util.Date".equals(fTypeName)) {
				Method method;
				try {
					method = clazz.getMethod("set" + StringUtil.captureName(f.getName()), f.getType());
					method.invoke(result, new Date());
				} catch (NoSuchMethodException e) {
					e.printStackTrace();
				} catch (SecurityException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
			} else if ("boolean".equals(fTypeName) || "java.lang.Boolean".equals(fTypeName)) {
				Method method;
				try {
					method = clazz.getMethod("set" + StringUtil.captureName(f.getName()), f.getType());
					method.invoke(result, new Boolean(new Random().nextInt() > 0));
				} catch (NoSuchMethodException e) {
					e.printStackTrace();
				} catch (SecurityException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
			} else if ("long".equals(fTypeName) || "java.lang.Long".equals(fTypeName)) {
				Method method;
				try {
					method = clazz.getMethod("set" + StringUtil.captureName(f.getName()), f.getType());
					method.invoke(result, new Random().nextLong());
				} catch (NoSuchMethodException e) {
					continue;
				} catch (SecurityException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
			} else {

				try {
					Method method = clazz.getMethod("set" + StringUtil.captureName(f.getName()), f.getType());
					method.invoke(result, randomString(10));

				} catch (NoSuchMethodException e) {
					continue;
				} catch (SecurityException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (IllegalArgumentException e) {

					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
			}
		}
	}

	private static Random randGen = null;
	private static char[] numbersAndLetters = null;

	public static final String randomString(int length) {
		if (length < 1) {
			return null;
		}
		if (randGen == null || numbersAndLetters.length == 10) {
			randGen = new Random();
			numbersAndLetters = ("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ").toCharArray();
		}
		char[] randBuffer = new char[length];
		for (int i = 0; i < randBuffer.length; i++) {
			randBuffer[i] = numbersAndLetters[randGen.nextInt(35)];
		}
		return new String(randBuffer);
	}

	public static final String randomNum(int length) {
		if (length < 1) {
			return null;
		}
		if (randGen == null || numbersAndLetters.length == 35) {
			randGen = new Random();
			numbersAndLetters = ("0123456789").toCharArray();
		}
		char[] randBuffer = new char[length];
		for (int i = 0; i < randBuffer.length; i++) {
			randBuffer[i] = numbersAndLetters[randGen.nextInt(10)];
		}
		return new String(randBuffer);
	}

	public static void main(String[] args) {
		for (int i = 0; i < 99; i++) {
			System.out.println(BeanUtils.randomString(10));
		}
	}
}
