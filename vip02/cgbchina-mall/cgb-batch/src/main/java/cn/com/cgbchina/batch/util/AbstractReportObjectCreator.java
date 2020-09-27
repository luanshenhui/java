package cn.com.cgbchina.batch.util;

import com.google.common.collect.Maps;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

@Slf4j
public abstract class AbstractReportObjectCreator {
	@Getter
	private Map<String, Reporter> dayReporterMap = Maps.newHashMap();
	@Getter
	private Map<String, Reporter> monthReporterMap = Maps.newHashMap();
	@Getter
	private Map<String, Reporter> weekReporterMap = Maps.newHashMap();

	protected void getIncompleteListenerObjectsFromClass(Class<?> clazz, Object targetObject) {
		for(Method method : clazz.getDeclaredMethods()) {
			Report report = method.getAnnotation(Report.class);
			if(report != null) {
				Reporter rp = new Reporter();
				rp.setId(report.id());
				rp.setName(report.name());
				rp.setOrdertypeId(report.ordertypeId());
				rp.setMethod(method);
				rp.setReturnType(method.getReturnType());
				rp.setTarget(targetObject);
				rp.setParameterTypes(method.getParameterTypes());
				if (report.type().equals(Report.ReportType.DAY)) {
					dayReporterMap.put(report.id(), rp);
				} else if (report.type().equals(Report.ReportType.MONTH)) {
					monthReporterMap.put(report.id(), rp);
				} else if (report.type().equals(Report.ReportType.WEEK)) {
					weekReporterMap.put(report.id(), rp);
				}
			}
		}
	}

	public void addClass(Class<?> clazz) {
		Object targetObject = this.getTargetObjectForClass(clazz);
		if(targetObject != null) {
			this.getIncompleteListenerObjectsFromClass(clazz, targetObject);
		}
	}

	public void addPackage(String packageName) {
		Collection<Class<?>> classes;
		try {
			classes = this.getClasses(packageName);
		} catch(Exception e) {
			throw new RuntimeException("Error during reading of package '" + packageName + "'", e);
		}
		for(Class<?> clazz : classes) {
			this.addClass(clazz);
		}
	}

	protected ClassLoader getClassLoader() {
		return Thread.currentThread().getContextClassLoader();
	}


	protected Collection<Class<?>> getClasses(String packageName) throws ClassNotFoundException, IOException {

		String path = packageName.replace('.', '/');
		Enumeration<URL> resources = this.getClassLoader().getResources(path); //NOPMD

		Collection<Class<?>> classes = new ArrayList<>();
		while(resources.hasMoreElements()) {
			URL resource = resources.nextElement();
			String filename = URLDecoder.decode(resource.getFile(), "UTF-8");

			if(resource.getProtocol().equals("jar") || resource.getProtocol().equals("zip")) {
				String zipFilename = filename.substring(5, filename.indexOf("!"));
				ZipFile zipFile = new ZipFile(zipFilename);
				classes.addAll(this.findClassesInZipFile(zipFile, path));
			} else {
				File directory = new File(filename);
				classes.addAll(this.findClassesInDirectory(directory, packageName));
			}
		}
		return classes;
	}

	protected Collection<Class<?>> findClassesInZipFile(ZipFile zipFile, String path) throws ClassNotFoundException {

		Collection<Class<?>> classes = new ArrayList<>();
		Enumeration<ZipEntry> zipEntries = (Enumeration<ZipEntry>) zipFile.entries();
		while(zipEntries.hasMoreElements()) {
			String entryName = zipEntries.nextElement().getName();
			Pattern p = Pattern.compile("(" + path + "/\\w+)\\.class");
			Matcher m = p.matcher(entryName);
			if(m.matches()) {
				String className = m.group(1).replaceAll("/", ".");
				classes.add(Class.forName(className));
			}
		}
		return classes;
	}


	protected Collection<Class<?>> findClassesInDirectory(File directory, String packageName) throws ClassNotFoundException {
		Collection<Class<?>> classes = new ArrayList<>();
		if(!directory.exists()) {
			return classes;
		}
		File[] files = directory.listFiles();
		for(File file : files) {
			classes.add(Class.forName(packageName + '.' + file.getName().substring(0, file.getName().length() - 6)));
		}
		return classes;
	}

	protected abstract Object getTargetObjectForClass(Class<?> clazz);
}
