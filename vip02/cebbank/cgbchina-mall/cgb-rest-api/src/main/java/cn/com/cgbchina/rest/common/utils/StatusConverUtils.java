package cn.com.cgbchina.rest.common.utils;

import com.google.common.base.Charsets;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.io.LineProcessor;
import com.google.common.io.Resources;
import org.apache.commons.lang3.StringUtils;

import javax.annotation.PostConstruct;
import javax.validation.constraints.NotNull;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Comment: Created by 11150321050126 on 2016/5/8.
 */
public class StatusConverUtils {
	private String filePath;
	private static Map<String, List<StatusConver>> map = Maps.newConcurrentMap();

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	@PostConstruct
	public synchronized void init() throws IOException {
		if (map == null) {
			Resources.readLines(Resources.getResource(this.filePath), Charsets.UTF_8, new LineProcessor<Void>() {
				@Override
				public boolean processLine(String line) throws IOException {
					if (StringUtils.isNotEmpty(line)) {
						// # 号开头的过滤掉，
						if (!nullOrComment(line)) {
							// 根据空白字符分割
							List<String> codeList = Splitter.on("\\s+").trimResults().splitToList(line);
							List<StatusConver> statusConverList = Lists.newArrayList();
							for (int i = 0; i < codeList.size(); i++) {
								StatusConver statusConver = new StatusConver();
								statusConver.setSystem1(codeList.get(1));
								statusConver.setSystem2(codeList.get(2));
								statusConverList.add(statusConver);
								map.put(codeList.get(0), statusConverList);
							}
						}
					}
					return true;
				}

				@Override
				public Void getResult() {
					return null;
				}
			});
		}
	}

	private boolean nullOrComment(String line) {
		return (Strings.isNullOrEmpty(line) || line.startsWith("#"));
	}

	public static <T> T getProject(@NotNull String name, @NotNull String code, Class<T> clazz) {
		List<StatusConver> list = map.get(name);
		for (StatusConver conver : list) {
			if (code.equals(conver.getSystem1())) {
				String system2 = conver.getSystem2();
				return getT(name, code, clazz, system2);
			}
		}
		throw new RuntimeException("【接口数据转换】没有找到数据：name" + name + " code:" + code);
	}

	private static <T> T getT(@NotNull String name, @NotNull String code, Class<T> clazz, String system) {
		if (int.class.equals(clazz) || Integer.class.equals(clazz)) {
			return (T) Integer.valueOf(system);
		} else if (double.class.equals(clazz) || Double.class.equals(clazz)) {
			return (T) Double.valueOf(system);
		} else if (float.class.equals(clazz) || Float.class.equals(clazz)) {
			return (T) Float.valueOf(system);
		} else if (byte.class.equals(clazz) || Byte.class.equals(clazz)) {
			return (T) Byte.valueOf(system);
		} else if (boolean.class.equals(clazz) || Boolean.class.equals(clazz)) {
			return (T) Boolean.valueOf(system);
		} else if (String.class.equals(clazz)) {
			return (T) system;
		} else {
			throw new RuntimeException("【接口数据转换】只支持基本数据类型：name" + name + " code:" + code + " class:" + clazz.getName());
		}
	}

	public static <T> T getInterface(@NotNull String name, @NotNull String code, Class<T> clazz) {
		List<StatusConver> list = map.get(name);
		for (StatusConver conver : list) {
			if (code.equals(conver.getSystem2())) {
				String system1 = conver.getSystem1();
				return getT(name, code, clazz, system1);
			}
		}
		throw new RuntimeException("【接口数据转换】没有找到数据：name" + name + " code:" + code);
	}

	private class StatusConver {
		// 指的接口
		private String system1;
		// 指的内部程序
		private String system2;

		public String getSystem1() {
			return system1;
		}

		public void setSystem1(String system1) {
			this.system1 = system1;
		}

		public String getSystem2() {
			return system2;
		}

		public void setSystem2(String system2) {
			this.system2 = system2;
		}
	}
}
