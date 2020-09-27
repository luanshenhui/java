package com.dhc.base.core;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;

import com.dhc.base.log.LogLevel;
import com.dhc.base.log.SysLog;

public abstract class BaseExtBO {
	private Class clazz = this.getClass();
	private HashMap methods = new HashMap();

	private Class types[] = { java.util.HashMap.class };

	public String execute(String methodName, HashMap hashMap) throws Exception {

		String message = "";
		String result = "";

		Method method = null;
		try {
			method = getMethod(methodName);
		} catch (NoSuchMethodException e) {
			message = "No Such Method Exception!" + e.getMessage();
			SysLog.writeExceptionLogs("iframework", LogLevel.ERROR, message, e);
			return (message);
		}

		try {
			Object args[] = { hashMap };
			result = (String) method.invoke(this, args);
		} catch (ClassCastException e) {
			message = "Class Cast Exception! -- " + e.getMessage();
			SysLog.writeExceptionLogs("iframework", LogLevel.ERROR, message, e);
			return message;
		} catch (IllegalAccessException e) {
			message = "Illegal Access Exception! -- " + e.getMessage();
			SysLog.writeExceptionLogs("iframework", LogLevel.ERROR, message, e);
			return message;
		} catch (InvocationTargetException e) {

			Throwable t = e.getTargetException();
			if (t instanceof Exception) {
				throw ((Exception) t);
			} else {
				message = "Dispatch Exception! -- " + e.getMessage();
				SysLog.writeExceptionLogs("iframework", LogLevel.ERROR, message, e);
				return message;
			}
		}
		return result;
	}

	private Method getMethod(String name) throws NoSuchMethodException {

		synchronized (methods) {
			Method method = (Method) methods.get(name);
			if (method == null) {
				method = clazz.getMethod(name, types);
				methods.put(name, method);
			}
			return (method);
		}

	}

}
