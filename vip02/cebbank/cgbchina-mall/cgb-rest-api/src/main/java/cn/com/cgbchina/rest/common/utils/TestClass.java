package cn.com.cgbchina.rest.common.utils;

import java.io.IOException;

import org.apache.http.HttpException;

import com.spirit.util.JsonMapper;

import cn.com.cgbchina.rest.common.exception.ConnectErrorException;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class TestClass {
	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	public static <T> T debugMethod(Class<T> clazz) {
		try {
			String methodName = Thread.currentThread().getStackTrace()[2].getMethodName();
			System.out.println("method:" + methodName);
			String className = null;
			try {
				className = Class.forName(Thread.currentThread().getStackTrace()[2].getClassName()).getSimpleName();
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
			System.out.println("className:" + className);
			return jsonMapper.fromJson(SoapTestHttpHelper.send(className + "." + methodName), clazz);
		} catch (IOException | HttpException e) {
			throw new ConnectErrorException("【链接】【链接其他系统失败】", e);
		}
	}
}
