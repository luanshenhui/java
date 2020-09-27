package cn.com.cgbchina.rest.common.utils;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;


public class ReflectResult<T> {
	private T result;
	public T getResult(){
		return this.result;
	}
	public ReflectResult(Class<T> T) throws ClassNotFoundException, InstantiationException, IllegalAccessException, InvocationTargetException {
		this.result = ReflectUtil.newInstance(T);
	}
	private Map<String,Integer> count=new HashMap<>();
	Map<String,Integer> getCount(){
		return this.count;
	}
	

}
