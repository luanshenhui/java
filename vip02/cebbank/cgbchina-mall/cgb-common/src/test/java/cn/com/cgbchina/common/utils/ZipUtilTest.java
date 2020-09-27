/*
 * 
 * Copyright 2016 by www.cgbchina.com.cn All rights reserved.
 * 
 */
package cn.com.cgbchina.common.utils;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Dictionary;
import java.util.Hashtable;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;

/**
 * 日期 : 2016年6月22日<br>
 * 作者 : liuyc<br>
 * 项目 : cgb-common<br>
 * 功能 : ZipUtil测试类<br>
 */
public class ZipUtilTest {

	@Test
	public void unzip() throws Exception {
		String destPath = "e:/test";
		String srcPath = "e:/jenkins.zip";
		ZipUtil.unzip(destPath, srcPath, null);
	}

	@Test
	public void unzipWithCheck() throws Exception {
		String destPath = "e:/test";
		String srcPath = "e:/jenkins.zip";
		Dictionary<String, Boolean> dict = new Hashtable<>();
		dict.put("xlsx", true);
		dict.put("js", true);
		ZipUtil.unzip(destPath, srcPath, dict);
	}

	@Test
	public void zip() throws Exception {
		String destPath = "e:/test";
		List<String> files = new ArrayList<>();
		files.add("e:/jenkins.xlsx");
		files.add("e:/common.js");
		ZipUtil.zip(files, destPath, "test.zip");
	}

	@Test
	public void getExtension() throws NoSuchMethodException, SecurityException, IllegalAccessException,
			IllegalArgumentException, InvocationTargetException {

		// 设置允许访问私用方法
		Method testNoParamMethod = ZipUtil.class.getDeclaredMethod("getExtension", String.class);
		testNoParamMethod.setAccessible(true);

		Assert.assertEquals(testNoParamMethod.invoke(testNoParamMethod, "1"), "");
		Assert.assertEquals(testNoParamMethod.invoke(testNoParamMethod, "1."), "");
		Assert.assertEquals(testNoParamMethod.invoke(testNoParamMethod, "."), "");
		Assert.assertEquals(testNoParamMethod.invoke(testNoParamMethod, ".2"), "2");
		Assert.assertEquals(testNoParamMethod.invoke(testNoParamMethod, "1.2"), "2");
		Assert.assertEquals(testNoParamMethod.invoke(testNoParamMethod, "1.23"), "23");
	}
}
