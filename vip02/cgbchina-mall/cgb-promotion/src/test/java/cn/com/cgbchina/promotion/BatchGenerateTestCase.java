package cn.com.cgbchina.promotion;

import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.io.FileFilter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.net.URL;
import java.util.*;
import java.util.Map.Entry;

public class BatchGenerateTestCase {

	/**
	 * 单元测试需要继承的基类
	 */
	private static final String BASE_TEST_CASE_NAME = "cn.com.cgbchina.promotion.BaseTestCase";
	/**
	 * 要生成单元测试的service的包名,请写到impl一级
	 */
	private static final String PACKAGE_NAME = "cn.com.cgbchina.promotion.service";

	public static void main(String[] args) {
		// 批量生成单元测试
		generateTestCase(PACKAGE_NAME, false);
	}

	/**
	 * 批量生成单元测试
	 *
	 * @param packageName
	 * @param isRecursive
	 * @return
	 */
	public static List<Class<?>> generateTestCase(String packageName, boolean isRecursive) {
		List<Class<?>> classList = new ArrayList<Class<?>>();
		try {
			Enumeration<URL> urls = Thread.currentThread().getContextClassLoader()
					.getResources(packageName.replaceAll("\\.", "/"));
			while (urls.hasMoreElements()) {
				URL url = urls.nextElement();
				if (url != null) {
					String protocol = url.getProtocol();
					if (protocol.equals("file")) {
						String packagePath = url.getPath();
						if (packagePath.contains("test-classes")) {
							continue;
						}
						addClass(classList, packagePath, packageName, isRecursive);
					}
				}
			}

			if (!classList.isEmpty()) {
				for (Class<?> serviceClass : classList) {
					Method[] methods = serviceClass.getDeclaredMethods();
					if (methods == null || methods.length < 1) {
						continue;
					}
					Field[] fields = serviceClass.getDeclaredFields();
					Map<String, List<String>> methodNameMap = new HashMap<String, List<String>>();
					for (Method method : methods) {
						if (!Modifier.isPublic(method.getModifiers())) {
							continue;
						}
						String methodName = method.getName();
						if (isGetSetMethod(fields, methodName)) {
							continue;
						}
						if (methodNameMap.containsKey(methodName)) {
							List<String> methodNameList = methodNameMap.get(methodName);
							methodNameList.add(methodName + "_" + methodNameList.size());
							continue;
						}
						List<String> methodNameList = new ArrayList<String>();
						methodNameList.add(methodName);
						methodNameMap.put(methodName, methodNameList);
					}
					generateTestCaseFile(serviceClass, methodNameMap);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return classList;
	}

	/**
	 * 判断方法是否是get/set方法
	 *
	 * @param fields
	 * @param methodName
	 * @return
	 */
	private static boolean isGetSetMethod(Field[] fields, String methodName) {
		if (!methodName.startsWith("set") && !methodName.startsWith("get")) {
			return false;
		}
		if (fields == null || fields.length < 1) {
			return false;
		}
		for (Field field : fields) {
			if (field.getName().equalsIgnoreCase(methodName.substring(3))) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 生成测试类文件
	 *
	 * @param serviceClass 需要测试的类
	 * @param methodNameMap 类的方法集合
	 * @throws IOException
	 */
	private static void generateTestCaseFile(Class<?> serviceClass, Map<String, List<String>> methodNameMap)
			throws IOException {
		String pack = serviceClass.getName();
		Set<Entry<String, List<String>>> methodNameSet = methodNameMap.entrySet();
		Iterator<Entry<String, List<String>>> methodNameIt = methodNameSet.iterator();
		while (methodNameIt.hasNext()) {
			Entry<String, List<String>> entry = methodNameIt.next();
			String methodName = entry.getKey();
			String packageName = pack.substring(0, pack.lastIndexOf("."));
			String className = pack.substring(pack.lastIndexOf(".") + 1) + "_" + methodName;
			String classContent = generateTestCaseContent(packageName, className, entry.getValue());
			String fullFilePath = new File(BatchGenerateTestCase.class.getClass().getResource("/").getPath())
					.getParentFile().getParentFile() + "\\src\\test\\java\\" + pack.replaceAll("[.]", "/") + "_"
					+ methodName + ".java";
			int index = fullFilePath.lastIndexOf('/');
			String folderPath = fullFilePath.substring(0, index);
			new File(folderPath).mkdirs();
			String filePath = fullFilePath.substring(index + 1, fullFilePath.length());
			new File(folderPath, filePath).createNewFile();
			FileOutputStream out = new FileOutputStream(fullFilePath);
			out.write(classContent.getBytes());
			out.flush();
			out.close();
		}
	}

	/**
	 * 生成文件内容
	 *
	 * @param packageName 包名称
	 * @param className 测试类名称
	 * @param methods 方法名称集合
	 * @return
	 */
	private static String generateTestCaseContent(String packageName, String className, List<String> methods) {
		StringBuilder content = new StringBuilder();
		content.append("package ");
		content.append(packageName);
		content.append(";\r\n\r\n");
		content.append("import org.junit.Test;\r\n\r\n");
		content.append("import " + BASE_TEST_CASE_NAME + ";\r\n\r\n");
		content.append("public class ");
		content.append(className);
		content.append(" extends BaseTestCase{\r\n\r\n");
		for (String method : methods) {
			content.append("    @Test\r\n");
			content.append("    public void test");
			content.append(method.substring(0, 1).toUpperCase() + method.substring(1));
			content.append("() {\r\n");
			content.append("    }\r\n\r\n");
		}
		content.append("}");

		return content.toString();
	}

	private static void addClass(List<Class<?>> classList, String packagePath, String packageName,
			boolean isRecursive) {
		try {
			File[] files = getClassFiles(packagePath);
			if (files != null) {
				for (File file : files) {
					String fileName = file.getName();
					if (file.isFile()) {
						String className = getClassName(packageName, fileName);
						classList.add(Class.forName(className));
					} else {
						if (isRecursive) {
							String subPackagePath = getSubPackagePath(packagePath, fileName);
							String subPackageName = getSubPackageName(packageName, fileName);
							addClass(classList, subPackagePath, subPackageName, isRecursive);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static File[] getClassFiles(String packagePath) {
		return new File(packagePath).listFiles(new FileFilter() {
			@Override
			public boolean accept(File file) {
				return (file.isFile() && file.getName().endsWith(".class")) || file.isDirectory();
			}
		});
	}

	private static String getClassName(String packageName, String fileName) {
		String className = fileName.substring(0, fileName.lastIndexOf("."));
		if (StringUtils.isNotEmpty(packageName)) {
			className = packageName + "." + className;
		}
		return className;
	}

	private static String getSubPackagePath(String packagePath, String filePath) {
		String subPackagePath = filePath;
		if (StringUtils.isNotEmpty(packagePath)) {
			subPackagePath = packagePath + "/" + subPackagePath;
		}
		return subPackagePath;
	}

	private static String getSubPackageName(String packageName, String filePath) {
		String subPackageName = filePath;
		if (StringUtils.isNotEmpty(packageName)) {
			subPackageName = packageName + "." + subPackageName;
		}
		return subPackageName;
	}

}
