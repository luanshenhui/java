package cn.com.cgbchina.rest.common.util;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.InputSoapHanderProcessImpl;

public class XMLUtil {

	/**
	 * 获取报文头部的 GwErrorCode 和GwErrorMessage 适合使用于部分报文
	 * 
	 * @param returnXml
	 * @param resultOther
	 * @param inputSoapHanderProcessImpl
	 * @throws Exception
	 */
	public static <T> void CopyHeaderCode(String returnXml, T resultOther,
			InputSoapHanderProcessImpl inputSoapHanderProcessImpl) {
		SoapModel returnModelVO = inputSoapHanderProcessImpl.packing(returnXml, SoapModel.class);
		Method[] methods = resultOther.getClass().getSuperclass().getDeclaredMethods();
		try {
			String methodName = null;
			for (Method method : methods) {
				methodName = method.getName().toLowerCase();
				if (methodName.indexOf("set") > -1) {
					if (methodName.indexOf("code") > -1) {
						method.invoke(resultOther, returnModelVO.getGwErrorCode());
					} else if (methodName.indexOf("msg") > -1) {
						method.invoke(resultOther, returnModelVO.getGwErrorMessage());
					}
				}
			}
		} catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
			throw new RuntimeException("【获取报文Header异常】", e);
		}
	}
}
