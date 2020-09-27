package cn.com.cgbchina.rest.common.utils;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.util.List;

import org.slf4j.Logger;

import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.process.LoopInterface;

/**
 * Comment: Created by 11150321050126 on 2016/4/25.
 */
@Deprecated
public class LoopLoadDataUtils {
	private static final Logger log = org.slf4j.LoggerFactory.getLogger(LoopLoadDataUtils.class);

	/**
	 * 迭代把xml内容转成obj
	 *
	 * @param rootClazz
	 * @param result
	 * @param key
	 * @param value
	 * @param <T>
	 * @return
	 * @throws NoSuchMethodException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws InstantiationException
	 */
	public static <T> T keyLoadToClass(Class<T> rootClazz, T result, String key, String value,
			LoopInterface loopInterface) throws ConverErrorException {
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
					Object obj4 = keyLoadToClass(childrenClazz, obj3, key, value, loopInterface);
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
								log.error(message);
								throw new ConverErrorException(message);
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
			log.error(message);
			throw new ConverErrorException(message);
		} catch (InvocationTargetException e) {
			String message = "【解析报文】【解析Soap体时异常】";
			log.error(message);
			throw new ConverErrorException(message);
		} catch (InstantiationException e) {
			String message = "【解析报文】【解析Soap体时异常】";
			log.error(message);
			throw new ConverErrorException(message);
		}

		return null;
	}
}
