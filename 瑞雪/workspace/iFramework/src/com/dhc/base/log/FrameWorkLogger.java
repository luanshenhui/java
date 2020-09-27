package com.dhc.base.log;

import com.dhc.base.context.FrameAppContext;

/**
 * 
 *
 * 框架日志
 */
public class FrameWorkLogger {
	public static void debug(String info) {
		SysLog.writeLogs(FrameAppContext.PREFIX, LogLevel.DEBUG, info);
	}

	public static void info(String info) {
		SysLog.writeLogs(FrameAppContext.PREFIX, LogLevel.INFO, info);
	}

	public static void warn(String info) {
		SysLog.writeLogs(FrameAppContext.PREFIX, LogLevel.WARN, info);
	}

	public static void error(String info) {
		SysLog.writeLogs(FrameAppContext.PREFIX, LogLevel.ERROR, info);
	}

	public static void error(String info, Exception e) {
		SysLog.writeExceptionLogs(FrameAppContext.PREFIX, LogLevel.ERROR, info, e);
	}

	public static void fatal(String info) {
		SysLog.writeLogs(FrameAppContext.PREFIX, LogLevel.FATAL, info);
	}

}
