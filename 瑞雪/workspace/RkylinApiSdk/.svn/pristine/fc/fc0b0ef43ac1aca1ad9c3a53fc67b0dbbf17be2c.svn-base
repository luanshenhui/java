package com.letv.common;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 日志工具类
 *
 * @author Administrator
 *
 */
public class LoggerUtil {

	private static final String ProjectName = "Levp\\";

	public static String LogPath = "";

	/**
	 * 初始化
	 */
	public static void Init() {

		if (LogPath.isEmpty())
			return;
		String strPath = LogPath + "logs\\" + ProjectName
				+ new SimpleDateFormat("yyyy-MM-dd").format(new Date());
		File file = new File(strPath);
		if (!file.exists())
			file.mkdirs();
	}

	/**
	 * 写异常日志
	 *
	 * @param ex
	 */
	public static void ErrorException(Exception e) {
		try {
			if (LogPath.isEmpty())
				return;
			String strPath = LogPath + "logs\\" + ProjectName
					+ new SimpleDateFormat("yyyy-MM-dd").format(new Date())
					+ "\\Execption_LOG.log";
			StringBuffer strLog = new StringBuffer();
			strLog.append(e.toString() + "\r\n");
			for (StackTraceElement element : e.getStackTrace()) {
				strLog.append("\tat " + element.toString() + "\r\n");
			}
			File f = new File(strPath);
			if (!f.exists())
				f.createNewFile();
			BufferedWriter output = new BufferedWriter(new FileWriter(f, true));
			output.write(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
					.format(new Date()) + "\r\n" + strLog + "\r\n");
			output.close();

		} catch (Exception ex) {
			// TODO: handle exception
		}
	}

	/**
	 * 写错误日志
	 *
	 * @throws IOException
	 * @throws SecurityException
	 */
	public static void Info(String message) {
		try {
			if (LogPath.isEmpty())
				return;
			String strPath = LogPath + "logs\\" + ProjectName
					+ new SimpleDateFormat("yyyy-MM-dd").format(new Date())
					+ "\\INFO.log";
			File f = new File(strPath);
			if (!f.exists())
				f.createNewFile();
			BufferedWriter output = new BufferedWriter(new FileWriter(f, true));
			output.write(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
					.format(new Date()) + "\t" + message + "\r\n");
			output.close();
		} catch (Exception e) {
			// TODO: handle exception
		}
	}
}
